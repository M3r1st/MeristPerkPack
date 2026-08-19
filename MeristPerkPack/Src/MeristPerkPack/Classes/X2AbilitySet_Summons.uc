class X2AbilitySet_Summons extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name ZombieLinkAbilityName;
var privatewrite name ZombieLinkName;
var privatewrite name KillSiredZombiesAbilityName;

var privatewrite name SpectreLinkAbilityName;
var privatewrite name SpectreLinkName;
var privatewrite name KillSummonedSpectresAbilityName;

var privatewrite name KillTargetSummonAbilityName;

var privatewrite name ImprovedZombiesAbilityName;
var privatewrite name ImprovedSpectresAbilityName;

var privatewrite name GatewayReanimationRequiredEffect;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    // Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_Summons_Animations', ""));

    // Templates.AddItem(PsiReanimation());
    // Templates.AddItem(KillSiredZombies());
    // Templates.AddItem(class'X2Ability_Sectoid'.static.AddLinkedEffectAbility(default.ZombieLinkAbilityName, default.ZombieLinkName, ZombieLink_BuildVisualizationSync));
    // Templates.AddItem(ImprovedZombies());
    // Templates.AddItem(Gateway());
    // Templates.AddItem(GatewayReanimation());

    // Templates.AddItem(SummonSpectralZombie());
    // Templates.AddItem(SpectralUnitInit('M31_SpectralZombieInit', 'ADD_SpectralFrost_Start', 'ADD_SpectralFrost_Stop'));
    // Templates.AddItem(SummonSpectralLancer());
    // Templates.AddItem(SpectralUnitInit('M31_SpectralLancerInit', 'ADD_SpectralArmy_Restart', 'ADD_SpectralArmy_Stop'));
    // Templates.AddItem(SummonSpectralCreature());
    // Templates.AddItem(SpectralUnitInit('M31_SpectralCreatureInit', 'ADD_', 'ADD_'));
    // Templates.AddItem(KillSummonedSpectres());
    // Templates.AddItem(class'X2Ability_Sectoid'.static.AddLinkedEffectAbility(default.SpectreLinkAbilityName, default.SpectreLinkName, none));
    // Templates.AddItem(ImprovedSpectres());

    // Templates.AddItem(KillTargetSummon());

    return Templates;
}

static function X2AbilityTemplate PsiReanimation(name DataName = 'M31_PsiReanimation')
{
    local X2AbilityTemplate             Template;
    local X2Condition_MaxNumZombies     MaxNumZombiesCondition;
    local X2Condition_UnitType          UnitTypeCondition;
    local X2Condition_UnitValue         UnitValueCondition;
    local X2Condition_UnitEffects       ExcludeEffects;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Condition_Visibility        VisibilityCondition;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2AbilityCharges_Tech         Charges;
    local X2AbilityCost_Charges         ChargeCost;
    local X2Effect_MeristSpawnZombie    SpawnZombieEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
    Template.HideErrors.AddItem('AA_CannotAfford_Charges');
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    if (`GetConfigInt("M31_Psi_MaxNumZombies") > 0)
    {
        MaxNumZombiesCondition = new class'X2Condition_MaxNumZombies';
        MaxNumZombiesCondition.LinkEffectName = default.ZombieLinkName;
        MaxNumZombiesCondition.MaxNumZombies = `GetConfigInt("");
        MaxNumZombiesCondition.AddMaxNumZombiesAbilityBonus(default.ImprovedZombiesAbilityName, `GetConfigInt(""));
        Template.AbilityShooterConditions.AddItem(MaxNumZombiesCondition);
    }

    // Units of these types may not be turned into a zombie
    UnitTypeCondition = new class'X2Condition_UnitType';
    UnitTypeCondition.ExcludeTypes = class'X2Ability_Sectoid'.default.SECTOID_REANIMATION_EXCLUDE_UNIT_TYPES;
    Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

    // This ability is only valid if the target has not yet been turned into a zombie
    UnitValueCondition = new class'X2Condition_UnitValue';
    UnitValueCondition.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
    Template.AbilityTargetConditions.AddItem(UnitValueCondition);

    // The target's tile must be clear of obstruction.
    Template.AbilityTargetConditions.AddItem(new class'X2Condition_ValidUnburrowTile');

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
    ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName, 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(ExcludeEffects);

    // The unit must be organic, dead, and not an alien
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeAlive = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeOrganic = false;
    UnitPropertyCondition.ExcludeAlien = true;
    UnitPropertyCondition.ExcludeCivilian = false;
    UnitPropertyCondition.ExcludeCosmetic = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = true;
    if (`GetConfigInt("") > 0)
    {
        UnitPropertyCondition.RequireWithinRange = true;
        UnitPropertyCondition.WithinRange = `TILESTOUNITS(`GetConfigInt(""));
    }
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    // Must be able to see the dead unit to reanimate it
    if (`GetConfigBool(""))
    {
        VisibilityCondition = new class'X2Condition_Visibility';
        VisibilityCondition.bRequireGameplayVisible = `GetConfigBool("");
        if (`GetConfigBool(""))
        {
            VisibilityCondition.bAllowSquadsight = `GetConfigBool("");
        }
        Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    }

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.NumTurnsFromTech = `GetConfigArrayInt("");
    Cooldown.AddCooldownModifier(default.ImprovedZombiesAbilityName, -1 * `GetConfigInt(""));
    Template.AbilityCooldown = Cooldown;

    AddActionPointCost(Template, eCost_SingleConsumeAll);

    if (`GetConfigBool(""))
    {
        Charges = new class'X2AbilityCharges_Tech';
        Charges.InitialChargesFromTech = `GetConfigArrayInt("");
        Template.AbilityCharges = Charges;

        ChargeCost = new class'X2AbilityCost_Charges';
        ChargeCost.NumCharges = 1;
        Template.AbilityCosts.AddItem(ChargeCost);
    }

    SpawnZombieEffect = new class'X2Effect_MeristSpawnZombie';
    SpawnZombieEffect.UnitToSpawnName = 'M31_PsiZombie';
    SpawnZombieEffect.UnitToSpawnHumanName = 'M31_PsiZombieHuman';
    SpawnZombieEffect.AltRequiredAbility = default.ImprovedZombiesAbilityName;
    SpawnZombieEffect.AltUnitToSpawnName = 'M31_AdvPsiZombie';
    SpawnZombieEffect.AltUnitToSpawnHumanName = 'M31_AdvPsiZombieHuman';
    SpawnZombieEffect.BuildPersistentEffect(1, true, true);
    Template.AddTargetEffect(SpawnZombieEffect);

    Template.CustomFireAnim = 'HL_Psi_ReAnimate';
    Template.bShowActivation = true;
    Template.bSkipFireAction = false;
    Template.bSkipExitCoverWhenFiring = false;
    Template.bSkipPerkActivationActions = true;
    Template.bSkipPerkActivationActionsSync = false;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CinescriptCameraType = "Sectoid_PsiReanimation";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = PsiReanimation_BuildVisualization;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem(default.KillSiredZombiesAbilityName);
    Template.AdditionalAbilities.AddItem(default.KillTargetSummonAbilityName);

    return Template;
}

simulated function PsiReanimation_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;
    local X2AbilityTemplate             AbilityTemplate;
    local X2Action_PlayAnimation        AnimationAction;

    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   ActionMetadata, ZombieTrack, DeadUnitTrack;
    local XComGameState_Unit            SpawnedUnit, DeadUnit;
    local UnitValue                     SpawnedUnitValue;
    local X2Effect_SpawnPsiZombie       SpawnPsiZombieEffect;
    local X2Action_TimedWait            ReanimateTimedWaitAction;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = Context.InputContext.SourceObject;

    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

    // Configure the visualization track for the shooter
    // ****************************************************************************************
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    // Configure the visualization track for the psi zombie
    // ******************************************************************************************
    DeadUnitTrack.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex);
    DeadUnitTrack.StateObject_NewState = DeadUnitTrack.StateObject_OldState;
    DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
    `assert(DeadUnit != none);
    DeadUnitTrack.VisualizeActor = History.GetVisualizer(DeadUnit.ObjectID);

    // Get the ObjectID for the ZombieUnit created from the DeadUnit
    DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

    ZombieTrack = EmptyTrack;
    ZombieTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
    ZombieTrack.StateObject_NewState = ZombieTrack.StateObject_OldState;
    SpawnedUnit = XComGameState_Unit(ZombieTrack.StateObject_NewState);
    `assert(SpawnedUnit != none);
    ZombieTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

    // Only one target effect and it is X2Effect_SpawnPsiZombie
    SpawnPsiZombieEffect = X2Effect_SpawnPsiZombie(Context.ResultContext.TargetEffectResults.Effects[0]);

    if (SpawnPsiZombieEffect == none)
    {
        `RedScreenOnce("PsiReanimation_BuildVisualization: Missing X2Effect_SpawnPsiZombie -dslonneger @gameplay");
        return;
    }

    // Build the tracks
    if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
    {
        class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
    }
    class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

    // Dead unit should wait for the Sectoid to play its Reanimation animation
    // Preferable to have an anim notify from content but can't do that currently, animation gave the time to wait before the zombie rises
    ReanimateTimedWaitAction = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(DeadUnitTrack, Context));
    ReanimateTimedWaitAction.DelayTimeSec = class'X2Ability_Sectoid'.default.SECTOID_REANIMATION_ZOMBIE_RISE_DELAY;

    SpawnPsiZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, ZombieTrack, DeadUnit, DeadUnitTrack);

    if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
    {
        AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
        // AnimationAction.Params.AnimName = 'HL_Psi_ReAnimate';
        AnimationAction.Params.AnimName = AbilityTemplate.CustomFireAnim;
    }

    class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
    if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
    {
        class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
    }
}

static function ZombieLink_BuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
    local XComGameStateContext_Ability AbilityContext;
    local XComGameState_Unit ZombieUnitState;
    local XComGameState_Unit DeadUnitState;
    local XComGameState_Ability ZombieAbility;
    local X2Action_CreateDoppelganger DoppelgangerAction;

    //Only run on the SireZombieLink effect
    if (EffectName != default.ZombieLinkName)
        return;
    
    //Find the context and unit states associated with the Psi Reanimation ability used
    AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    if (AbilityContext == None)
        return;

    ZombieUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
    DeadUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
    if (ZombieUnitState == None || DeadUnitState == None)
        return;

    ZombieAbility = XComGameState_Ability(VisualizeGameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
    if (ZombieAbility == none)
        return;

    //Perform X2Action_CreateDoppelganger on the zombie, as we did when it was spawned, to grab the original unit's appearance and tether effect.
    DoppelgangerAction = X2Action_CreateDoppelganger(class'X2Action_CreateDoppelganger'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
    DoppelgangerAction.OriginalUnitState = DeadUnitState;
    DoppelgangerAction.ShouldCopyAppearance = true;
    DoppelgangerAction.ReanimatorAbilityState = ZombieAbility;
    DoppelgangerAction.bIgnorePose = true;
}

static function X2AbilityTemplate KillSiredZombies()
{
    local X2AbilityTemplate Template;

    Template = class'X2Ability_Sectoid'.static.AddKillLinkedUnits(
        default.KillSiredZombiesAbilityName,
        default.ZombieLinkName,
        class'X2Action_ZombieSireDeath',
        true);
    Template.bUniqueSource = true;

    return Template;
}

static function X2AbilityTemplate ImprovedZombies()
{
    local X2AbilityTemplate Template;
    
    Template = Passive(default.ImprovedZombiesAbilityName, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ghost", false, true);

    return Template;
}

static function X2AbilityTemplate Gateway()
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_Gateway');

    Template.AdditionalAbilities.AddItem('M31_Psi_Gateway_Reanimation');

    return Template;
}

static function X2AbilityTemplate GatewayReanimation()
{
    local X2AbilityTemplate             Template;
    local X2AbilityTrigger_EventListener Trigger;
    local X2Condition_MaxNumZombies     MaxNumZombiesCondition;
    local X2Condition_UnitType          UnitTypeCondition;
    local X2Condition_UnitValue         UnitValueCondition;
    local X2Condition_UnitEffects       ExcludeEffects;
    local X2Condition_UnitEffects       RequiredEffects;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Effect_MeristSpawnZombie    SpawnZombieEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_Gateway_Reanimation');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitDied';
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.Priority = 0;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_GatewayReanimation;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    if (`GetConfigInt("M31_Psi_MaxNumZombies") > 0)
    {
        MaxNumZombiesCondition = new class'X2Condition_MaxNumZombies';
        MaxNumZombiesCondition.LinkEffectName = default.ZombieLinkName;
        MaxNumZombiesCondition.MaxNumZombies = `GetConfigInt("");
        MaxNumZombiesCondition.AddMaxNumZombiesAbilityBonus(default.ImprovedZombiesAbilityName, `GetConfigInt(""));
        Template.AbilityShooterConditions.AddItem(MaxNumZombiesCondition);
    }

    // Units of these types may not be turned into a zombie
    UnitTypeCondition = new class'X2Condition_UnitType';
    UnitTypeCondition.ExcludeTypes = class'X2Ability_Sectoid'.default.SECTOID_REANIMATION_EXCLUDE_UNIT_TYPES;
    Template.AbilityTargetConditions.AddItem(UnitTypeCondition);

    // This ability is only valid if the target has not yet been turned into a zombie
    UnitValueCondition = new class'X2Condition_UnitValue';
    UnitValueCondition.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
    Template.AbilityTargetConditions.AddItem(UnitValueCondition);

    // The target's tile must be clear of obstruction.
    Template.AbilityTargetConditions.AddItem(new class'X2Condition_ValidUnburrowTile');

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
    ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName, 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(ExcludeEffects);

    RequiredEffects = new class'X2Condition_UnitEffects';
    RequiredEffects.AddRequireEffect(default.GatewayReanimationRequiredEffect, 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(RequiredEffects);

    // The unit must be organic, dead, and not an alien
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeAlive = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeOrganic = false;
    UnitPropertyCondition.ExcludeAlien = true;
    UnitPropertyCondition.ExcludeCivilian = false;
    UnitPropertyCondition.ExcludeCosmetic = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    SpawnZombieEffect = new class'X2Effect_MeristSpawnZombie';
    SpawnZombieEffect.UnitToSpawnName = 'M31_PsiZombie';
    SpawnZombieEffect.UnitToSpawnHumanName = 'M31_PsiZombieHuman';
    SpawnZombieEffect.AltRequiredAbility = default.ImprovedZombiesAbilityName;
    SpawnZombieEffect.AltUnitToSpawnName = 'M31_AdvPsiZombie';
    SpawnZombieEffect.AltUnitToSpawnHumanName = 'M31_AdvPsiZombieHuman';
    SpawnZombieEffect.BuildPersistentEffect(1, true, true);
    Template.AddTargetEffect(SpawnZombieEffect);

    Template.CustomFireAnim = 'HL_Psi_ReAnimate';
    Template.bShowActivation = false;
    Template.bSkipFireAction = true;
    Template.bSkipExitCoverWhenFiring = true;
    Template.bSkipPerkActivationActions = true;
    Template.bSkipPerkActivationActionsSync = false;

    Template.CinescriptCameraType = "Sectoid_PsiReanimation";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = PsiReanimation_BuildVisualization;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem(default.KillSiredZombiesAbilityName);
    Template.AdditionalAbilities.AddItem(default.KillTargetSummonAbilityName);

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_GatewayReanimation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability         AbilityState;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            TargetUnit;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        TargetUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(CallbackData);
        if (TargetUnit != none && AbilityState != none)
        {
            AbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
        }
    }

    return ELR_NoInterrupt;
}


static function X2AbilityTemplate SummonSpectralZombie()
{
    local X2AbilityTemplate             Template;
    local X2Effect_MeristSpawnSpectre   SpawnUnitEffect;
    
    Template = CreateSummonSpectreAbility('M31_SummonSpectralZombie', "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 3;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddSummonSpectreCooldown(Template, `GetConfigInt(""));
    AddCharges(Template, `GetConfigInt(""));

    SpawnUnitEffect = new class'X2Effect_MeristSpawnSpectre';
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralZombie_M1');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralZombie_M1');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralZombie_M2');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralZombie_M2');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralZombie_M3');

    SpawnUnitEffect.AltRequiredAbility = default.ImprovedSpectresAbilityName;
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralZombie_M1');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralZombie_M1');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralZombie_M2');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralZombie_M2');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralZombie_M3');

    SpawnUnitEffect.NumStartingPoints = 1;
    SpawnUnitEffect.SpawnAnim = 'HL_FrostZombieRise';
    SpawnUnitEffect.LinkAbilityName = default.SpectreLinkAbilityName;
    Template.AddShooterEffect(SpawnUnitEffect);

    return Template;
}

static function X2AbilityTemplate SummonSpectralLancer()
{
    local X2AbilityTemplate             Template;
    local X2Effect_MeristSpawnSpectre   SpawnUnitEffect;

    Template = CreateSummonSpectreAbility('M31_SummonSpectralLancer', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_possess");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 2;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddSummonSpectreCooldown(Template, `GetConfigInt(""));
    AddCharges(Template, `GetConfigInt(""));

    SpawnUnitEffect = new class'X2Effect_MeristSpawnSpectre';
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralLancer_M1');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralLancer_M1');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralLancer_M2');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralLancer_M2');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralLancer_M3');

    SpawnUnitEffect.AltRequiredAbility = default.ImprovedSpectresAbilityName;
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralLancer_M1');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralLancer_M1');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralLancer_M2');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralLancer_M2');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralLancer_M3');

    SpawnUnitEffect.NumStartingPoints = 1;
    SpawnUnitEffect.SpawnAnim = 'HL_SpectralArmy_Target';
    SpawnUnitEffect.LinkAbilityName = default.SpectreLinkAbilityName;
    Template.AddShooterEffect(SpawnUnitEffect);

    return Template;
}

static function X2AbilityTemplate SummonSpectralCreature()
{
    local X2AbilityTemplate             Template;
    local X2Effect_MeristSpawnSpectre   SpawnUnitEffect;

    Template = CreateSummonSpectreAbility('M31_SummonSpectralCreature', "img:///UILibrary_PerkIcons.UIPerk_chryssalid_burrow");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    AddActionPointCost(Template, eCost_DoubleConsumeAll);
    AddSummonSpectreCooldown(Template, `GetConfigInt(""));
    AddCharges(Template, `GetConfigInt(""));

    SpawnUnitEffect = new class'X2Effect_MeristSpawnSpectre';
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralCreature_M1');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralCreature_M1');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralCreature_M2');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralCreature_M2');
    SpawnUnitEffect.UnitToSpawnNames.AddItem('M31_SpectralCreature_M3');

    SpawnUnitEffect.AltRequiredAbility = default.ImprovedSpectresAbilityName;
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralCreature_M1');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralCreature_M1');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralCreature_M2');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralCreature_M2');
    SpawnUnitEffect.AltUnitToSpawnNames.AddItem('M31_AdvSpectralCreature_M3');

    SpawnUnitEffect.NumStartingPoints = 1;
    SpawnUnitEffect.SpawnAnim = 'HL_SpectralArmy_Target';
    SpawnUnitEffect.LinkAbilityName = default.SpectreLinkAbilityName;
    Template.AddShooterEffect(SpawnUnitEffect);

    return Template;
}

static function X2AbilityTemplate CreateSummonSpectreAbility(name DataName, string IconImage)
{
    local X2AbilityTemplate             Template;
    local X2AbilityTarget_Cursor        CursorTarget;
    local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
    local X2Condition_MaxNumZombies     MaxNumZombiesCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "UILibrary_XPACK_Common.PerkIcons.UIPerk_spectralarmy";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
    Template.HideErrors.AddItem('AA_CannotAfford_Charges');
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToSquadsightRange = true;
    if (`GetConfigInt("M31_Psi_SummonRange") > 0)
    {
        CursorTarget.FixedAbilityRange = `GetConfigInt("M31_Psi_SummonRange");
    }
    Template.AbilityTargetStyle = CursorTarget;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = 0.25;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Template.TargetingMethod = class'X2TargetingMethod_Teleport';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    if (`GetConfigInt("") > 0)
    {
        MaxNumZombiesCondition = new class'X2Condition_MaxNumZombies';
        MaxNumZombiesCondition.LinkEffectName = default.SpectreLinkName;
        MaxNumZombiesCondition.MaxNumZombies = `GetConfigInt("");
        MaxNumZombiesCondition.AddMaxNumZombiesAbilityBonus('FakeName22', 0);
        Template.AbilityShooterConditions.AddItem(MaxNumZombiesCondition);
    }

    Template.CustomFireAnim = 'HL_M31_Psi_Corrupt';
    Template.bShowActivation = true;
    Template.bSkipFireAction = false;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CinescriptCameraType = "Warlock_SpectralZombie";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = SpawnUnit_BuildVisualization;

    Template.ConcealmentRule = eConceal_Never;
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem(default.KillSummonedSpectresAbilityName);
    Template.AdditionalAbilities.AddItem(default.KillTargetSummonAbilityName);

    return Template;
}

simulated function SpawnUnit_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateVisualizationMgr VisMgr;
    local XComWorldData WorldData;
    local XComGameStateContext_Ability Context;
    local VisualizationActionMetadata ActionMetadata;
    local X2Action_CameraLookAt LookAtAction;
    local Array<X2Action> FoundActions;
    local X2Action FireAction;
    local XComGameState_Unit GameStateUnit;
    local X2Action_CameraRemove RemoveCamera;

    // Build the basic ability visualization
    TypicalAbility_BuildVisualization(VisualizeGameState);

    VisMgr = `XCOMVISUALIZATIONMGR;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    // Add a look at camera to the spawned units
    // ****************************************************************************************
    VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ShowSpawnedUnit', FoundActions);
    FireAction = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', , Context.InputContext.SourceObject.ObjectID);

    if ((FoundActions.Length > 0) && (FireAction != none) )
    {
        ActionMetadata.StateObject_OldState = FoundActions[0].MetaData.StateObject_OldState;
        ActionMetadata.StateObject_NewState = FoundActions[0].MetaData.StateObject_NewState;
        ActionMetadata.VisualizeActor = FoundActions[0].MetaData.VisualizeActor;

        GameStateUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

        if (GameStateUnit != none)
        {
            WorldData = `XWORLD;

            LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, true, FireAction));
            LookAtAction.LookAtLocation = WorldData.GetPositionFromTileCoordinates(GameStateUnit.TileLocation);
            LookAtAction.LookAtDuration = class'X2Ability_ChosenWarlock'.default.CORRESS_LOOKAT_DURATION * (`XPROFILESETTINGS.Data.bEnableZipMode ? class'X2TacticalGameRuleset'.default.ZipModeDelayModifier : 1.0);
            LookAtAction.BlockUntilActorOnScreen = true;
            LookAtAction.AddInputEvent('Visualizer_AbilityHit');

            ActionMetadata.StateObject_NewState = `XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID);
            ActionMetadata.StateObject_OldState = ActionMetadata.StateObject_NewState.GetPreviousVersion();
            ActionMetadata.VisualizeActor = `XCOMHISTORY.GetVisualizer(Context.InputContext.SourceObject.ObjectID);

            RemoveCamera = X2Action_CameraRemove(class'X2Action_CameraRemove'.static.AddToVisualizationTree( ActionMetadata, Context, true, ActionMetadata.LastActionAdded));
            RemoveCamera.CameraTagToRemove = 'AbilityFraming';
        }
    }
}

static function AddSummonSpectreCooldown(out X2AbilityTemplate AbilityTemplate, int iNumTurns)
{
    local X2AbilityCooldown_Extended Cooldown;

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = iNumTurns;
    if (`GetConfigBool(""))
    {
        if (`GetConfigInt("") > 0)
        {
            iNumTurns = `GetConfigInt("");
        }
        if (AbilityTemplate.DataName != '')
        {
            Cooldown.AddAdditionalCooldownInfo('', iNumTurns);
        }
        if (AbilityTemplate.DataName != '')
        {
            Cooldown.AddAdditionalCooldownInfo('', iNumTurns);
        }
        if (AbilityTemplate.DataName != '')
        {
            Cooldown.AddAdditionalCooldownInfo('', iNumTurns);
        }
    }
    AbilityTemplate.AbilityCooldown = Cooldown;
}

static function X2AbilityTemplate KillSummonedSpectres()
{
    local X2AbilityTemplate Template;

    Template = class'X2Ability_Sectoid'.static.AddKillLinkedUnits(
        default.KillSummonedSpectresAbilityName,
        default.SpectreLinkName,
        class'X2Action_ZombieSireDeath',
        false);
    Template.bUniqueSource = true;

    return Template;
}

static function X2AbilityTemplate SpectralUnitInit(name DataName, name AddEffectAnimName, name RemoveEffectAnimName)
{
    local X2AbilityTemplate         Template;
    local X2Effect_SpectralUnit     Effect;
    
    Template = Passive(DataName, "UILibrary_XPACK_Common.PerkIcons.UIPerk_spectralarmy", false, false, true);

    Effect = new class'X2Effect_SpectralUnit';
    Effect.AddEffectAnimName = AddEffectAnimName;
    Effect.RemoveEffectAnimName =  RemoveEffectAnimName;
    Effect.BuildPersistentEffect(1, true, true);
    Effect.bRemoveWhenTargetDies = true;
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ImprovedSpectres()
{
    local X2AbilityTemplate Template;
    
    Template = Passive(default.ImprovedSpectresAbilityName, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ghost", false, true);

    return Template;
}

static function X2AbilityTemplate KillTargetSummon()
{
    local X2AbilityTemplate Template;
    local X2Condition_TargetHasOneOfTheEffectsWithAbilitySource TargetEffectCondition;
    local X2Effect_KillUnit KillUnitEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, default.KillTargetSummonAbilityName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_executioner";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;
    Template.bUniqueSource = true;

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.INTERACT_PRIORITY;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    TargetEffectCondition = new class'X2Condition_TargetHasOneOfTheEffectsWithAbilitySource';
    TargetEffectCondition.EffectNames.AddItem(class'X2Ability_Sectoid'.default.SireZombieLinkName);
    TargetEffectCondition.EffectNames.AddItem(default.ZombieLinkName);
    TargetEffectCondition.EffectNames.AddItem(default.SpectreLinkName);
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

    Template.AbilityCosts.AddItem(default.FreeActionCost);

    KillUnitEffect = new class'X2Effect_KillUnit';
    KillUnitEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    KillUnitEffect.DeathActionClass = class'X2Action_ZombieSireDeath';
    KillUnitEffect.VisualizationFn = class'X2Ability_Sectoid'.static.BuildVisualization_SireDeathEffect;
    Template.AddTargetEffect(KillUnitEffect);

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    // Template.CinescriptCameraType = "Zombie_SireDeath";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipFireAction = true;
    Template.bShowActivation = false;

    return Template;
}

defaultproperties
{
    ZombieLinkAbilityName = M31_ZombieLink
    ZombieLinkName = M31_SireZombieLink
    KillSiredZombiesAbilityName = M31_KillSiredZombies

    SpectreLinkAbilityName = M31_SpectreLink
    SpectreLinkName = M31_SireSpectreLink
    KillSummonedSpectresAbilityName = M31_KillSummonedSpectres

    KillTargetSummonAbilityName = M31_KillTargetSummon
}