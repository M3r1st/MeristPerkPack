class X2GetOverHerePuck extends X2GrapplePuck;

var protected bool bInitialized;
var XComGameState_Unit SourceUnit;
var delegate<ValidateGrappleTileDelegate> IsValidGrappleTileFn;

delegate bool ValidateGrappleTileDelegate(const out TTile TileOption, const out XComGameState_Unit SourceUnitState, const out XComGameState_Unit TargetUnitState)
{
    local array<Actor> TileActors;

    TileActors = `XWORLD.GetActorsOnTile(TileOption);
    if (TileActors.Length > 0)
        return false;

    return true;
}

function InitForUnitState(XComGameState_Unit InUnitState)
{
    local XComWorldData WorldData;
    local StaticMesh PuckMesh;
    local StaticMesh PuckMeshConfirmed;
    local TTile SelectedTile;

    UnitState = InUnitState;

    if (!bInitialized)
    {
        InstancedMeshComponent.SetStaticMesh(StaticMesh(DynamicLoadObject("UI_3D.Tile.AOETile", class'StaticMesh')));
        InstancedMeshComponent.SetAbsolute(true, true);

        // load the resources for our components
        GrapplePath.SetMaterial(MaterialInterface(DynamicLoadObject(PathMaterialName, class'MaterialInterface')));

        PuckMesh = StaticMesh(DynamicLoadObject(PuckMeshName, class'StaticMesh'));
        PuckMeshConfirmed = StaticMesh(DynamicLoadObject(PuckMeshConfirmedName, class'StaticMesh'));
        GrapplePuck.SetStaticMeshes(PuckMesh, PuckMeshConfirmed);
        OutOfRangeGrapplePuck.SetStaticMeshes(PuckMesh, PuckMeshConfirmed);

        WaypointMesh.Init();

        // get all valid grapple location
        GetGrappleLocations(GrappleLocations);

        // add tiles for all grapple locations to the grid component
        FillOutGridComponent();

        bInitialized = true;
    }

    // and select the default grapple destination (if any)
    if (GrappleLocations.Length > 0)
    {
        SelectClosestGrappleLocationToUnit();

        // if the controller is active, snap it to the location we just picked
        if(`ISCONTROLLERACTIVE)
        {
            WorldData = `XWORLD;
            SelectedTile = GrappleLocations[SelectedGrappleLocation].Tile;
            Cursor.CursorSetLocation(WorldData.GetPositionFromTileCoordinates(SelectedTile), true);

            // these should probably be added to CursorSetLocation, but in the interests of changing as little
            // as possible for the controller patch, just setting them here.
            Cursor.m_iRequestedFloor = Cursor.WorldZToFloor(Cursor.Location);
            Cursor.m_iLastEffectiveFloorIndex = Cursor.m_iRequestedFloor;
            Cursor.m_bCursorLaunchedInAir = false;
        }
    }
}

function FillOutGridComponent()
{
    super.FillOutGridComponent();
}

static function bool HasGrappleLocations(XComGameState_Unit Unit, optional out array<GrappleTarget> OutGrappleLocations)
{
    return true;
}

function bool GetGrappleTargetLocation(out Vector TargetLocation)
{
    `LOG("GrappleLocations.Length = " $ GrappleLocations.Length, class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
    if (GrappleLocations.Length > 0)
    {
        TargetLocation = GrappleLocations[SelectedGrappleLocation].TileLocation;
        return true;
    }

    return false;
}

function SelectGrappleLocation()
{
    super.SelectGrappleLocation();
    `LOG("LastCursorTile = " $ LastCursorTile.X @ LastCursorTile.Y @ LastCursorTile.Z, class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
    `LOG("SelectedGrappleLocation = " $ SelectedGrappleLocation, class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
}

function GetGrappleLocations(out array<GrappleTarget> OutGrappleLocations)
{
    local XComWorldData     WorldData;
    local array<TTile>      SourceTiles;
    local TTile             SourceTile;
    local array<TTile>      AdjacentTiles;
    local TTile             AdjacentTile;
    local array<TTile>      PossibleTiles;
    local GrappleTarget     NewTarget, EmptyTarget;
    local Vector            TileLocation;

    WorldData = `XWORLD;
    OutGrappleLocations.Length = 0;

    if (SourceUnit != none)
    {
        GatherTilesOccupiedByUnit(SourceUnit, SourceTiles);
        GatherTilesAdjacentToTiles(SourceTiles, AdjacentTiles);

        foreach SourceTiles(SourceTile)
        {
            foreach AdjacentTiles(AdjacentTile)
            {
                if (class'Helpers'.static.FindTileInList(AdjacentTile, PossibleTiles) != INDEX_NONE
                    || class'Helpers'.static.FindTileInList(AdjacentTile, SourceTiles) != INDEX_NONE)
                    continue;

                if (IsValidGrappleTile(AdjacentTile))
                {
                    PossibleTiles.AddItem(AdjacentTile);
                    TileLocation = WorldData.GetPositionFromTileCoordinates(AdjacentTile);

                    NewTarget = EmptyTarget;
                    NewTarget.Tile = AdjacentTile;
                    NewTarget.TileLocation = TileLocation;
                    NewTarget.OverhangLocation = TileLocation;
                    NewTarget.WillBreakWindow = false;
                    OutGrappleLocations.AddItem(NewTarget);
                }
            }
        }
    }

    `LOG("OutGrappleLocations.Length = " $ OutGrappleLocations.Length, class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
}

function bool IsValidGrappleTile(const out TTile TargetTile)
{
    if (IsValidGrappleTileFn != none)
    {
        return IsValidGrappleTileFn(TargetTile, SourceUnit, UnitState);
    }

    return true;
}

static function GatherTilesOccupiedByUnit(const XComGameState_Unit TargetUnit, out array<TTile> OccupiedTiles)
{
    local XComWorldData      WorldData;
    local array<TilePosPair> TilePosPairs;
    local TilePosPair        TilePair;
    local Box                VisibilityExtents;

    TargetUnit.GetVisibilityExtents(VisibilityExtents);
    
    WorldData = `XWORLD;
    WorldData.CollectTilesInBox(TilePosPairs, VisibilityExtents.Min, VisibilityExtents.Max);

    foreach TilePosPairs(TilePair)
    {
        OccupiedTiles.AddItem(TilePair.Tile);
    }
}

static function GatherTilesAdjacentToTiles(out array<TTile> TargetTiles, out array<TTile> AdjacentTiles)
{
    local XComWorldData      WorldData;
    local array<TilePosPair> TilePosPairs;
    local TilePosPair        TilePair;
    local TTile              TargetTile;
    local vector             Minimum;
    local vector             Maximum;

    WorldData = `XWORLD;

    foreach TargetTiles(TargetTile)
    {
        Minimum = WorldData.GetPositionFromTileCoordinates(TargetTile);
        Maximum = Minimum;

        Minimum.X -= WorldData.WORLD_StepSize;
        Minimum.Y -= WorldData.WORLD_StepSize;
        Minimum.Z -= WorldData.WORLD_FloorHeight;

        Maximum.X += WorldData.WORLD_StepSize;
        Maximum.Y += WorldData.WORLD_StepSize;
        Maximum.Z += WorldData.WORLD_FloorHeight;

        WorldData.CollectTilesInBox(TilePosPairs, Minimum, Maximum);

        foreach TilePosPairs(TilePair)
        {
            if (class'Helpers'.static.FindTileInList(TilePair.Tile, AdjacentTiles) != INDEX_NONE)
                continue;

            AdjacentTiles.AddItem(TilePair.Tile);
        }
    }
}

defaultproperties
{
    IsValidGrappleTileFn = ValidateGrappleTileDelegate
}