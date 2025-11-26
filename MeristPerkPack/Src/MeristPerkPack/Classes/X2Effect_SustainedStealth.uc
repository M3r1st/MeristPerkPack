class X2Effect_SustainedStealth extends X2Effect_RangerStealth;

var bool bRemoveWhenSourceImpaired;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local XComGameState_Unit SourceUnitState;
    local XComGameStateHistory History;
    local Object EffectObj;

    History = `XCOMHISTORY;
    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (bRemoveWhenSourceImpaired)
    {
        EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', EffectGameState.OnSourceBecameImpaired, ELD_OnStateSubmitted, , SourceUnitState);
    }
}

defaultproperties
{
    bRemoveWhenSourceImpaired = true
}