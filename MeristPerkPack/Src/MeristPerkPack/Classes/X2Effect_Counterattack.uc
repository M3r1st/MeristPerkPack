class X2Effect_Counterattack extends X2Effect_Persistent;

var int DodgeBase;
var int DodgeReductionPerHit;
var int ActivationsPerTurn;
var bool bOnlyOnEnemyTurn;

var name CounterName;

var bool bAllowImpaired;
var bool bAllowPanicked;
var bool bAllowBurning;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;
    local UnitValue         UnitValue;
    local int               DodgeMod;

    if (!ValidateEffects(Target))
        return;

    if (bOnlyOnEnemyTurn && `TACTICALRULES.GetUnitActionTeam() == Target.GetTeam())
        return;

    if (!Target.GetUnitValue(CounterName, UnitValue) || int(UnitValue.fValue) < ActivationsPerTurn)
    {
        if (bMelee)
        {
            DodgeMod = DodgeBase - DodgeReductionPerHit * int(UnitValue.fValue);
            if (DodgeMod > 0)
            {
                `LOG(DodgeMod,, 'X2Effect_Counterattack');
                ModInfo.ModType = eHit_Graze;
                ModInfo.Reason = FriendlyName;
                ModInfo.Value = DodgeMod;
                ShotModifiers.AddItem(ModInfo);
            }
        }
    }
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_Counterattack, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_Counterattack(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local X2TacticalGameRuleset         TacticalRules;
    local XComGameStateContext_Ability  AbilityContext;

    local XComGameState_Effect          EffectState;
    local X2Effect_Counterattack        CounterattackEffect;
    local XComGameState_Unit            Defender;

    local XComGameState_Unit            Attacker;
    local XComGameState_Ability         AbilityState;

    local StateObjectReference          CounterattackAbilityRef;
    local XComGameState_Ability         CounterattackAbilityState;
    local UnitValue                     CounterattackUVFlag;
    local UnitValue                     CounterattackUnitValue;

    local XComGameState                 NewGameState;
    
    History = `XCOMHISTORY;
    TacticalRules = `TACTICALRULES;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    EffectState = XComGameState_Effect(CallbackData);

    if (AbilityContext != none
        && EffectState != none
        && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt
        && AbilityContext.InputContext.PrimaryTarget == EffectState.ApplyEffectParameters.TargetStateObjectRef
        && AbilityContext.ResultContext.HitResult == eHit_CounterAttack)
    {
        CounterattackEffect = X2Effect_Counterattack(EffectState.GetX2Effect());
        Defender = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (CounterattackEffect != none && Defender != none)
        {
            if (!CounterattackEffect.ValidateEffects(Defender))
                return ELR_NoInterrupt;

            if (CounterattackEffect.bOnlyOnEnemyTurn && TacticalRules.GetUnitActionTeam() == Defender.GetTeam())
                return ELR_NoInterrupt;

            if (!Defender.GetUnitValue(class'X2Ability'.default.CounterattackDodgeEffectName, CounterattackUVFlag)
                || int(CounterattackUVFlag.fValue) != class'X2Ability'.default.CounterattackDodgeUnitValue)
                return ELR_NoInterrupt;

            if (Defender.GetUnitValue(CounterattackEffect.CounterName, CounterattackUnitValue)
                && (CounterattackEffect.ActivationsPerTurn <= 0 || int(CounterattackUnitValue.fValue) >= CounterattackEffect.ActivationsPerTurn))
                return ELR_NoInterrupt;

            Attacker = XComGameState_Unit(EventSource);
            AbilityState = XComGameState_Ability(EventData);

            if (Attacker != none && AbilityState != none)
            {
                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                Defender = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Defender.ObjectID));
                Defender.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);

                TacticalRules.SubmitGameState(NewGameState);

                foreach Defender.Abilities(CounterattackAbilityRef)
                {
                    CounterattackAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(CounterattackAbilityRef.ObjectID));
                    if (CounterattackAbilityState != none
                        && IsCounterattackAbility(CounterattackAbilityState)
                        && CounterattackAbilityState.CanActivateAbilityForObserverEvent(Attacker, Defender) == 'AA_Success')
                    {                       
                        CounterattackAbilityState.AbilityTriggerAgainstSingleTarget(Attacker.GetReference(), false);
                        return ELR_NoInterrupt;
                    }
                }
            }
        }
    }
    
    return ELR_NoInterrupt;
}

static function bool IsCounterattackAbility(XComGameState_Ability AbilityState)
{
    local X2AbilityTemplate             AbilityTemplate;
    local X2AbilityCost                 AbilityCost;
    local X2AbilityCost_ActionPoints    ActionPointCost;

    AbilityTemplate = AbilityState.GetMyTemplate();
    
    foreach AbilityTemplate.AbilityCosts(AbilityCost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
        if (ActionPointCost != none &&
            ActionPointCost.AllowedTypes.Find(class'X2CharacterTemplateManager'.default.CounterattackActionPoint) != INDEX_NONE)
        {
            return true;
        }
    }
    return false;
}

protected function bool ValidateEffects(XComGameState_Unit UnitState)
{
    return (!UnitState.IsImpaired() || bAllowImpaired)
        && (!UnitState.IsPanicked() || bAllowPanicked)
        && (!UnitState.IsBurning() || bAllowBurning)
        && UnitState.AffectedByEffectNames.Find('Frozen') == INDEX_NONE;
}

defaultproperties
{
    EffectName = M31_PA_Counterattack
    CounterName = M31_PA_Counterattack_Counter
    DuplicateResponse = eDupe_Ignore
}