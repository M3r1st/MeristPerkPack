//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_MeristPinions.uc
//  AUTHOR:  Merist
//  NOTE:    This class is still a work-in-progress.
//---------------------------------------------------------------------------------------
class X2TargetingMethod_MeristPinions extends X2TargetingMethod config(GameData);

var protected XCom3DCursor                  Cursor;
var protected XComWorldData                 World;
var protected XComPresentationLayer         Pres;
var protected X2AbilityTemplate             AbilityTemplate;
var protected X2AbilityMultiTarget_MeristPinions    PinionsMultiTarget;
var protected XComGameState_Player          AssociatedPlayerState;

var protected Vector                        LockedAreaLocation;
var protected array<TTile>                  AreaTiles;

var protected array<TTile>                  TargetTiles;
var protected transient array<XComEmitter>  TargetEmitters;
var protected int                           TargetIndex;

var protected X2Actor_InvalidTarget         InvalidTileActor;
var protected X2Actor_BlazingPinionsTarget  LockedAreaActor;
var protected transient XComEmitter         ExplosionEmitter;
var protected UIScrollingTextField          TextField;
var config int TextFieldOffsetX;
var config int TextFieldOffsetY;

var protected bool                          bAreaLocked;
var protected bool                          bFinalClickReady;
var protected bool                          bRestrictToSquadsightRange;

var protected ParticleSystem                TargetEmitterPS;

var localized string strLockAreaText;
var localized string strSelectLocationText;
var localized string strConfirmActivationText;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    local XComGameStateHistory      History;
    local XGBattle                  Battle;
    local X2AbilityTarget_Cursor    CursorTarget;
    local UITacticalHUD             TacticalHUD;

    super.Init(InAction, NewTargetIndex);

    World = `XWORLD;
    History = `XCOMHISTORY;
    Battle = `BATTLE;

    Pres = `PRES;
    Pres.m_kTacticalHUD.Movie.Stack.SubscribeToOnInputForScreen(Pres.m_kTacticalHUD, OnTacticalHUDInput);

    AssociatedPlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
    AbilityTemplate = Ability.GetMyTemplate();
    PinionsMultiTarget = X2AbilityMultiTarget_MeristPinions(AbilityTemplate.AbilityMultiTargetStyle);

    Cursor = `Cursor;
    Cursor.m_fMaxChainedDistance = GetTargetingRange();
    Cursor.CursorSetLocation(Cursor.GetCursorFeetLocation(), false, true); 

    CursorTarget = X2AbilityTarget_Cursor(AbilityTemplate.AbilityTargetStyle);
    if (CursorTarget != none)
    {
        bRestrictToSquadsightRange = CursorTarget.bRestrictToSquadsightRange;
    }

    InvalidTileActor = Battle.Spawn(class'X2Actor_InvalidTarget');
    LockedAreaActor = Battle.Spawn(class'X2Actor_BlazingPinionsTarget');

    if (!AbilityTemplate.SkipRenderOfTargetingTemplate)
    {
        // setup the blast emitter
        ExplosionEmitter = Battle.Spawn(class'XComEmitter');
        if (AbilityIsOffensive)
        {
            ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));
        }
        else
        {
            ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere_Neutral", class'ParticleSystem')));
        }

        ExplosionEmitter.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
        ExplosionEmitter.SetHidden(true);
    }

    TargetEmitterPS = ParticleSystem(`CONTENT.RequestGameArchetype("FX_Archon.P_BlazingPinions_Target"));

    TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
    TextField = TacticalHUD.Spawn(class'UIScrollingTextField', TacticalHUD);
    TextField.bAnimateOnInit = false;
    TextField.InitScrollingText('MeristPinions_SelectTargetText', "", 400, 0, 0);
    TextField.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("N/A", eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));
    TextField.ShowShadow(0);
}

function Committed()
{
    Canceled();
}

function Canceled()
{
    super.Canceled();

    AreaTiles.Length = 0;
    DrawAOETiles(AreaTiles);
    ClearAllTargets(); // In case some hotkey isn't caught by canceled input,
                       // such as switching to another ability or something.
    if (Pres != none)
    {
        Pres.m_kTacticalHUD.Movie.Stack.UnsubscribeFromOnInputForScreen(Pres.m_kTacticalHUD, OnTacticalHUDInput);
    }
    Cursor.m_fMaxChainedDistance = -1;
    ExplosionEmitter.Destroy();
    InvalidTileActor.Destroy();
    LockedAreaActor.Destroy();
    TextField.Remove();
    TextField.Destroy();
    ClearTargetedActors();
}

private function ClearAllTargets()
{
    local XComEmitter TargetEmitter;

    TargetIndex = 0;
    TargetTiles.Length = 0;
    foreach TargetEmitters(TargetEmitter)
    {
        TargetEmitter.Destroy();
    }
    TargetEmitters.Length = 0;
}

simulated protected function bool OnTacticalHUDInput(UIScreen Screen, int iInput, int ActionMask)
{
    if (!Screen.CheckInputIsReleaseOrDirectionRepeat(iInput, ActionMask))
    {
        return false;
    }

    switch (iInput)
    {
        case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
        case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
        // Do people really use controllers to play XCOM?
        case class'UIUtilities_Input'.static.GetBackButtonInputCode():
        case class'UIUtilities_Input'.const.FXS_BUTTON_START:
        case class'UIUtilities_Input'.const.FXS_BUTTON_B:
        case class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER:
            return CancelInput();
    }

    return false;
}

// Returns true if we handled the right click and there's no need to kill the targeting method yet.
protected function bool CancelInput()
{
    bFinalClickReady = false;

    if (TargetIndex > 0)
    {
        RemoveLastTargetTile();
        CachedTargetLocation.Z = -255;
        return true; // after removing the last location you still have to cancel one additional time to unlock the area.
    }
    
    if (bAreaLocked)
    {
        Cursor.m_fMaxChainedDistance = GetTargetingRange();
        bAreaLocked = false;
        // Move to an impossible location to force an update
        CachedTargetLocation.Z = -255;
        return true;
    }

    return false;
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
    local Vector Center;
    local TTile CenterTile;
    local int i;

    TargetLocations.Length = 0;

    // First, add the initial area
    TargetLocations.AddItem(LockedAreaLocation);

    // Then add all of the cached target locations
    for (i = 0; i < TargetIndex; i++)
    {
        CenterTile = TargetTiles[i];
        TargetLocations.AddItem(World.GetPositionFromTileCoordinates(CenterTile));
    }

    // Lastly, if there are still available targets, add the pending one
    if (TargetIndex < GetNumTargets())
    {
        Center = GetSplashRadiusCenter();
        CenterTile = World.GetTileCoordinatesFromPosition(Center);
        if (class'Helpers'.static.FindTileInList(CenterTile, AreaTiles) != INDEX_NONE
            && class'Helpers'.static.FindTileInList(CenterTile, TargetTiles) == INDEX_NONE)
        {
            TargetLocations.AddItem(GetSplashRadiusCenter());
        }
    }
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
    local TTile     SelectedTile;
    local Vector    SelectedLocation;
    local name      ReturnCode;

    if (bFinalClickReady)
    {
        return 'AA_Success';
    }
    
    ReturnCode = super.ValidateTargetLocations(TargetLocations);
    if (ReturnCode == 'AA_Success')
    {
        SelectedLocation = TargetLocations[TargetLocations.Length - 1];
        SelectedTile = World.GetTileCoordinatesFromPosition(SelectedLocation);
        if (bRestrictToSquadsightRange)
        {
            if (!class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(AssociatedPlayerState.ObjectID, SelectedTile))
            {
                return 'AA_NotVisible';
            }
        }
        if (bAreaLocked) // If area is locked, then it means we're clicking to place a pawn.
        {
            // Only tiles within the bounds of designated area are valid.
            if (class'Helpers'.static.FindTileInList(SelectedTile, AreaTiles) == INDEX_NONE)
            {
                ReturnCode = 'AA_TileIsBlocked';
            }

            // Only tiles that were not previously selected are valid.
            if (class'Helpers'.static.FindTileInList(SelectedTile, TargetTiles) != INDEX_NONE)
            {
                ReturnCode = 'AA_TileIsBlocked';
            }
        }
    }
    return ReturnCode;
}

function bool VerifyTargetableFromIndividualMethod(delegate<ConfirmAbilityCallback> fnCallback)
{
    if (bFinalClickReady)
        return true;

    // First click locks the targeted area.
    if (!bAreaLocked)
    {
        LockedAreaLocation = CachedTargetLocation;
        Cursor.m_fMaxChainedDistance = -1;
        bAreaLocked = true;
        CachedTargetLocation.Z = -255;
        return false;
    }

    // Following clicks will lock the new target tile.
    AddNewTargetTile();
    // Then see if we need to lock more.
    if (TargetIndex < GetNumTargets())
    {
        CachedTargetLocation.Z = -255;
        return false;
    }

    bFinalClickReady = true;
    CachedTargetLocation.Z = -255;
    return false;
}

protected function AddNewTargetTile()
{
    local Vector        TargetLocation;
    local TTile	        TargetTile;
    local XComEmitter   TargetEmitter;

    TargetLocation = CachedTargetLocation;
    TargetTile = World.GetTileCoordinatesFromPosition(TargetLocation);
    TargetTiles[TargetIndex] = TargetTile;

    TargetEmitter = `BATTLE.Spawn(class'XComEmitter');
    TargetEmitter.SetTemplate(TargetEmitterPS);
    TargetEmitter.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
    TargetEmitter.SetDrawScale(1);
    TargetEmitter.SetRotation(rot(0,0,1));
    if (!TargetEmitter.ParticleSystemComponent.bIsActive)
    {
        TargetEmitter.ParticleSystemComponent.ActivateSystem();
    }
    TargetEmitter.SetLocation(TargetLocation);
    TargetEmitters.AddItem(TargetEmitter);

    TargetIndex++;
}

protected function RemoveLastTargetTile()
{
    local XComEmitter TargetEmitter;
    local TTile EmptyTile;

    if (TargetIndex > 0)
    {
        TargetEmitter = TargetEmitters[TargetIndex - 1];
        TargetEmitters.Remove(TargetIndex - 1, 1);
        TargetEmitter.Destroy();

        TargetTiles[TargetIndex - 1] = EmptyTile;

        TargetIndex--;
    }
}

function Update(float DeltaTime)
{
    local array<Actor>  CurrentlyMarkedTargets;
    local array<TTile>  Tiles;
    local Vector        NewTargetLocation;
    local TTile         SelectedTile;
    local Vector2D      vMouseCursorPos;
    local string        TextFieldString;

    // vMouseCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(Cursor.Location);
    // TextField.SetPosition((vMouseCursorPos.X + 1) * 960 + 60, (1 - vMouseCursorPos.Y) * 540 + 180);

    NewTargetLocation = GetSplashRadiusCenter();

    if (NewTargetLocation != CachedTargetLocation)
    {
        vMouseCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(NewTargetLocation);
        TextField.SetPosition((vMouseCursorPos.X + 1) * 960 + TextFieldOffsetX, (1 - vMouseCursorPos.Y) * 540 + TextFieldOffsetY);
        if (!bAreaLocked)
        {
            AreaTiles.Length = 0;
            PinionsMultiTarget.GetTilesForLockedArea(Ability, NewTargetLocation, CurrentlyMarkedTargets, AreaTiles);
            if (AreaTiles.Length >= GetNumTargets())
            {
                DrawLockedArea();
            }
            else
            {
                DrawInvalidTile();
            }
            MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);
            DrawAOETiles(AreaTiles);
            ExplosionEmitter.SetHidden(true);
            TextFieldString = default.strLockAreaText;
        }
        else if (!bFinalClickReady)
        {
            SelectedTile = World.GetTileCoordinatesFromPosition(NewTargetLocation);
            if (class'Helpers'.static.FindTileInList(SelectedTile, AreaTiles) != INDEX_NONE
                && class'Helpers'.static.FindTileInList(SelectedTile, TargetTiles) == INDEX_NONE
                && (!bRestrictToSquadsightRange || class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(AssociatedPlayerState.ObjectID, SelectedTile)))
            {
                GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
                CheckForFriendlyUnit(CurrentlyMarkedTargets);
                MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);
                DrawAOETiles(Tiles);
                ExplosionEmitter.SetHidden(false);
                DrawSplashRadius();
            }
            else
            {
                Tiles.Length = 0;
                MarkTargetedActors(CurrentlyMarkedTargets, eTeam_None);
                DrawAOETiles(Tiles);
                ExplosionEmitter.SetHidden(true);
            }
            TextFieldString = default.strSelectLocationText $ TargetIndex + 1 $ " / " $ GetNumTargets();
        }
        else
        {
            Tiles.Length = 0;
            MarkTargetedActors(CurrentlyMarkedTargets, eTeam_None);
            DrawAOETiles(Tiles);
            ExplosionEmitter.SetHidden(true);
            TextFieldString = default.strConfirmActivationText;
        }
        TextFieldString = class'UIUtilities_Text'.static.GetColoredText(TextFieldString, eUIState_Warning, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
        TextField.SetHTMLText(TextFieldString);
    }

    super.Update(DeltaTime);
}

simulated protected function DrawLockedArea()
{
    local Vector Center;
    local float Radius;

    Center = GetSplashRadiusCenter();
    Radius = PinionsMultiTarget.GetAreaTargetRadius(Ability);

    LockedAreaActor.SetDrawScale(Radius / 48.0f);
    LockedAreaActor.SetLocation(Center);
    LockedAreaActor.SetHidden(false);

    InvalidTileActor.SetHidden(true);
}

simulated protected function DrawInvalidTile()
{
    local Vector Center;

    Center = GetSplashRadiusCenter();

    LockedAreaActor.SetHidden(true);

    InvalidTileActor.SetHidden(false);
    InvalidTileActor.SetLocation(Center);
}

simulated protected function DrawSplashRadius()
{
    local Vector Center;
    local float Radius;
    local LinearColor CylinderColor;

    Center = GetSplashRadiusCenter();

    Radius = Ability.GetAbilityRadius();

    if ((ExplosionEmitter != none) && (Center != ExplosionEmitter.Location))
    {
        ExplosionEmitter.SetLocation(Center); // Set initial location of emitter
        ExplosionEmitter.SetDrawScale(Radius / 48.0f);
        ExplosionEmitter.SetRotation(rot(0,0,1));

        if (!ExplosionEmitter.ParticleSystemComponent.bIsActive)
        {
            ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
        }

        ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
        ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
    }
}

simulated protected function Vector GetSplashRadiusCenter()
{
    local Vector    CursorLocation;
    local TTile     CursorTile;

    CursorLocation = Cursor.Location;
    CursorLocation.Z = World.GetFloorZForPosition(CursorLocation);

    CursorTile = World.GetTileCoordinatesFromPosition(CursorLocation);
    CursorLocation = World.GetPositionFromTileCoordinates(CursorTile);

    return CursorLocation;
}

function float GetTargetingRange()
{
    local float TargetingRange;

    TargetingRange = Ability.GetAbilityCursorRangeMeters();

    if (TargetingRange > 0)
    {
        return `METERSTOUNITS(TargetingRange);
    }

    return -1;
}

function int GetNumTargets()
{
    local int NumTargets;

    NumTargets = PinionsMultiTarget.GetNumTargets();

    if (NumTargets > 0)
    {
        return NumTargets;
    }

    return 1;
}

function int GetTargetIndex()
{
    return -1;
}

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
    return false;
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
    Focus = GetSplashRadiusCenter();
    return true;
}

function bool AllowMouseConfirm()
{
    return true;
}