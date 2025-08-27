class X2Effect_PassiveWeaponEffect extends X2Effect_Persistent;

var name AttackName;
var array<name> AllowedAbilities;
var bool bApplyToSingleTarget;
var bool bApplyToMultiTarget;

// If true, requires AbilityTemplate.bAllowAmmoEffects to be true
var bool bCountsAsAmmoEffect;
// If true, requires AbilityTemplate.bAllowBonusWeaponEffects to be true
var bool bCountsAsWeaponEffect;

// If true, requires the attack's source weapon and the follow-up ability's source weapon to match
// OR the attack's source weapon's category should match of the additional categories
var bool bMatchSourceWeapon;
var array<name> AdditionalWeaponCategories;

var int EventPriority;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    SourceUnitState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_WeaponEffect, ELD_OnStateSubmitted, EventPriority, SourceUnitState,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_WeaponEffect(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit, TargetUnit;
    local XComGameState_Ability             AbilityState, AttackAbilityState;
    local X2WeaponTemplate                  WeaponTemplate;
    local X2AbilityTemplate                 AbilityTemplate;
    local X2Effect_PassiveWeaponEffect      WeaponEffect;
    local X2Effect                          Effect;
    local X2AbilityMultiTarget_BurstFire    BurstFire;
    local int                               VisualizeIndex;
    local XComGameStateContext              FindContext;
    local bool      bDealsDamage;
    local int       NumShots;
    local int       i, k;

    History = `XCOMHISTORY;
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    
    SourceUnit = XComGameState_Unit(EventSource);

    AbilityState = XComGameState_Ability(EventData);
    AbilityTemplate = AbilityState.GetMyTemplate();

    WeaponEffect = X2Effect_PassiveWeaponEffect(XComGameState_Effect(CallbackData).GetX2Effect());

    if (SourceUnit == none || AbilityState == none || AbilityTemplate == none || WeaponEffect == none)
        return ELR_NoInterrupt;

    if (WeaponEffect.AllowedAbilities.Length > 0 && WeaponEffect.AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE ||
        AbilityTemplate.Hostility != eHostility_Offensive)
        return ELR_NoInterrupt;

    if (WeaponEffect.bCountsAsAmmoEffect && !AbilityTemplate.bAllowAmmoEffects ||
        WeaponEffect.bCountsAsWeaponEffect && !AbilityTemplate.bAllowBonusWeaponEffects)
        return ELR_NoInterrupt;

    if (AbilityContext.InputContext.ItemObject.ObjectID == 0)
        return ELR_NoInterrupt;

    if (WeaponEffect.bMatchSourceWeapon)
    {
        AttackAbilityState = XComGameState_Ability(
            History.GetGameStateForObjectID(SourceUnit.FindAbility(WeaponEffect.AttackName, AbilityContext.InputContext.ItemObject).ObjectID));
    }

    if (AttackAbilityState == none)
    {
        AttackAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility(WeaponEffect.AttackName).ObjectID));

        if (AttackAbilityState == none)
            return ELR_NoInterrupt;

        if (WeaponEffect.bMatchSourceWeapon)
        {
            WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
            if (WeaponTemplate == none || WeaponEffect.AdditionalWeaponCategories.Find(WeaponTemplate.WeaponCat) == INDEX_NONE)
                return ELR_NoInterrupt;
        }
    }
        
    if (WeaponEffect.bApplyToSingleTarget)
    {
        TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

        if (TargetUnit != none)
        {
            if (AbilityContext.IsResultContextHit() && AttackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit, SourceUnit) == 'AA_Success')
            {
                foreach AbilityTemplate.AbilityTargetEffects(Effect)
                {
                    if (X2Effect_ApplyWeaponDamage(Effect) != none)
                    {
                        bDealsDamage = true;
                        break;
                    }
                }
                if (bDealsDamage)
                {
                    NumShots = 1;
                    BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
                    if (BurstFire != none)
                    {
                        NumShots += BurstFire.NumExtraShots;
                    }
                    for (i = 0; i < NumShots; i++)
                    {
                        VisualizeIndex = GameState.HistoryIndex;
                        FindContext = AbilityContext;
                        while (FindContext.InterruptionHistoryIndex > -1)
                        {
                            FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
                            VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
                        }
                        AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
                    }
                }
            }
        }
    }

    if (WeaponEffect.bApplyToMultiTarget)
    {
        if (AbilityTemplate.AbilityMultiTargetStyle != none)
        {
            BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
            if (BurstFire == none)
            {
                foreach AbilityTemplate.AbilityMultiTargetEffects(Effect)
                {
                    if (X2Effect_ApplyWeaponDamage(Effect) != none)
                    {
                        bDealsDamage = true;
                        break;
                    }
                }

                for (k = 0; k < AbilityContext.InputContext.MultiTargets.Length; k++)
                {
                    TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[k].ObjectID));

                    if (TargetUnit != none)
                    {
                        if (AbilityContext.IsResultContextMultiHit(k) && AttackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit, SourceUnit) == 'AA_Success')
                        {
                            if (bDealsDamage)
                            {
                                VisualizeIndex = GameState.HistoryIndex;
                                FindContext = AbilityContext;
                                while (FindContext.InterruptionHistoryIndex > -1)
                                {
                                    FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
                                    VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
                                }
                                AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.MultiTargets[k], false, VisualizeIndex);
                            }
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bApplyToSingleTarget = true
    bApplyToMultiTarget = true
    bMatchSourceWeapon = true
    EventPriority = 40
}
