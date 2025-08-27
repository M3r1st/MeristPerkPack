class X2TargetingMethod_AreaTopDown extends X2TargetingMethod_TopDown;

function Update(float DeltaTime)
{
    local array<Actor> CurrentlyMarkedTargets;
    local array<TTile> Tiles;
    local vector NewTargetLocation;
    local TTile SnapTile;
    local Actor TargetedActor, CurrentTarget;
    local XGUnit TargetedUnit;

    TargetedActor = GetTargetedActor();
    NewTargetLocation = TargetedActor.Location;
    SnapTile = `XWORLD.GetTileCoordinatesFromPosition(NewTargetLocation);
    `XWORLD.GetFloorPositionForTile(SnapTile, NewTargetLocation);

    if (NewTargetLocation != CachedTargetLocation)
    {
        GetTargetedActors(TargetedActor.Location, CurrentlyMarkedTargets, Tiles);
        foreach CurrentlyMarkedTargets(CurrentTarget)
        {
            TargetedUnit = XGUnit(CurrentTarget);
            if (TargetedUnit == none)
            {
                CurrentlyMarkedTargets.RemoveItem(CurrentTarget);
            }
            else
            {
                if (FiringUnit.GetTeam() == TargetedUnit.GetTeam())
                    CurrentlyMarkedTargets.RemoveItem(CurrentTarget);
            }
        }

        MarkTargetedActors(CurrentlyMarkedTargets, ((!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None));

        CachedTargetLocation = NewTargetLocation;
    }
}

function Canceled()
{
    super.Canceled();
    ClearTargetedActors();
}
