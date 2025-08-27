class X2Effect_ChangeUnitValue extends X2Effect_SetUnitValue;

var int iMinValue;
var int iMaxValue;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnitState;
    local UnitValue UnitVal;
    local int NewValue;
    
    TargetUnitState = XComGameState_Unit(kNewTargetState);
    TargetUnitState.GetUnitValue(UnitName, UnitVal);
    
    NewValue = Clamp(UnitVal.fValue + NewValueToSet, iMinValue, iMaxValue);
    TargetUnitState.SetUnitFloatValue(UnitName, NewValue, CleanupType);
}