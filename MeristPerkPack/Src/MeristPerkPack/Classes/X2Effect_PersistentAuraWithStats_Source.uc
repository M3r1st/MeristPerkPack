class X2Effect_PersistentAuraWithStats_Source extends X2Effect_Persistent;

var name UpdateEventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    History = `XCOMHISTORY;

    EffectObj = EffectGameState;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'PlayerTurnBegun', UpdateStats, ELD_OnStateSubmitted, 20,,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'MindControlled', UpdateStats, ELD_OnStateSubmitted, 20, SourceUnit,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'UnitMoveFinished', UpdateStats, ELD_OnStateSubmitted, 20, SourceUnit,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'UnitDied', UpdateStats, ELD_OnStateSubmitted, 20, SourceUnit,, EffectObj);
}

static function EventListenerReturn UpdateStats(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory  History;
    local XComGameState_Effect  EffectState;
    local X2Effect_PersistentAuraWithStats_Source Effect;
    local XComGameState_Unit    SourceUnit;
    local XComGameState         NewGameState;

    History = `XCOMHISTORY;

    EffectState = XComGameState_Effect(CallbackData);
    if (EffectState != none)
    {
        Effect = X2Effect_PersistentAuraWithStats_Source(EffectState.GetX2Effect());
        if (Effect != none)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Aura update for " $ EffectState.ApplyEffectParameters.AbilityInputContext.AbilityTemplateName);
            SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
            `XEVENTMGR.TriggerEvent(Effect.UpdateEventName, SourceUnit, SourceUnit, NewGameState);
            `TACTICALRULES.SubmitGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
}
