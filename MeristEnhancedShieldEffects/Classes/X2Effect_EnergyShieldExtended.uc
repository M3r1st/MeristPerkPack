class X2Effect_EnergyShieldExtended extends X2Effect_PersistentStatChange;

var int ShieldPriority;

var delegate<ShieldsTakeDamage> ShieldsTakeDamageFn;

delegate ShieldsTakeDamage(X2Effect_EnergyShieldExtended ShieldEffect, XComGameState_Effect kNewEffectState, XComGameState NewGameState, XComGameState_Unit kTargetUnitState, int DamageTaken);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit                kTargetUnitState;
    local XCGS_Effect_EnergyShieldExtended  EffectState;
    local XCGS_Effect_EnergyShieldInterface InterfaceEffectState;
    local int ShieldStrength;

    kTargetUnitState = XComGameState_Unit(kNewTargetState);
    `assert(kTargetUnitState != none);
    EffectState = XCGS_Effect_EnergyShieldExtended(NewEffectState);
    EffectState.AddLinkedInterfaceEffectRef();

    ShieldStrength = GetShieldAmount(ApplyEffectParameters, kNewTargetState, NewGameState, EffectState);

    m_aStatChanges.Length = 0;
    AddPersistentStatChange(eStat_ShieldHP, ShieldStrength);

    EffectState = XCGS_Effect_EnergyShieldExtended(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
    EffectState.ShieldPriority = ShieldPriority;
    EffectState.ShieldRemaining = ShieldStrength;

    InterfaceEffectState = XCGS_Effect_EnergyShieldInterface(`XCOMHISTORY.GetGameStateForObjectID(EffectState.LinkedInterfaceEffectRef.ObjectID));
    InterfaceEffectState.AddShieldEffectRefToInterface(EffectState);
    InterfaceEffectState.LogShieldEffectStates(NewGameState);
    
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit                UnitState;	
    local XCGS_Effect_EnergyShieldExtended  EffectState;
    local XCGS_Effect_EnergyShieldInterface InterfaceEffectState;
    local int ShieldCurrent;
    local int ShieldRemaining;
    local int NewShieldHP;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    `assert(UnitState != none);
    EffectState = XCGS_Effect_EnergyShieldExtended(RemovedEffectState);

    ShieldRemaining = EffectState.ShieldRemaining;
    ShieldCurrent = UnitState.GetCurrentStat(eStat_ShieldHP);
    NewShieldHP = ShieldCurrent - ShieldRemaining;

    InterfaceEffectState = XCGS_Effect_EnergyShieldInterface(`XCOMHISTORY.GetGameStateForObjectID(EffectState.LinkedInterfaceEffectRef.ObjectID));
    InterfaceEffectState.RemoveShieldEffectRefFromInterface(EffectState);
    InterfaceEffectState.LogShieldEffectStates(NewGameState);

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    if (NewShieldHP > 0)
    {
        UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
        UnitState.SetCurrentStat(eStat_ShieldHP, NewShieldHP);
		NewGameState.AddStateObject(UnitState);
    }
}

simulated function int GetShieldAmount(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    return 0;
}


defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    bForceReapplyOnRefresh = true
    GameStateEffectClass = class'XCGS_Effect_EnergyShieldExtended'
}