//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_MeleePathWithRadius.uc
//  AUTHOR:  Merist
//  PURPOSE: 
//---------------------------------------------------------------------------------------
class X2TargetingMethod_MeleePathWithRadius extends X2TargetingMethod_MeleePath;

var X2AbilityTemplate AbilityTemplate;
var TTile LastDestination;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    super.Init(InAction, NewTargetIndex);

    AbilityTemplate = Ability.GetMyTemplate();
}

function DirectSetTarget(int TargetIndex)
{
    local Actor TargetedActor;
    local array<TTile> Tiles;
    local TTile TargetedActorTile;
    local XGUnit TargetedPawn;
    local vector TargetedLocation;
    local XComWorldData World;

    super.DirectSetTarget(TargetIndex);

    TargetedActor = GetTargetedActor();
    TargetedPawn = XGUnit(TargetedActor);
    if (TargetedPawn != none)
    {
        World = `XWORLD;
        TargetedLocation = TargetedPawn.GetFootLocation();
        TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
        TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
        LastDestination = TargetedActorTile;

        AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(Ability, TargetedLocation, Tiles);

        if (Tiles.Length > 1)
        {
            DrawAOETiles(Tiles);
        }
    }
}

function TickUpdatedDestinationTile(TTile NewDestination)
{
    local Actor TargetedActor;
    local array<TTile> Tiles;
    local TTile TargetedActorTile;
    local XGUnit TargetedPawn;
    local vector TargetedLocation;
    local XComWorldData World;
    local array<Actor> CurrentlyMarkedTargets;
    local X2AbilityMultiTarget_Radius RadiusMultiTarget;

    TargetedActor = GetTargetedActor();
    TargetedPawn = XGUnit(TargetedActor);
    if (TargetedPawn != none)
    {
        World = `XWORLD;
        TargetedLocation = TargetedPawn.GetFootLocation();
        TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
        TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
        LastDestination = NewDestination;

        RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
        if (RadiusMultiTarget != none)
        {
            RadiusMultiTarget.GetValidTilesForLocation(Ability, TargetedLocation, Tiles);

            if (Tiles.Length > 1)
            {
                DrawAOETiles(Tiles);

                GetTargetedActorsInTiles(Tiles, CurrentlyMarkedTargets, true);
                MarkTargetedActors(CurrentlyMarkedTargets);
            }
        }
    }
}

function bool GetPreAbilityPath(out array<TTile> PathTiles)
{
    PathTiles = PathingPawn.PathTiles;
    return PathTiles.Length > 1;
}

protected function Vector GetPathDestination()
{
    local XComWorldData WorldData;
    local TTile Tile;

    WorldData = `XWORLD;
    if (PathingPawn.PathTiles.Length > 0)
    {
        Tile = PathingPawn.PathTiles[PathingPawn.PathTiles.Length - 1];
    }
    else
    {
        Tile = UnitState.TileLocation;
    }

    return WorldData.GetPositionFromTileCoordinates(Tile);
}

// function GetTargetLocations(out array<Vector> TargetLocations)
// {
// 	TargetLocations.AddItem(GetPathDestination());
// }

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
    local Actor TargetedActor;
    local array<TTile> Tiles;
    local TTile TargetedActorTile;
    local XGUnit TargetedPawn;
    local vector TargetedLocation;
    local XComWorldData World;
    local array<Actor> CurrentlyMarkedTargets;
    local XGUnit CurrentTargetUnit;
    local int i;
    local name AvailableCode;
    local XComGameStateHistory History;
    local XComGameState_BaseObject StateObject;
    local X2AbilityMultiTarget_Radius RadiusMultiTarget;

    TargetedActor = GetTargetedActor();
    TargetedPawn = XGUnit(TargetedActor);

    // Start Issue #1408
    /// HL-Docs: ref:Bugfixes; issue:1408
    /// Fixes a bug with Arc Wave targeting where an ability could hit enemies not targeted by the player
    AdditionalTargets.AdditionalTargets.Length = 0;
    // End Issue #1408

    if (TargetedPawn != none)
    {
        World = `XWORLD;
        TargetedLocation = TargetedPawn.GetFootLocation();
        TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
        TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);

        RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
        if (RadiusMultiTarget != none)
        {
            RadiusMultiTarget.GetValidTilesForLocation(Ability, TargetedLocation, Tiles);

            if (Tiles.Length > 1)
            {
                GetTargetedActorsInTiles(Tiles, CurrentlyMarkedTargets, true);
                
                History = `XCOMHISTORY;
                for (i = 0; i < CurrentlyMarkedTargets.Length; ++i)
                {
                    CurrentTargetUnit = XGUnit(CurrentlyMarkedTargets[i]);
                    if (CurrentTargetUnit != none)
                    {
                        StateObject = History.GetGameStateForObjectID(CurrentTargetUnit.ObjectID);
                        AvailableCode = AbilityTemplate.CheckMultiTargetConditions(Ability, UnitState, StateObject);
                        if (AvailableCode == 'AA_Success' && StateObject.ObjectID != AdditionalTargets.PrimaryTarget.ObjectID)
                        {
                            if (AdditionalTargets.AdditionalTargets.Find('ObjectID', StateObject.ObjectID) == INDEX_NONE)
                                AdditionalTargets.AdditionalTargets.AddItem(StateObject.GetReference());
                        }
                    }
                }

                return true;
            }
        }
    }

    return false;
}

function Canceled()
{
    super.Canceled();
    ClearTargetedActors();
}