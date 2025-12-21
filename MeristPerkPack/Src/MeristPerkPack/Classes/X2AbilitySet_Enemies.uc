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

    Templates.AddItem(Lockjaw('M31_ENEMY_Lockjaw', 'M31_ENEMY_Lockjaw_Passive'));
        Templates.AddItem(LockjawPassive('M31_ENEMY_Lockjaw_Passive'));

    Templates.AddItem(AngryBite('M31_ENEMY_AngryBite', 'M31_ENEMY_AngryBite_Passive'));
        Templates.AddItem(AngryBitePassive('M31_ENEMY_AngryBite_Passive'));
        
    Templates.AddItem(PoisonSpit('M31_ENEMY_PoisonSpit', false /* bDealsDamage */));
    Templates.AddItem(PoisonSpit('M31_ENEMY_PoisonSpitWithDamage', true /* bDealsDamage */));

    Templates.AddItem(CoilHunkerPassive('M31_ENEMY_CoilHunker', 'M31_ENEMY_CoilHunker_Trigger'));
        Templates.AddItem(CoilHunkerDeepCover('M31_ENEMY_CoilHunker_Trigger'));
    Templates.AddItem(CoilHunkerPassive('M31_ENEMY_AdvancedCoilHunker', 'M31_ENEMY_AdvancedCoilHunker_Trigger'));
        Templates.AddItem(AdvancedCoilHunker('M31_ENEMY_AdvancedCoilHunker_Trigger'));
    Templates.AddItem(CoilHunkerPassive('M31_ENEMY_CoilHunkerDamaged', 'M31_ENEMY_CoilHunkerDamaged_Trigger'));
        Templates.AddItem(CoilHunkerDamaged('M31_ENEMY_CoilHunkerDamaged_Trigger'));

    Templates.AddItem(ChryssalidMeleeAttack('M31_ENEMY_Claw'));
    Templates.AddItem(ChryssalidMeleeAttack('M31_ENEMY_LightningClaw', true));

    Templates.AddItem(BruhThirst());
    Templates.AddItem(BruhThirstForAll());

    return Templates;
}

static function X2AbilityTemplate Sidewinder(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_Sidewinder    Effect;

    Template = Passive(DataName, "img:///UILibrary_MeristPerkIcons.UIPerk_Sidewinder", false, true);
    
    Effect = new class'X2Effect_PA_Sidewinder';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);

    return Template;
}

static function X2AbilityTemplate SidewinderMove(name DataName, int Cooldown)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local array<name>                       SkipExclusions;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Effect_RunBehaviorTree          BehaviorTreeEffect;
    
    Template = SelfTargetTrigger(DataName, "img:///UILibrary_MeristPerkIcons.UIPerk_Sidewinder");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = class'X2Effect_PA_Sidewinder'.default.EventName;
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

    class'X2Effect_PA_Sidewinder'.static.AddSidewinderCooldown(Template, Cooldown);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate ViperBite(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = MovingMelee(DataName, "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_ENEMY_ViperBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_ENEMY_ViperBite_CritBonus");
    Template.AbilityToHitCalc = ToHitCalc;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    AddCooldown(Template, `GetConfigInt("M31_ENEMY_ViperBite_Cooldown"));
    AddActionPointCost(Template, eCost_DoubleConsumeAll);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_ViperBite_Damage");
    DamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_ENEMY_ViperBite_Rupture");
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);
    AddViperPoisonEffects(Template);

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}


static function X2AbilityTemplate ViperBite2(name DataName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = ViperBite(DataName);

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_ENEMY_ViperBite2_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_ENEMY_ViperBite2_CritBonus");
    Template.AbilityToHitCalc = ToHitCalc;

    AddCooldown(Template, `GetConfigInt("M31_ENEMY_ViperBite2_Cooldown"));

    Template.AbilityTargetEffects.Length = 0;

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_ViperBite2_Damage");
    DamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_ENEMY_ViperBite2_Rupture");
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);
    AddViperPoisonEffects(Template);

    return Template;
}

static function X2AbilityTemplate Lockjaw(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityCooldown_Extended        Cooldown;

    Template = StandardMelee(DataName, "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_ENEMY_Lockjaw_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_ENEMY_Lockjaw_CritBonus");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;

    Template.AbilityTriggers.Length = 0;
    AddOverwatchTriggers(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BladestormConcealment;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 180;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    AddBladestormMark(Template, 'M31_ENEMY_Lockjaw_MarkTarget');

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_ENEMY_Lockjaw_Cooldown");
    Cooldown.bApplyOnlyOnHit = true;
    Template.AbilityCooldown = Cooldown;

    Template.AddTargetEffect(class'X2AbilitySet_PA_Viper'.static.CreateLockjawStunEffect());
    Template.AddTargetEffect(CreateLockjawDamageEffect());
    AddViperPoisonEffects(Template);

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);
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

static function X2AbilityTemplate LockjawPassive(name DataName)
{
    return Passive(DataName, "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, true);
}

static function X2AbilityTemplate AngryBite(name DataName, name AdditionalAbilityName)
{
    local X2AbilityTemplate                         Template;
    local X2AbilityToHitCalc_StandardMelee          ToHitCalc;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_Visibility                    VisibilityCondition;
    local X2Condition_UnitProperty                  UnitPropertyCondition;

    Template = StandardMelee(DataName, "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_ENEMY_AngryBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_ENEMY_AngryBite_CritBonus");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.AbilityTriggers.Length = 0;
    AddOverwatchTriggers(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BladestormConcealment;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 180;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    AddBladestormMark(Template, 'M31_ENEMY_AngryBite_MarkTarget');

    Template.AddTargetEffect(CreateAngryBiteDamageEffect());

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.AdditionalAbilities.AddItem(AdditionalAbilityName);
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

static function X2AbilityTemplate AngryBitePassive(name DataName)
{
    return Passive(DataName, "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, true);
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

    if (bDealsDamage)
    {
        DamageEffect = new class'X2Effect_ApplyWeaponDamage';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_PoisonSpit_Damage");
        DamageEffect.bIgnoreBaseDamage = true;
        DamageEffect.DamageTypes.AddItem('Poison');
        Template.AddMultiTargetEffect(DamageEffect);
    }
    AddViperPoisonEffects(Template);
    Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');

    Template.CustomFireAnim = 'HL_PoisonSpit';

    return Template;
}

static function AddViperPoisonEffects(out X2AbilityTemplate Template)
{
    local X2Effect_PersistentStatChange EnhancedPoisonedEffect;
    local X2Effect_PersistentStatChange PoisonedEffect;
    local X2Effect_Persistent   NeuroPoisonEffect;
    local X2Effect_Persistent   BlindingPoisonEffect;

    EnhancedPoisonedEffect = CreateEnhancedPoisonedEffect();
    PoisonedEffect = CreatePoisonedEffect();
    NeuroPoisonEffect = class'X2AbilitySet_PA_Viper'.static.CreateNeuroPoisonEffect();
    BlindingPoisonEffect = CreateBlindingPoisonEffect();

    if (Template.AbilityTargetEffects.Length > 0)
    {
        Template.AddTargetEffect(EnhancedPoisonedEffect);
        Template.AddTargetEffect(PoisonedEffect);
        Template.AddTargetEffect(NeuroPoisonEffect);
        Template.AddTargetEffect(BlindingPoisonEffect);
    }
    if (Template.AbilityMultiTargetEffects.Length > 0)
    {
        Template.AddMultiTargetEffect(EnhancedPoisonedEffect);
        Template.AddMultiTargetEffect(PoisonedEffect);
        Template.AddMultiTargetEffect(NeuroPoisonEffect);
        Template.AddMultiTargetEffect(BlindingPoisonEffect);
    }
}

static function X2Effect_PersistentStatChange CreatePoisonedEffect()
{
    local X2Effect_PersistentStatChange PoisonedEffect;
    local X2Effect_ApplyScalingDamage   DamageEffect;
    local X2Condition_SoldierAbilities  AbilityCondition;

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();

    PoisonedEffect.BuildPersistentEffect(`GetConfigInt("M31_ENEMY_ViperPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PoisonedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_Poisoned_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");

    PoisonedEffect.m_aStatChanges.Length = 0;
    PoisonedEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ENEMY_ViperPoison_MobilityPenalty"));
    PoisonedEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ENEMY_ViperPoison_AimPenalty"));

    PoisonedEffect.ApplyOnTick.Length = 0;
    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_ViperPoison_Damage");
    DamageEffect.DamageFromHP = `GetConfigFloat("M31_ENEMY_ViperPoison_DamageFromHP");
    DamageEffect.EffectDamageValue.DamageType = 'Poison';
    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS;
    PoisonedEffect.ApplyOnTick.AddItem(DamageEffect);

    AbilityCondition = new class'X2Condition_SoldierAbilities';
    AbilityCondition.ExcludedAbilities.AddItem(class'X2AbilitySet_PA_Viper'.default.EnhancedPoisonAbilityName);
    PoisonedEffect.TargetConditions.AddItem(AbilityCondition);

    PoisonedEffect.EffectRank = 1;

    return PoisonedEffect;
}

static function X2Effect_PersistentStatChange CreateEnhancedPoisonedEffect()
{
    local X2Effect_PersistentStatChange PoisonedEffect;
    local X2Effect_ApplyScalingDamage   DamageEffect;
    local X2Condition_SoldierAbilities  AbilityCondition;

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();

    PoisonedEffect.BuildPersistentEffect(`GetConfigInt("M31_ENEMY_EnhancedPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PoisonedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_Poisoned_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");

    PoisonedEffect.m_aStatChanges.Length = 0;
    PoisonedEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ENEMY_EnhancedPoison_MobilityPenalty"));
    PoisonedEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ENEMY_EnhancedPoison_AimPenalty"));

    PoisonedEffect.ApplyOnTick.Length = 0;
    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_EnhancedPoison_Damage");
    DamageEffect.DamageFromHP = `GetConfigFloat("M31_ENEMY_EnhancedPoison_DamageFromHP");
    DamageEffect.EffectDamageValue.DamageType = 'Poison';
    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS;
    PoisonedEffect.ApplyOnTick.AddItem(DamageEffect);

    AbilityCondition = new class'X2Condition_SoldierAbilities';
    AbilityCondition.RequiredAbilities.AddItem(class'X2AbilitySet_PA_Viper'.default.EnhancedPoisonAbilityName);
    PoisonedEffect.TargetConditions.AddItem(AbilityCondition);

    PoisonedEffect.EffectRank = 2;

    return PoisonedEffect;
}

static function X2Effect_Persistent CreateBlindingPoisonEffect()
{
    local X2Effect_PA_ViperBlind        BlindedEffect;
    local X2Condition_AbilityProperty   AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_BlindingPoison');

    BlindedEffect = class'X2Effect_PA_ViperBlind'.static.CreateViperBlindEffect(
        `GetConfigInt("M31_ENEMY_ViperPoison_Duration"),
        `GetConfigFloat("M31_ENEMY_BlindingPoison_SightMult"),
        `GetConfigInt("M31_ENEMY_BlindingPoison_ApplyChance"));
    BlindedEffect.BonusDuration = `GetConfigInt("M31_ENEMY_EnhancedPoison_Duration") - `GetConfigInt("M31_ENEMY_ViperPoison_Duration");
    BlindedEffect.TargetConditions.AddItem(AbilityCondition);

    return BlindedEffect;
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
    
    
    local X2Condition_UnitEffects   EffectsCondition;
    local array<name>               SkipExclusions;
    local X2Effect_PA_CoilDefense   HunkerDownEffect;
    
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

    HunkerDownEffect =  new class'X2Effect_PA_CoilDefense';
    HunkerDownEffect.DefenseBonus = `GetConfigInt("M31_ENEMY_Coil_DefenseBonus");
    HunkerDownEffect.DodgeBonus = `GetConfigInt("M31_ENEMY_Coil_DodgeBonus");
    HunkerDownEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
    Template.AddTargetEffect(HunkerDownEffect);

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate ChryssalidMeleeAttack(name DataName, optional bool bFixed)
{
    local X2AbilityTemplate Template;
    local array<name> SkipExclusions;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;

    Template = MovingMelee(DataName, "img:///UILibrary_PerkIcons.UIPerk_chryssalid_slash", false, true);
    
    Template.AbilitySourceName = 'eAbilitySource_Standard';

    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    if (bFixed)
    {
        AddActionPointCost(Template, eCost_Single);
    }
    else
    {
        AddActionPointCost(Template, eCost_SingleConsumeAll);
    }
    
    Template.CinescriptCameraType = "Chryssalid_PoisonousClaws";
    Template.CustomFireAnim = 'FF_Melee';
    Template.bSkipMoveStop = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    if (bFixed)
    {
        MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
        MeleeTarget.iFixedRange = 1;
        Template.AbilityTargetStyle = MeleeTarget;
    }

    return Template;
}

static function X2AbilityTemplate BruhThirst()
{
    local X2AbilityTemplate     Template;
    local X2Effect_BruhThirst   Effect;
    
    Template = Passive('M31_ENEMY_BruhThirst', "img:///UILibrary_PerkIcons.UIPerk_adventmec_minigun", false, true);

    Effect = new class'X2Effect_BruhThirst';
    Effect.DamagePerStack = `GetConfigInt("M31_ENEMY_BruhThirst_DamagePerStack");
    Effect.MaxStacks = `GetConfigInt("M31_ENEMY_BruhThirst_MaxStacks");
    Effect.MaxStacksPerTurn = `GetConfigInt("M31_ENEMY_BruhThirst_MaxStacks");
    Effect.StackDuration = 1;
    Effect.bRefreshDuration = false;
    Effect.bMatchSourceWeapon = true;
    Effect.bIncreaseOnlyOnHit = false;
    Effect.bIncreaseOnlyOnMiss = `GetConfigBool("M31_ENEMY_BruhThirst_bIncreaseOnlyOnMiss");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate BruhThirstForAll()
{
    return Passive('M31_ENEMY_BruhThirstForAll', "img:///UILibrary_PerkIcons.UIPerk_muton_punch", false, true);
}