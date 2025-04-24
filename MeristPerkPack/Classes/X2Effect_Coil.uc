class X2Effect_Coil extends X2Effect_Persistent;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
}