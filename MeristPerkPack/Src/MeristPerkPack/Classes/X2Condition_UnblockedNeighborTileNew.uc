class X2Condition_UnblockedNeighborTileNew extends X2Condition_UnblockedNeighborTile;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;
    local TTile NeighborTile;

    TargetUnit = XComGameState_Unit(kTarget);
    `assert(TargetUnit != none);

    if (RequireVisible)
    {
        if (class'X2Effect_GetOverHereNew'.static.HasBindableNeighborTile(TargetUnit))
        {
            return 'AA_Success';
        }
    }
    else
    {
        if (TargetUnit.FindAvailableNeighborTile(NeighborTile))
        {
            return 'AA_Success';
        }
    }
    
    return 'AA_TileIsBlocked';
}