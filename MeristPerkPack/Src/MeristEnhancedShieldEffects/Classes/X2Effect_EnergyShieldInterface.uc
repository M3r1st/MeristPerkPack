class X2Effect_EnergyShieldInterface extends X2Effect_Persistent;

var privatewrite int EventPriority;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local XComGameState_Unit UnitState;
    local XCGS_Effect_EnergyShieldInterface EffectState;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EffectState = XCGS_Effect_EnergyShieldInterface(EffectGameState);
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectState.ShieldsTakeDamage, ELD_OnStateSubmitted, EventPriority, UnitState);
    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectState.RemoveDepletedShields, ELD_OnStateSubmitted, EventPriority - 1, UnitState);
}

defaultproperties
{
    EventPriority = 49;
    GameStateEffectClass = class'XCGS_Effect_EnergyShieldInterface'
}