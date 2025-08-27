class X2Effect_OnTheMove extends X2Effect_PersistentStatChange;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
    ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
}