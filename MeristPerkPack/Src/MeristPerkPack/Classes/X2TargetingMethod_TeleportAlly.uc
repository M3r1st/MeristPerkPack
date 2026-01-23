class X2TargetingMethod_TeleportAlly extends X2TargetingMethod;

// From X2TargetingMethod_TopDown
var X2Camera_LookAtActor    LookatCamera;
var protected int           LastTarget;

// From X2TargetingMethod_Grenade
var protected XCom3DCursor          Cursor;
var protected transient XComEmitter ExplosionEmitter;
var protected bool                  bRequireVisibility;
var protected XComGameState_Player  AssociatedPlayerState;

var bool SnapToTile;

// From X2TargetingMethod_Teleport
var protected X2Actor_InvalidTarget InvalidTileActor;
var protected XComActionIconManager IconManager;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    local XGBattle                      Battle;
    local XComGameStateHistory          History;
    local X2AbilityTarget_TeleportAlly  TeleportAllyTarget;
    local X2AbilityTemplate             AbilityTemplate;

    super.Init(InAction, NewTargetIndex);

    // From X2TargetingMethod_TopDown

    // make sure this ability has a target
    `assert(InAction.AvailableTargets.Length > 0);

    LookatCamera = new class'X2Camera_LookAtActor';
    LookatCamera.UseTether = false;
    `CAMERASTACK.AddCamera(LookatCamera);

    DirectSetTarget(0);

    // From X2TargetingMethod_Grenade

    History = `XCOMHISTORY;

    AssociatedPlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
    `assert(AssociatedPlayerState != none);

    // determine our targeting range and lock the cursor to that range
    AbilityTemplate = Ability.GetMyTemplate();
    Cursor = `Cursor;
    Cursor.m_fMaxChainedDistance = `METERSTOUNITS(GetTargetingRange());

    // set the cursor location to itself to make sure the chain distance updates
    Cursor.CursorSetLocation(Cursor.GetCursorFeetLocation(), false, true); 

    TeleportAllyTarget = X2AbilityTarget_TeleportAlly(Ability.GetMyTemplate().AbilityTargetStyle);
    if (TeleportAllyTarget != none)
        bRequireVisibility = TeleportAllyTarget.bRequireVisibility;

    if (!AbilityTemplate.SkipRenderOfTargetingTemplate)
    {
        // setup the blast emitter
        ExplosionEmitter = `BATTLE.spawn(class'XComEmitter');
        if(AbilityIsOffensive)
        {
            ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));
        }
        else
        {
            ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere_Neutral", class'ParticleSystem')));
        }

        ExplosionEmitter.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
    }

    // From X2TargetingMethod_Teleport
    Battle = `BATTLE;

    InvalidTileActor = Battle.Spawn(class'X2Actor_InvalidTarget');
    ExplosionEmitter.SetHidden(true);

    IconManager = `PRES.GetActionIconMgr();
    IconManager.UpdateCursorLocation(true);
}

function float GetTargetingRange()
{
    local X2AbilityTemplate AbilityTemplate;
    local X2AbilityTarget_TeleportAlly TeleportAllyTarget;
    local float TargetingRange;

    TargetingRange = -1;

    AbilityTemplate = Ability.GetMyTemplate();
    TeleportAllyTarget = X2AbilityTarget_TeleportAlly(AbilityTemplate.AbilityTargetStyle);
    if (TeleportAllyTarget != none)
    {
        TargetingRange = TeleportAllyTarget.GetCursorRangeMeters(Ability);
    }

    return TargetingRange;
}

function bool AllowMouseConfirm()
{
    return true;
}

function Canceled()
{
    super.Canceled();

    if (LookatCamera != none)
    {
        `CAMERASTACK.RemoveCamera(LookatCamera);
    }

    ClearTargetedActors();

    // unlock the 3d cursor
    Cursor.m_fMaxChainedDistance = -1;

    // clean up the ui
    ExplosionEmitter.Destroy();
    InvalidTileActor.Destroy();
    IconManager.ShowIcons(false);
}

function Committed()
{
    Canceled();
}

function Update(float DeltaTime)
{
    local vector NewTargetLocation;
    local array<vector> TargetLocations;
    local array<TTile> Tiles;
    local XComWorldData World;
    local TTile TeleportTile;

    if (LookatCamera.HasArrived)
    {
        `CAMERASTACK.RemoveCamera(LookatCamera);
        LookatCamera = none;
    }

    NewTargetLocation = Cursor.GetCursorFeetLocation();

    if (NewTargetLocation != CachedTargetLocation )
    {
        TargetLocations.AddItem(Cursor.GetCursorFeetLocation());
        if (ValidateTargetLocations(TargetLocations) == 'AA_Success')
        {
            // The current tile the cursor is on is a valid tile
            // Show the ExplosionEmitter
            ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
            InvalidTileActor.SetHidden(true);

            World = `XWORLD;
        
            TeleportTile = World.GetTileCoordinatesFromPosition(TargetLocations[0]);
            Tiles.AddItem(TeleportTile);
            DrawAOETiles(Tiles);
            IconManager.UpdateCursorLocation(, true);
        }
        else
        {
            DrawInvalidTile();
        }
    }

    super.UpdateTargetLocation(DeltaTime);
}

simulated protected function DrawInvalidTile()
{
    local Vector Center;

    Center = GetSplashRadiusCenter();

    // Hide the ExplosionEmitter
    ExplosionEmitter.ParticleSystemComponent.DeactivateSystem();
    
    InvalidTileActor.SetHidden(false);
    InvalidTileActor.SetLocation(Center);
}

simulated protected function Vector GetSplashRadiusCenter(bool SkipTileSnap = false)
{
    local XComWorldData World;
    local vector Center;
    local TTile SnapTile;

    World = `XWORLD;

    Center = Cursor.GetCursorFeetLocation();

    if (SnapToTile && !SkipTileSnap)
    {
        SnapTile = `XWORLD.GetTileCoordinatesFromPosition(Center);

        // keep moving down until we find a floor tile.
        while ((SnapTile.Z >= 0) && !World.GetFloorPositionForTile(SnapTile, Center))
        {
            --SnapTile.Z;
        }
    }

    return Center;
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
    TargetLocations.Length = 0;
    TargetLocations.AddItem(GetSplashRadiusCenter());
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
    local XComWorldData World;
    local TTile         TeleportTile;
    local bool          bFoundFloorTile;

    World = `XWORLD;

    // There is only one target location and visible by squadsight
    if (TargetLocations.Length == 1)
    {
        if (bRequireVisibility)
        {
            TeleportTile = World.GetTileCoordinatesFromPosition(TargetLocations[0]);
            if (!class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(AssociatedPlayerState.ObjectID, TeleportTile))
            {
                return 'AA_NotVisible';
            }
        }

        bFoundFloorTile = World.GetFloorTileForPosition(TargetLocations[0], TeleportTile);
        if (bFoundFloorTile && !World.CanUnitsEnterTile(TeleportTile))
        {
            return 'AA_TileIsBlocked';
        }

        return 'AA_Success';
    }

    return 'AA_NoTargets';
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

function DirectSetTarget(int TargetIndex)
{
    local XComPresentationLayer Pres;
    local UITacticalHUD TacticalHud;
    local Actor TargetedActor;
    local array<TTile> Tiles;
    local TTile TargetedActorTile;
    local XGUnit TargetedPawn;
    local vector TargetedLocation;
    local XComWorldData World;
    local int NewTarget;
    local array<Actor> CurrentlyMarkedTargets;
    local X2AbilityTemplate AbilityTemplate;

    World = `XWORLD;

    // put the targeting reticle on the new target
    Pres = `PRES;
    TacticalHud = Pres.GetTacticalHUD();

    // advance the target counter
    NewTarget = TargetIndex % Action.AvailableTargets.Length;
    if (NewTarget < 0) NewTarget = Action.AvailableTargets.Length + NewTarget;

    LastTarget = NewTarget;
    TacticalHud.TargetEnemy(Action.AvailableTargets[NewTarget].PrimaryTarget.ObjectID);

    // have the idle state machine look at the new target
    if (FiringUnit != none)
    {
        FiringUnit.IdleStateMachine.CheckForStanceUpdate();
    }

    // have the camera look at the new target (or the source unit if no target is available)
    TargetedActor = GetTargetedActor();
    if (TargetedActor != none)
    {
        LookatCamera.ActorToFollow = TargetedActor;
    }
    else if (FiringUnit != none)
    {
        LookatCamera.ActorToFollow = FiringUnit;
    }

    TargetedPawn = XGUnit(TargetedActor);
    if (TargetedPawn != none)
    {
        TargetedLocation = TargetedPawn.GetFootLocation();
        TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
        TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
    }
    else
    {
        TargetedLocation = TargetedActor.Location;
    }

    AbilityTemplate = Ability.GetMyTemplate();

    if (AbilityTemplate.AbilityMultiTargetStyle != none)
    {
        AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(Ability, TargetedLocation, Tiles);
    }

    if (AbilityTemplate.AbilityTargetStyle != none)
    {
        AbilityTemplate.AbilityTargetStyle.GetValidTilesForLocation(Ability, TargetedLocation, Tiles);
    }

    if (Tiles.Length > 1)
    {
        GetTargetedActors(TargetedLocation, CurrentlyMarkedTargets, Tiles);
        CheckForFriendlyUnit(CurrentlyMarkedTargets);
        MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);
        DrawAOETiles(Tiles);
    }
    else if (AbilityTemplate.DataName == 'Interact_ActivateAscensionGate')
    {
        bSeriousConsequencesForAction = true;
    }
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
    local Actor TargetedActor;
    local X2VisualizerInterface TargetVisualizer;

    TargetedActor = GetTargetedActor();

    if (TargetedActor != none)
    {
        TargetVisualizer = X2VisualizerInterface(TargetedActor);
        if (TargetVisualizer != None )
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

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
    Ability.GatherAdditionalAbilityTargetsForLocation(GetSplashRadiusCenter(), AdditionalTargets);
    return true;
}

defaultproperties
{
    SnapToTile = true
}