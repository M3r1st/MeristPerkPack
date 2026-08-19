class X2Effect_MeristSpawnSpectre extends X2Effect_SpawnUnit;

var name LinkAbilityName;
var name SpawnAnim;

var name AltRequiredAbility;
var array<name> UnitToSpawnNames, AltUnitToSpawnNames;
var int NumStartingPoints;

var privatewrite bool bLog;

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit    SpawnedUnit;
    local EffectAppliedData     NewEffectParams;
    local X2Effect              SireLinkEffect;
    local int i;

    SpawnedUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));

    if (SpawnedUnit == none)
    {
        `LOG(GetFuncName() $ ": spawned unit is missing", default.bLog, self.Class.Name);
        return;
    }

    SpawnedUnit.ActionPoints.Length = 0;
    for (i = 0; i < NumStartingPoints; i++)
    {
        SpawnedUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
    }

    SpawnedUnit.SetUnitFloatValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCleanup_BeginTactical);
    SpawnedUnit.SetUnitFloatValue('NewSpawnedUnit', 1, eCleanup_BeginTactical);
    SpawnedUnit.kAppearance.bGhostPawn = true;

    // Link the source and zombie
    NewEffectParams = ApplyEffectParameters;
    NewEffectParams.EffectRef.ApplyOnTickIndex = INDEX_NONE;
    NewEffectParams.EffectRef.LookupType = TELT_AbilityTargetEffects;
    NewEffectParams.EffectRef.SourceTemplateName = LinkAbilityName;
    NewEffectParams.EffectRef.TemplateEffectLookupArrayIndex = 0;
    NewEffectParams.TargetStateObjectRef = SpawnedUnit.GetReference();

    SireLinkEffect = class'X2Effect'.static.GetX2Effect(NewEffectParams.EffectRef);
    if (SireLinkEffect == none)
    {
        `LOG(GetFuncName() $ ": link effect is missing", default.bLog, self.Class.Name);
        return;
    }
    SireLinkEffect.ApplyEffect(NewEffectParams, SpawnedUnit, NewGameState);

    `XEVENTMGR.TriggerEvent('UnitMoveFinished', SpawnedUnit, SpawnedUnit, NewGameState);
}

function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit;
    local XComGameState_Item    SourceWeapon;
    local array<name>           arrUnitNames;
    local int Tech;

    History = `XCOMHISTORY;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    arrUnitNames = UnitToSpawnNames;
    if (SourceUnit.HasSoldierAbility(AltRequiredAbility, true))
    {
        arrUnitNames = AltUnitToSpawnNames;
    }

    SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    Tech = `GetTechLevel(SourceWeapon.GetMyTemplate());
    Tech = Clamp(Tech, 0, arrUnitNames.Length - 1);

    return arrUnitNames[Tech];
}

function vector GetSpawnLocation(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
    local Vector DropPosition;

    DropPosition = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];

    if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length == 0)
    {
        `LOG(GetFuncName() $ ": attempting to create without a target location!", default.bLog, self.Class.Name);
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
    local array<XComGameState_Unit> SpawnedUnits;
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

    FindNewlySpawnedUnit(VisualizeGameState, SpawnedUnits);

    for (j = 0; j < SpawnedUnits.Length; ++j)
    {
        NewUnitActionMetadata = EmptyTrack;
        NewUnitActionMetadata.StateObject_OldState = SpawnedUnits[j];
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
    bLog = true
}