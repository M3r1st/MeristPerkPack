class X2TargetingMethod_GetOverHere extends X2TargetingMethod config(GameData);

var config bool bLog;
var protected X2Camera_LookAtActor LookAtCamera;
var protected X2GetOverHerePuck GrapplePuck;
var protected int LastTarget;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    super.Init(InAction, NewTargetIndex);

    `assert(InAction.AvailableTargets.Length > 0);

    SpawnGrapplePuck();

    DirectSetTarget(0);
}

function SpawnGrapplePuck()
{
    GrapplePuck = `CURSOR.Spawn(class'X2GetOverHerePuck', `CURSOR);
    GrapplePuck.SourceUnit = UnitState;
    GrapplePuck.IsValidGrappleTileFn = IsTileValidForBind;
}

function Canceled()
{
    if (LookAtCamera != none)
    {
        `CAMERASTACK.RemoveCamera(LookAtCamera);
    }
    GrapplePuck.Destroy();
}

function Committed()
{
    if (LookAtCamera != none)
    {
        `CAMERASTACK.RemoveCamera(LookAtCamera);
    }
    GrapplePuck.ShowConfirmAndDestroy();
}

function Update(float DeltaTime)
{
    if (LookAtCamera.HasArrived)
    {
        `CAMERASTACK.RemoveCamera(LookAtCamera);
        LookAtCamera = none;
    }
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
    local Vector TargetLocation;

    TargetLocations.Length = 0;
    if (GrapplePuck.GetGrappleTargetLocation(TargetLocation))
    {
        TargetLocations.AddItem(TargetLocation);
    }
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
    return TargetLocations.Length == 1 ? 'AA_Success' : 'AA_NoTargets';
}

function DirectSetTarget(int TargetIndex)
{
    local XComGameState_Unit    TargetUnit;
    local UITacticalHUD         TacticalHUD;
    local int                   NewTarget;
    local Actor                 TargetedActor;

    TacticalHUD = `PRES.GetTacticalHUD();
    NewTarget = TargetIndex % Action.AvailableTargets.Length;
    if (NewTarget < 0) NewTarget = Action.AvailableTargets.Length + NewTarget;
    LastTarget = NewTarget;
    TacticalHUD.TargetEnemy(Action.AvailableTargets[NewTarget].PrimaryTarget.ObjectID);

    if (FiringUnit != none)
    {
        FiringUnit.IdleStateMachine.CheckForStanceUpdate();
    }

    if (LookAtCamera == none)
    {
        LookAtCamera = new class'X2Camera_LookAtActor';
        LookAtCamera.UseTether = false;
        `CAMERASTACK.AddCamera(LookAtCamera);
    }
    if (LookAtCamera != none)
    {
        TargetedActor = GetTargetedActor();
        if (TargetedActor != none)
        {
            LookatCamera.ActorToFollow = TargetedActor;
        }
        else if (FiringUnit != none)
        {
            LookatCamera.ActorToFollow = FiringUnit;
        }
    }

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Action.AvailableTargets[NewTarget].PrimaryTarget.ObjectID));
    if (TargetUnit != none)
    {
        GrapplePuck.InitForUnitState(TargetUnit);
    }
}

function NextTarget()
{
    DirectSetTarget(LastTarget + 1);
}

function PrevTarget()
{
    DirectSetTarget(LastTarget - 1);
}

function int GetTargetIndex()
{
    return LastTarget;
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
    local Actor TargetedActor;
    local X2VisualizerInterface TargetVisualizer;

    TargetedActor = GetTargetedActor();

    if (TargetedActor != none)
    {
        TargetVisualizer = X2VisualizerInterface(TargetedActor);
        if (TargetVisualizer != none)
        {
            Focus = TargetVisualizer.GetTargetingFocusLocation();
        }
        else
        {
            Focus = TargetedActor.Location;
        }

        return true;
    }
    
    return false;
}

function bool AllowMouseConfirm()
{
    return true;
}

static function bool IsTileValidForBind(const out TTile TileOption, const out XComGameState_Unit SourceUnitState, const out XComGameState_Unit TargetUnitState)
{
    local array<Actor> TileActors;
    local Object PassToDelegate;

    TileActors = `XWORLD.GetActorsOnTile(TileOption);
    if (TileActors.Length > 0)
        return false;

    return class'X2Condition_BindableTile'.static.IsTileValidForBind(TileOption, SourceUnitState.TileLocation, PassToDelegate);
}