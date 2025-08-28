class X2Effect_SummonUnit extends X2Effect_SpawnUnit;

var name SpawnAnim;
var name LinkName;
var name SpawnUnitValueName;

var name UnitToSpawnNameT2;
var name UnitToSpawnNameT3;

var name AltReqAbilityName;

var name AltUnitToSpawnName;
var name AltUnitToSpawnNameT2;
var name AltUnitToSpawnNameT3;

var int NumStartingPoint;

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SpectralUnit;
    local EffectAppliedData NewEffectParams;
    local X2Effect SpectralArmyLinkEffect;

    SpectralUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));

    if (SpectralUnit == none)
    {
        `RedScreen("X2Effect_SummonUnit: spawned unit is missing: " $ SpectralUnit.ObjectID);
        return;
    }

    SpectralUnit.ActionPoints.Length = NumStartingPoint;

    //SpectralUnit.GhostSourceUnit = ApplyEffectParameters.SourceStateObjectRef;
    SpectralUnit.SetUnitFloatValue('TurnedIntoZombie', 1, eCleanup_BeginTactical);
    SpectralUnit.SetUnitFloatValue('NewSpawnedUnit', 1, eCleanup_BeginTactical);
    SpectralUnit.kAppearance.bGhostPawn = true;

    if (SpawnUnitValueName != '')
        SpectralUnit.SetUnitFloatValue(SpawnUnitValueName, 1, eCleanup_BeginTactical);

    // Link the source and zombie
    NewEffectParams = ApplyEffectParameters;
    NewEffectParams.EffectRef.ApplyOnTickIndex = INDEX_NONE;
    NewEffectParams.EffectRef.LookupType = TELT_AbilityTargetEffects;
    NewEffectParams.EffectRef.SourceTemplateName = LinkName;
    NewEffectParams.EffectRef.TemplateEffectLookupArrayIndex = 0;
    NewEffectParams.TargetStateObjectRef = SpectralUnit.GetReference();

    SpectralArmyLinkEffect = class'X2Effect'.static.GetX2Effect(NewEffectParams.EffectRef);

    if (SpectralUnit == none)
    {
        `RedScreen("X2Effect_SpawnFrostZombies: Spectral Army Link Effect is missing.");
        return;
    }

    SpectralArmyLinkEffect.ApplyEffect(NewEffectParams, SpectralUnit, NewGameState);

    `XEVENTMGR.TriggerEvent('UnitMoveFinished', SpectralUnit, SpectralUnit, NewGameState);
}

function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameStateHistory History;
    local XComGameState_Unit SourceUnit;
    local XComGameState_Item SourceWeapon;
    local int Tier;

    History = `XCOMHISTORY;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

    Tier = class'X2DLCInfo_MeristPerkPack'.static.GetItemTech(SourceWeapon.GetMyTemplate());
    Tier = Clamp(Tier, 0, 4);
    
    `assert(SourceUnit != none);

    if (SourceUnit.HasSoldierAbility(AltReqAbilityName, true))
    {
        switch (Tier)
        {
            case 4:
                return AltUnitToSpawnNameT3;
            case 3:
            case 2:
                return AltUnitToSpawnNameT2;
            default:
                return AltUnitToSpawnName;
        }
    }
    else
    {
        switch (Tier)
        {
            case 4:
                return UnitToSpawnNameT3;
            case 3:
            case 2:
                return UnitToSpawnNameT2;
            default:
                return UnitToSpawnName;
        }    
    }
}

function vector GetSpawnLocation(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
    local Vector DropPosition;

    DropPosition = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];

    if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length == 0)
    {
        return vect(0,0,0);
    }
    
    return DropPosition;
}

function ETeam GetTeam(const out EffectAppliedData ApplyEffectParameters)
{
    return GetSourceUnitsTeam(ApplyEffectParameters);
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
    local XComGameStateHistory History;
    local XComGameStateVisualizationMgr VisualizationMgr;
    local X2Action_Fire_SpectralArmy FireAction;
    local array<XComGameState_Unit> SpectralUnits;
    local VisualizationActionMetadata EmptyTrack, NewUnitActionMetadata;
    local int j;
    local XComGameState_Unit SpawnedUnit;
    local X2Action_PlayAnimation AnimAction;
    local X2Action_WaitForAbilityEffect WaitAction;
    local X2Action_ShowSpawnedUnit ShowUnitAction;

    History = `XCOMHISTORY;
    VisualizationMgr = `XCOMVISUALIZATIONMGR;

    // Find the X2Action_Fire_SpectralArmy
    FireAction = X2Action_Fire_SpectralArmy(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_Fire_SpectralArmy', ActionMetadata.VisualizeActor));

    FindNewlySpawnedUnit(VisualizeGameState, SpectralUnits);

    for (j = 0; j < SpectralUnits.Length; ++j)
    {
        NewUnitActionMetadata = EmptyTrack;
        NewUnitActionMetadata.StateObject_OldState = SpectralUnits[j];
        NewUnitActionMetadata.StateObject_NewState = NewUnitActionMetadata.StateObject_OldState;
        SpawnedUnit = XComGameState_Unit(NewUnitActionMetadata.StateObject_NewState);
        NewUnitActionMetadata.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

        WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(NewUnitActionMetadata, VisualizeGameState.GetContext(), false, FireAction));

        ShowUnitAction = X2Action_ShowSpawnedUnit(class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(NewUnitActionMetadata, VisualizeGameState.GetContext(), false, WaitAction));
        ShowUnitAction.bPlayIdle = false;

        AnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(NewUnitActionMetadata, VisualizeGameState.GetContext(), false, ShowUnitAction));
        AnimAction.Params.AnimName = SpawnAnim;
        AnimAction.Params.BlendTime = 0.0f;
    }
}

defaultproperties
{
    bKnockbackAffectsSpawnLocation = false
    bAddToSourceGroup = true
}