class X2TargetingMethod_ViperSpit_New extends X2TargetingMethod_ViperSpit config(GameData);

var vector NewTargetLocation;
var bool bBlocked;
var config bool bSnapToTile;
var config bool bBlockedPreventsActivation;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    SnapToTile = default.bSnapToTile;

    super.Init(InAction, NewTargetIndex);
}

function Update(float DeltaTime)
{
    local XComWorldData     World;
    local TTile             SourceTile, TargetTile, BlockedTile, PeekTile, SnapTile;
    local GameRulesCache_VisibilityInfo VisibilityInfo;
    local bool              GoodView;

    local vector                    FiringLocation;
    local VoxelRaytraceCheckResult  Raytrace;
    local UnitPeekSide              PeekSide;
    local int                       Direction, CanSeeFromDefault, OutRequiresLean;
    local CachedCoverAndPeekData    PeekData;

    local array<Actor>      CurrentlyMarkedTargets;
    local array<TTile>      Tiles;

    NewTargetLocation = super.GetSplashRadiusCenter();
    NewTargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

    if (NewTargetLocation != CachedTargetLocation)
    {
        World = `XWORLD;

        bBlocked = false;
        SourceTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
        TargetTile = World.GetTileCoordinatesFromPosition(NewTargetLocation);
        GoodView = World.CanSeeTileToTile(SourceTile, TargetTile, VisibilityInfo);
        if (!GoodView)
        {
            FiringLocation = FiringUnit.Location;
            FiringLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight + class'XComWorldData'.const.WORLD_HalfFloorHeight;
            if (World.VoxelRaytrace_Locations(FiringLocation, NewTargetLocation, Raytrace))
            {
                BlockedTile = Raytrace.BlockedTile;
                FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, VisibilityInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);
                if (PeekSide != eNoPeek)
                {
                    PeekData = World.GetCachedCoverAndPeekData(SourceTile);
                    if (PeekSide == ePeekLeft)
                        PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
                    else
                        PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

                    TargetTile = World.GetTileCoordinatesFromPosition(NewTargetLocation);
                    if (!World.VoxelRaytrace_Tiles(PeekTile, TargetTile, Raytrace))
                        GoodView = true;
                    else
                        BlockedTile = Raytrace.BlockedTile;
                }
            }
            else
            {
                GoodView = true;
            }
        }
        if (GoodView)
        {
            if (SnapToTile)
            {
                SnapTile = World.GetTileCoordinatesFromPosition(NewTargetLocation);
                World.GetFloorPositionForTile(SnapTile, NewTargetLocation);
            }
        }
        else
        {
            bBlocked = true;
            NewTargetLocation = World.GetPositionFromTileCoordinates(BlockedTile);
        }
        GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
        CheckForFriendlyUnit(CurrentlyMarkedTargets);	
        MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
        DrawSplashRadius();
        DrawAOETiles(Tiles);
    }

    super.UpdateTargetLocation(DeltaTime);
}

simulated protected function Vector GetSplashRadiusCenter(bool SkipTileSnap = false)
{
    return NewTargetLocation;
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
    TargetLocations.Length = 0;
    TargetLocations.AddItem(NewTargetLocation);
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
    local name RetCode;

    RetCode = super.ValidateTargetLocations(TargetLocations);

    if (RetCode == 'AA_Success')
    {
        if (default.bBlockedPreventsActivation && bBlocked)
            RetCode =  'AA_NotVisible';
    }

    return RetCode;
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
    Focus = GetSplashRadiusCenter();
    return true;
}

defaultproperties
{
    SnapToTile = true
}