class X2AbilitySet_WinterSentinel extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name HeavyOrdnanceAbilityName;
var privatewrite name BallistaPassiveAbilityName;
var privatewrite name BoltToHitBonusAbilityName;

var privatewrite name LeadTheTargetRequiredAbilityName;
var privatewrite name LeadTheTargetReserveActionName;

var privatewrite name BoltMaelstromName;
var privatewrite string BoltMaelstromIcon;

var privatewrite name BoltFrostName;
var privatewrite string BoltFrostIcon;

var privatewrite name BoltShredName;
var privatewrite string BoltShredIcon;

var privatewrite name BoltRuptureName;
var privatewrite string BoltRuptureIcon;

var privatewrite name BoltStunName;
var privatewrite string BoltStunIcon;

var privatewrite name BoltCritName;
var privatewrite string BoltCritIcon;

var privatewrite name BoltFireName;
var privatewrite string BoltFireIcon;

var privatewrite name BoltPsiName;
var privatewrite string BoltPsiIcon;

var privatewrite name BoltPoisonName;
var privatewrite string BoltPoisonIcon;

var privatewrite name BoltRadName;
var privatewrite string BoltRadIcon;


var config array<name> Ballista_Categories;
var config array<name> FrostGrenades;
var config array<name> Thrill_ExcludeCharacterTemplates;
var config array<name> Thrill_ExcludeCharacterGroups;

var config bool bNorthernWinds_AllowWhileConcealed;
var config bool bNorthernWinds_AllowWhileBurning;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Hide());
    Templates.AddItem(Entwine());
    Templates.AddItem(ReinforcedScales());
    Templates.AddItem(GlacialArmor());
        Templates.AddItem(GlacialArmorUpdate());
    Templates.AddItem(Dominance());
    Templates.AddItem(Indomitable());
    Templates.AddItem(RagingSerpent());

    Templates.AddItem(Vigilance());
    Templates.AddItem(Fracture());
    Templates.AddItem(AlloyedTCores());
    Templates.AddItem(HeavyOrdnance());
    Templates.AddItem(DragonSlayer());

    Templates.AddItem(WinterWarfare());
    Templates.AddItem(WinterSoldier());
    Templates.AddItem(ChillingMist());
        Templates.AddItem(ChillingMistAttack());
    Templates.AddItem(StupidSexySnake());
    Templates.AddItem(RebelYell());
    Templates.AddItem(NorthernWinds());
        Templates.AddItem(NorthernWindsTrigger());
    Templates.AddItem(MetabolicBoost());
    Templates.AddItem(ThrillOfTheHunt());
        Templates.AddItem(ThrillOfTheHuntUpdate());

    Templates.AddItem(BallistaPassive());
    Templates.AddItem(BoltToHitBonus());

    Templates.AddItem(BoltMaelstrom());
        Templates.AddItem(BoltMaelstromAddLTT());
        Templates.AddItem(BoltMaelstromLTT());
        Templates.AddItem(BoltMaelstromLTTAttack());

    Templates.AddItem(BoltFrost());
        Templates.AddItem(BoltFrostAddLTT());
        Templates.AddItem(BoltFrostLTT());
        Templates.AddItem(BoltFrostLTTAttack());

    Templates.AddItem(BoltShred());
        Templates.AddItem(BoltShredAddLTT());
        Templates.AddItem(BoltShredLTT());
        Templates.AddItem(BoltShredLTTAttack());

    Templates.AddItem(BoltRupture());
        Templates.AddItem(BoltRuptureAddLTT());
        Templates.AddItem(BoltRuptureLTT());
        Templates.AddItem(BoltRuptureLTTAttack());

    Templates.AddItem(BoltStun());
        Templates.AddItem(BoltStunAddLTT());
        Templates.AddItem(BoltStunLTT());
        Templates.AddItem(BoltStunLTTAttack());
    
    Templates.AddItem(BoltCrit());
        Templates.AddItem(BoltCritAddLTT());
        Templates.AddItem(BoltCritLTT());
        Templates.AddItem(BoltCritLTTAttack());

    Templates.AddItem(BoltFire());
        Templates.AddItem(BoltFireAddLTT());
        Templates.AddItem(BoltFireLTT());
        Templates.AddItem(BoltFireLTTAttack());

    Templates.AddItem(BoltPsi());
        Templates.AddItem(BoltPsiAddLTT());
        Templates.AddItem(BoltPsiLTT());
        Templates.AddItem(BoltPsiLTTAttack());

    Templates.AddItem(BoltPoison());
        Templates.AddItem(BoltPoisonAddLTT());
        Templates.AddItem(BoltPoisonLTT());
        Templates.AddItem(BoltPoisonLTTAttack());

    Templates.AddItem(BoltRad());
        Templates.AddItem(BoltRadAddLTT());
        Templates.AddItem(BoltRadLTT());
        Templates.AddItem(BoltRadLTTAttack());
    return Templates;
}

static function X2AbilityTemplate Hide()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WS_Hide          Effect;
    local X2Effect_GreaterPadding   GreaterPaddingEffect;

    Template = Passive('M31_PA_WS_Hide', "img:///UILibrary_LW_PerkPack.LW_AbilityIronSkin", false, true);

    Effect = new class'X2Effect_WS_Hide';
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    GreaterPaddingEffect = new class 'X2Effect_GreaterPadding';
    GreaterPaddingEffect.BuildPersistentEffect(1, true, false);
    GreaterPaddingEffect.Padding_HealHP = `GetConfigInt("M31_PA_WS_Hide_PaddingHP");
    Template.AddTargetEffect(GreaterPaddingEffect);

    return Template;
}

static function X2AbilityTemplate Entwine()
{
    local X2AbilityTemplate     Template;
    local X2Effect_WS_Entwine   Effect;

    Template = Passive('M31_PA_WS_Entwine', "img:///UILibrary_MZChimeraIcons.Ability_TightSqueeze", false, true);

    Effect = new class'X2Effect_WS_Entwine';
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ReinforcedScales()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ReinforcedScales      Effect;

    Template = Passive('M31_PA_WS_ReinforcedScales', "img:///UILibrary_MZChimeraIcons.Ability_ReinforcedScales", false, true);
    
    Effect = new class'X2Effect_WS_ReinforcedScales';
    Effect.EffectName = 'M31_PA_WS_ReinforcedScales';
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate GlacialArmor()
{
    local X2AbilityTemplate             Template;
    local X2Effect_WS_GlacialArmor      Effect;

    Template = Passive('M31_PA_WS_GlacialArmor', "img:///UILibrary_MZChimeraIcons.Ability_KineticArmor", false, true);

    Effect = new class'X2Effect_WS_GlacialArmor';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_PA_WS_GlacialArmor_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_GlacialArmor_Update');

    return Template;
}

static function X2AbilityTemplate GlacialArmorUpdate()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        EventListener;
    local X2Effect_IncrementUnitValue           UnitValueEffect;

    Template = SelfTargetTrigger('M31_PA_WS_GlacialArmor_Update', "img:///UILibrary_MZChimeraIcons.Ability_KineticArmor");

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    // EventListener.ListenerData.Priority = 50;
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    UnitValueEffect = new class'X2Effect_IncrementUnitValue';
    UnitValueEffect.UnitName = class'X2Effect_WS_GlacialArmor'.default.UnitValueName;
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(UnitValueEffect);

    Return Template;
}

static function X2AbilityTemplate Dominance()
{
    local X2AbilityTemplate             Template;

    Template = Passive('M31_PA_WS_Dominance', "img:///UILibrary_MZChimeraIcons.Ability_KineticArmor", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_Dominance_Trigger');

    return Template;
}

static function X2AbilityTemplate DominanceTrigger()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SkipExclusions;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_SkirmisherInterrupt      InterruptEffect;

    Template = SelfTargetTrigger('M31_PA_WS_Dominance_Trigger', "img:///UILibrary_MZChimeraIcons.Ability_KineticArmor");

    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    AddCooldown(Template, 1);

    if (`GetConfigBool("M31_PA_WS_Dominance_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_WS_Dominance_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 60;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeStunned = true;
    UnitPropertyCondition.ExcludePanicked = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    InterruptEffect = new class'X2Effect_SkirmisherInterrupt';
    InterruptEffect.BuildPersistentEffect(1, false, , , eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(InterruptEffect);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    // Template.BuildInterruptGameStateFn = 

    return Template;
}

static function X2AbilityTemplate Indomitable()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_Indomitable           Effect;

    Template = Passive('M31_PA_WS_Indomitable', "img:///KetarosPkg_Abilities.UIPerk_ShieldWings", false, true);
    
    Effect = new class'X2Effect_WS_Indomitable';
    Effect.AddPersistentStatChange(eStat_HP, float(`GetConfigInt("M31_PA_WS_Indomitable_HPBonus")));
    Effect.AddPersistentStatChange(eStat_Mobility, float(`GetConfigInt("M31_PA_WS_Indomitable_MobilityBonus")));
    Effect.AddPersistentStatChange(eStat_Dodge, float(`GetConfigInt("M31_PA_WS_Indomitable_DodgeBonus")));
    Effect.AddPersistentStatChange(eStat_Will, float(`GetConfigInt("M31_PA_WS_Indomitable_WillBonus")));
    Effect.AddPersistentStatChange(eStat_Defense, float(`GetConfigInt("M31_PA_WS_Indomitable_DefenseBonus")));
    Effect.AddPersistentStatChange(eStat_ArmorMitigation, float(`GetConfigInt("M31_PA_WS_Indomitable_ArmorBonus")), MODOP_Addition);
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate RagingSerpent()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee       MeleeTarget;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_WS_RagingSerpent');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_SOCombatEngineer.UIPerk_bullrush";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    Template.bCrossClassEligible = false;

    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PA_WS_RagingSerpent_Cooldown"));

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_WS_RagingSerpent_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_WS_RagingSerpent_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee';
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeLargeUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropCondition);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    
    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_RagingSerpent_StunDuration"), 100, false));

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_WS_RagingSerpent_Damage");
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.bSkipMoveStop = true;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bOverrideMeleeDeath = false;

    Template.CustomFireAnim = 'HL_ViciousBite';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate Vigilance()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PersistentStatChange     Effect;
    Template = Passive('M31_PA_WS_Vigilance', "", false, true);
    
    Effect = new class'X2Effect_PersistentStatChange';
    Effect.BuildPersistentEffect(1, true);
    Effect.AddPersistentStatChange(eStat_SightRadius, `TILESTOMETERS(`GetConfigInt("M31_PA_WS_Vigilance_SightRangeBonus")));

    return Template;
}

static function X2AbilityTemplate Fracture()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_Fracture              Effect;

    Template = Passive('M31_PA_WS_Fracture', "img:///UILibrary_SOCombatEngineer.UIPerk_fracture", false, true);
    
    Effect = new class'X2Effect_WS_Fracture';
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate AlloyedTCores()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_AlloyedCores              Effect;

    Template = Passive('M31_PA_WS_AlloyedCores', "img:///UILibrary_SOCombatEngineer.UIPerk_fracture", false, true);
    
    Effect = new class'X2Effect_WS_AlloyedCores';
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate HeavyOrdnance()
{
    local X2AbilityTemplate Template;

    Template = Passive(default.HeavyOrdnanceAbilityName, "img:///UILibrary_MZChimeraIcons.Ability_ShrapnelGrenade", false, true);
    
    return Template;
}

static function X2AbilityTemplate DragonSlayer()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_DragonSlayer          Effect;

    Template = Passive('M31_PA_WS_DragonSlayer', "img:///KetarosPkg_Abilities.UIPerk_diablo", false, false);

    Effect = new class'X2Effect_WS_DragonSlayer';
    Effect.BuildPersistentEffect(1, true);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddShooterEffect(Effect);

    return Template;
}

static function X2AbilityTemplate WinterWarfare()
{
    local X2AbilityTemplate                 Template;
    local XMBEffect_DoNotConsumeAllPoints   CostEffect;
    local XMBEffect_AddItemCharges          BonusItemEffect;
    local XMBEffect_BonusRadius             RadiusEffect;
    local XMBCondition_WeaponName           Condition;

    Template = Passive('M31_PA_WS_WinterWarfare', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);
    
    CostEffect = new class'XMBEffect_DoNotConsumeAllPoints';
    CostEffect.AbilityNames = class'X2DLCInfo_MeristPerkPack'.default.GrenadeAbilities;
    Condition = new class'XMBCondition_WeaponName';
    Condition.IncludeWeaponNames = default.FrostGrenades;
    Condition.bCheckAmmo = true;
    CostEffect.AbilityTargetConditions.AddItem(Condition);
    CostEffect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(CostEffect);

    BonusItemEffect = new class'XMBEffect_AddItemCharges';
    BonusItemEffect.PerItemBonus = `GetConfigInt("M31_PA_WS_WinterWarfare_ChargeBonus");
    BonusItemEffect.ApplyToNames = default.FrostGrenades;
    Template.AddTargetEffect(BonusItemEffect);

    RadiusEffect = new class'XMBEffect_BonusRadius';
    RadiusEffect.EffectName = 'M31_PA_WS_WinterWarfare_Radius';
    RadiusEffect.fBonusRadius = `GetConfigInt("M31_PA_WS_WinterWarfare_RadiusBonus");
    RadiusEffect.IncludeItemNames = default.FrostGrenades;
    RadiusEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(RadiusEffect);

    return Template;
}

static function X2AbilityTemplate WinterSoldier()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_AddGrenade               Effect;

    Template = Passive('M31_PA_WS_WinterSoldier', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);
        
    Effect = new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = true;
    Effect.DataName = 'Frostbomb';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ChillingMist()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_PA_WS_ChillingMist', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);
        
    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_PA_WS_ChillingMist';
    PassiveWeaponEffect.AttackName = 'M31_PA_WS_ChillingMist_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_ChillingMist_Attack');

    return Template;
}

static function X2AbilityTemplate ChillingMistAttack()
{
    local X2AbilityTemplate                 Template;

    Template = class'M31_AbilityHelpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_PA_WS_ChillingMist_Attack',
        "img:///UILibrary_DLC2Images.UIPerk_freezingbreath",
        GetChillingMistHypothermiaEffect()
    );

    return Template;
}

static function MZ_Effect_Hypothermia GetChillingMistHypothermiaEffect(optional bool bAddAbilityCondition = false)
{
    return class'MZ_Effect_Hypothermia'.static.CreateHypothermiaEffect(`GetConfigInt("M31_PA_WS_ChillingMist_Duration"));
}

static function X2AbilityTemplate StupidSexySnake()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PersistentStatChange     Effect;

    Template = Passive('M31_PA_WS_StupidSexySnake', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);
        
    Effect = new class'X2Effect_PersistentStatChange';

    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_StupidSexySnake');

    return Template;
}

static function X2AbilityTemplate RebelYell()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              MultiTargetProperty;
    local X2Effect_WS_RebelYell                 Effect;

    Template = SelfTargetActivated('M31_PA_WS_RebelYell', "img:///KetarosPkg_Abilities.UIPerk_ShieldWings");
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
    
    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_PA_WS_RebelYell_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    MultiTargetProperty = new class'X2Condition_UnitProperty';
    MultiTargetProperty.ExcludeAlive = false;
    MultiTargetProperty.ExcludeDead = true;
    MultiTargetProperty.ExcludeHostileToSource = true;
    MultiTargetProperty.ExcludeFriendlyToSource = false;
    MultiTargetProperty.RequireSquadmates = true;
    MultiTargetProperty.ExcludePanicked = true;
    MultiTargetProperty.ExcludeRobotic = true;
    MultiTargetProperty.ExcludeStunned = true;

    Effect = new class'X2Effect_WS_RebelYell';
    Effect.EffectName = 'M31_PA_WS_RebelYell';

    Effect.AddPersistentStatChange(eStat_Offense, float(`GetConfigInt("M31_PA_WS_RebelYell_AimBonus_Alt")), true);
    Effect.AddPersistentStatChange(eStat_Mobility, float(`GetConfigInt("M31_PA_WS_RebelYell_MobilityBonus_Alt")), true);
    Effect.AddPersistentStatChange(eStat_Dodge, float(`GetConfigInt("M31_PA_WS_RebelYell_DodgeBonus_Alt")), true);
    Effect.AddPersistentStatChange(eStat_Will, float(`GetConfigInt("M31_PA_WS_RebelYell_WillBonus_Alt")), true);
    Effect.AddPersistentStatChange(eStat_Defense, float(`GetConfigInt("M31_PA_WS_RebelYell_DefenseBonus_Alt")), true);

    Effect.AddPersistentStatChange(eStat_Offense, float(`GetConfigInt("M31_PA_WS_RebelYell_AimBonus")));
    Effect.AddPersistentStatChange(eStat_Mobility, float(`GetConfigInt("M31_PA_WS_RebelYell_MobilityBonus")));
    Effect.AddPersistentStatChange(eStat_Dodge, float(`GetConfigInt("M31_PA_WS_RebelYell_DodgeBonus")));
    Effect.AddPersistentStatChange(eStat_Will, float(`GetConfigInt("M31_PA_WS_RebelYell_WillBonus")));
    Effect.AddPersistentStatChange(eStat_Defense, float(`GetConfigInt("M31_PA_WS_RebelYell_DefenseBonus")));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_RebelYell_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(Effect);
    
    AddCooldown(Template, `GetConfigInt("M31_PA_WS_RebelYell_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_WS_RebelYell_Charges"));

    Template.AddShooterEffectExclusions();

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    // Template.bSkipFireAction = false;
    // Template.CustomFireAnim = "";

    Template.bSkipFireAction = true;
    Template.bShowActivation = true;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = RebelYell_BuildVisualization;

    return Template;
}

function RebelYell_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      context;
    local StateObjectReference              InteractingUnitRef;
    local VisualizationActionMetadata       EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation            PlayAnimationAction;
    local X2Action_PlaySoundAndFlyOver      SoundAndFlyover, SoundAndFlyoverTarget;
    local XComGameState_Ability             Ability;
    local XComGameState_Effect              EffectState;
    local XComGameState_Unit                UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Alien);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'M31_HL_EscapeA';
    PlayAnimationAction.bFinishAnimationWait = true;

    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        if (EffectState.GetX2Effect().EffectName == class'X2Effect_WS_RebelYell'.default.EffectName)
        {
                TargetTrack = EmptyTrack;
                UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
                if ((UnitState != none) && (EffectState.StatChanges.Length > 0))
                {
                    TargetTrack.StateObject_NewState = UnitState;
                    TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
                    TargetTrack.VisualizeActor = UnitState.GetVisualizer();
                    SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
                    SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Alien);
                }
        }
    }

}

static function X2AbilityTemplate MetabolicBoost()
{
    local X2AbilityTemplate                     Template;
    local array<name>                           SkipExclusions;
    local X2Effect_ToHitModifier                DodgeEffect;
    local X2Effect_RemoveEffectsByDamageType    RemoveEffects;
    local X2Effect_ApplyHeal                    HealingEffect;
    
    Template = SelfTargetActivated('M31_PA_WS_MetabolicBoost', "img:///UILibrary_MZChimeraIcons.Ability_Resilience");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    DodgeEffect = new class'X2Effect_ToHitModifier';
    DodgeEffect.AddEffectHitModifier(eHit_Graze, `GetConfigInt("M31_PA_WS_MetabolicBoost_DodgeBonus"), Template.LocFriendlyName);
    DodgeEffect.AddEffectHitModifier(eHit_Success, `GetConfigInt("M31_PA_WS_MetabolicBoost_DefenseBonus"), Template.LocFriendlyName);
    DodgeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    DodgeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(DodgeEffect);
    
    RemoveEffects = class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType();
    RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddTargetEffect(RemoveEffects);

    HealingEffect = new class'X2Effect_ApplyHeal';
    HealingEffect.HealAmount = `GetConfigInt("M31_PA_WS_MetabolicBoost_Heal");
    HealingEffect.MaxHealAmount = `GetConfigInt("M31_PA_WS_MetabolicBoost_MaxHeal");
    HealingEffect.HealthRegeneratedName = 'M31_PA_WS_MetabolicBoost_HealingCounter';
    Template.AddTargetEffect(HealingEffect);

    AddCooldown(Template, `GetConfigInt("M31_PA_WS_MetabolicBoost_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_WS_MetabolicBoost_Charges"));

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    Template.Hostility = eHostility_Defensive;

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;

    return Template;
}

static function X2AbilityTemplate ThrillOfTheHunt()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_Thrill                Effect;
    local X2Effect_TurnStartActionPoints    ActionPointEffect;

    Template = Passive('M31_PA_WS_ThrillOfTheHunt', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);
        
    Effect = new class'X2Effect_WS_Thrill';
    Effect.BuildPersistentEffect(1, true, true);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    ActionPointEffect = new class'X2Effect_TurnStartActionPoints';
    ActionPointEffect.ActionPointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.BuildPersistentEffect(1, true, true);
    Template.AddTargetEffect(ActionPointEffect);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_ThrillOfTheHunt_Update');

    return Template;
}

static function X2AbilityTemplate ThrillOfTheHuntUpdate()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        EventListener;
    local X2Effect_IncrementUnitValue           UnitValueEffect;

    Template = SelfTargetTrigger('M31_PA_WS_ThrillOfTheHunt_Update', "img:///UILibrary_MZChimeraIcons.Ability_KineticArmor");

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.EventID = 'UnitDied';
    EventListener.ListenerData.EventFn = AbilityTriggerEventListener_ThrillOfTheHunt;
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    // EventListener.ListenerData.Priority = 50;
    EventListener.ListenerData.Filter = eFilter_None;
    Template.AbilityTriggers.AddItem(EventListener);

    UnitValueEffect = new class'X2Effect_IncrementUnitValue';
    UnitValueEffect.UnitName = class'X2Effect_WS_Thrill'.default.UnitValueName;
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddTargetEffect(UnitValueEffect);

    Template.bShowActivation = true;

    Return Template;
}

function EventListenerReturn AbilityTriggerEventListener_ThrillOfTheHunt(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability             AbilityState;
    local XComGameState_Unit                SourceUnit, TargetUnit;
    local GameRulesCache_VisibilityInfo     VisInfo;

    AbilityState = XComGameState_Ability(CallbackData);
    SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    TargetUnit = XComGameState_Unit(EventData);
    
    if (SourceUnit.IsEnemyUnit(TargetUnit)
        && default.Thrill_ExcludeCharacterGroups.Find(TargetUnit.GetMyTemplate().CharacterGroupName) == INDEX_NONE
        && default.Thrill_ExcludeCharacterTemplates.Find(TargetUnit.GetMyTemplateName()) == INDEX_NONE
        && `TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
    {
        return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
    }

    return ELR_NoInterrupt;
}


static function X2AbilityTemplate NorthernWinds()
{
    local X2AbilityTemplate     Template;

    Template = Passive('M31_PA_WS_NorthernWinds', "img:///KetarosPkg_Abilities.UIPerk_punisher", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_NorthernWinds_Trigger');

    return Template;
}

static function X2AbilityTemplate NorthernWindsTrigger()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        EventListener;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local array<name>                           SkipExclusions;
    local X2Condition_UnitProperty              UnitPropertyCondition;

    Template = SelfTargetTrigger('M31_PA_WS_NorthernWinds_Trigger', "img:///KetarosPkg_Abilities.UIPerk_punisher");

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.EventID = 'PlayerTurnEnded';
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    // EventListener.ListenerData.Priority = 50;
    EventListener.ListenerData.Filter = eFilter_Player;
    Template.AbilityTriggers.AddItem(EventListener);

    Template.AbilityShooterConditions.Length = 0;
    UnitPropertyCondition = default.LivingShooterProperty;
    UnitPropertyCondition.ExcludeConcealed = !`GetConfigBool("M31_PA_WS_NorthernWinds_bAllowWhileConcealed");
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_WS_NorthernWinds_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_PA_WS_NorthernWinds_Radius"));
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    if (`GetConfigBool("M31_PA_WS_NorthernWinds_bRequireVisibility"))
        Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);

    Template.AddMultiTargetEffect(new class'X2Effect_RevealSourceUnit');
    
    Template.AddMultiTargetEffect(GetNorthernWindsDamageEffect());

    class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

    Template.bSkipFireAction = false;
    // Template.CustomFireAnim = "noanim";

    return Template;
}

static function X2Effect_ApplyDamageWithRank GetNorthernWindsDamageEffect()
{
    local X2Effect_ApplyDamageWithRank DamageEffect;

    DamageEffect = new class'X2Effect_ApplyDamageWithRank';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_WS_NorthernWinds_Damage");
    DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_WS_NorthernWinds_DamagePerRank");
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.EffectDamageValue.DamageType = 'Frost';
    DamageEffect.DamageTypes.AddItem('Frost');

    return DamageEffect;
}

static function X2AbilityTemplate BallistaPassive()
{
    local X2AbilityTemplate         Template;

    Template = Passive(default.BallistaPassiveAbilityName, "", false, false);

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    return Template;
}

static function X2AbilityTemplate BoltToHitBonus()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_BoltToHitBonus        Effect;

    Template = Passive(default.BoltToHitBonusAbilityName, "", false, false);

    Effect = new class'X2Effect_WS_BoltToHitBonus';
    Effect.BuildPersistentEffect(1, true, false);

    Effect.AddToHitBonus(default.BoltCritName, 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus"));
    Effect.AddToHitBonus(default.BoltCritName, 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus_Ballista", true));
    Effect.AddToHitBonus(GetLLTAttackName(default.BoltCritName), 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus"));
    Effect.AddToHitBonus(GetLLTAttackName(default.BoltCritName), 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus_Ballista", true));

    Effect.AddToHitBonus(default.BoltRuptureName, 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus"));
    Effect.AddToHitBonus(default.BoltRuptureName, 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus_Ballista", true));
    Effect.AddToHitBonus(GetLLTAttackName(default.BoltRuptureName), 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus"));
    Effect.AddToHitBonus(GetLLTAttackName(default.BoltRuptureName), 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus_Ballista", true));

    Template.AddTargetEffect(Effect);

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    return Template;
}

static function X2AbilityTemplate BoltMaelstrom()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;

    Template = BoltAttack(default.BoltMaelstromName, default.BoltMaelstromIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bMaelstromBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltMaelstromAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltMaelstromName, default.BoltMaelstromIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltMaelstromLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltMaelstromName, default.BoltMaelstromIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltMaelstromLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;

    Template = BoltLeadTheTargetAttack(default.BoltMaelstromName, default.BoltMaelstromIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bMaelstromBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    return Template;
}

static function X2AbilityTemplate BoltFrost()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack(default.BoltFrostName, default.BoltFrostIcon);

    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltFrostName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeEffect(false));
    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeCleanse(false));

    return Template;
}

static function X2AbilityTemplate BoltFrostAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltFrostName, default.BoltFrostIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltFrostLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltFrostName, default.BoltFrostIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltFrostLTTAttack()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTargetAttack(default.BoltFrostName, default.BoltFrostIcon);
    
    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltFrostName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeEffect(false));
    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeCleanse(false));

    return Template;
}

static function X2AbilityTemplate BoltShred()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;
    local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;

    Template = BoltAttack(default.BoltShredName, default.BoltShredIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bShredBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
    WorldDamage.bUseWeaponDamageType = true;
    WorldDamage.bUseWeaponEnvironmentalDamage = false;
    WorldDamage.EnvironmentalDamageAmount = 100;
    WorldDamage.bApplyOnHit = false;
    WorldDamage.bApplyOnMiss = false;
    WorldDamage.bApplyToWorldOnHit = true;
    WorldDamage.bApplyToWorldOnMiss = true;
    WorldDamage.bHitAdjacentDestructibles = true;
    WorldDamage.PlusNumZTiles = 1;
    WorldDamage.bHitTargetTile = true;
    WorldDamage.bAllowDestructionOfDamageCauseCover = true;
    Template.AddTargetEffect(WorldDamage);

    return Template;
}

static function X2AbilityTemplate BoltShredAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltShredName, default.BoltShredIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltShredLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltShredName, default.BoltShredIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltShredLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;
    local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;

    Template = BoltLeadTheTargetAttack(default.BoltShredName, default.BoltShredIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bShredBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
    WorldDamage.bUseWeaponDamageType = true;
    WorldDamage.bUseWeaponEnvironmentalDamage = false;
    WorldDamage.EnvironmentalDamageAmount = 100;
    WorldDamage.bApplyOnHit = false;
    WorldDamage.bApplyOnMiss = false;
    WorldDamage.bApplyToWorldOnHit = true;
    WorldDamage.bApplyToWorldOnMiss = true;
    WorldDamage.bHitAdjacentDestructibles = true;
    WorldDamage.PlusNumZTiles = 1;
    WorldDamage.bHitTargetTile = true;
    WorldDamage.bAllowDestructionOfDamageCauseCover = true;
    Template.AddTargetEffect(WorldDamage);
    
    return Template;
}

static function X2AbilityTemplate BoltRupture()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;

    Template = BoltAttack(default.BoltRuptureName, default.BoltRuptureIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bRuptureBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltRuptureAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltRuptureName, default.BoltRuptureIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltRuptureLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltRuptureName, default.BoltRuptureIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltRuptureLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;

    Template = BoltLeadTheTargetAttack(default.BoltRuptureName, default.BoltRuptureIcon);
 
    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bRuptureBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    return Template;
}

static function X2AbilityTemplate BoltStun()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Persistent               StunnedEffect;
    local X2Effect_PersistentStatChange     CrippleEffect;
    local X2Effect_Persistent               BleedingEffect;

    Template = BoltAttack(default.BoltStunName, default.BoltStunIcon);


    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), false, false, true, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_AbilityHelpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage"));
    BleedingEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);


    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration_Ballista"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty_Ballista"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), false, false, true, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_AbilityHelpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage_Ballista"));
    BleedingEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);

    return Template;
}

static function X2AbilityTemplate BoltStunAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltStunName, default.BoltStunIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltStunLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltStunName, default.BoltStunIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltStunLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Persistent               StunnedEffect;
    local X2Effect_PersistentStatChange     CrippleEffect;
    local X2Effect_Persistent               BleedingEffect;

    Template = BoltLeadTheTargetAttack(default.BoltStunName, default.BoltStunIcon);
    

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), false, false, true, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_AbilityHelpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage"));
    BleedingEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);


    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration_Ballista"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty_Ballista"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), false, false, true, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_AbilityHelpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage_Ballista"));
    BleedingEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);

    return Template;
}

static function X2AbilityTemplate BoltCrit()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;

    Template = BoltAttack(default.BoltCritName, default.BoltCritIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bCritBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltCritAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltCritName, default.BoltCritIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltCritLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltCritName, default.BoltCritIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltCritLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;

    Template = BoltLeadTheTargetAttack(default.BoltCritName, default.BoltCritIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bCritBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    return Template;
}

static function X2AbilityTemplate BoltFire()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Effect_Burning                  BurningEffect;
    local X2Effect_ApplyFireToWorld         WorldEffect;

    Template = BoltAttack(default.BoltFireName, default.BoltFireIcon);
    
    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltFireName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltFireName;
    DamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(DamageEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance");
    BurningEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddMultiTargetEffect(BurningEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread_Ballista"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance_Ballista");
    BurningEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddMultiTargetEffect(BurningEffect);

    WorldEffect = new class'X2Effect_ApplyFireToWorld';
    WorldEffect.bApplyOnMiss = false;
    WorldEffect.bApplyToWorldOnMiss = false;
    WorldEffect.bApplyOnHit = true;
    WorldEffect.bApplyToWorldOnHit = true;
    Template.AddMultiTargetEffect(WorldEffect);

    return Template;
}

static function X2AbilityTemplate BoltFireAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltFireName, default.BoltFireIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltFireLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltFireName, default.BoltFireIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltFireLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Effect_Burning                  BurningEffect;
    local X2Effect_ApplyFireToWorld         WorldEffect;

    Template = BoltLeadTheTargetAttack(default.BoltFireName, default.BoltFireIcon);

    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltFireName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltFireName;
    DamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(DamageEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance");
    BurningEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddMultiTargetEffect(BurningEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread_Ballista"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance_Ballista");
    BurningEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddMultiTargetEffect(BurningEffect);

    WorldEffect = new class'X2Effect_ApplyFireToWorld';
    WorldEffect.bApplyOnMiss = false;
    WorldEffect.bApplyToWorldOnMiss = false;
    WorldEffect.bApplyOnHit = true;
    WorldEffect.bApplyToWorldOnHit = true;
    Template.AddMultiTargetEffect(WorldEffect);

    return Template;
}

static function X2AbilityTemplate BoltPsi()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = BoltAttack(default.BoltPsiName, default.BoltPsiIcon);

    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltPsiName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPsiName;
    DamageEffect.bExplosiveDamage = true;
    DamageEffect.EnvironmentalDamageAmount = `GetConfigInt("M31_PA_WS_Bolt_Psi_EnvDamage");
    Template.AddMultiTargetEffect(DamageEffect);

    return Template;
}

static function X2AbilityTemplate BoltPsiAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltPsiName, default.BoltPsiIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltPsiLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltPsiName, default.BoltPsiIcon);

    return Template;
}

static function X2AbilityTemplate BoltPsiLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = BoltLeadTheTargetAttack(default.BoltPsiName, default.BoltPsiIcon);
    
    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltPsiName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPsiName;
    DamageEffect.bExplosiveDamage = true;
    DamageEffect.EnvironmentalDamageAmount = `GetConfigInt("M31_PA_WS_Bolt_Psi_EnvDamage");
    Template.AddMultiTargetEffect(DamageEffect);

    return Template;
}

static function X2AbilityTemplate BoltPoison()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Persistent               DisorientedEffect;

    Template = BoltAttack(default.BoltPoisonName, default.BoltPoisonIcon);

    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltPoisonName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPoisonName;
    Template.AddMultiTargetEffect(DamageEffect);

    Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
    Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddMultiTargetEffect(DisorientedEffect);

    return Template;
}

static function X2AbilityTemplate BoltPoisonAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltPoisonName, default.BoltPoisonIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltPoisonLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltPoisonName, default.BoltPoisonIcon);

    return Template;
}

static function X2AbilityTemplate BoltPoisonLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Persistent               DisorientedEffect;

    Template = BoltLeadTheTargetAttack(default.BoltPoisonName, default.BoltPoisonIcon);
    
    Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltPoisonName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPoisonName;
    Template.AddMultiTargetEffect(DamageEffect);

    Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());
    Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddMultiTargetEffect(DisorientedEffect);

    return Template;
}

static function X2AbilityTemplate BoltRad()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack(default.BoltRadName, default.BoltRadIcon);

    return Template;
}

static function X2AbilityTemplate BoltRadAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(default.BoltRadName, default.BoltRadIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltRadLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTarget(default.BoltRadName, default.BoltRadIcon);
    

    return Template;
}

static function X2AbilityTemplate BoltRadLTTAttack()
{
    local X2AbilityTemplate                 Template;

    Template = BoltLeadTheTargetAttack(default.BoltRadName, default.BoltRadIcon);
    
    return Template;
}

// Helpers

static function X2AbilityTemplate BoltAttack(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

    Template.bAllowFreeFireWeaponUpgrade = true;

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);

    AddBoltCharges(Template, TemplateName);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.bAddWeaponTypicalCost = true;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
        
    Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
    Template.bUsesFiringCamera = true;
    Template.CinescriptCameraType = "StandardGunFiring";

    Template.AssociatedPassives.AddItem('HoloTargeting');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.AdditionalAbilities.AddItem(GetAddLLTName(TemplateName));

    return Template;
}

static function X2AbilityTemplate BoltAttack_AddLTT(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate                             Template;
    local X2Condition_AbilityProperty                   AbilityCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget  AddAbilityEffect;

    Template = Passive(GetAddLLTName(TemplateName), IconImage, false, false);
    
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(default.LeadTheTargetRequiredAbilityName);
    Template.AbilityShooterConditions.Additem(AbilityCondition);

    AddAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    AddAbilityEffect.AddAbilities.AddItem(GetLLTName(TemplateName));
    AddAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    AddAbilityEffect.TargetConditions.AddItem(AbilityCondition);
    Template.AddTargetEffect(AddAbilityEffect);

    return Template;
}

static function X2AbilityTemplate BoltLeadTheTarget(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ReserveActionPoints      ReservePointsEffect;
    local X2Effect_Persistent               MarkEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, GetLLTName(TemplateName));

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    MarkEffect = new class'X2Effect_Persistent';
    MarkEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
    MarkEffect.EffectName = GetLLTMarkName(TemplateName);
    MarkEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(MarkEffect);

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    AmmoCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(AmmoCost);

    AddBoltCharges(Template, TemplateName);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.bAddWeaponTypicalCost = true;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.bFreeCost = true;
    ActionPointCost.DoNotConsumeAllEffects.Length = 0;
    ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
    ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
    ReservePointsEffect.ReserveType = default.LeadTheTargetReserveActionName;
    Template.AddShooterEffect(ReservePointsEffect);
    
    Template.AbilityToHitCalc = default.DeadEye;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.AdditionalAbilities.AddItem(GetLLTAttackName(TemplateName));

    return Template;
}

static function X2AbilityTemplate BoltLeadTheTargetAttack(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, GetLLTAttackName(TemplateName));

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    //  Trigger on movement - interrupt the move
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'ObjectMoved';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = LeadTheTargetListener;
    Template.AbilityTriggers.AddItem(Trigger);
    //  Trigger on an attack
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(GetLLTMarkName(TemplateName), 'AA_MissingRequiredEffect');

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

    Template.bAllowFreeFireWeaponUpgrade = true;
    
    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);

    AddBoltCharges(Template, TemplateName);

    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;
    ReserveActionPointCost.AllowedTypes.AddItem(default.LeadTheTargetReserveActionName);
    Template.AbilityCosts.AddItem(ReserveActionPointCost);

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
        
    Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
    Template.bUsesFiringCamera = true;
    Template.CinescriptCameraType = "StandardGunFiring";

    Template.AssociatedPassives.AddItem('HoloTargeting');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bShowActivation = true;

    Template.bCrossClassEligible = false;

    return Template;
}

static function EventListenerReturn LeadTheTargetListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit TargetUnit;
    local XComGameStateContext_Ability AbilityContext;
    local XComGameState_Ability AbilityState;

    TargetUnit = XComGameState_Unit(EventData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none)
    {
        if (class'X2Ability_DefaultAbilitySet'.default.OverwatchIgnoreAbilities.Find(AbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE)
            return ELR_NoInterrupt;
    }

    AbilityState = XComGameState_Ability(CallbackData);
    if (AbilityState != none)
    {
        if (AbilityState.CanActivateAbilityForObserverEvent( TargetUnit ) == 'AA_Success')
        {
            AbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
        }
    }

    return ELR_NoInterrupt;
}

static function AddBoltCharges(out X2AbilityTemplate Template, const name DefaultAbilityName)
{
    local X2AbilityCharges Charges;
    local X2AbilityCost_Charges ChargeCost;
    local array<name> SharedAbilities;
    local bool bFreeCost;

    if (`GetConfigInt(DefaultAbilityName $ "_Charges") > 0)
    {
        if (Template.DataName != DefaultAbilityName)
            SharedAbilities.AddItem(DefaultAbilityName);
        
        if (Template.DataName != GetLLTName(DefaultAbilityName))
            SharedAbilities.AddItem(GetLLTName(DefaultAbilityName));
        else
            bFreeCost = true;

        if (Template.DataName != GetLLTAttackName(DefaultAbilityName))
            SharedAbilities.AddItem(GetLLTAttackName(DefaultAbilityName));

        Charges = new class 'X2AbilityCharges';
        Charges.InitialCharges = `GetConfigInt(DefaultAbilityName $ "_Charges");
        Charges.AddBonusCharge(default.HeavyOrdnanceAbilityName, `GetConfigInt("M31_PA_WS_HeavyOrdnance_BonusCharges"));
        Template.AbilityCharges = Charges;

        ChargeCost = new class'X2AbilityCost_Charges';
        ChargeCost.NumCharges = 1;
        ChargeCost.bFreeCost = bFreeCost;
        ChargeCost.SharedAbilityCharges = SharedAbilities;
        Template.AbilityCosts.AddItem(ChargeCost);
    }
}

static function name GetAddLLTName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_AddLTT");
}

static function name GetLLTName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_LTT");
}

static function name GetLLTAttackName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_LTT_Attack");
}

static function name GetLLTMarkName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_LTT_Mark");
}

static function X2AbilityMultiTarget_Radius GetBoltRadiusMultiTarget(name DefaultAbilityName)
{
    local X2AbilityMultiTarget_Radius RadiusMultiTarget;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `GetConfigFloat(DefaultAbilityName $ "_Radius");
    RadiusMultiTarget.AddAbilityBonusRadius(default.BallistaPassiveAbilityName,
        `GetConfigFloat(DefaultAbilityName $ "_Radius_Ballista") - `GetConfigFloat(DefaultAbilityName $ "_Radius"));
    RadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = true;

    return RadiusMultiTarget;
}


static function X2Condition_WOTC_APA_Class_ValidWeaponCategory GetBallistaCondition()
{
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory Condition;

    Condition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    Condition.AllowedWeaponCategories = default.Ballista_Categories;

    return Condition;
}

static function X2Condition_WOTC_APA_Class_ValidWeaponCategory GetNoBallistaCondition()
{
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory Condition;

    Condition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    Condition.ExcludedWeaponCategories = default.Ballista_Categories;

    return Condition;
}

defaultproperties
{
    HeavyOrdnanceAbilityName = M31_PA_WS_HeavyOrdnance
    BallistaPassiveAbilityName = M31_PA_WS_BallistaPassive
    BoltToHitBonusAbilityName = M31_PA_WS_BoltToHitBonus

    LeadTheTargetRequiredAbilityName = M31_PA_WS_Vigilance
    LeadTheTargetReserveActionName = M31_PA_WS_LeadTheTargetActionPoint

    BoltMaelstromName = M31_PA_WS_Bolt_Maelstrom
    BoltMaelstromIcon = ""

    BoltFrostName = M31_PA_WS_Bolt_Frost
    BoltFrostIcon = ""

    BoltShredName = M31_PA_WS_Bolt_Shred
    BoltShredIcon = ""

    BoltRuptureName = M31_PA_WS_Bolt_Rupture
    BoltRuptureIcon = ""

    BoltStunName = M31_PA_WS_Bolt_Stun
    BoltStunIcon = ""

    BoltCritName = M31_PA_WS_Bolt_Crit
    BoltCritIcon = ""

    BoltFireName = M31_PA_WS_Bolt_Fire
    BoltFireIcon = ""

    BoltPsiName = M31_PA_WS_Bolt_Psi
    BoltPsiIcon = ""

    BoltPoisonName = M31_PA_WS_Bolt_Poison
    BoltPoisonIcon = ""

    BoltRadName = M31_PA_WS_Bolt_Rad
    BoltRadIcon = ""
}