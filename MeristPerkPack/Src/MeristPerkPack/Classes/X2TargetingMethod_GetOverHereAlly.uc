class X2TargetingMethod_GetOverHereAlly extends X2TargetingMethod_GetOverHere;

function SpawnGrapplePuck()
{
    GrapplePuck = `CURSOR.Spawn(class'X2GetOverHerePuck', `CURSOR);
    GrapplePuck.SourceUnit = UnitState;
    GrapplePuck.IsValidGrappleTileFn = IsTileValidForPull;
}

static function bool IsTileValidForPull(const out TTile TileOption, const out XComGameState_Unit SourceUnitState, const out XComGameState_Unit TargetUnitState)
{
    local XComWorldData World;
    local array<Actor> TileActors;
    local Object PassToDelegate;

    World = `XWORLD;
    TileActors = World.GetActorsOnTile(TileOption);
    if (TileActors.Length > 0)
        return false;

    if (!World.IsFloorTile(TileOption) || !World.CanUnitsEnterTile(TileOption))
        return false;

    return class'X2Condition_BindableTile'.static.IsTileValidForPull(TileOption, SourceUnitState.TileLocation, PassToDelegate);
}