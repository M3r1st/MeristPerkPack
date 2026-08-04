class X2AbilitySet_Gremlin extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> AidProtocols;
var config array<name> OffensiveProtocols;
var config array<name> Botnet_AllowedAbilities;

var privatewrite name OverclockActionPointType;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(AdvancedAidProtocol());
    Templates.AddItem(TargetingAid());
    Templates.AddItem(ShadowstepAid());
    Templates.AddItem(RapidDumping());
    Templates.AddItem(FutureWarfare());
    /*>>*/Templates.AddItem(FutureWarfarePassive());
    Templates.AddItem(Botnet());
    // Templates.AddItem(Overclock());

    // Templates.AddItem(ChainingJolt());
    // /*>>*/Templates.AddItem(StormGenerator());
    // /*>>*/Templates.AddItem(Capacitors());
    // Templates.AddItem(VoltaicArc());
    // /*>>*/Templates.AddItem(VoltaicArcPassive());

    return Templates;
}

static function X2AbilityTemplate AdvancedAidProtocol()
{
    return Passive('M31_AdvancedAidProtocol', "img:///UILibrary_MZChimeraIcons.Ability_ArmorSystem", false, true);
}

static function X2AbilityTemplate TargetingAid()
{
    return Passive('M31_TargetingAid', "img:///UILibrary_MZChimeraIcons.Ability_CombatProtocol", false, true);
}

static function X2AbilityTemplate ShadowstepAid()
{
    return Passive('M31_ShadowstepAid', "img:///UILibrary_MeristPerkIcons.UIPerk_ShadowstepAid", false, true);
}

static function X2AbilityTemplate RapidDumping()
{
    return Passive('M31_RapidDumping', "img:///UILibrary_PerkIcons.UIPerk_gremlincommand", false, true);
}

static function X2AbilityTemplate FutureWarfare()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Effect_ReduceCooldowns              Effect;

    Template = SelfTargetTrigger('M31_FutureWarfare', "img:///UILibrary_MZChimeraIcons.Ability_Recharge");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_FutureWarfare;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.Amount = `GetConfigInt("M31_FutureWarfare_CooldownReduction");
    Effect.AbilitiesToTick = default.OffensiveProtocols;
    Effect.ReduceAll = false;
    Template.AddTargetEffect(Effect);
    
    AddUnitValueCondition(Template, 'M31_FutureWarfare_Counter', `GetConfigInt("M31_FutureWarfare_ActivationsPerTurn"));

    Template.bShowActivation = true;

    Template.AdditionalAbilities.AddItem('M31_FutureWarfare_Passive');

    return Template;
}

static function X2AbilityTemplate FutureWarfarePassive()
{
    return Passive('M31_FutureWarfare_Passive', "img:///UILibrary_MZChimeraIcons.Ability_Recharge", false, true);
}

static function EventListenerReturn AbilityTriggerEventListener_FutureWarfare(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Ability             ActivatedAbilityState;
    local XComGameState_Ability             CallbackAbilityState;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        ActivatedAbilityState = XComGameState_Ability(EventData);
        CallbackAbilityState = XComGameState_Ability(CallbackData);
        if (default.OffensiveProtocols.Find(ActivatedAbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            return CallbackAbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate Botnet()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_Persistent               Effect;

    Template = SelfTargetActivated('M31_Botnet', "img:///UILibrary_XPerkIconPack.UIPerk_gremlin_circle", false);

    AddCooldown(Template, `GetConfigInt("M31_Botnet_Cooldown"));
    AddActionPointCost(Template, eCost_Free);

    Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_Botnet_Valid';
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Botnet_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    Effect.DuplicateResponse = eDupe_Refresh;
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Botnet_BonusText"), Template.IconImage,,, Template.AbilitySourceName);

    Template.AddTargetEffect(Effect);
    Template.AddMultiTargetEffect(Effect);

    Template.AbilityConfirmSound = "Unreal2DSounds_TargetLock";

    return Template;
}

static function X2AbilityTemplate Overclock()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ReduceCooldowns_Extended Effect;
    local X2Effect_GrantActionPoints        ActionPointEffect;

    Template = SelfTargetActivated('M31_SP_Overclock', "img:///UILibrary_MeristPerkPack.UIPerk_Overclock", false);

    AddCooldown(Template, `GetConfigInt("M31_SP_Overclock_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_SP_Overclock_Charges"));
    AddActionPointCost(Template, eCost_Free);

    Template.AddShooterEffectExclusions();

    Effect = new class'X2Effect_ReduceCooldowns_Extended';
    Effect.ReduceAll = true;
    Effect.bMatchSourceWeapon = true;
    Effect.AbilitiesToExclude.AddItem(Template.DataName);
    Template.AddTargetEffect(Effect);

    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = default.OverclockActionPointType;
    Template.AddTargetEffect(ActionPointEffect);

    return Template;
}

static function X2AbilityTemplate ChainingJolt()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_WeakToTech            OrganicCondition;

    Template = CreateSingleTargetProtocol('M31_SP_ChainingJolt', "img:///UILibrary_MZChimeraIcons.Ability_ChainingJolt");

    SetAbilityShotHUDPriority(Template, ePriorityType_Secondary, eCost_SingleConsumeAll, eHostility_Offensive);
    Template.Hostility = eHostility_Offensive;

    Template.AbilityMultiTargetStyle = ChainingJoltMultiTarget();

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

    AddCooldown(Template, `GetConfigInt("M31_SP_ChainingJolt_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    OrganicCondition = new class'X2Condition_WeakToTech';
    OrganicCondition.bRequireNotWeak = true;

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = 'M31_SP_ChainingJolt';
    DamageEffect.TargetConditions.AddItem(OrganicCondition);
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = 'M31_SP_ChainingJolt_Robotic';
    DamageEffect.TargetConditions.AddItem(new class'X2Condition_WeakToTech');
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    //=================================================
    // Compatibility for Mitzruti's perks
    //=================================================
    AddOtherCombatProtocolEffects(Template);
    //=================================================

    Template.BuildVisualizationFn = ChainingJolt_BuildVisualization;

    Template.ActionFireClass = class'X2Action_Fire_ChainingJolt';
    Template.CustomSelfFireAnim = 'NO_CombatProtocol';
    Template.ActivationSpeech = 'AbilCombatProtocol';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    if (`GetConfigBool("M31_SP_ChainingJolt_bOverrideCombatProtocol"))
    {
        Template.OverrideAbilities.AddItem('CombatProtocol');
    }

    return Template;
}

static private function X2AbilityMultiTarget_ChainingJolt ChainingJoltMultiTarget()
{
    local X2AbilityMultiTarget_ChainingJolt ChainMultiTarget;

    ChainMultiTarget = new class'X2AbilityMultiTarget_ChainingJolt';
    ChainMultiTarget.arrTargetRadius = `GetConfigArrayFloat("M31_SP_ChainingJolt_Radius");
    ChainMultiTarget.AddAbilityBonusRadius('M31_SP_StormGenerator', `GetConfigFloat("M31_SP_StormGenerator_BonusRadius"));
    ChainMultiTarget.arrMaxTargets = `GetConfigArrayInt("M31_SP_ChainingJolt_MaxTargets");
    ChainMultiTarget.AddAbilityBonusNumTargets('M31_SP_Capacitors', `GetConfigFloat("M31_SP_Capacitors_BonusNumTargets"));

    return ChainMultiTarget;
}

static simulated function ChainingJolt_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      Context;
    local X2AbilityTemplate                 AbilityTemplate;
    local StateObjectReference              InteractingUnitRef;
    local XComGameState_Item                GremlinItem;
    local XComGameState_Unit                TargetUnitState;
    local XComGameState_Unit                AttachedUnitState;
    local XComGameState_Unit                GremlinUnitState;
    local array<PathPoint>                  Path;
    local TTile                             TargetTile;
    local TTile                             StartTile;

    local VisualizationActionMetadata       EmptyTrack;
    local VisualizationActionMetadata       ActionMetadata;
    local X2Action_WaitForAbilityEffect     DelayAction;
    local X2Action_AbilityPerkStart         PerkStartAction;
    local X2Action_CameraLookAt             CameraAction;

    local X2Action_PlaySoundAndFlyOver      SoundAndFlyOver;
    local int                               EffectIndex, Index;
    local PathingInputData                  PathData;
    local PathingResultData                 ResultData;

    local X2VisualizerInterface             TargetVisualizerInterface;
    local X2Action_CameraLookAt             TargetCameraAction;
    local Actor                             TargetVisualizer;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

    TargetUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));

    GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
    GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID));
    AttachedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.AttachedUnitRef.ObjectID));

    if (GremlinUnitState == none)
    {
        `RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinUnitState of none");
        return;
    }

    //****************************************************************************************
    // Configure the visualization track for the shooter
    //****************************************************************************************

    InteractingUnitRef = Context.InputContext.SourceObject;
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer( InteractingUnitRef.ObjectID );

    CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
    CameraAction.LookAtActor = ActionMetadata.VisualizeActor;
    CameraAction.BlockUntilActorOnScreen = true;

    class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

    if (AbilityTemplate.ActivationSpeech != '')
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
    }

    // Make sure we wait for the gremlin to come back, so that the cinescript camera doesn't pop until then
    X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded)).SetCustomTimeOutSeconds(30);

    //****************************************************************************************
    // Configure the visualization track for the gremlin
    //****************************************************************************************

    InteractingUnitRef = GremlinUnitState.GetReference();

    ActionMetadata = EmptyTrack;
    History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,, VisualizeGameState.HistoryIndex);
    ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();
    TargetVisualizer = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

    class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

    if (AttachedUnitState.TileLocation != TargetUnitState.TileLocation)
    {
        // Given the target location, we want to generate the movement data.

        // Handle tall units.
        TargetTile = TargetUnitState.GetDesiredTileForAttachedCosmeticUnit();
        StartTile = AttachedUnitState.GetDesiredTileForAttachedCosmeticUnit();

        class'X2PathSolver'.static.BuildPath(GremlinUnitState, StartTile, TargetTile, PathData.MovementTiles);
        class'X2PathSolver'.static.GetPathPointsFromPath( GremlinUnitState, PathData.MovementTiles, Path);
        class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);

        PathData.MovingUnitRef = GremlinUnitState.GetReference();
        PathData.MovementData = Path;
        Context.InputContext.MovementPaths.AddItem(PathData);

        class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID,	PathData.MovementTiles,	ResultData.PathTileData);
        Context.ResultContext.PathResults.AddItem(ResultData);

        class'X2VisualizerHelpers'.static.ParsePath(Context, ActionMetadata);

        if (TargetVisualizer != none)
        {
            TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
            TargetCameraAction.LookAtActor = TargetVisualizer;
            TargetCameraAction.BlockUntilActorOnScreen = true;
            TargetCameraAction.LookAtDuration = 10.0f;          // longer than we need - camera will be removed by tag below
            TargetCameraAction.CameraTag = 'TargetFocusCamera';
            TargetCameraAction.bRemoveTaggedCamera = false;
        }
    }

    PerkStartAction = X2Action_AbilityPerkStart(class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
    PerkStartAction.NotifyTargetTracks = true;

    if (!AbilityTemplate.bSkipFireAction)
    {
        AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
    }

    class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree( ActionMetadata, Context );

    //****************************************************************************************
    // Configure the visualization track for the target
    //****************************************************************************************

    InteractingUnitRef = Context.InputContext.PrimaryTarget;
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = TargetVisualizer;

    DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context));
    DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_ARRIVAL_TIMEOUT);     //  give the gremlin plenty of time to show up

    for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
    {
        AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult( AbilityTemplate.AbilityTargetEffects[EffectIndex]));
    }

    TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
    if (TargetVisualizerInterface != none)
    {
        // Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
        TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
    }

    for (Index = 0; Index < Context.InputContext.MultiTargets.Length; Index++)
    {
        InteractingUnitRef = Context.InputContext.MultiTargets[Index];
        ActionMetadata = EmptyTrack;
        ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
        ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
        ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    
        class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context);
    
        for (EffectIndex = 0; EffectIndex < Context.ResultContext.MultiTargetEffectResults[Index].Effects.Length; Index++)
        {
            Context.ResultContext.MultiTargetEffectResults[Index].Effects[EffectIndex].AddX2ActionsForVisualization(
                VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[Index].ApplyResults[EffectIndex]);
        }

        TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
        if (TargetVisualizerInterface != none)
        {
            //Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
            TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
        }
    }

    if (TargetCameraAction != none)
    {
        TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
        TargetCameraAction.CameraTag = 'TargetFocusCamera';
        TargetCameraAction.bRemoveTaggedCamera = true;
    }
}

static function X2AbilityTemplate StormGenerator()
{
    return Passive('M31_SP_StormGenerator', "img:///UILibrary_MZChimeraIcons.Ability_StormGenerator", false, true);
}

static function X2AbilityTemplate Capacitors()
{
    return Passive('M31_SP_Capacitors', "img:///UILibrary_MZChimeraIcons.Ability_Battery", false, true);
}

static function X2AbilityTemplate VoltaicArc()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_WeakToTech            OrganicCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SP_VoltaicArc');

    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_VoltaicArc";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = false;
    Template.bLimitTargetIcons = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;
    Template.AbilityMultiTargetStyle = ChainingJoltMultiTarget();

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'ObjectMoved';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
    Template.AbilityTriggers.AddItem(Trigger);

    if (`GetConfigBool("M31_SP_VoltaicArc_bActivateOnAttack"))
    {
        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.EventID = 'AbilityActivated';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.Filter = eFilter_None;
        if (`GetConfigBool("M31_SP_VoltaicArc_bActivateOnAttack_RequiresCoveringFire"))
            Trigger.ListenerData.EventFn = CoveringFireAttackListener;
        else
            Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
        Template.AbilityTriggers.AddItem(Trigger);
    }

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bActAsSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = `METERSTOUNITS(`GetConfigFloat("M31_SP_VoltaicArc_Radius"));
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    AddBladestormMark(Template, 'M31_SP_VoltaicArc_Mark');

    OrganicCondition = new class'X2Condition_WeakToTech';
    OrganicCondition.bRequireNotWeak = true;

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = 'M31_SP_VoltaicArc';
    DamageEffect.TargetConditions.AddItem(OrganicCondition);
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = 'M31_SP_VoltaicArc_Robotic';
    DamageEffect.TargetConditions.AddItem(new class'X2Condition_WeakToTech');
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    //=================================================
    // Compatibility for Mitzruti's perks
    //=================================================
    AddOtherCombatProtocolEffects(Template);
    //=================================================

    Template.bStationaryWeapon = true;
    Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;;
    Template.BuildVisualizationFn = ChainingJolt_BuildVisualization;
    Template.bSkipPerkActivationActions = true;
    Template.PostActivationEvents.AddItem('ItemRecalled');

    Template.bFrameEvenWhenUnitIsHidden = true;
    Template.bShowActivation = true;

    Template.ActionFireClass = class'X2Action_Fire_ChainingJolt';
    Template.CustomSelfFireAnim = 'NO_CombatProtocol';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_SP_VoltaicArc_Passive');

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate VoltaicArcPassive()
{
    return Passive('M31_SP_VoltaicArc_Passive', "img:///UILibrary_MZChimeraIcons.Ability_VoltaicArc", false, true);
}

static function X2AbilityTemplate CreateSingleTargetProtocol(name DataName, string IconImage)
{
    local X2AbilityTemplate         Template;
    local X2Condition_Visibility    VisibilityCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;
    Template.bLimitTargetIcons = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bActAsSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.bStationaryWeapon = true;
    Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
    Template.bSkipPerkActivationActions = true;
    Template.PostActivationEvents.AddItem('ItemRecalled');

    Template.bFrameEvenWhenUnitIsHidden = true;
    Template.bShowActivation = true;

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function AddOtherCombatProtocolEffects(out X2AbilityTemplate Template, optional bool bSingleTarget = true, optional bool bMultiTarget = true)
{
    local X2Condition_AbilityProperty       AbilityCondition;
    local X2Effect_DisarmWeapon             DisableEffect;
    local X2Condition_AbilityProperty       ShockTherapyCondition;
    local X2Effect_Persistent               DisorientedEffect;
    local X2Effect_Stunned                  StunnedEffect;
    local X2Effect_SetUnitValue             UnitValueEffect;
    local X2Condition_UnitValue             UnitValueCondition;

    // Disarm effect
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySabotage');
    DisableEffect = new class'X2Effect_DisarmWeapon';
    DisableEffect.TargetConditions.AddItem(AbilityCondition);
    if (bSingleTarget && Template.AbilityTargetEffects.Length > 0)
        Template.AddTargetEffect(DisableEffect);
    if (bMultiTarget && Template.AbilityMultiTargetEffects.Length > 0)
        Template.AddMultiTargetEffect(DisableEffect);

    ShockTherapyCondition = new class'X2Condition_AbilityProperty';
    ShockTherapyCondition.OwnerHasSoldierAbilities.AddItem('MZShockTherapy');

    // Stun effect
    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
    UnitValueEffect.ApplyChance = 50;
    if (bSingleTarget && Template.AbilityTargetEffects.Length > 0)
        Template.AddTargetEffect(UnitValueEffect);
    if (bMultiTarget && Template.AbilityMultiTargetEffects.Length > 0)
        Template.AddMultiTargetEffect(UnitValueEffect);

    UnitValueCondition = new class'X2Condition_UnitValue';
    UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 1);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
    StunnedEffect.bRemoveWhenSourceDies = false;
    StunnedEffect.TargetConditions.AddItem(ShockTherapyCondition);
    StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
    if (bSingleTarget && Template.AbilityTargetEffects.Length > 0)
        Template.AddTargetEffect(StunnedEffect);
    if (bMultiTarget && Template.AbilityMultiTargetEffects.Length > 0)
        Template.AddMultiTargetEffect(StunnedEffect);

    // Disorient effect
    UnitValueCondition = new class'X2Condition_UnitValue';
    UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 0);

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
    DisorientedEffect.bRemoveWhenSourceDies = false;
    DisorientedEffect.TargetConditions.AddItem(ShockTherapyCondition);
    DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
    if (bSingleTarget && Template.AbilityTargetEffects.Length > 0)
        Template.AddTargetEffect(DisorientedEffect);
    if (bMultiTarget && Template.AbilityMultiTargetEffects.Length > 0)
        Template.AddMultiTargetEffect(DisorientedEffect);

    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.NewValueToSet = 0;
    UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
    if (bSingleTarget && Template.AbilityTargetEffects.Length > 0)
        Template.AddTargetEffect(UnitValueEffect);
    if (bMultiTarget && Template.AbilityMultiTargetEffects.Length > 0)
        Template.AddMultiTargetEffect(UnitValueEffect);
}

defaultproperties
{
    OverclockActionPointType = M31_SP_Overclock
}
