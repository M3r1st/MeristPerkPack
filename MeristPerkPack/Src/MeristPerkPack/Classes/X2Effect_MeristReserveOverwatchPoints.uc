class X2Effect_MeristReserveOverwatchPoints extends X2Effect_ReserveOverwatchPoints;

var bool bRemoveActionPoints;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnitState;
    local int i, Points;

    TargetUnitState = XComGameState_Unit(kNewTargetState);
    if (TargetUnitState != none)
    {
        Points = GetNumPoints(TargetUnitState);

        for (i = 0; i < Points; ++i)
        {
            TargetUnitState.ReserveActionPoints.AddItem(GetReserveType(ApplyEffectParameters, NewGameState));
        }

        if (bRemoveActionPoints)
            TargetUnitState.ActionPoints.Length = 0;
    }
}

defaultproperties
{
    bRemoveActionPoints = false
}