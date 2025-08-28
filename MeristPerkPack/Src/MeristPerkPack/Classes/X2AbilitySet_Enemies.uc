class X2AbilitySet_Enemies extends X2Ability_Extended config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Sidewinder('M31_ENEMY_Sidewinder', 'M31_ENEMY_Sidewinder_Move'));
        Templates.AddItem(SidewinderMove('M31_ENEMY_Sidewinder_Move', `GetConfigInt("M31_ENEMY_Sidewinder_Cooldown")));
    Templates.AddItem(Sidewinder('M31_ENEMY_MuchSidewinder', 'M31_ENEMY_MuchSidewinder_Move'));
        Templates.AddItem(SidewinderMove('M31_ENEMY_MuchSidewinder_Move', 1));

    Templates.AddItem(ViperBite('M31_ENEMY_ViperBite'));
    Templates.AddItem(ViperBite2('M31_ENEMY_ViperBiteWithCrit'));

    Templates.AddItem(Lockjaw('M31_ENEMY_Lockjaw', 'M31_ENEMY_Lockjaw_Attack'));
        Templates.AddItem(LockjawAttack('M31_ENEMY_Lockjaw_Attack'));

    Templates.AddItem(AngryBite('M31_ENEMY_AngryBite', 'M31_ENEMY_AngryBite_Attack'));
        Templates.AddItem(AngryBiteAttack('M31_ENEMY_AngryBite_Attack'));
        
    Templates.AddItem(PoisonSpit('M31_ENEMY_PoisonSpit', false /* bDealsDamage */));
    Templates.AddItem(PoisonSpit('M31_ENEMY_PoisonSpitWithDamage', true /* bDealsDamage */));

    Templates.AddItem(CoilHunkerPassive('M31_ENEMY_CoilHunker', 'M31_ENEMY_CoilHunker_Trigger'));
        Templates.AddItem(CoilHunkerDeepCover('M31_ENEMY_CoilHunker_Trigger'));
    Templates.AddItem(CoilHunkerPassive('M31_ENEMY_AdvancedCoilHunker', 'M31_ENEMY_AdvancedCoilHunker_Trigger'));
        Templates.AddItem(AdvancedCoilHunker('M31_ENEMY_AdvancedCoilHunker_Trigger'));
    Templates.AddItem(CoilHunkerPassive('M31_ENEMY_CoilHunkerDamaged', 'M31_ENEMY_CoilHunkerDamaged_Trigger'));
        Templates.AddItem(CoilHunkerDamaged('M31_ENEMY_CoilHunkerDamaged_Trigger'));

    Templates.AddItem(ChryssalidMeleeAttack('M31_ENEMY_LightningClaw'));

    return Templates;
}

static function X2AbilityTemplate Sidewinder(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Sidewinder               Effect;

    Template = Passive(DataName, "img:///UILibrary_PerkIcons.UIPerk_Shadowstrike", false, true);
    
    Effect = new class'X2Effect_Sidewinder';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);

    return Template;
}

static function X2AbilityTemplate SidewinderMove(name DataName, int iCooldown)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local array<name>                       SkipExclusions;
    local X2Effect_Persistent               CooldownEffect;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Effect_RunBehaviorTree          BehaviorTreeEffect;
    
    Template = SelfTargetTrigger(DataName, "img:///UILibrary_PerkIcons.UIPerk_Shadowstrike");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = class'X2AbilitySet_PlayableAliens'.default.SidewinderEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 50;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_NotItsOwnTurn');

    if (`GetConfigBool("M31_ENEMY_Sidewinder_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_ENEMY_Sidewinder_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddTargetEffect(ActionPointEffect);

    BehaviorTreeEffect = new class'X2Effect_RunBehaviorTree';
    BehaviorTreeEffect.BehaviorTreeName = 'M31_SidewinderMove';
    Template.AddTargetEffect(BehaviorTreeEffect);

    CooldownEffect = new class'X2Effect_Persistent';
    CooldownEffect.EffectName = class'X2AbilitySet_PlayableAliens'.default.SidewinderCooldownEffectName;
    CooldownEffect.BuildPersistentEffect(iCooldown, false, true, false, eGameRule_PlayerTurnBegin);
    CooldownEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_PA_Sidewinder_CooldownText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(CooldownEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate ViperBite(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    Template.bCrossClassEligible = false;

    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    AddActionPointCost(Template, eCost_DoubleConsumeAll);

    AddCooldown(Template, `GetConfigInt("M31_ENEMY_ViperBite_Cooldown"));

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_ENEMY_ViperBite_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_ENEMY_ViperBite_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    // Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeRobotic = true;
    Template.AbilityTargetConditions.AddItem(UnitPropCondition);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    
    AddEnhancedPoisonEffectToTarget(Template);
    AddBlindingPoisonEffectToTarget(Template);

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_ViperBite_Damage");
    PhysicalDamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_ENEMY_ViperBite_Rupture");
    PhysicalDamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.bSkipMoveStop = false;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bOverrideMeleeDeath = false;

    Template.CustomFireAnim = 'HL_M31_ViciousBite';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2AbilityTemplate ViperBite2(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    Template.bCrossClassEligible = false;

    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    AddActionPointCost(Template, eCost_DoubleConsumeAll);

    AddCooldown(Template, `GetConfigInt("M31_ENEMY_ViperBite2_Cooldown"));

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_ENEMY_ViperBite2_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_ENEMY_ViperBite2_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    // Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeRobotic = true;
    Template.AbilityTargetConditions.AddItem(UnitPropCondition);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    
    AddEnhancedPoisonEffectToTarget(Template);
    AddBlindingPoisonEffectToTarget(Template);

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_ViperBite2_Damage");
    PhysicalDamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_ENEMY_ViperBite2_Rupture");
    PhysicalDamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.bSkipMoveStop = false;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bOverrideMeleeDeath = false;

    Template.CustomFireAnim = 'HL_M31_ViciousBite';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2AbilityTemplate Lockjaw(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate                 Template;

    Template = Passive(DataName, "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, true);

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);

    return Template;
}

static function X2AbilityTemplate LockjawAttack(name DataName)
{
    local X2AbilityTemplate                         Template;
    local X2AbilityToHitCalc_StandardMelee          ToHitCalc;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_Visibility                    VisibilityCondition;
    local X2Condition_UnitProperty                  UnitPropertyCondition;
    local X2AbilityCooldown_Extended                Cooldown;

    Template = StandardMelee(DataName, "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_ENEMY_Lockjaw_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_ENEMY_Lockjaw_CritBonus");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'X2AbilitySet_PlayableAliens'.static.AbilityTriggerEventListener_Lockjaw;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    AddAdjacencyCondition(Template);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_ENEMY_Lockjaw_Cooldown");
    Cooldown.bApplyOnlyOnHit = true;
    Template.AbilityCooldown = Cooldown;

    AddBladestormMark(Template, 'M31_ENEMY_Lockjaw_MarkTarget');
    AddSuppressedCondition(Template);

    AddEnhancedPoisonEffectToTarget(Template);
    AddBlindingPoisonEffectToTarget(Template);

    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false));
    Template.AddTargetEffect(CreateLockjawDamageEffect());

    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2Effect_ApplyWeaponDamage CreateLockjawDamageEffect()
{
    local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_Lockjaw_Damage");
    PhysicalDamageEffect.bIgnoreBaseDamage = true;

    return PhysicalDamageEffect;
}

static function X2AbilityTemplate AngryBite(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate                 Template;

    Template = Passive(DataName, "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, true);

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);

    return Template;
}

static function X2AbilityTemplate AngryBiteAttack(name DataName)
{
    local X2AbilityTemplate                         Template;
    local X2AbilityToHitCalc_StandardMelee          ToHitCalc;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_Visibility                    VisibilityCondition;
    local X2Condition_UnitProperty                  UnitPropertyCondition;

    Template = StandardMelee(DataName, "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_ENEMY_AngryBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_ENEMY_AngryBite_CritBonus");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'X2AbilitySet_PlayableAliens'.static.AbilityTriggerEventListener_Lockjaw;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    AddAdjacencyCondition(Template);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    AddBladestormMark(Template, 'M31_ENEMY_AngryBite_MarkTarget');
    AddSuppressedCondition(Template);

    Template.AddTargetEffect(CreateAngryBiteDamageEffect());

    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');
 
    return Template;
}

static function X2Effect_ApplyWeaponDamage CreateAngryBiteDamageEffect()
{
    local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_AngryBite_Damage");
    PhysicalDamageEffect.bIgnoreBaseDamage = true;

    return PhysicalDamageEffect;
}

static function X2AbilityTemplate PoisonSpit(name DataName, bool bDealsDamage)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_Cylinder     CylinderMultiTarget;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCooldown_LocalAndGlobal  Cooldown;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.AbilitySourceName = 'eAbilitySource_Standard'; 
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    CylinderMultiTarget = new class'X2AbilityMultiTarget_Cylinder';
    CylinderMultiTarget.bUseWeaponRadius = true;
    CylinderMultiTarget.fTargetHeight = class'X2Ability_Viper'.default.POISON_SPIT_CYLINDER_HEIGHT_METERS;
    CylinderMultiTarget.bUseOnlyGroundTiles = true;
    Template.AbilityMultiTargetStyle = CylinderMultiTarget;

    Template.TargetingMethod = class'X2TargetingMethod_ViperSpit';

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    Template.AbilityToHitCalc = default.DeadEye;

    Template.CinescriptCameraType = "_PoisonSpit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = false;
    Template.bUseAmmoAsChargesForHUD = false;

    Template.bCrossClassEligible = false;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
    Template.bFrameEvenWhenUnitIsHidden = true;

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    ActionPointCost.bFreeCost = `GetConfigBool("M31_ENEMY_PoisonSpit_bFreeCost");
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
    Cooldown.iNumTurns = `GetConfigInt("M31_ENEMY_PoisonSpit_Cooldown");
    Cooldown.NumGlobalTurns = `GetConfigInt("M31_ENEMY_PoisonSpit_GlobalCooldown");
    Template.AbilityCooldown = Cooldown;

    Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');

    AddEnhancedPoisonEffectToMultiTarget(Template);
    AddBlindingPoisonEffectToMultiTarget(Template);

    if (bDealsDamage)
    {
        DamageEffect = new class'X2Effect_ApplyWeaponDamage';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_PoisonSpit_Damage");
        DamageEffect.bIgnoreBaseDamage = true;
        Template.AddMultiTargetEffect(DamageEffect);
    }

    Template.CustomFireAnim = 'HL_PoisonSpit';

    return Template;
}

static function AddEnhancedPoisonEffectToTarget(out X2AbilityTemplate Template)
{
    Template.AddTargetEffect(CreateEnhancedPoisonedEffect());
    Template.AddTargetEffect(CreatePoisonedEffect());
    Template.AddTargetEffect(class'M31_AbilityHelpers'.static.CreateNeuroPoisonEffect());
}

static function AddEnhancedPoisonEffectToMultiTarget(out X2AbilityTemplate Template)
{
    Template.AddMultiTargetEffect(CreateEnhancedPoisonedEffect());
    Template.AddMultiTargetEffect(CreatePoisonedEffect());
    Template.AddMultiTargetEffect(class'M31_AbilityHelpers'.static.CreateNeuroPoisonEffect());
}

static function X2Effect_PersistentStatChange CreatePoisonedEffect()
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Effect_ApplyDamageFromHP        DamageEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_ENEMY_ViperPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(
        ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_ENEMY_ViperPoison_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ENEMY_ViperPoison_MobilityPenalty"));
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ENEMY_ViperPoison_AimPenalty"));
    PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.PoisonedVisualization;
    PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationTicked;
    PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationRemoved;
    PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
    PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
    PersistentStatChangeEffect.bCanTickEveryAction = true;
    PersistentStatChangeEffect.EffectAppliedEventName = 'PoisonedEffectAdded';

    if (class'X2StatusEffects'.default.PoisonEnteredParticle_Name != "")
    {
        PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.PoisonEnteredParticle_Name;
        PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.PoisonEnteredSocket_Name;
        PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.PoisonEnteredSocketsArray_Name;
    }
    PersistentStatChangeEffect.PersistentPerkName = class'X2StatusEffects'.default.PoisonEnteredPerk_Name;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropertyCondition);

    DamageEffect = new class'X2Effect_ApplyDamageFromHP';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_ENEMY_ViperPoison_DamagePerTurn");
    DamageEffect.EffectDamageValue.Spread = `GetConfigInt("M31_ENEMY_ViperPoison_DamagePerTurn_Spread");
    DamageEffect.fPrcDmg = `GetConfigFloat("M31_ENEMY_ViperPoison_DamagePerTurn_Prc");
    DamageEffect.fPrcDamage_RulerMultiplier = 0;
    DamageEffect.fPrcDamage_ChosenMultiplier = 0;
    DamageEffect.bCeiling = true;
    DamageEffect.EffectDamageValue.DamageType = 'Poison';

    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS;
    PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    PersistentStatChangeEffect.TargetConditions.AddItem(EffectCondition);

    PersistentStatChangeEffect.EffectRank = 1;

    return PersistentStatChangeEffect;
}

static function X2Effect_PersistentStatChange CreateEnhancedPoisonedEffect()
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Effect_ApplyDamageFromHP        DamageEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_ENEMY_ViperEnhPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(
        ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_ENEMY_ViperEnhPoison_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ENEMY_ViperEnhPoison_MobilityPenalty"));
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ENEMY_ViperEnhPoison_AimPenalty"));
    PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.PoisonedVisualization;
    PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationTicked;
    PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationRemoved;
    PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
    PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
    PersistentStatChangeEffect.bCanTickEveryAction = true;
    PersistentStatChangeEffect.EffectAppliedEventName = 'PoisonedEffectAdded';

    if (class'X2StatusEffects'.default.PoisonEnteredParticle_Name != "")
    {
        PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.PoisonEnteredParticle_Name;
        PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.PoisonEnteredSocket_Name;
        PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.PoisonEnteredSocketsArray_Name;
    }
    PersistentStatChangeEffect.PersistentPerkName = class'X2StatusEffects'.default.PoisonEnteredPerk_Name;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropertyCondition);

    DamageEffect = new class'X2Effect_ApplyDamageFromHP';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_ENEMY_ViperEnhPoison_DamagePerTurn");
    DamageEffect.EffectDamageValue.Spread = `GetConfigInt("M31_ENEMY_ViperEnhPoison_DamagePerTurn_Spread");
    DamageEffect.fPrcDmg = `GetConfigFloat("M31_ENEMY_ViperEnhPoison_DamagePerTurn_Prc");
    DamageEffect.fPrcDamage_RulerMultiplier = 0;
    DamageEffect.fPrcDamage_ChosenMultiplier = 0;
    DamageEffect.bCeiling = true;
    DamageEffect.EffectDamageValue.DamageType = 'Poison';

    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS; // Issue #89
    PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    PersistentStatChangeEffect.TargetConditions.AddItem(EffectCondition);

    PersistentStatChangeEffect.EffectRank = 2;

    return PersistentStatChangeEffect;
}

static function AddBlindingPoisonEffectToTarget(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffectsOnSource   EffectCondition, EffectConditionEnhanced;
    local X2Effect_Blind                    BlindEffect, BlindEffectEnhanced;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_ENEMY_ViperEnhPoison_Duration"));
    BlindEffect.DamageTypes.AddItem('Poison');
    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    BlindEffect.TargetConditions.AddItem(EffectCondition);
    BlindEffect.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddTargetEffect(BlindEffect);

    BlindEffectEnhanced = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_ENEMY_ViperPoison_Duration"));
    BlindEffectEnhanced.DamageTypes.AddItem('Poison');
    EffectConditionEnhanced = new class'X2Condition_UnitEffectsOnSource';
    EffectConditionEnhanced.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectConditionEnhanced.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    BlindEffectEnhanced.TargetConditions.AddItem(EffectConditionEnhanced);
    BlindEffectEnhanced.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddTargetEffect(BlindEffectEnhanced);
}

static function AddBlindingPoisonEffectToMultiTarget(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffectsOnSource   EffectCondition, EffectConditionEnhanced;
    local X2Effect_Blind                    BlindEffect, BlindEffectEnhanced;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_ENEMY_ViperEnhPoison_Duration"));
    BlindEffect.DamageTypes.AddItem('Poison');
    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    BlindEffect.TargetConditions.AddItem(EffectCondition);
    BlindEffect.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddMultiTargetEffect(BlindEffect);

    BlindEffectEnhanced = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_ENEMY_ViperPoison_Duration"));
    BlindEffectEnhanced.DamageTypes.AddItem('Poison');
    EffectConditionEnhanced = new class'X2Condition_UnitEffectsOnSource';
    EffectConditionEnhanced.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectConditionEnhanced.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    BlindEffectEnhanced.TargetConditions.AddItem(EffectConditionEnhanced);
    BlindEffectEnhanced.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddMultiTargetEffect(BlindEffectEnhanced);
}


static function X2AbilityTemplate CoilHunkerPassive(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate Template;

    Template = Passive(DataName, "img:///UILibrary_PerkIcons.UIPerk_takecover", false, true);

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);

    return Template;
}

static function X2AbilityTemplate CoilHunkerDeepCover(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitValue             ValueCondition;

    Template = CoilHunker_Base(DataName);
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    ValueCondition = new class'X2Condition_UnitValue';
    ValueCondition.AddCheckValue('AttacksThisTurn', 0, eCheck_Exact);
    Template.AbilityTargetConditions.AddItem(ValueCondition);

    return Template;
}

static function X2AbilityTemplate AdvancedCoilHunker(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;

    Template = CoilHunker_Base(DataName);
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    return Template;
}

static function X2AbilityTemplate CoilHunkerDamaged(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;

    Template = CoilHunker_Base(DataName);
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 20;
    Template.AbilityTriggers.AddItem(Trigger);

    AddCooldown(Template, 1);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_NotItsOwnTurn');

    return Template;
}

static function X2AbilityTemplate CoilHunker_Base(name DataName)
{
    local X2AbilityTemplate                 Template;
    
    
    local X2Condition_UnitEffects           EffectsCondition;
    local array<name>                       SkipExclusions;
    local X2Effect_CoilHunker               HunkerDownEffect;
    
    Template = SelfTargetTrigger(DataName, "img:///UILibrary_PerkIcons.UIPerk_takecover");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY + 1;

    Template.Hostility = eHostility_Defensive;
    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;
    Template.bSkipFireAction = false;

    EffectsCondition = new class'X2Condition_UnitEffects';
    EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(EffectsCondition);
    
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    HunkerDownEffect = new class'X2Effect_CoilHunker';
    HunkerDownEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
    Template.AddTargetEffect(HunkerDownEffect);

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate ChryssalidMeleeAttack(name DataName)
{
    local X2AbilityTemplate Template;
    local array<name> SkipExclusions;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;

    Template = MovingMelee(DataName, "img:///UILibrary_PerkIcons.UIPerk_chryssalid_slash", false, true);
    
    Template.AbilitySourceName = 'eAbilitySource_Standard';

    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddActionPointCost(Template, eCost_Single);

    Template.CinescriptCameraType = "Chryssalid_PoisonousClaws";
    Template.CustomFireAnim = 'FF_Melee';
    Template.bSkipMoveStop = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;

    return Template;
}
