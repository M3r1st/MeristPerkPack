class X2Effect_WS_LTTMark extends X2Effect_Persistent;

var name AbilityToTrigger;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'UnitGroupTurnBegun', AbilityTriggerEventListener_LeadTheTarget, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_LeadTheTarget(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        SourceUnit;
    local XComGameState_Unit        TargetUnit;
    local XComGameState_Effect      EffectState;
    local X2Effect_WS_LTTMark       Effect;
    local StateObjectReference      AbilityRef;
    local XComGameState_Ability     AbilityState;

    History = `XCOMHISTORY;
    EffectState = XComGameState_Effect(CallbackData);
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    
    if (TargetUnit.GetGroupMembership().ObjectID != XComGameState_AIGroup(EventSource).ObjectID)
        return ELR_NoInterrupt;

    Effect = X2Effect_WS_LTTMark(EffectState.GetX2Effect());

    if (Effect == none)
        return ELR_NoInterrupt;

    AbilityRef = SourceUnit.FindAbility(Effect.AbilityToTrigger, EffectState.ApplyEffectParameters.ItemStateObjectRef);
    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityRef.ObjectID));
    if (AbilityState != none)
    {
        if (AbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
        {
            AbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
        }
    }

    return ELR_NoInterrupt;
}