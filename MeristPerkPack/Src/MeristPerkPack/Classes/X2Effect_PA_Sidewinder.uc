class X2Effect_PA_Sidewinder extends X2Effect_Persistent;

var bool bApplyToFriendlyFire;
var EAbilityHitResult NewHitResult;
var int EventPriority;

var name CooldownEffectName;
var name EventName;
var name OriginalGroupValueName;

var localized string strFriendlyDesc;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'PostModifyNewAbilityContext', OnPostModifyNewAbilityContext, ELD_Immediate, EventPriority,,, EffectObj);
}

static function EventListenerReturn OnPostModifyNewAbilityContext(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local XComGameState_Unit            Defender, Attacker;
    local X2Effect_PA_Sidewinder        Effect;
    local int                           Index;
    local bool                          bChangedResult;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(EventData);
    AbilityState = XComGameState_Ability(EventSource);
    EffectState = XComGameState_Effect(CallbackObject);

    if (AbilityContext == none || AbilityState == none || EffectState == none)
        return ELR_NoInterrupt;

    Defender = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    Attacker = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

    if (Defender == none || Attacker == none)
        return ELR_NoInterrupt;

    Effect = X2Effect_PA_Sidewinder(EffectState.GetX2Effect());

    if (Effect != none)
    {
        if (Effect.IsAbilityRelevant(AbilityState, Defender, Attacker, EffectState))
        {
            if (Effect.IsEffectCurrentlyRelevant(EffectState, Defender))
            {
                if (AbilityContext.InputContext.PrimaryTarget.ObjectID == Defender.ObjectID)
                {
                    if (AbilityContext.IsResultContextHit())
                    {
                        AbilityContext.ResultContext.HitResult = Effect.NewHitResult;
                        bChangedResult = true;
                    }
                }
                for (Index = 0; Index < AbilityContext.ResultContext.MultiTargetHitResults.Length; Index++)
                {
                    if (AbilityContext.InputContext.MultiTargets[Index].ObjectID == Defender.ObjectID)
                    {
                        if (AbilityContext.IsResultContextMultiHit(Index))
                        {
                            AbilityContext.ResultContext.HitResult = Effect.NewHitResult;
                            bChangedResult = true;
                        }
                    }
                }
                if (bChangedResult)
                {
                    `XEVENTMGR.TriggerEvent(Effect.EventName, AbilityContext, Defender);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    if (TargetUnit.IsAbleToAct() || TargetUnit.IsMindControlled())
    {
        return false;
    }

    if (FindUsableSidewinderAbility(TargetUnit) != none)
    {
        return false;
    }

    return true;
}

function XComGameState_Ability FindUsableSidewinderAbility(XComGameState_Unit Defender)
{
    local XComGameStateHistory  History;
    local XComGameState_Ability AbilityState;
    local StateObjectReference  AbilityRef;

    History = `XCOMHISTORY;

    foreach Defender.Abilities(AbilityRef)
    {
        AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
        if (IsSidewinderkAbility(AbilityState))
        {
            if (AbilityState.CanActivateAbility(Defender) == 'AA_Success')
            {
                return AbilityState;
            }
        }
    }

    return none;
}

function bool IsSidewinderkAbility(XComGameState_Ability AbilityState)
{
    local X2AbilityTemplate                 AbilityTemplate;
    local X2AbilityTrigger                  Trigger;
    local X2AbilityTrigger_EventListener    EventListener;

    AbilityTemplate = AbilityState.GetMyTemplate();

    foreach AbilityTemplate.AbilityTriggers(Trigger)
    {
        EventListener = X2AbilityTrigger_EventListener(Trigger);
        if (EventListener != none)
        {
            if (EventListener.ListenerData.EventID == EventName)
            {
                return true;
            }
        }
    }

    return false;
}

static function AddSidewinderCooldown(out X2AbilityTemplate Template, int NumTurns = 1)
{
    local X2Condition_UnitEffects EffectCondition;
    local X2Effect_Persistent Effect;

    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = class'X2Effect_PA_Sidewinder'.default.CooldownEffectName;
    Effect.BuildPersistentEffect(NumTurns, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Effect_PA_Sidewinder'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddShooterEffect(Effect);

    EffectCondition = new class'X2Condition_UnitEffects';
    EffectCondition.AddExcludeEffect(class'X2Effect_PA_Sidewinder'.default.CooldownEffectName, 'AA_CoolingDown');
    Template.AbilityShooterConditions.AddItem(EffectCondition);
}

function bool IsAbilityRelevant(XComGameState_Ability AbilityState, XComGameState_Unit Defender, XComGameState_Unit Attacker, XComGameState_Effect EffectState)
{
    local X2AbilityTemplate AbilityTemplate;
    local bool              bDealsDamage;

    if (!bApplyToFriendlyFire && Defender.IsFriendlyUnit(Attacker))
    {
        return false;
    }

    AbilityTemplate = AbilityState.GetMyTemplate();

    if (!AbilityState.IsAbilityInputTriggered() || X2AbilityToHitCalc_DeadEye(AbilityTemplate.AbilityToHitCalc) != none)
    {
        return false;
    }

    bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);
    if (AbilityTemplate.Hostility != eHostility_Offensive || !bDealsDamage || AbilityTemplate.bIsASuppressionEffect)
    {
        return false;
    }

    return true;
}

defaultproperties
{
    EffectName = M31_Sidewinder
    DuplicateResponse = eDupe_Ignore

    CooldownEffectName = M31_PA_Sidewinder_Cooldown
    EventName = M31_PA_Sidewinder_Trigger
    OriginalGroupValueName = M31_PA_Sidewinder_Group

    NewHitResult = eHit_LightningReflexes

    EventPriority = 39
}