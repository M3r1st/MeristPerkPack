//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_EnergyShieldExtended.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class X2Effect_EnergyShieldExtended extends X2Effect_EnergyShield abstract;

var int ShieldPriority;

// Called by the handler in the corresponding listener
var delegate<ShieldsTakeDamage> ShieldsTakeDamageFn;

delegate ShieldsTakeDamage(X2Effect_EnergyShieldExtended ShieldEffect, XComGameState_Effect kNewEffectState, XComGameState NewGameState, XComGameState_Unit kTargetUnitState, int DamageTaken);

// Override definition in X2Effect_EnergyShield
function RegisterForEvents(XComGameState_Effect EffectGameState){}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit                kTargetUnitState;
    local XCGS_Effect_EnergyShieldExtended  EffectState;
    local XCGS_Effect_EnergyShieldHandler HandlerEffectState;
    local int ShieldStrength;

    kTargetUnitState = XComGameState_Unit(kNewTargetState);
    `assert(kTargetUnitState != none);
    EffectState = XCGS_Effect_EnergyShieldExtended(NewEffectState);
    EffectState.AddLinkedHandlerID();

    ShieldStrength = GetShieldAmount(ApplyEffectParameters, kNewTargetState, NewGameState, EffectState);

    m_aStatChanges.Length = 0;
    AddPersistentStatChange(eStat_ShieldHP, ShieldStrength);

    EffectState.ShieldPriority = ShieldPriority;
    EffectState.ShieldRemaining = ShieldStrength;

    HandlerEffectState = XCGS_Effect_EnergyShieldHandler(NewGameState.ModifyStateObject(class'XCGS_Effect_EnergyShieldHandler', EffectState.LinkedHandlerID));
    `assert(HandlerEffectState != none);
    HandlerEffectState.AddShieldEffectToHandler(EffectState);
    HandlerEffectState.LogShieldEffectStates(NewGameState);
    
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit                UnitState;	
    local XCGS_Effect_EnergyShieldExtended  EffectState;
    local XCGS_Effect_EnergyShieldHandler HandlerEffectState;
    local int ShieldCurrent;
    local int ShieldRemaining;
    local int NewShieldHP;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    `assert(UnitState != none);
    EffectState = XCGS_Effect_EnergyShieldExtended(RemovedEffectState);

    ShieldRemaining = EffectState.ShieldRemaining;
    ShieldCurrent = UnitState.GetCurrentStat(eStat_ShieldHP);
    NewShieldHP = ShieldCurrent - ShieldRemaining;

    HandlerEffectState = XCGS_Effect_EnergyShieldHandler(NewGameState.ModifyStateObject(class'XCGS_Effect_EnergyShieldHandler', EffectState.LinkedHandlerID));
    `assert(HandlerEffectState != none);
    HandlerEffectState.RemoveShieldEffectFromHandler(EffectState);
    HandlerEffectState.LogShieldEffectStates(NewGameState);

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    if (NewShieldHP > 0)
    {
        UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (UnitState == none)
            UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
        UnitState.SetCurrentStat(eStat_ShieldHP, NewShieldHP);
    }
}

simulated function int GetShieldAmount(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    return 0;
}


defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    GameStateEffectClass = class'XCGS_Effect_EnergyShieldExtended'
}