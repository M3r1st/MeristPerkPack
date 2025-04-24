class X2TargetingMethod_Fuse_New extends X2TargetingMethod_Fuse;

function Update(float DeltaTime)
{
    local XComGameState_Ability ActualAbility;
    local array<Actor> CurrentlyMarkedTargets;
    local vector NewTargetLocation;
    local array<TTile> EmptyTiles;
    local TTile SnapTile;

    NewTargetLocation = GetTargetedActor().Location;
    SnapTile = `XWORLD.GetTileCoordinatesFromPosition( NewTargetLocation );
    `XWORLD.GetFloorPositionForTile( SnapTile, NewTargetLocation );

    if (NewTargetLocation != CachedTargetLocation)
    {
        ActualAbility = Ability;
        if (FuseAbility != none)
        {
            Ability = FuseAbility;
        }
        else
        {
            EmptyTiles.Length = 0;
            DrawAOETiles(EmptyTiles);
        }
        GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets);
        CheckForFriendlyUnit(CurrentlyMarkedTargets);	
        MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );

        Ability = ActualAbility;

        CachedTargetLocation = NewTargetLocation;
    }
}