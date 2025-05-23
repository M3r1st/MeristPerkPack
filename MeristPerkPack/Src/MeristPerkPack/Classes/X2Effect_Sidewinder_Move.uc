class X2Effect_Sidewinder_Move extends X2Effect_Persistent;

var privatewrite name OriginalGroupValueName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnit;
    local XComGameState_AIGroup GroupState;

    TargetUnit = XComGameState_Unit(kNewTargetState);
    GroupState = TargetUnit.GetGroupMembership();

    TargetUnit.SetUnitFloatValue(OriginalGroupValueName, GroupState.ObjectID, eCleanup_BeginTactical);

    GroupState = XComGameState_AIGroup(NewGameState.CreateNewStateObject(class'XComGameState_AIGroup'));	
    GroupState.AddUnitToGroup(TargetUnit.ObjectID, NewGameState);
    GroupState.bSummoningSicknessCleared = true;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit TargetUnit;
    local XComGameState_AIGroup GroupState;
    local UnitValue GroupValue;

    TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    GroupState = TargetUnit.GetGroupMembership();
    `assert(GroupState.m_arrMembers.Length == 1 && GroupState.m_arrMembers[0].ObjectID == TargetUnit.ObjectID);
    NewGameState.RemoveStateObject(GroupState.ObjectID);

    TargetUnit.GetUnitValue(OriginalGroupValueName, GroupValue);
    GroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(class'XComGameState_AIGroup', GroupValue.fValue));
    GroupState.AddUnitToGroup(TargetUnit.ObjectID, NewGameState);
    TargetUnit.ClearUnitValue(OriginalGroupValueName);
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    local UnitValue GroupValue;
    local XComGameState_AIGroup GroupState;

    GroupState = UnitState.GetGroupMembership();
    UnitState.GetUnitValue(OriginalGroupValueName, GroupValue);

    if (GroupState.ObjectID != GroupValue.fValue && UnitState.IsAbleToAct())
    {
        ActionPoints.Length = 0;
        ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
    }	
}

defaultproperties
{
    EffectName = "M31_Sidewinder_Move"
    DuplicateResponse = eDupe_Ignore
}