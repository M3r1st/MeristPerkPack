class X2Condition_BindableTile extends X2Condition;

var bool bOnlyForPull;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;
    TargetUnit = XComGameState_Unit(kTarget);
    if (TargetUnit != none)
    {
        if (!bOnlyForPull)
        {
            if (HasBindableNeighborTile(TargetUnit))
            {
                return 'AA_Success';
            }
        }
        else
        {
            if (HasPullableNeighborTile(TargetUnit))
            {
                return 'AA_Success';
            }
        }
        return 'AA_TileIsBlocked';
    }
    else return 'AA_NotAUnit';
}

static function bool HasBindableNeighborTile(XComGameState_Unit UnitState, Vector PreferredDirection = vect(1,0,0), optional out TTile TeleportToTile)
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
    local Vector            SourceLoc, TargetLoc;
    local ECoverType        Cover;
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
                }
            }
        }
    }

    return false;
}

static function bool HasPullableNeighborTile(XComGameState_Unit UnitState, Vector PreferredDirection = vect(1,0,0), optional out TTile TeleportToTile)
{
    if (FindAvailableNeighborTileForPullWeighted(UnitState, PreferredDirection, TeleportToTile))
    {
        return true;
    }
    return false;
}

static function bool IsTileValidForPull(const out TTile TileOption, const out TTile SourceTile, const out Object PassedObject)
{
    local XComWorldData     World;
    local Vector            SourceLoc, TargetLoc;
    local ECoverType        Cover;
    local float             TargetCoverAngle;
    local GameRulesCache_VisibilityInfo OutVisibilityInfo;
    local int               dX, dY, dZ;

    World = `XWORLD;

    if (World.CanSeeTileToTile(SourceTile, TileOption, OutVisibilityInfo))
    {
        if (OutVisibilityInfo.bVisibleFromDefault) // No peeking!
        {
            dX = TileOption.X - SourceTile.X;
            dY = TileOption.Y - SourceTile.Y;
            // Tiles have to be adjacent
            if (Abs(dX) <= 1 && Abs(dY) <= 1)
            {
                // dZ = TileOption.Z - SourceTile.Z;
                dZ = World.GetFloorTileZ(TileOption, false) - World.GetFloorTileZ(SourceTile, false);
                if (Abs(dZ) <= 2 - Abs(dX) - Abs(dY))
                {
                    if (dZ == 0)
                    {
                        return true;
                    }

                    SourceLoc = World.GetPositionFromTileCoordinates(SourceTile);
                    TargetLoc = World.GetPositionFromTileCoordinates(TileOption);
                    if (dZ > 0) // Source is lower
                    {
                        Cover = World.GetCoverTypeForTarget(SourceLoc, TargetLoc, TargetCoverAngle);
                        if (Cover == CT_None)
                        {
                            return true;
                        }
                    }
                    else // Source is higher
                    {
                        Cover = World.GetCoverTypeForTarget(TargetLoc, SourceLoc, TargetCoverAngle);
                        if (Cover == CT_None)
                        {
                            return true;
                        }
                    }
                }
            }
        }
    }

    return false;
}

static function bool FindAvailableNeighborTileForPullWeighted(const XComGameState_Unit SourceUnit, Vector PreferredDirection, out TTile OutTileLocation, optional Object PassToDelegate)
{
    local TTile SourceTile, NeighborTileLocation;
    local XComWorldData World;
    local array<Actor> TileActors;

    local Vector ToNeighbor;
    local TTile BestTile;
    local float DotToPreferred;
    local float BestDot;
    local bool FoundTile;
    local int CardinalScore;
    local int BestCardinalScore;

    World = `XWORLD;

    BestDot = -1.0f; // Exact opposite of preferred direction
    FoundTile = false;
    BestCardinalScore = -1;
    SourceTile = SourceUnit.TileLocation;
    NeighborTileLocation = SourceTile;
    for (NeighborTileLocation.X = SourceTile.X - 1; NeighborTileLocation.X <= SourceTile.X + 1; ++NeighborTileLocation.X)
    {
        for (NeighborTileLocation.Y = SourceTile.Y - 1; NeighborTileLocation.Y <= SourceTile.Y + 1; ++NeighborTileLocation.Y)
        {
            for (NeighborTileLocation.Z = SourceTile.Z - 1; NeighborTileLocation.Z <= SourceTile.Z + 1; ++NeighborTileLocation.Z)
            {
                TileActors = World.GetActorsOnTile(NeighborTileLocation);
                // If the tile is empty and is on the same z as this unit's location
                if (TileActors.Length == 0 && World.IsFloorTile(NeighborTileLocation) && World.CanUnitsEnterTile(NeighborTileLocation))
                {
                    if (!IsTileValidForPull(NeighborTileLocation, SourceTile, PassToDelegate))
                    {
                        continue;
                    }

                    CardinalScore = (abs(NeighborTileLocation.X - SourceTile.X) > 0 && abs(NeighborTileLocation.Y - SourceTile.Y) > 0) ? 0 : 1;
                    ToNeighbor = Normal(World.GetPositionFromTileCoordinates(NeighborTileLocation) - World.GetPositionFromTileCoordinates(SourceTile));
                    DotToPreferred = NoZDot(PreferredDirection, ToNeighbor);
                    // Jwats: Cardinal directions have priority over diagonals
                    if ((DotToPreferred >= BestDot && CardinalScore >= BestCardinalScore) || (CardinalScore > BestCardinalScore))
                    {
                        BestCardinalScore = CardinalScore;
                        BestDot = DotToPreferred;
                        BestTile = NeighborTileLocation;
                        FoundTile = true;
                    }
                }
            }
        }
    }

    if (FoundTile)
    {
        OutTileLocation = BestTile;
    }

    return FoundTile;
}