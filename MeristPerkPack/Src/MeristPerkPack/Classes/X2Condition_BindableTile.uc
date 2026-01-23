class X2Condition_BindableTile extends X2Condition_UnblockedNeighborTile;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;
    local TTile NeighborTile;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit != none)
    {
        if (RequireVisible)
        {
            if (HasBindableNeighborTile(TargetUnit))
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
    else return 'AA_NotAUnit';
}

static function bool HasBindableNeighborTile(XComGameState_Unit UnitState, vector PreferredDirection = vect(1,0,0), optional out TTile TeleportToTile)
{
    if (UnitState.FindAvailableNeighborTileWeighted(PreferredDirection, TeleportToTile, IsTileValidForBind))
    {
        return true;
    }
    return false;
}

static function bool IsTileValidForBind(const out TTile TileOption, const out TTile SourceTile, const out Object PassedObject)
{
    local XComWorldData     World;
    local GameRulesCache_VisibilityInfo OutVisibilityInfo;
    local vector            SourceLoc, TargetLoc, OtherLocX, OtherLocY;
    local TTile             OtherTileX, OtherTileY;
    local ECoverType        Cover, CoverSourceToOtherX, CoverSourceToOtherY, CoverTargetToOtherX, CoverTargetToOtherY;
    local float             TargetCoverAngle;
    local int               dX, dY;

    World = `XWORLD;

    // Match the tile visibility condition checks from the Bind ability template as much as possible.
    //   Actual conditions from Bind ability cannot be directly tested without the units in place
    //   i.e. gameplay visibility not tested via CanSeeTileToTile.
    if (World.CanSeeTileToTile(SourceTile, TileOption, OutVisibilityInfo))
    {
        if (OutVisibilityInfo.bVisibleFromDefault) // No peeking!
        {
            // Tiles have to be on the same elevation
            if (SourceTile.Z == TileOption.Z)
            {
                dX = TileOption.X - SourceTile.X;
                dY = TileOption.Y - SourceTile.Y;
                // Tiles have to be adjacent
                if (Abs(dX) <= 1 && Abs(dY) <= 1)
                {
                    // No high cover allowed for bind. CanSeeTileToTile does not update TargetCover either, so we must check this manually.
                    SourceLoc = World.GetPositionFromTileCoordinates(SourceTile);
                    TargetLoc = World.GetPositionFromTileCoordinates(TileOption);
                    Cover = World.GetCoverTypeForTarget(SourceLoc, TargetLoc, TargetCoverAngle);
                    if (Cover != CT_Standing)
                    {
                        return true;
                    }
                    // Diagonal neighbours
                    if (dX != 0 && dY != 0)
                    {
                        OtherTileX = SourceTile;
                        OtherTileX.X += dX;
                        OtherLocX = World.GetPositionFromTileCoordinates(OtherTileX);

                        OtherTileY = SourceTile;
                        OtherTileY.Y += dY;
                        OtherLocY = World.GetPositionFromTileCoordinates(OtherTileY);

                        CoverSourceToOtherX = World.GetCoverTypeForTarget(SourceLoc, OtherLocX, TargetCoverAngle);
                        CoverSourceToOtherY = World.GetCoverTypeForTarget(SourceLoc, OtherLocY, TargetCoverAngle);
                        CoverTargetToOtherX = World.GetCoverTypeForTarget(TargetLoc, OtherLocX, TargetCoverAngle);
                        CoverTargetToOtherY = World.GetCoverTypeForTarget(TargetLoc, OtherLocY, TargetCoverAngle);

                        if (CoverTargetToOtherX == CT_Standing && CoverTargetToOtherY != CT_Standing)
                        {
                            if (CoverSourceToOtherX != CT_None && CoverSourceToOtherY == CT_None)
                            {
                                return true;
                            }
                        }
                        else if (CoverTargetToOtherX != CT_Standing && CoverTargetToOtherY == CT_Standing)
                        {
                            if (CoverSourceToOtherX == CT_None && CoverSourceToOtherY != CT_None)
                            {
                                return true;
                            }
                        }
                    }
                }
            }
        }
    }
    
    return false;
}