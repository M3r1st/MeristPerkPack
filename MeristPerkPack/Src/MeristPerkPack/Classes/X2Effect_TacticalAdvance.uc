class X2Effect_TacticalAdvance extends X2Effect_Persistent;

var name ActionPointType;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    if (ActionPointType != '')
    {
         ActionPoints.AddItem(ActionPointType);
    }
    else
    {
        ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
    }
}

defaultproperties
{
    EffectName = M31_TacticalAdvance
    DuplicateResponse = eDupe_Refresh
}
