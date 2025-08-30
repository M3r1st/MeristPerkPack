class X2AbilitySet_PA_Muton extends X2AbilitySet_PlayableAliens;

var config array<name> ExcessiveForce_RifleCategories;
var config array<name> ExcessiveForce_CannonCategories;
var config array<name> ChargeIn_RifleCategories;
var config array<name> Barbarian_RifleCategories;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(MutonPunch());
    Templates.AddItem(PersonalShield());
    Templates.AddItem(Aegis());
    Templates.AddItem(HardenedShield());
    Templates.AddItem(CreateBayonetAbility('M31_PA_Bayonet', false));
    Templates.AddItem(CreateBayonetChargeAbility('M31_PA_BayonetCharge'));
    Templates.AddItem(Counterattack());
        Templates.AddItem(CreateBayonetAbility('M31_PA_Counterattack_Attack', true));
    Templates.AddItem(CripplingBlow());
    Templates.AddItem(Bladestorm());
    Templates.AddItem(Barbarian());
    Templates.AddItem(ExcessiveForce());
    Templates.AddItem(ChargeIn());
    Templates.AddItem(Shieldbreaker());
    Templates.AddItem(MutonBullRush());
    Templates.AddItem(HunterMark());
    Templates.AddItem(HunterWatchfulEye());
        Templates.AddItem(HunterWatchfulEyeAttack());
    Templates.AddItem(HunterDedication());
    Templates.AddItem(StayFrosty());
        Templates.AddItem(StayFrostyAttack());

    Templates.AddItem(class'M31_AbilityHelpers'.static.CreateAnimSetPassive('M31_PA_MutonPunch_Anims', "M31_PA_Mutons.Anims.AS_MutonPunch"));

    return Templates;
}

static function X2AbilityTemplate MutonPunch()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;

    Template = StandardMelee('M31_PA_MutonPunch', "img:///UILibrary_PerkIcons.UIPerk_muton_punch", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.bHideOnClassUnlock = true;

    AddActionPointCost(Template, eCost_Single);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_MutonPunch_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_MutonPunch_CritBonus");
    Template.AbilityToHitCalc = ToHitCalc;

    Template.bLimitTargetIcons = true;

    AddAdjacencyCondition(Template);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.bIgnoreBaseDamage = true;
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_MutonPunch_Damage");
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.bOverrideMeleeDeath = true;

    SetFireAnim(Template, 'FF_MutonPunch');

    Template.AdditionalAbilities.AddItem('M31_PA_MutonPunch_Anims');

    return Template;
}

static function X2DataTemplate PersonalShield()
{
    local X2AbilityTemplate                         Template;
    local X2AbilityCooldown                         Cooldown;
    local X2AbilityCost_ActionPoints                ActionPointCost;
    local array<name>                               SkipExclusions;
    local X2Effect_RemoveEffects                    RemoveEffect;
    local X2Effect_PersonalShield                   Effect;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'M31_PA_PersonalShield');

    Template.AbilitySourceName = 'eAbilitySource_Perk';

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Phalanx";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    Template.Hostility = eHostility_Defensive;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    if (`GetConfigBool("M31_PA_PersonalShield_bAllowWhileDisoriented"))
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);

    RemoveEffect = new class'X2Effect_RemoveEffects';
    RemoveEffect.EffectNamesToRemove.AddItem('M31_PA_PersonalShield');
    RemoveEffect.bDoNotVisualize = true;
    Template.AddTargetEffect(RemoveEffect);

    Effect = new class'X2Effect_PersonalShield';
    Effect.EffectName = 'M31_PA_PersonalShield';
    Effect.ShieldAmount = `GetConfigArrayInt("M31_PA_PersonalShield_ShieldAmount");
    Effect.ShieldPriority = `GetConfigInt("M31_PA_PersonalShield_ShieldPriority");
    Effect.bGetShieldAmountFromArmor = true;
    Effect.AddAdditionalShieldAmount('M31_PA_HardenedShield', `GetConfigInt("M31_PA_HardenedShield_ShieldAmount"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_PersonalShield_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Shield_BonusText"), Template.IconImage,, , Template.AbilitySourceName);
    Effect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;;
    Template.AddTargetEffect(Effect);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_PersonalShield_Cooldown");
    Template.AbilityCooldown = Cooldown;

    Template.bCrossClassEligible = false;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.bShowActivation = true;
    // Template.bSkipFireAction = true;

    Template.CustomFireAnim = 'HL_SignalPositive';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = PersonalyShield_BuildVisualization;

    return Template;
}

simulated function PersonalyShield_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;

    local StateObjectReference          SourceUnitRef;
    local X2AbilityTemplate             AbilityTemplate;

    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   SourceTrack;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
    local X2Action_PlayAnimation        PlayAnimationAction;

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

    SourceUnitRef = Context.InputContext.SourceObject;

    SourceTrack = EmptyTrack;
    SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(SourceUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceUnitRef.ObjectID);
    SourceTrack.VisualizeActor = History.GetVisualizer(SourceUnitRef.ObjectID);

    SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
    SoundAndFlyOver.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, 'None', eColor_Good, AbilityTemplate.IconImage);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = AbilityTemplate.CustomFireAnim;
}

static function X2AbilityTemplate Aegis()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_Aegis                 Effect;

    Template = Passive('M31_PA_Aegis', "img:///UILibrary_SODragoon.UIPerk_aegis", false, true);

    Effect = new class'X2Effect_PA_Aegis';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_PA_PersonalShield');

    return Template;
}

static function X2AbilityTemplate HardenedShield()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_HardenedShield        Effect;

    Template = Passive('M31_PA_HardenedShield', "img:///UILibrary_PerkIcons.UIPerk_extrapadding", false, true);

    Effect = new class'X2Effect_PA_HardenedShield';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_PA_PersonalShield');

    return Template;
}

static function X2AbilityTemplate CreateBayonetAbility(name TemplateName, bool bCounterattack)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;
    local X2Effect_IncrementUnitValue       IncrementValueEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_muton_bayonet";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

    Template.bCrossClassEligible = false;
    if (bCounterattack)
    {
        Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
        Template.bDisplayInUITooltip = false;
        Template.bDisplayInUITacticalText = false;
        Template.bShowActivation = false;
        Template.bDontDisplayInAbilitySummary = true;
    }
    else
    {
        Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
        Template.bDisplayInUITooltip = true;
        Template.bDisplayInUITacticalText = true;
        Template.bShowActivation = true;
    }
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    if (bCounterattack)
    {
        ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
    }
    else
    {
        ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_PA_Bladestorm');
    }
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    if (bCounterattack)
    {
        Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
    }
    else
    {
        Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    }
    

    Template.bLimitTargetIcons = true;

    AddAdjacencyCondition(Template);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    if (!bCounterattack)
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.bAllowBonusWeaponEffects = true;

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    Template.AddTargetEffect(PhysicalDamageEffect);

    // Impairing effects need to come after the damage. This is needed for proper visualization ordering.
    // Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
    Template.AddTargetEffect(class'M31_AbilityHelpers'.static.CreateImpairingEffect());

    if (bCounterattack)
    {
        IncrementValueEffect = new class'X2Effect_IncrementUnitValue';
        IncrementValueEffect.UnitName = class'X2Effect_Counterattack'.default.CounterName;
        IncrementValueEffect.NewValueToSet = 1;
        IncrementValueEffect.CleanupType = eCleanup_BeginTurn;
        IncrementValueEffect.bApplyOnMiss = true;
        Template.AddShooterEffect(IncrementValueEffect);
    }

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    if (bCounterattack)
        Template.MergeVisualizationFn = class'X2Ability_Muton'.static.CounterAttack_MergeVisualization;

    if (!bCounterattack)
        Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    // Template.AdditionalAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    return Template;
}

static function X2AbilityTemplate CreateBayonetChargeAbility(name TemplateName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee       MeleeTarget;
    local array<name>                       SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_LWAlienPack.LWCenturion_AbilityBayonetCharge32";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

    Template.bCrossClassEligible = false;
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.bShowActivation = true;
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee';
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    Template.bLimitTargetIcons = true;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    if (`GetConfigBool("M31_PA_BayonetCharge_bAllowWhileDisoriented"))
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.bAllowBonusWeaponEffects = true;

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

    // Impairing effects need to come after the damage. This is needed for proper visualization ordering.
    // Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
    // Template.AddTargetEffect(class'M31_AbilityHelpers'.static.CreateImpairingEffect());

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    // Template.AdditionalAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    return Template;
}

static function X2AbilityTemplate Counterattack()
{
    local X2AbilityTemplate             Template;
    local X2Effect_SetUnitValue         SetUnitValEffect;
    local X2Effect_Counterattack        CounterattackEffect;

    Template = Passive('M31_PA_Counterattack', "img:///UILibrary_PerkIcons.UIPerk_muton_counterattack", false, true);

    SetUnitValEffect = new class'X2Effect_SetUnitValue';
    SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
    SetUnitValEffect.NewValueToSet = class'X2Ability'.default.CounterattackDodgeUnitValue;
    SetUnitValEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddTargetEffect(SetUnitValEffect);

    CounterattackEffect = new class'X2Effect_Counterattack';
    CounterattackEffect.DodgeBase = `GetConfigInt("M31_PA_Counterattack_Dodge");
    CounterattackEffect.DodgeReductionPerHit = `GetConfigInt("M31_PA_Counterattack_Dodge_ReductionPerHit");
    CounterattackEffect.ActivationsPerTurn = `GetConfigInt("M31_PA_Counterattack_ActivationsPerTurn");
    CounterattackEffect.bOnlyOnEnemyTurn = `GetConfigBool("M31_PA_Counterattack_bOnlyOnEnemyTurn");
    CounterattackEffect.bAllowBurning = true;
    CounterattackEffect.BuildPersistentEffect(1, true, false);
    CounterattackEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(CounterattackEffect);

    Template.AdditionalAbilities.AddItem('M31_PA_Counterattack_Attack');

    return Template;
}

static function X2AbilityTemplate CripplingBlow()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    // local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_PersistentStatChange     Effect;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_CripplingBlow');
    Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_knife_crit";

    Template.DisplayTargetHitChance = true;

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    // MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    // MeleeTarget.iFixedRange = 1;
    // Template.AbilityTargetStyle = MeleeTarget;
    // Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.bLimitTargetIcons = true;

    AddAdjacencyCondition(Template);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.bAllowBonusWeaponEffects = true;

    AddCooldown(Template, `GetConfigInt("M31_PA_CripplingBlow_Cooldown"));

    Effect = new class'X2Effect_PersistentStatChange';
    Effect.EffectName = 'HamstringEffect';
    Effect.EffectRank = 2;
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_CripplingBlow_AimPenalty"));
    Effect.AddPersistentStatChange(eStat_Defense, -1 * `GetConfigInt("M31_PA_CripplingBlow_DefensePenalty"));
    Effect.AddPersistentStatChange(eStat_Dodge, -1 * `GetConfigInt("M31_PA_CripplingBlow_DodgePenalty"));
    Effect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_CripplingBlow_MobilityPenalty"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_CripplingBlow_Duration"), `GetConfigBool("M31_PA_CripplingBlow_bInfiniteDuration"), false, true, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_PA_CripplingBlow_DebuffText"), Template.IconImage,,, Template.AbilitySourceName);
    if (`GetConfigBool("M31_PA_CripplingBlow_bAllowStack"))
    {
        Effect.DuplicateResponse = eDupe_Allow;
    }
    else
    {
        Effect.DuplicateResponse = eDupe_Refresh;
    }
    Template.AddTargetEffect(Effect);

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    Template.AddTargetEffect(PhysicalDamageEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.bCrossClassEligible = false;

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate Bladestorm()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_Bladestorm', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, false);

    Template.AdditionalAbilities.AddItem('Bladestorm');

    return Template;
}

static function X2AbilityTemplate Barbarian()
{
    local X2AbilityTemplate Template;
    local X2Effect_PA_Barbarian Effect;

    Template = Passive('M31_PA_Barbarian', "img:///UILibrary_MZChimeraIcons.Ability_Knife", false, true);

    Effect = new class'X2Effect_PA_Barbarian';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);
    return Template;
}

static function X2AbilityTemplate ExcessiveForce()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_PA_ExcessiveForce', "img:///KetarosPkg_Abilities.UIPerk_gatling", false, false);
    
    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('SkirmisherStrike');

    class'M31_AbilityHelpers'.static.AddConditionalAbilityEffect(Template, default.ExcessiveForce_RifleCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('TraverseFire');

    class'M31_AbilityHelpers'.static.AddConditionalAbilityEffect(Template, default.ExcessiveForce_CannonCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate ChargeIn()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_PA_ChargeIn', "img:///UILibrary_MZChimeraIcons.Ability_BatteringRam", false, false);
    
    Template.AdditionalAbilities.AddItem('RunAndGun_LW');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('ExtraConditioning');

    class'M31_AbilityHelpers'.static.AddConditionalAbilityEffect(Template, default.ChargeIn_RifleCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate Shieldbreaker()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ChangeAbilityHitContext  Effect;
    
    Template = Passive('M31_PA_Shieldbreaker', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_parry", false, true);

    Effect = new class'X2Effect_ChangeAbilityHitContext';
    Effect.bApplyToMelee = true;
    Effect.ChangeHitResults[eHit_Graze] = eHit_Success;
    Effect.ChangeHitResults[eHit_Deflect] = eHit_Success;
    Effect.ChangeHitResults[eHit_Reflect] = eHit_Success;
    Effect.ChangeHitResults[eHit_Parry] = eHit_Success;
    Effect.ChangeHitResults[eHit_CounterAttack] = eHit_Success;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate MutonBullRush()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local array<name>                       SkipExclusions;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = MovingMelee('M31_PA_MutonBullRush', "img:///UILibrary_SOCombatEngineer.UIPerk_bullrush", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_PA_MutonBullRush_Cooldown"));
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_MutonBullRush_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_MutonBullRush_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_MutonBullRush_StunDuration"), 100, false));

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_MutonBullRush_Damage");
    Template.AddTargetEffect(DamageEffect);

    Template.bShowActivation = true;
    Template.bSkipFireAction = false;

    Template.bOverrideMeleeDeath = true;
    SetFireAnim(Template, 'FF_MutonPunch');

    Template.AdditionalAbilities.AddItem('M31_PA_MutonPunch_Anims');

    return Template;
}

static function X2AbilityTemplate HunterMark()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_HunterMark    Effect;
    local X2Condition_UnitEffectsWithAbilitySource EffectCondition;

    Template = SelfTargetActivated('M31_PA_HunterMark', "img:///UILibrary_SOHunter.UIPerk_thisonesmine", false);

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    AddActionPointCost(Template, eCost_Free);
    AddCooldown(Template, `GetConfigInt("M31_PA_HunterMark_Cooldown"));

    Effect = new class'X2Effect_PA_HunterMark';
    Effect.DefenseBonus = `GetConfigInt("M31_PA_HunterMark_DefenseBonus");
    Effect.DefenseBonusPerTurn = `GetConfigInt("M31_PA_HunterMark_DefenseBonusPerTurn");
    Effect.DodgeBonus = `GetConfigInt("M31_PA_HunterMark_DodgeBonus");
    Effect.DodgeBonusPerTurn = `GetConfigInt("M31_PA_HunterMark_DodgeBonusPerTurn");
    Effect.AimBonus = `GetConfigInt("M31_PA_HunterMark_AimBonus");
    Effect.AimBonusPerTurn = `GetConfigInt("M31_PA_HunterMark_AimBonusPerTurn");
    Effect.CritBonus = `GetConfigInt("M31_PA_HunterMark_CritBonus");
    Effect.CritBonusPerTurn = `GetConfigInt("M31_PA_HunterMark_CritBonusPerTurn");
    Effect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_PA_HunterMark_DebuffText"), Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddExcludeEffect(class'X2Effect_PA_HunterMark'.default.EffectName, 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(EffectCondition);

    // Template.bSkipFireAction = false;
    // Template.CustomFireAnim = 'HL_SignalPoint';
    Template.bShowActivation = true;
    
    return Template;
}

static function X2AbilityTemplate HunterWatchfulEye()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_HunterWatchfulEye', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_HunterWatchfulEye_Attack');

    return Template;
}

static function X2AbilityTemplate HunterWatchfulEyeAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    Template = Attack('M31_PA_HunterWatchfulEye_Attack', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(class'X2Effect_PA_HunterMark'.default.EffectName, 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

    AddBladestormMark(Template, 'M31_PA_HunterWatchfulEye_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_HunterWatchfulEye_Counter', `GetConfigInt("M31_PA_HunterWatchfulEye_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate HunterDedication()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_HunterDedication      Effect;

    Template = SelfTargetActivated('M31_PA_HunterDedication', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Dedication", false);

    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_Free);
    AddCooldown(Template, `GetConfigInt("M31_PA_HunterDedication_Cooldown"));

    Effect = new class'X2Effect_PA_HunterDedication';
    Effect.DefenseBonus = `GetConfigInt("M31_PA_HunterDedication_DefenseBonus");
    Effect.DodgeBonus = `GetConfigInt("M31_PA_HunterDedication_DodgeBonus");
    Effect.bExcludeFlanking = `GetConfigBool("M31_PA_HunterDedication_bExcludeFlanking");
    Effect.bExcludeMelee = `GetConfigBool("M31_PA_HunterDedication_bExcludeMelee");
    Effect.AddPersistentStatChange(eStat_Mobility, `GetConfigInt("M31_PA_HunterDedication_MobilityBonus"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_HunterDedication_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_PA_HunterDedication_BuffText"), Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.bShowActivation = true;
    
    return Template;
}

static function X2AbilityTemplate StayFrosty()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_StayFrosty', "img:///KetarosPkg_Abilities.UIPerk_shootingtarget", false, true);
    
    Template.AdditionalAbilities.AddItem('M31_PA_StayFrosty_Attack');

    return Template;
}

static function X2AbilityTemplate StayFrostyAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;

    Template = Attack('M31_PA_StayFrosty_Attack', "img:///KetarosPkg_Abilities.UIPerk_shootingtarget", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = false;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = `GetConfigFloat("M31_PA_StayFrosty_Radius") * class'XComWorldData'.const.WORLD_StepSize;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    AddBladestormMark(Template, 'M31_PA_StayFrosty_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_StayFrosty_Counter', `GetConfigInt("M31_PA_StayFrosty_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = `GetConfigBool("M31_PA_StayFrosty_bReactionFire");
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}