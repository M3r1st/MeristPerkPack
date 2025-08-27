//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_EnergyShieldHandler.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class X2Effect_EnergyShieldHandler extends X2Effect_Persistent;

var privatewrite int UpdateEventPriority;
var privatewrite int RemoveEventPriority;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager                    EventMgr;
    local XComGameState_Unit                UnitState;
    local XCGS_Effect_EnergyShieldHandler   EffectState;
    local Object                            EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EffectState = XCGS_Effect_EnergyShieldHandler(EffectGameState);
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectState.ShieldsTakeDamage, ELD_OnStateSubmitted, UpdateEventPriority, UnitState);
    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectState.RemoveDepletedShields, ELD_OnStateSubmitted, RemoveEventPriority, UnitState);
}

defaultproperties
{
    UpdateEventPriority = 49
    RemoveEventPriority = 48
    GameStateEffectClass = class'XCGS_Effect_EnergyShieldHandler'
}