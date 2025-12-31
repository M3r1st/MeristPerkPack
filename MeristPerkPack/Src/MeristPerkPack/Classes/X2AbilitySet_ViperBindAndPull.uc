class X2AbilitySet_ViperBindAndPull extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> GetOverHere_Abilities;
var config array<name> Bind_Abilities;
var config array<name> BindCrush_Abilities;
var config array<name> BindEnd_Abilities;
var private int GetOverHere_HUDPriority;
var private int GetOverHereAlly_HUDPriority;
var private int RushAndBind_HUDPriority;
var private int Bind_HUDPriority;
var private int BindCrush_HUDPriority;
var private int BindEnd_HUDPriority;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(GetOverHere('M31_PA_GetOverHere', 'M31_PA_Bind'));
    Templates.AddItem(GetOverHereAlly('M31_PA_GetOverHereAlly'));

    Templates.AddItem(EndBind('M31_PA_EndBind'));

    Templates.AddItem(Bind('M31_PA_Bind', 'M31_PA_Bind_Crush', 'M31_PA_Bind_Crush_Input'));
    Templates.AddItem(BindCrush('M31_PA_Bind_Crush'));
    Templates.AddItem(BindCrush('M31_PA_Bind_Crush_Input', true));

    Templates.AddItem(RushAndBind('M31_PA_RushAndBind', 'M31_PA_RushAndBind_Bind', 'M31_PA_RushAndBind_Crush', 'M31_PA_RushAndBind_Crush_Input'));
    Templates.AddItem(RushAndBindBind('M31_PA_RushAndBind_Bind', 'M31_PA_RushAndBind_Crush'));
    Templates.AddItem(RushAndBindCrush('M31_PA_RushAndBind_Crush'));
    Templates.AddItem(RushAndBindCrush('M31_PA_RushAndBind_Crush_Input', true));

    Templates.AddItem(RushAndBind('M31_PA_WS_RushAndBind', 'M31_PA_WS_RushAndBind_Bind', 'M31_PA_RushAndBind_Crush', 'M31_PA_RushAndBind_Crush_Input', true));
    Templates.AddItem(RushAndBindBind('M31_PA_WS_RushAndBind_Bind', 'M31_PA_RushAndBind_Crush', true));

    return Templates;
}

static function X2AbilityTemplate GetOverHere(name DataName, name BindAbilityName)
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityCooldown_Extended        Cooldown;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Effect_ImmediateAbilityActivation BindAbilityEffect;
    local name AbilityName;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_getoverhere";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.ShotHUDPriority = default.GetOverHere_HUDPriority;

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);
    // There must be a free tile around the source unit
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_UnblockedNeighborTile');

    // The target cannot be bound, carried, unconcious or frozen
    // The target must be humanoid
    // The target must be bindable
    AddDefaultBindConditions(Template);
    // Target must be visible and not in high cover
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    // The target must be within range
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.RequireWithinMinRange = true;
    UnitPropertyCondition.WithinMinRange = `TILESTOUNITS(`GetConfigInt("M31_PA_GetOverHere_MinRange"));
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = `TILESTOUNITS(`GetConfigInt("M31_PA_GetOverHere_MaxRange")) + 1;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_GetOverHere_Cooldown");
    if (`GetConfigBool("M31_PA_GetOverHere_bSharedCooldown"))
    {
        foreach default.GetOverHere_Abilities(AbilityName)
        {
            if (DataName != AbilityName)
            {
                Cooldown.AddAdditionalCooldownInfo(AbilityName, Cooldown.iNumTurns);
            }
        }
    }
    Template.AbilityCooldown = Cooldown;
    AddActionPointCost(Template, eCost_Single);

    // Apply the effect that pulls the unit to the Viper
    Template.AddTargetEffect(new class'X2Effect_GetOverHere');

    // The shooter gets an action point that can be used for bind
    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.GOHBindActionPoint;
    Template.AddShooterEffect(ActionPointEffect);

    // Successful GetOverHere leads to a bind
    BindAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
    BindAbilityEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    BindAbilityEffect.EffectName = 'ImmediateBind';
    BindAbilityEffect.AbilityName = BindAbilityName;
    BindAbilityEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(BindAbilityEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_Viper'.static.GetOverHere_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CinescriptCameraType = "Viper_StranglePull";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate GetOverHereAlly(name DataName)
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2AbilityCooldown_Extended    Cooldown;
    local name                          AbilityName;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TonguePull";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;

    Template.ShotHUDPriority = default.GetOverHereAlly_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);
    // There must be a free tile around the source unit
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_UnblockedNeighborTile');

    // The target cannot be bound, carried, unconcious or frozen
    // The target must be humanoid
    // The target must be bindable
    AddDefaultBindConditions(Template);
    // Target must be visible and not in high cover
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    // The target must be within range
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireWithinMinRange = true;
    UnitPropertyCondition.WithinMinRange = `TILESTOUNITS(`GetConfigInt("M31_PA_GetOverHereAlly_MinRange"));
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = `TILESTOUNITS(`GetConfigInt("M31_PA_GetOverHereAlly_MaxRange")) + 1;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_GetOverHereAlly_Cooldown");
    if (`GetConfigBool("M31_PA_GetOverHere_bSharedCooldown"))
    {
        foreach default.GetOverHere_Abilities(AbilityName)
        {
            if (DataName != AbilityName)
            {
                Cooldown.AddAdditionalCooldownInfo(AbilityName, Cooldown.iNumTurns);
            }
        }
    }
    Template.AbilityCooldown = Cooldown;
    AddActionPointCost(Template, eCost_Single);

    // Apply the effect that pulls the unit to the Viper
    Template.AddTargetEffect(new class'X2Effect_GetOverHere');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = GetOverHereAlly_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CinescriptCameraType = "Viper_StranglePull";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static simulated function GetOverHereAlly_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local X2AbilityTemplate             AbilityTemplate;
    local StateObjectReference          InteractingUnitRef;
    local X2Action_ViperGetOverHere     GetOverHereAction;
    local X2VisualizerInterface         Visualizer;

    local VisualizationActionMetadata        EmptyTrack;
    local VisualizationActionMetadata        ActionMetadata;
    local VisualizationActionMetadata        SourceMetadata;

    local int                           EffectIndex;
    local X2Action_ExitCover            ExitCoverAction;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);


    InteractingUnitRef = Context.InputContext.SourceObject;
    SourceMetadata = EmptyTrack;
    SourceMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    SourceMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    SourceMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceMetadata, Context, false, SourceMetadata.LastActionAdded));
    ExitCoverAction.bUsePreviousGameState = true;
    GetOverHereAction = X2Action_ViperGetOverHere(class'X2Action_ViperGetOverHere'.static.AddToVisualizationTree(SourceMetadata, Context, false, SourceMetadata.LastActionAdded));
    GetOverHereAction.SetFireParameters(Context.IsResultContextHit());

    Visualizer = X2VisualizerInterface(SourceMetadata.VisualizeActor);
    if (Visualizer != none)
    {
        Visualizer.BuildAbilityEffectsVisualization(VisualizeGameState, SourceMetadata);
    }

    class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceMetadata, Context, false, SourceMetadata.LastActionAdded);

    InteractingUnitRef = Context.InputContext.PrimaryTarget;
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
    {
        AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
    }
}

static function X2AbilityTemplate Bind(name DataName, name CrushAbilityName, optional name InputCrushAbilityName)
{
    local X2AbilityTemplate                     Template;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2Condition_Visibility                TargetVisibilityCondition;
    local X2Effect_Persistent                   BoundEffect;
    local X2Effect_ViperBindSustainedExtended   SustainedEffect;
    // local X2Effect_GrantActionPoints            ActionPointsEffect;
    local X2Effect_ApplyWeaponDamage            DamageEffect;
    local X2Effect_ApplyDirectionalWorldDamage  EnvironmentDamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.AdditionalAbilities.AddItem(CrushAbilityName);
    if (InputCrushAbilityName != '')
        Template.AdditionalAbilities.AddItem(InputCrushAbilityName);
    Template.AdditionalAbilities.AddItem('M31_PA_EndBind');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_bind";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.ShotHUDPriority = default.Bind_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.GOHBindActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bCannotPeek = true;
    TargetVisibilityCondition.bRequireNotMatchCoverType = true;
    TargetVisibilityCondition.TargetCover = CT_Standing;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    AddDefaultBindConditions(Template);
    AddAdjacencyCondition(Template);

    // Add to the target the sustained bind effect
    SustainedEffect = new class'X2Effect_ViperBindSustainedExtended';
    SustainedEffect.SustainedAbilityName = CrushAbilityName;
    SustainedEffect.FragileAmount = `GetConfigInt("M31_PA_Bind_FragileAmount");
    SustainedEffect.bUseGeometricDamageIncrease = false;
    SustainedEffect.bUseExponentialDamageIncrease = true;
    SustainedEffect.iTurnsForFirstIncrease = 0;
    SustainedEffect.EffectName = class'X2Ability_Viper'.default.BindSustainedEffectName;
    SustainedEffect.bRemoveWhenTargetDies = true;
    SustainedEffect.EffectRemovedSourceVisualizationFn = class'X2Ability_Viper'.static.BindEndSource_BuildVisualization;
    SustainedEffect.EffectRemovedVisualizationFn = class'X2Ability_Viper'.static.BindEndTarget_BuildVisualization;
    SustainedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
    SustainedEffect.RegisterAdditionalEventsLikeImpair.AddItem('AffectedByStasis');
    SustainedEffect.RegisterAdditionalEventsLikeImpair.AddItem('StunStrikeActivated');
    SustainedEffect.bBringRemoveVisualizationForward = true;

    // Since this will also be a sustained ability, only put the bound status on the target for one round
    BoundEffect = class'X2StatusEffects'.static.CreateBoundStatusEffect(1, true, true);
    BoundEffect.CustomIdleOverrideAnim = 'NO_BindLoop';
    Template.AddTargetEffect(BoundEffect);
    // This target effect needs to be set as a child on the sustain effect
    SustainedEffect.EffectsToRemoveFromTarget.AddItem(BoundEffect.EffectName);

    // The shooter is also bound
    BoundEffect = class'X2StatusEffects'.static.CreateBoundStatusEffect(1, true, false);
    BoundEffect.CustomIdleOverrideAnim = 'NO_BindLoop';
    Template.AddShooterEffect(BoundEffect);
    // This source effect needs to be set as a child on the sustain effect
    SustainedEffect.EffectsToRemoveFromSource.AddItem(BoundEffect.EffectName);

    // All child effects to the sustained effect have been added, submit
    Template.AddTargetEffect(SustainedEffect);

    // Ability causes damage by crushing
    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_BindCrush_Damage");
    DamageEffect.DamageTypes.AddItem('ViperCrush');
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);

    EnvironmentDamageEffect = new class 'X2Effect_ApplyDirectionalWorldDamage';
    EnvironmentDamageEffect.DamageTypeTemplateName = 'Melee';
    EnvironmentDamageEffect.EnvironmentalDamageAmount = `GetConfigInt("M31_PA_Bind_EnvDamage");
    EnvironmentDamageEffect.PlusNumZTiles = 1;
    EnvironmentDamageEffect.bApplyToWorldOnMiss = false;
    EnvironmentDamageEffect.bHitSourceTile = true;
    EnvironmentDamageEffect.bAllowDestructionOfDamageCauseCover = true;
    Template.AddTargetEffect(EnvironmentDamageEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_Viper'.static.Bind_BuildVisualization;
    Template.BuildAffectedVisualizationSyncFn = class'X2Ability_Viper'.static.BindUnit_BuildAffectedVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CinescriptCameraType = "Viper_Bind";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate BindCrush(name DataName, optional bool bInputTriggered)
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitEffectsWithAbilitySource UnitEffectsCondition;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TightSqueeze";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.Hostility = eHostility_Neutral;
    Template.bDontDisplayInAbilitySummary = true;

    Template.ShotHUDPriority = default.BindCrush_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    if (bInputTriggered)
    {
        Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
        Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
        AddActionPointCost(Template, eCost_SingleConsumeAll);
    }
    else
    {
        Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
        Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_SustainedEffect');
    }

    UnitEffectsCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    UnitEffectsCondition.AddRequireEffect(class'X2Ability_Viper'.default.BindSustainedEffectName, 'AA_UnitIsBound');
    Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

    // While sustained this ability causes damage by crushing
    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_BindCrush_Damage");
    DamageEffect.DamageTypes.AddItem('ViperCrush');
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);

    Template.bSkipFireAction = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_Viper'.static.BindSustained_BuildVisualization;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate EndBind(name DataName)
{
    local X2AbilityTemplate         Template;
    local X2Condition_UnitEffectsWithAbilitySource UnitEffectsCondition;
    local X2Effect_RemoveEffects    RemoveEffects;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_BindRelease";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.ShotHUDPriority = default.BindEnd_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    AddActionPointCost(Template, eCost_Free);

    // This ability is only valid if this unit is currently binding the target
    UnitEffectsCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    UnitEffectsCondition.AddRequireEffect(class'X2Ability_Viper'.default.BindSustainedEffectName, 'AA_UnitIsBound');
    Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

    // Remove the bind/bound effects from the Target
    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability_Viper'.default.BindSustainedEffectName);
    Template.AddTargetEffect(RemoveEffects);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_Viper'.static.BindEnd_BuildVisualization;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate RushAndBind(name DataName, name BindAbilityName, name CrushAbilityName, optional name InputCrushAbilityName, bool bSentinel = false)
{
    local X2AbilityTemplate             Template;
    local X2Effect_GrantActionPoints    ActionPointsEffect;
    local X2Effect_ImmediateAbilityActivation BindAbilityEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.AdditionalAbilities.AddItem(BindAbilityName);
    Template.AdditionalAbilities.AddItem(CrushAbilityName);
    if (InputCrushAbilityName != '')
        Template.AdditionalAbilities.AddItem(InputCrushAbilityName);
    Template.AdditionalAbilities.AddItem('M31_PA_EndBind');

    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Bind";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.ShotHUDPriority = default.RushAndBind_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    AddDefaultBindConditions(Template, bSentinel);

    AddCooldown(Template, (bSentinel ? `GetConfigInt("M31_PA_WS_RushAndBind_Cooldown") : `GetConfigInt("M31_PA_RushAndBind_Cooldown")));
    AddActionPointCost(Template, eCost_Single);

    ActionPointsEffect = new class'X2Effect_GrantActionPoints';
    ActionPointsEffect.NumActionPoints = 1;
    ActionPointsEffect.PointType = class'X2CharacterTemplateManager'.default.GOHBindActionPoint;
    Template.AddShooterEffect(ActionPointsEffect);

    BindAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
    BindAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
    BindAbilityEffect.EffectName = 'ImmediateBind';
    BindAbilityEffect.AbilityName = BindAbilityName;
    BindAbilityEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(BindAbilityEffect);

    Template.bSkipFireAction = true;

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    return Template;
}

static function X2AbilityTemplate RushAndBindBind(name DataName, name CrushAbilityName, bool bSentinel = false)
{
    local X2AbilityTemplate                     Template;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2Effect_Persistent                   BoundEffect;
    local X2Effect_ViperBindSustainedExtended   SustainedEffect;
    // local X2Effect_GrantActionPoints            ActionPointsEffect;
    local X2Effect_ApplyWeaponDamage            DamageEffect;
    local X2Effect_ApplyDirectionalWorldDamage  EnvironmentDamageEffect;
    local X2Condition_Visibility                TargetVisibilityCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_bind";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.ShotHUDPriority = default.Bind_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.GOHBindActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bCannotPeek = true;
    TargetVisibilityCondition.bRequireNotMatchCoverType = true;
    TargetVisibilityCondition.TargetCover = CT_Standing;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    AddDefaultBindConditions(Template, bSentinel);
    AddAdjacencyCondition(Template);

    // Add to the target the sustained bind effect
    SustainedEffect = new class'X2Effect_ViperBindSustainedExtended';
    SustainedEffect.SustainedAbilityName = CrushAbilityName;
    SustainedEffect.FragileAmount = (bSentinel ? `GetConfigInt("M31_PA_WS_RushAndBind_FragileAmount") : `GetConfigInt("M31_PA_RushAndBind_FragileAmount"));
    SustainedEffect.bUseGeometricDamageIncrease = false;
    SustainedEffect.bUseExponentialDamageIncrease = false;
    SustainedEffect.iTurnsForFirstIncrease = 1; 
    SustainedEffect.EffectName = class'X2Ability_Viper'.default.BindSustainedEffectName;
    SustainedEffect.bRemoveWhenTargetDies = true;
    SustainedEffect.EffectRemovedSourceVisualizationFn = class'X2Ability_FrostLegionVisualization'.static.BindEndSource_BuildVisualization;
    SustainedEffect.EffectRemovedVisualizationFn = class'X2Ability_FrostLegionVisualization'.static.BindEndTarget_BuildVisualization;
    SustainedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
    SustainedEffect.RegisterAdditionalEventsLikeImpair.AddItem('AffectedByStasis');
    SustainedEffect.RegisterAdditionalEventsLikeImpair.AddItem('StunStrikeActivated');
    SustainedEffect.bBringRemoveVisualizationForward = true;

    // Since this will also be a sustained ability, only put the bound status on the target for one round
    BoundEffect = class'X2StatusEffects'.static.CreateBoundStatusEffect(1, true, true);
    BoundEffect.CustomIdleOverrideAnim = 'NO_BindLoop';
    Template.AddTargetEffect(BoundEffect);
    // This target effect needs to be set as a child on the sustain effect
    SustainedEffect.EffectsToRemoveFromTarget.AddItem(BoundEffect.EffectName);

    // The shooter is also bound
    BoundEffect = class'X2StatusEffects'.static.CreateBoundStatusEffect(1, true, false);
    BoundEffect.CustomIdleOverrideAnim = 'NO_BindLoop';
    Template.AddShooterEffect(BoundEffect);
    // This source effect needs to be set as a child on the sustain effect
    SustainedEffect.EffectsToRemoveFromSource.AddItem(BoundEffect.EffectName);

    // All child effects to the sustained effect have been added, submit
    Template.AddTargetEffect(SustainedEffect);

    // Ability causes damage by crushing
    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.DamageTag = 'Crush';
    DamageEffect.DamageTypes.AddItem('ViperCrush');
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);

    Template.bAllowBonusWeaponEffects = true;

    EnvironmentDamageEffect = new class 'X2Effect_ApplyDirectionalWorldDamage';
    EnvironmentDamageEffect.DamageTypeTemplateName = 'Melee';
    EnvironmentDamageEffect.EnvironmentalDamageAmount = (bSentinel ? `GetConfigInt("M31_PA_WS_RushAndBind_EnvDamage") : `GetConfigInt("M31_PA_Bind_EnvDamage"));
    EnvironmentDamageEffect.PlusNumZTiles = 1;
    EnvironmentDamageEffect.bApplyToWorldOnMiss = false;
    EnvironmentDamageEffect.bHitSourceTile = true;
    EnvironmentDamageEffect.bAllowDestructionOfDamageCauseCover = true;
    Template.AddTargetEffect(EnvironmentDamageEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_FrostLegionVisualization'.static.Bind_BuildVisualization;
    Template.BuildAffectedVisualizationSyncFn = class'X2Ability_Viper'.static.BindUnit_BuildAffectedVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CinescriptCameraType = "Viper_Bind";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate RushAndBindCrush(name DataName, optional bool bInputTriggered)
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitEffectsWithAbilitySource UnitEffectsCondition;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_TightSqueeze";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.Hostility = eHostility_Neutral;
    Template.bDontDisplayInAbilitySummary = true;

    Template.ShotHUDPriority = default.BindCrush_HUDPriority;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    if (bInputTriggered)
    {
        Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
        Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
        AddActionPointCost(Template, eCost_SingleConsumeAll);
    }
    else
    {
        Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
        Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_SustainedEffect');
    }

    UnitEffectsCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    UnitEffectsCondition.AddRequireEffect(class'X2Ability_Viper'.default.BindSustainedEffectName, 'AA_UnitIsBound');
    Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

    // While sustained this ability causes damage by crushing
    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.DamageTag = 'Crush';
    DamageEffect.DamageTypes.AddItem('ViperCrush');
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);

    Template.bAllowBonusWeaponEffects = true;

    Template.bSkipFireAction = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_FrostLegionVisualization'.static.BindSustained_BuildVisualization;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function AddDefaultBindConditions(out X2AbilityTemplate Template, optional bool bSentinel)
{
    local X2Condition_UnitEffects UnitEffectsCondition;
    local X2Condition_UnitProperty UnitPropertyCondition;

    if (bSentinel)
        Template.AbilityTargetConditions.AddItem(new class'X2Condition_TooHeavyToPull_Sentinel');
    else
        Template.AbilityTargetConditions.AddItem(new class'X2Condition_TooHeavyToPull');

    UnitEffectsCondition = new class'X2Condition_UnitEffects';
    UnitEffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
    UnitEffectsCondition.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
    UnitEffectsCondition.AddExcludeEffect(class'X2Effect_PersistentVoidConduit'.default.EffectName, 'AA_UnitIsBound');
    UnitEffectsCondition.AddExcludeEffect(class'X2Effect_DLC_Day60Freeze'.default.EffectName, 'AA_UnitIsFrozen');
    UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.UnconsciousName, 'AA_UnitIsUnconscious');
    Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeAlien = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
}

defaultproperties
{
    GetOverHere_HUDPriority = 300
    GetOverHereAlly_HUDPriority = 301
    RushAndBind_HUDPriority = 303
    Bind_HUDPriority = 304
    BindCrush_HUDPriority = 305
    BindEnd_HUDPriority = 306
}