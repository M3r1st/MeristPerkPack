class X2Effect_WatchfulEye extends X2Effect_Persistent;

var name CountValueName;
var privatewrite name HoloEffectName;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
    return true;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;
    local UnitValue UnitVal;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
    {
        SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    }
    if (SourceUnit != none)
    {
        SourceUnit.GetUnitValue(CountValueName, UnitVal);
        SourceUnit.SetUnitFloatValue(CountValueName, UnitVal.fValue + 1, eCleanup_BeginTurn);
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XComGameState_Effect HoloEffectState;

    HoloEffectState = TargetUnit.GetUnitAffectedByEffectState(default.HoloEffectName);

    return HoloEffectState != none && HoloEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID;
}

defaultproperties
{
    EffectName = M31_WatchfulEye
    DuplicateResponse = eDupe_Refresh

    HoloEffectName = LWHoloTarget
    CountValueName = M31_WatchfulEye_Counter
}