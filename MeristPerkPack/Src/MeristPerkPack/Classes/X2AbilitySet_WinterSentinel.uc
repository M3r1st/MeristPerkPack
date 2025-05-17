class X2AbilitySet_WinterSentinel extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name HeavyOrdnanceAbilityName;

var privatewrite name LeadTheTargetRequiredAbilityName;
var privatewrite name LeadTheTargetReserveActionName;

var privatewrite name BoltMaelstromName;
var privatewrite string BoltMaelstromIcon;
var privatewrite name BoltLeadTheTargetMaelstromMarkEffectName;

var privatewrite name BoltFrostName;
var privatewrite string BoltFrostIcon;
var privatewrite name BoltLeadTheTargetFrostMarkEffectName;

var privatewrite name BoltShredName;
var privatewrite string BoltShredIcon;
var privatewrite name BoltLeadTheTargetShredMarkEffectName;

var privatewrite name BoltRuptureName;
var privatewrite string BoltRuptureIcon;
var privatewrite name BoltLeadTheTargetRuptureMarkEffectName;

var privatewrite name BoltStunName;
var privatewrite string BoltStunIcon;
var privatewrite name BoltLeadTheTargetStunMarkEffectName;

var privatewrite name BoltCritName;
var privatewrite string BoltCritIcon;
var privatewrite name BoltLeadTheTargetCritMarkEffectName;

var config array<name> Ballista_Categories;
var config array<name> ChillingMist_AllowedGrenades;

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
    Templates.AddItem(Indomitable());
    Templates.AddItem(RagingSerpent());
    Templates.AddItem(Fracture());
    Templates.AddItem(AlloyedTCores());
    Templates.AddItem(HeavyOrdnance());
    Templates.AddItem(DragonSlayer());
    Templates.AddItem(ChillingMist());
    Templates.AddItem(NorthernWinds());
        Templates.AddItem(NorthernWindsTrigger());
    Templates.AddItem(MetabolicBoost());

    // Templates.AddItem(BoltMaelstrom());
    //     Templates.AddItem(BoltMaelstromBonus());
    //     Templates.AddItem(BoltMaelstromAddLTT());
    //     Templates.AddItem(BoltMaelstromLTT());
    //     Templates.AddItem(BoltMaelstromLTTAttack());

    // Templates.AddItem(BoltFrost());
    //     Templates.AddItem(BoltFrostAddLTT());
    //     Templates.AddItem(BoltFrostLTT());
    //     Templates.AddItem(BoltFrostLTTAttack());

    // Templates.AddItem(BoltShred());
    //     Templates.AddItem(BoltShredBonus());
    //     Templates.AddItem(BoltShredAddLTT());
    //     Templates.AddItem(BoltShredLTT());
    //     Templates.AddItem(BoltShredLTTAttack());

    // Templates.AddItem(BoltRupture());
    //     Templates.AddItem(BoltRuptureBonus());
    //     Templates.AddItem(BoltRuptureAddLTT());
    //     Templates.AddItem(BoltRuptureLTT());
    //     Templates.AddItem(BoltRuptureLTTAttack());

    // Templates.AddItem(BoltStun());
    //     Templates.AddItem(BoltStunAddLTT());
    //     Templates.AddItem(BoltStunLTT());
    //     Templates.AddItem(BoltStunLTTAttack());
    
    // Templates.AddItem(BoltCrit());
    //     Templates.AddItem(BoltCritBonus());
    //     Templates.AddItem(BoltCritAddLTT());
    //     Templates.AddItem(BoltCritLTT());
    //     Templates.AddItem(BoltCritLTTAttack());

    return Templates;
}

static function X2AbilityTemplate Hide()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WS_Hide          Effect;
    local X2Effect_GreaterPadding   GreaterPaddingEffect;

    Template = Passive('M31_PA_WS_Hide', "img:///UILibrary_PerkIcons.UIPerk_viper_bind", false, true);

    Effect = new class'X2Effect_WS_Hide';
    Effect.EffectName = 'M31_PA_WS_Hide';
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
    Effect.EffectName = 'M31_PA_WS_Entwine';
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
    Effect.EffectName = 'M31_PA_WS_GlacialArmor';
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

static function X2AbilityTemplate Indomitable()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_Indomitable           Effect;

    Template = Passive('M31_PA_WS_Indomitable', "img:///KetarosPkg_Abilities.UIPerk_ShieldWings", false, true);
    
    Effect = new class'X2Effect_WS_Indomitable';
    Effect.EffectName = 'M31_PA_WS_Indomitable';
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

static function X2AbilityTemplate Fracture()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_Fracture              Effect;

    Template = Passive('M31_PA_WS_Fracture', "img:///UILibrary_SOCombatEngineer.UIPerk_fracture", false, true);
    
    Effect = new class'X2Effect_WS_Fracture';
    Effect.EffectName = 'M31_PA_WS_Fracture';
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
    Effect.EffectName = 'M31_PA_WS_AlloyedCores';
    Effect.BuildPersistentEffect(1, true);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate HeavyOrdnance()
{
    local X2AbilityTemplate	Template;

    Template = Passive(default.HeavyOrdnanceAbilityName, "img:///UILibrary_MZChimeraIcons.Ability_ShrapnelGrenade", false, true);
    
    return Template;
}

static function X2AbilityTemplate DragonSlayer()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_DragonSlayer          Effect;

    Template = Passive('M31_PA_WS_DragonSlayer', "img:///KetarosPkg_Abilities.UIPerk_diablo", false, false);

    Effect = new class'X2Effect_WS_DragonSlayer';
    Effect.EffectName = 'M31_PA_WS_DragonSlayer';
    Effect.BuildPersistentEffect(1, true);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddShooterEffect(Effect);

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
    DodgeEffect.EffectName = 'M31_PA_WS_MetabolicBoost_Buff';
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

    Template.AddMultiTargetEffect(GetNorthernWindsDamageEffect());

    class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

    Template.AddMultiTargetEffect(new class'X2Effect_RevealSourceUnit');

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

static function X2AbilityTemplate BoltMaelstrom()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltAttack(default.BoltMaelstromName, default.BoltMaelstromIcon, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltMaelstromName $ "_Bonus"));
    Template.AdditionalAbilities.AddItem(name(default.BoltMaelstromName $ "_AddLTT"));

    SharedAbilities.AddItem(name(default.BoltMaelstromName $ "_LTT"));
    SharedAbilities.AddItem(name(default.BoltMaelstromName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltMaelstromName $ "_Charges"), SharedAbilities, false);

    return Template;
}

static function X2AbilityTemplate BoltMaelstromBonus()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_BoltBonus_Maelstrom   Effect;
    local array<name>                       AllowedAbilities;

    Template = Passive(name(default.BoltMaelstromName $ "_Bonus"), default.BoltMaelstromIcon, false, false);

    AllowedAbilities.AddItem(default.BoltMaelstromName);
    AllowedAbilities.AddItem(name(default.BoltMaelstromName $ "_LTT_Attack"));

    Effect = new class'X2Effect_WS_BoltBonus_Maelstrom';
    Effect.AllowedAbilities = AllowedAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BoltMaelstromAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(name(default.BoltMaelstromName $ "_AddLTT"), default.BoltMaelstromIcon, name(default.BoltMaelstromName $ "_LTT"));
    
    return Template;
}

static function X2AbilityTemplate BoltMaelstromLTT()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTarget(name(default.BoltMaelstromName $ "_LTT"), default.BoltMaelstromIcon, default.BoltLeadTheTargetMaelstromMarkEffectName);
    
    SharedAbilities.AddItem(default.BoltMaelstromName);
    SharedAbilities.AddItem(name(default.BoltMaelstromName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltMaelstromName $ "_Charges"), SharedAbilities, true);

    return Template;
}

static function X2AbilityTemplate BoltMaelstromLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTargetAttack(name(default.BoltMaelstromName $ "_LTT"), default.BoltMaelstromIcon, default.BoltLeadTheTargetMaelstromMarkEffectName, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltMaelstromName $ "_LTT_Attack"));

    SharedAbilities.AddItem(default.BoltMaelstromName);
    SharedAbilities.AddItem(name(default.BoltMaelstromName $ "_LTT"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltMaelstromName $ "_Charges"), SharedAbilities, false);
    
    return Template;
}

static function X2AbilityTemplate BoltFrost()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltAttack(default.BoltFrostName, default.BoltFrostIcon, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltFrostName $ "_Bonus"));
    Template.AdditionalAbilities.AddItem(name(default.BoltFrostName $ "_AddLTT"));

    SharedAbilities.AddItem(name(default.BoltFrostName $ "_LTT"));
    SharedAbilities.AddItem(name(default.BoltFrostName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltFrostName $ "_Charges"), SharedAbilities, false);

    return Template;
}

static function X2AbilityTemplate BoltFrostAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(name(default.BoltFrostName $ "_AddLTT"), default.BoltFrostIcon, name(default.BoltFrostName $ "_LTT"));
    
    return Template;
}

static function X2AbilityTemplate BoltFrostLTT()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTarget(name(default.BoltFrostName $ "_LTT"), default.BoltFrostIcon, default.BoltLeadTheTargetFrostMarkEffectName);
    
    SharedAbilities.AddItem(default.BoltFrostName);
    SharedAbilities.AddItem(name(default.BoltFrostName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltFrostName $ "_Charges"), SharedAbilities, true);

    return Template;
}

static function X2AbilityTemplate BoltFrostLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTargetAttack(name(default.BoltFrostName $ "_LTT"), default.BoltFrostIcon, default.BoltLeadTheTargetFrostMarkEffectName, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltFrostName $ "_LTT_Attack"));

    SharedAbilities.AddItem(default.BoltFrostName);
    SharedAbilities.AddItem(name(default.BoltFrostName $ "_LTT"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltFrostName $ "_Charges"), SharedAbilities, false);
    
    return Template;
}

static function X2AbilityTemplate BoltShred()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltAttack(default.BoltShredName, default.BoltShredIcon, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltShredName $ "_Bonus"));
    Template.AdditionalAbilities.AddItem(name(default.BoltShredName $ "_AddLTT"));

    SharedAbilities.AddItem(name(default.BoltShredName $ "_LTT"));
    SharedAbilities.AddItem(name(default.BoltShredName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltShredName $ "_Charges"), SharedAbilities, false);

    return Template;
}

static function X2AbilityTemplate BoltShredBonus()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_BoltBonus_Shred   Effect;
    local array<name>                       AllowedAbilities;

    Template = Passive(name(default.BoltShredName $ "_Bonus"), default.BoltShredIcon, false, false);

    AllowedAbilities.AddItem(default.BoltShredName);
    AllowedAbilities.AddItem(name(default.BoltShredName $ "_LTT_Attack"));

    Effect = new class'X2Effect_WS_BoltBonus_Shred';
    Effect.AllowedAbilities = AllowedAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BoltShredAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(name(default.BoltShredName $ "_AddLTT"), default.BoltShredIcon, name(default.BoltShredName $ "_LTT"));
    
    return Template;
}

static function X2AbilityTemplate BoltShredLTT()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTarget(name(default.BoltShredName $ "_LTT"), default.BoltShredIcon, default.BoltLeadTheTargetShredMarkEffectName);
    
    SharedAbilities.AddItem(default.BoltShredName);
    SharedAbilities.AddItem(name(default.BoltShredName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltShredName $ "_Charges"), SharedAbilities, true);

    return Template;
}

static function X2AbilityTemplate BoltShredLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTargetAttack(name(default.BoltShredName $ "_LTT"), default.BoltShredIcon, default.BoltLeadTheTargetShredMarkEffectName, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltShredName $ "_LTT_Attack"));

    SharedAbilities.AddItem(default.BoltShredName);
    SharedAbilities.AddItem(name(default.BoltShredName $ "_LTT"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltShredName $ "_Charges"), SharedAbilities, false);
    
    return Template;
}

static function X2AbilityTemplate BoltRupture()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltAttack(default.BoltRuptureName, default.BoltRuptureIcon, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltRuptureName $ "_Bonus"));
    Template.AdditionalAbilities.AddItem(name(default.BoltRuptureName $ "_AddLTT"));

    SharedAbilities.AddItem(name(default.BoltRuptureName $ "_LTT"));
    SharedAbilities.AddItem(name(default.BoltRuptureName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltRuptureName $ "_Charges"), SharedAbilities, false);

    return Template;
}

static function X2AbilityTemplate BoltRuptureBonus()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_BoltBonus_Rupture     Effect;
    local array<name>                       AllowedAbilities;

    Template = Passive(name(default.BoltRuptureName $ "_Bonus"), default.BoltRuptureIcon, false, false);

    AllowedAbilities.AddItem(default.BoltRuptureName);
    AllowedAbilities.AddItem(name(default.BoltRuptureName $ "_LTT_Attack"));

    Effect = new class'X2Effect_WS_BoltBonus_Rupture';
    Effect.AllowedAbilities = AllowedAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BoltRuptureAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(name(default.BoltRuptureName $ "_AddLTT"), default.BoltRuptureIcon, name(default.BoltRuptureName $ "_LTT"));
    
    return Template;
}

static function X2AbilityTemplate BoltRuptureLTT()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTarget(name(default.BoltRuptureName $ "_LTT"), default.BoltRuptureIcon, default.BoltLeadTheTargetRuptureMarkEffectName);
    
    SharedAbilities.AddItem(default.BoltRuptureName);
    SharedAbilities.AddItem(name(default.BoltRuptureName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltRuptureName $ "_Charges"), SharedAbilities, true);

    return Template;
}

static function X2AbilityTemplate BoltRuptureLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTargetAttack(name(default.BoltRuptureName $ "_LTT"), default.BoltRuptureIcon, default.BoltLeadTheTargetRuptureMarkEffectName, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltRuptureName $ "_LTT_Attack"));

    SharedAbilities.AddItem(default.BoltRuptureName);
    SharedAbilities.AddItem(name(default.BoltRuptureName $ "_LTT"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltRuptureName $ "_Charges"), SharedAbilities, false);
    
    return Template;
}

static function X2AbilityTemplate BoltStun()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltAttack(default.BoltStunName, default.BoltStunIcon, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltStunName $ "_Bonus"));
    Template.AdditionalAbilities.AddItem(name(default.BoltStunName $ "_AddLTT"));

    SharedAbilities.AddItem(name(default.BoltStunName $ "_LTT"));
    SharedAbilities.AddItem(name(default.BoltStunName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltStunName $ "_Charges"), SharedAbilities, false);

    return Template;
}

static function X2AbilityTemplate BoltStunAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(name(default.BoltStunName $ "_AddLTT"), default.BoltStunIcon, name(default.BoltStunName $ "_LTT"));
    
    return Template;
}

static function X2AbilityTemplate BoltStunLTT()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTarget(name(default.BoltStunName $ "_LTT"), default.BoltStunIcon, default.BoltLeadTheTargetStunMarkEffectName);
    
    SharedAbilities.AddItem(default.BoltStunName);
    SharedAbilities.AddItem(name(default.BoltStunName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltStunName $ "_Charges"), SharedAbilities, true);

    return Template;
}

static function X2AbilityTemplate BoltStunLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTargetAttack(name(default.BoltStunName $ "_LTT"), default.BoltStunIcon, default.BoltLeadTheTargetStunMarkEffectName, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltStunName $ "_LTT_Attack"));

    SharedAbilities.AddItem(default.BoltStunName);
    SharedAbilities.AddItem(name(default.BoltStunName $ "_LTT"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltStunName $ "_Charges"), SharedAbilities, false);
    
    return Template;
}

static function X2AbilityTemplate BoltCrit()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltAttack(default.BoltCritName, default.BoltCritIcon, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltCritName $ "_Bonus"));
    Template.AdditionalAbilities.AddItem(name(default.BoltCritName $ "_AddLTT"));

    SharedAbilities.AddItem(name(default.BoltCritName $ "_LTT"));
    SharedAbilities.AddItem(name(default.BoltCritName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltCritName $ "_Charges"), SharedAbilities, false);

    return Template;
}

static function X2AbilityTemplate BoltCritBonus()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_BoltBonus_Crit        Effect;
    local array<name>                       AllowedAbilities;

    Template = Passive(name(default.BoltCritName $ "_Bonus"), default.BoltCritIcon, false, false);

    AllowedAbilities.AddItem(default.BoltCritName);
    AllowedAbilities.AddItem(name(default.BoltCritName $ "_LTT_Attack"));

    Effect = new class'X2Effect_WS_BoltBonus_Crit';
    Effect.AllowedAbilities = AllowedAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BoltCritAddLTT()
{
    local X2AbilityTemplate                 Template;

    Template = BoltAttack_AddLTT(name(default.BoltCritName $ "_AddLTT"), default.BoltCritIcon, name(default.BoltCritName $ "_LTT"));
    
    return Template;
}

static function X2AbilityTemplate BoltCritLTT()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTarget(name(default.BoltCritName $ "_LTT"), default.BoltCritIcon, default.BoltLeadTheTargetCritMarkEffectName);
    
    SharedAbilities.AddItem(default.BoltCritName);
    SharedAbilities.AddItem(name(default.BoltCritName $ "_LTT_Attack"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltCritName $ "_Charges"), SharedAbilities, true);

    return Template;
}

static function X2AbilityTemplate BoltCritLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SharedAbilities;

    Template = BoltLeadTheTargetAttack(name(default.BoltCritName $ "_LTT"), default.BoltCritIcon, default.BoltLeadTheTargetCritMarkEffectName, true);

    Template.AdditionalAbilities.AddItem(name(default.BoltCritName $ "_LTT_Attack"));

    SharedAbilities.AddItem(default.BoltCritName);
    SharedAbilities.AddItem(name(default.BoltCritName $ "_LTT"));
    AddBoltCharges(Template, `GetConfigInt(default.BoltCritName $ "_Charges"), SharedAbilities, false);
    
    return Template;
}

static function X2AbilityTemplate BoltAttack(
    name TemplateName,
    string IconImage,
    optional bool bAddDefaultEffects = true)
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

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
        Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

        Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    }

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);

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

    return Template;	
}

static function X2AbilityTemplate BoltAttack_AddLTT(
    name TemplateName,
    string IconImage,
    name BoltLTTName)
{
    local X2AbilityTemplate                             Template;
    local X2Condition_AbilityProperty                   AbilityCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget  AddAbilityEffect;

    Template = Passive(TemplateName, IconImage, false, false);
    
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(default.LeadTheTargetRequiredAbilityName);
    Template.AbilityShooterConditions.Additem(AbilityCondition);

    AddAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    AddAbilityEffect.AddAbilities.AddItem(BoltLTTName);
    AddAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    AddAbilityEffect.TargetConditions.AddItem(AbilityCondition);
    Template.AddTargetEffect(AddAbilityEffect);

    return Template;
}

static function X2AbilityTemplate BoltLeadTheTarget(
    name TemplateName,
    string IconImage,
    name MarkEffectName)
{
    local X2AbilityTemplate                 Template;	
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ReserveActionPoints      ReservePointsEffect;
    local X2Effect_Persistent               MarkEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

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
    MarkEffect.EffectName = MarkEffectName;
    MarkEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(MarkEffect);

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    AmmoCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(AmmoCost);

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

    return Template;	
}

static function X2AbilityTemplate BoltLeadTheTargetAttack(
    name TemplateName,
    string IconImage,
    name MarkEffectName,
    optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate                 Template;	
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

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
    TargetEffectCondition.AddRequireEffect(MarkEffectName, 'AA_MissingRequiredEffect');

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

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
        Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

        Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    }
    
    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);

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

static function AddBoltCharges(X2AbilityTemplate Template, int InitialCharges, array<name> SharedAbilities, optional bool bFreeCost = false)
{
    local X2AbilityCharges Charges;
    local X2AbilityCost_Charges ChargeCost;

    if (InitialCharges > 0)
    {
        Charges = new class 'X2AbilityCharges';
        Charges.InitialCharges = InitialCharges;
        Charges.AddBonusCharge(default.HeavyOrdnanceAbilityName, 1);
        Template.AbilityCharges = Charges;

        ChargeCost = new class'X2AbilityCost_Charges';
        ChargeCost.NumCharges = 1;
        ChargeCost.bFreeCost = bFreeCost;
        ChargeCost.SharedAbilityCharges = SharedAbilities;
        Template.AbilityCosts.AddItem(ChargeCost);
    }
}

defaultproperties
{
    HeavyOrdnanceAbilityName = M31_PA_WS_HeavyOrdnance

    LeadTheTargetRequiredAbilityName = M31_PA_WS_Vigilance
    LeadTheTargetReserveActionName = WS_LeadTheTargetAction

    BoltMaelstromName = M31_PA_WS_Bolt_Maelstrom
    BoltMaelstromIcon = ""
    BoltLeadTheTargetMaelstromMarkEffectName = M31_PA_WS_Bolt_Maelstrom_LTT_MarkName

    BoltFrostName = M31_PA_WS_Bolt_Frost
    BoltFrostIcon = ""
    BoltLeadTheTargetFrostMarkEffectName = M31_PA_WS_Bolt_Frost_LTT_MarkName

    BoltShredName = M31_PA_WS_Bolt_Shred
    BoltShredIcon = ""
    BoltLeadTheTargetShredMarkEffectName = M31_PA_WS_Bolt_Shred_LTT_MarkName

    BoltRuptureName = M31_PA_WS_Bolt_Rupture
    BoltRuptureIcon = ""
    BoltLeadTheTargetRuptureMarkEffectName = M31_PA_WS_Bolt_Rupture_LTT_MarkName

    BoltStunName = M31_PA_WS_Bolt_Stun
    BoltStunIcon = ""
    BoltLeadTheTargetStunMarkEffectName = M31_PA_WS_Bolt_Stun_LTT_MarkName

    BoltCritName = M31_PA_WS_Bolt_Crit
    BoltCritIcon = ""
    BoltLeadTheTargetCritMarkEffectName = M31_PA_WS_Bolt_Crit_LTT_MarkName
}