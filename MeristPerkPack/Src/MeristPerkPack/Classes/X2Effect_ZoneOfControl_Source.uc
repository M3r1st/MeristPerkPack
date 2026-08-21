class X2Effect_ZoneOfControl_Source extends X2Effect_PersistentAuraWithStats_Source;

var bool bAllowWhileImpaired;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit;
    local Object                EffectObj;

    super.RegisterForEvents(EffectGameState);

    EventMgr = `XEVENTMGR;
    History = `XCOMHISTORY;

    EffectObj = EffectGameState;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (!bAllowWhileImpaired)
    {
        EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', UpdateStats, ELD_OnStateSubmitted, 20, SourceUnit,, EffectObj);
    }
}

defaultproperties
{
    EffectName = M31_ZoneOfControl_Source
}