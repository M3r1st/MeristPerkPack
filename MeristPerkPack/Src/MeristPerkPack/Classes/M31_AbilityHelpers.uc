class M31_AbilityHelpers extends X2Ability;

static function X2AbilityTemplate CreatePassiveWeaponEffectAttack(name DataName, string IconImage, optional X2Effect Effect = none)
{
    local X2AbilityTemplate     Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.bAllowAmmoEffects = false;
    Template.bAllowBonusWeaponEffects = false;
    Template.bAllowFreeFireWeaponUpgrade = false;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    if (Effect != none)
    {
        Template.AddTargetEffect(Effect);
    }

    Template.FrameAbilityCameraType = eCameraFraming_Never; 
    Template.bSkipExitCoverWhenFiring = true;
    Template.bSkipFireAction = true;
    Template.bShowActivation = false;
    Template.bUsesFiringCamera = false;

    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    // Template.BuildVisualizationFn = FollowUpShot_BuildVisualization;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.MergeVisualizationFn = FollowUpShot_MergeVisualization;
    Template.BuildInterruptGameStateFn = none;
    Template.bCrossClassEligible = false;
    return Template;
}

static function X2Effect_PersistentStatChange CreateHackDefenseReductionStatusEffect(
    name EffectName,
    int HackDefenseChangeAmount,
    optional X2Condition Condition)
{
    
    local X2Effect_PersistentStatChange HackDefenseReductionEffect;
    HackDefenseReductionEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(HackDefenseChangeAmount, Condition);
    HackDefenseReductionEffect.EffectName = EffectName;
    HackDefenseReductionEffect.DuplicateResponse = eDupe_Allow;
    HackDefenseReductionEffect.IconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
    return HackDefenseReductionEffect;
}

static function X2Effect_PersistentStatChange CreateRoboticDisorientedStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f)
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Condition_UnitProperty          UnitPropCondition;

    PersistentStatChangeEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    PersistentStatChangeEffect.TargetConditions.Length = 0;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeOrganic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

    return PersistentStatChangeEffect;
}

static function X2Effect_ImmediateAbilityActivation CreateImpairingEffect()
{
    local X2Effect_ImmediateAbilityActivation   ImpairingAbilityEffect;
    local X2Condition_AbilityProperty           AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
    ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
    ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
    ImpairingAbilityEffect.AbilityName = class'X2Ability_Impairing'.default.ImpairingAbilityName;
    ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
    ImpairingAbilityEffect.VisualizationFn = class'X2Ability_Impairing'.static.ImpairingAbilityEffectTriggeredVisualization;
    ImpairingAbilityEffect.TargetConditions.AddItem(AbilityCondition);

    return ImpairingAbilityEffect;
}

static function X2Effect_PersistentStatChange CreatePoisonedEffect()
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Effect_ApplyDamageFromHPWithRank DamageEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Poison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(
        ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_PA_ViperPoison_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_Poison_MobilityPenalty"));
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_Poison_AimPenalty"));
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

    DamageEffect = new class'X2Effect_ApplyDamageFromHPWithRank';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_PA_Poison_DamagePerTurn");
    DamageEffect.EffectDamageValue.Spread = `GetConfigInt("M31_PA_Poison_DamagePerTurn_Spread");
    DamageEffect.fPrcDmg = `GetConfigFloat("M31_PA_Poison_DamagePerTurn_Prc");
    DamageEffect.fPrcDmgPerRank = `GetConfigFloat("M31_PA_Poison_DamagePerTurn_Prc_PerRank");
    DamageEffect.fBaseDmgPerRank = `GetConfigFloat("M31_PA_Poison_DamagePerTurn_PerRank");
    DamageEffect.fPrcDamage_RulerMultiplier = `GetConfigFloat("M31_PA_Poison_DamagePerTurn_Prc_RulerMult");
    DamageEffect.fPrcDamage_ChosenMultiplier = `GetConfigFloat("M31_PA_Poison_DamagePerTurn_Prc_ChosenMult");
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
    local X2Effect_ApplyDamageFromHPWithRank DamageEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(
        ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_PA_ViperEnhancedPoison_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_EnhancedPoison_MobilityPenalty"));
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_EnhancedPoison_AimPenalty"));
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

    DamageEffect = new class'X2Effect_ApplyDamageFromHPWithRank';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_PA_EnhancedPoison_DamagePerTurn");
    DamageEffect.EffectDamageValue.Spread = `GetConfigInt("M31_PA_EnhancedPoison_DamagePerTurn_Spread");
    DamageEffect.fPrcDmg = `GetConfigFloat("M31_PA_EnhancedPoison_DamagePerTurn_Prc");
    DamageEffect.fPrcDmgPerRank = `GetConfigFloat("M31_PA_EnhancedPoison_DamagePerTurn_Prc_PerRank");
    DamageEffect.fBaseDmgPerRank = `GetConfigFloat("M31_PA_EnhancedPoison_DamagePerTurn_PerRank");
    DamageEffect.fPrcDamage_RulerMultiplier = `GetConfigFloat("M31_PA_EnhancedPoison_DamagePerTurn_Prc_RulerMult");
    DamageEffect.fPrcDamage_ChosenMultiplier = `GetConfigFloat("M31_PA_EnhancedPoison_DamagePerTurn_Prc_ChosenMult");
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

static function AddEnhancedPoisonEffectToTarget(out X2AbilityTemplate Template)
{
    Template.AddTargetEffect(CreateEnhancedPoisonedEffect());
    Template.AddTargetEffect(CreatePoisonedEffect());
    Template.AddTargetEffect(CreateNeuroPoisonEffect());
}

static function AddEnhancedPoisonEffectToMultiTarget(out X2AbilityTemplate Template)
{
    Template.AddMultiTargetEffect(CreateEnhancedPoisonedEffect());
    Template.AddMultiTargetEffect(CreatePoisonedEffect());
    Template.AddMultiTargetEffect(CreateNeuroPoisonEffect());
}

static function X2Effect_Persistent CreateNeuroPoisonEffect()
{
    local X2Effect_Persistent DisorientedEffect;
    local X2Condition_AbilityProperty AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_NeuroPoison');

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
    DisorientedEffect.DamageTypes.AddItem('Poison');
    DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

    return DisorientedEffect;
}

static function AddBlindingPoisonEffectToTarget(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffectsOnSource   EffectCondition, EffectConditionEnhanced;
    local X2Effect_Blind                    BlindEffect, BlindEffectEnhanced;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"));
    BlindEffect.DamageTypes.AddItem('Poison');
    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    BlindEffect.TargetConditions.AddItem(EffectCondition);
    BlindEffect.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddTargetEffect(BlindEffect);

    BlindEffectEnhanced = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_Poison_Duration"));
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

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"));
    BlindEffect.DamageTypes.AddItem('Poison');
    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    BlindEffect.TargetConditions.AddItem(EffectCondition);
    BlindEffect.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddMultiTargetEffect(BlindEffect);

    BlindEffectEnhanced = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_Poison_Duration"));
    BlindEffectEnhanced.DamageTypes.AddItem('Poison');
    EffectConditionEnhanced = new class'X2Condition_UnitEffectsOnSource';
    EffectConditionEnhanced.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectConditionEnhanced.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    BlindEffectEnhanced.TargetConditions.AddItem(EffectConditionEnhanced);
    BlindEffectEnhanced.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddMultiTargetEffect(BlindEffectEnhanced);
}

static function X2Effect_Persistent CreateBleedingStatusEffect(int NumTurns, int BleedDamage, optional int BleedDamageSpread, optional float BleedDamagePrc)
{
    local X2Effect_Persistent PersistentEffect;
    local X2Effect_ApplyDamageFromHP DamageEffect;
    local X2Condition_UnitProperty UnitPropCondition;

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = class'X2StatusEffects'.default.BleedingName;
    PersistentEffect.DuplicateResponse = eDupe_Refresh;
    PersistentEffect.BuildPersistentEffect(NumTurns, , false, , eGameRule_PlayerTurnBegin);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, class'X2StatusEffects'.default.BleedingFriendlyDesc, "img:///UILibrary_XPACK_Common.UIPerk_bleeding");
    PersistentEffect.VisualizationFn = class'X2StatusEffects'.static.BleedingVisualization;
    PersistentEffect.EffectSyncVisualizationFn = class'X2StatusEffects'.static.BleedingSyncVisualization;
    PersistentEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.BleedingVisualizationTicked;
    PersistentEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.BleedingVisualizationRemoved;
    PersistentEffect.DamageTypes.AddItem('Bleeding');
    PersistentEffect.bRemoveWhenTargetDies = true;
    PersistentEffect.bCanTickEveryAction = true;
    PersistentEffect.bEffectForcesBleedout = true;

    PersistentEffect.PersistentPerkName = class'X2StatusEffects'.default.BleedingPerk_Name;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = false;
    UnitPropCondition.ExcludeRobotic = true;
    PersistentEffect.TargetConditions.AddItem(UnitPropCondition);

    DamageEffect = new class'X2Effect_ApplyDamageFromHP';
    DamageEffect.EffectDamageValue.Damage = BleedDamage;
    DamageEffect.EffectDamageValue.Spread = BleedDamageSpread;
    DamageEffect.fPrcDmg = BleedDamagePrc;
    DamageEffect.fPrcDamage_ChosenMultiplier = 0.5;
    DamageEffect.fPrcDamage_RulerMultiplier = 0.5;
    DamageEffect.bCeiling = true;
    DamageEffect.EffectDamageValue.DamageType = 'Bleeding';

    DamageEffect.DamageTypes.AddItem('Bleeding');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.BLEEDING_IGNORES_SHIELDS;
    PersistentEffect.ApplyOnTick.AddItem(DamageEffect);

    return PersistentEffect;
}

static function X2Effect_Immobilize CreateMaimedStatusEffect(optional int NumTurns = 1, optional name AbilitySourceName = 'eAbilitySource_Standard')
{
    local X2Effect_Immobilize ImmobilizeEffect;

    ImmobilizeEffect = new class'X2Effect_Immobilize';
    ImmobilizeEffect.EffectName = 'Maim_Immobilize';
    ImmobilizeEffect.DuplicateResponse = eDupe_Refresh;
    ImmobilizeEffect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnEnd);
    ImmobilizeEffect.SetDisplayInfo(ePerkBuff_Penalty, `GetLocalizedString("M31_Maimed_FriendlyName"), `GetLocalizedString("M31_Maimed_DebuffText"),
            "img:///UILibrary_XPerkIconPack.UIPerk_move_blossom", true, , AbilitySourceName);
    ImmobilizeEffect.AddPersistentStatChange(eStat_Mobility, 0.0f, MODOP_PostMultiplication);
    ImmobilizeEffect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;

    return ImmobilizeEffect;
}

// Default = 144
static function AddAdjacencyCondition(out X2AbilityTemplate Template, optional int Range = 180)
{
    local X2Condition_UnitProperty                  AdjacencyCondition;

    AdjacencyCondition = new class'X2Condition_UnitProperty';
    AdjacencyCondition.ExcludeDead = false;
    AdjacencyCondition.ExcludeFriendlyToSource = false;
    AdjacencyCondition.RequireWithinRange = true;
    AdjacencyCondition.WithinRange = Range;
    Template.AbilityTargetConditions.AddItem(AdjacencyCondition);
}

    
static function X2AbilityTemplate CreateAnimSetPassive(name TemplateName, string AnimSetPath)
{
    local X2AbilityTemplate                 Template;
    local X2Effect_AdditionalAnimSets       AnimSetEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    
    AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
    AnimSetEffect.AddAnimSetWithPath(AnimSetPath);
    AnimSetEffect.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(AnimSetEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

static final function int GetActionPoints(const XComGameState_Unit Unit, array<name> AllowedTypes)
{
    local int i, Count;

    for (i = 0; i < Unit.ActionPoints.Length; i++)
    {
        if (AllowedTypes.Find(Unit.ActionPoints[i]) != INDEX_NONE) {
            Count++;
        }
    }
    return Count;
}

static function array<X2Effect> CreateRadiationEffects(
    optional int RadiationRadBurnApplyChance = 50, optional int RadiationRadBurnDamage = 3, optional int RadiationRadBurnDamageSpread = 2,
    optional int RadiationBoilingBloodApplyChance = 33, optional int RadiationBoilingBloodDamage = 4, optional int RadiationBoilingBloodDamageSpread = 2,
    optional int RadiationIrradiateApplyChance = 100, optional int RadiationPanicApplyChance = 10)
{
    local array<X2Effect> Effects;
    // 33, 3, 2
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadBurningStatusEffect(RadiationRadBurnApplyChance, RadiationRadBurnDamage, RadiationRadBurnDamageSpread));
    // 25, 4, 2
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadBleedingStatusEffect(RadiationBoilingBloodApplyChance, RadiationBoilingBloodDamage, RadiationBoilingBloodDamageSpread));
    // 75
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadDisorientedStatusEffect(RadiationIrradiateApplyChance, , ,false));
    // 10
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadPanickedStatusEffect(RadiationPanicApplyChance));
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    ////////////////////////////
    /////// This Needs to be here so the Lost can benefit from having Radiation applied on them
    ///////////////////////////
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateLostRadRegenStatusEffect(100));
    ////////////////////////////
    /////// This Needs to be here so the Lost can benefit from having Radiation applied on them
    ///////////////////////////
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    ///////////////////////////
    /////// These apply the stat debuffs for Radiation Burn, and Boiling Blood, they will only activate if said effects are successfully applied
    ///////////////////////////
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadBurnDodgeStatusEffect());
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateBoilingBloodMobilityStatusEffect());
    ///////////////////////////
    /////// These apply the stat debuffs for Radiation Burn, and Boiling Blood, they will only activate if said effects are successfully applied
    ///////////////////////////
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    ////////////////////////////
    /////// This applies additional debuffs to robotic units affected by Irradiate
    ///////////////////////////
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateIrradiatedRoboticDebuffStatusEffect());
    ////////////////////////////
    /////// This applies additional debuffs to robotic units affected by Irradiate
    ///////////////////////////
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    return Effects;
}

static function AddRadiationToTarget(out X2AbilityTemplate Template,
    optional int RadiationRadBurnApplyChance = 33, optional int RadiationRadBurnDamage = 3, optional int RadiationRadBurnDamageSpread = 2,
    optional int RadiationBoilingBloodApplyChance = 25, optional int RadiationBoilingBloodDamage = 4, optional int RadiationBoilingBloodDamageSpread = 2,
    optional int RadiationIrradiateApplyChance = 75, optional int RadiationPanicApplyChance = 10)
{
    local array<X2Effect> Effects;
    local X2Effect Effect;
    
    Effects = CreateRadiationEffects(RadiationRadBurnApplyChance, RadiationRadBurnDamage, RadiationRadBurnDamageSpread,
        RadiationBoilingBloodApplyChance, RadiationBoilingBloodDamage, RadiationBoilingBloodDamageSpread,
        RadiationIrradiateApplyChance, RadiationPanicApplyChance);
    
    foreach Effects(Effect)
        Template.AddTargetEffect(Effect);
}

static function AddRadiationToMultiTarget(out X2AbilityTemplate Template,
    optional int RadiationRadBurnApplyChance = 33, optional int RadiationRadBurnDamage = 3, optional int RadiationRadBurnDamageSpread = 2,
    optional int RadiationBoilingBloodApplyChance = 25, optional int RadiationBoilingBloodDamage = 4, optional int RadiationBoilingBloodDamageSpread = 2,
    optional int RadiationIrradiateApplyChance = 75, optional int RadiationPanicApplyChance = 10)
{
    local array<X2Effect> Effects;
    local X2Effect Effect;
    
    Effects = CreateRadiationEffects(RadiationRadBurnApplyChance, RadiationRadBurnDamage, RadiationRadBurnDamageSpread,
        RadiationBoilingBloodApplyChance, RadiationBoilingBloodDamage, RadiationBoilingBloodDamageSpread,
        RadiationIrradiateApplyChance, RadiationPanicApplyChance);
    
    foreach Effects(Effect)
        Template.AddMultiTargetEffect(Effect);
}

static function AddConditionalAbilityEffect(out X2AbilityTemplate Template, array<name> WeaponCats, array<name> AbilitiesToAdd, EInventorySlot Slot = eInvSlot_Unknown)
{
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory    Condition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget      Effect;

    Condition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    Condition.AllowedWeaponCategories = WeaponCats;
    if (Slot != eInvSlot_Unknown)
    {
        Condition.bCheckSpecificSlot = true;
        Condition.SpecificSlot = Slot;
    }

    Effect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    Effect.AddAbilities = AbilitiesToAdd;
    if (Slot != eInvSlot_Unknown)
    {
        Effect.ApplyToWeaponSlot = Slot;
    }
    Effect.TargetConditions.AddItem(Condition);
    
    Template.AddTargetEffect(Effect);
}

static function EventListenerReturn KillMailListener_Self(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Ability             AbilityState;
    local XComGameStateContext_Ability      AbilityContext;

    SourceUnit = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        if (AbilityState.OwnerStateObject.ObjectID == SourceUnit.ObjectID)
        {
            return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
        }
    }

    return ELR_NoInterrupt;
}

static function AddSuppressedCondition(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffects SuppressedCondition;

    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    // SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    SuppressedCondition.AddExcludeEffect('AreaSuppression', 'AA_UnitIsSuppressed'); // Not building against LWOTC
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);
}


static function AddBladestormMark(out X2AbilityTemplate Template, name MarkName)
{
    local X2Effect_Persistent BladestormTargetEffect;
    local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;

    BladestormTargetEffect = new class'X2Effect_Persistent';
    BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
    BladestormTargetEffect.EffectName = MarkName;
    BladestormTargetEffect.bApplyOnMiss = true;
    Template.AddTargetEffect(BladestormTargetEffect);
    
    BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    BladestormTargetCondition.AddExcludeEffect(MarkName, 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);
}

// Helpers_LW.uc
static final function bool IsUnitInterruptingEnemyTurn(XComGameState_Unit UnitState)
{
    local XComGameState_BattleData BattleState;

    BattleState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    return BattleState.InterruptingGroupRef == UnitState.GetGroupMembership().GetReference();
}

// Iridar's Perk Pack

final static function FollowUpShot_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
    local XComGameStateVisualizationMgr     VisMgr;
    local array<X2Action>                   FindActions;
    local X2Action                          FindAction;
    local X2Action                          FireAction;
    local X2Action_MarkerTreeInsertBegin    MarkerStart;
    local X2Action_MarkerTreeInsertEnd      MarkerEnd;
    local X2Action                          WaitAction;
    local X2Action                          ChildAction;
    local X2Action_MarkerNamed              MarkerAction;
    local array<X2Action>                   MarkerActions;
    local array<X2Action>                   DamageUnitActions;
    local array<X2Action>                   DamageTerrainActions;
    local XComGameStateContext_Ability      AbilityContext;
    local VisualizationActionMetadata       ActionMetadata;
    local bool                              bFoundHistoryIndex;

    VisMgr = `XCOMVISUALIZATIONMGR;
    AbilityContext = XComGameStateContext_Ability(BuildTree.StateChangeContext);
    
    //  Find all Fire Actions in the triggering ability's Vis Tree performed by the unit that used the FollowUpShot.
    VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', FindActions,, AbilityContext.InputContext.SourceObject.ObjectID);
    
    // Find all Damage Unit / Damage Terrain actions in the triggering ability visualization tree that are playing on the primary target of the follow up shot.
    // Damage Terrain actions play the damage flyover for damageable non-unit objects, like Alien Relay.
    VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToUnit', DamageUnitActions,, AbilityContext.InputContext.PrimaryTarget.ObjectID);
    VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', DamageTerrainActions,, AbilityContext.InputContext.PrimaryTarget.ObjectID);

    // If there are several Fire Actions in the triggering ability tree (e.g. Faceoff), we need to find the right Fire Action that fires at the same target this instance of Follow Up Shot was fired at.
    // This info is not stored in the Fire Action itself, so we find the needed Fire Action by looking at its children Damage Unit / Damage Terrain actions,
    // as well as the visualization index recorded in FollowUpShot's context by its ability trigger.
    foreach FindActions(FireAction)
    {
        if (FireAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
        {
            foreach FireAction.ChildActions(ChildAction)
            {
                if (DamageTerrainActions.Find(ChildAction) != INDEX_NONE)
                {
                    bFoundHistoryIndex = true;
                    break;
                }
                if (DamageUnitActions.Find(ChildAction) != INDEX_NONE)
                {
                    bFoundHistoryIndex = true;
                    break;
                }
            }
        }

        if (bFoundHistoryIndex)
                break;
    }

    // If we didn't find the correct Fire Action, we call the failsafe Merge Vis Function,
    // which will make both Singe's Target Effects apply seperately after the triggering ability's visualization finishes.
    if (!bFoundHistoryIndex)
    {
        `LOG("WARNING ::" @ GetFuncName() @ "Failed to find the correct Fire Action, using a failsafe.",, 'MeristPerkPack');
        AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
        return;
    }

    // Find the start and end of the FollowUpShot's Vis Tree
    MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
    MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

    // Will need these later to tie the shoelaces.
    VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', MarkerActions);

    //  Add a Wait For Effect Action after the triggering ability's Fire Action. This will allow Singe's Effects to visualize the moment the triggering ability connects with the target.
    ActionMetaData = FireAction.Metadata;
    WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, FireAction);

    //  Insert the Singe's Vis Tree right after the Wait For Effect Action
    VisMgr.ConnectAction(MarkerStart, VisualizationTree, false, WaitAction);

    // Main part of Merge Vis is done, now we just tidy up the ending part. 
    // As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
    // Cycle through Marker Actions we got earlier and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
    foreach MarkerActions(FindAction)
    {
        MarkerAction = X2Action_MarkerNamed(FindAction);

        if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
        {
            //  TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
            if (MarkerEnd != none)
            {
                //  "tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are fully visualized.
                VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
                VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
            }
            else
            {
                VisMgr.GetAllLeafNodes(BuildTree, FindActions);
                VisMgr.ConnectAction(MarkerAction, BuildTree,,, FindActions);
            }
            break;
        }
    }
}

static function EventListenerReturn AbilityTriggerEventListener_Multitasking(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    AbilityState = XComGameState_Ability(CallbackData);

    if (AbilityContext.InputContext.PrimaryTarget.ObjectID != AbilityContext.InputContext.SourceObject.ObjectID)
        return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);

    return ELR_NoInterrupt;
}

static function EventListenerReturn AbilityTriggerEventListener_ChasingAttack(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Ability         CallbackAbilityState;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Unit            Attacker;
    local XComGameState_Unit            TargetUnit;
    local X2AbilityTemplate             AbilityTemplate;
    local bool bDealsDamage;
    
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        AbilityState = XComGameState_Ability(EventData);
        CallbackAbilityState = XComGameState_Ability(CallbackData);
        Attacker = XComGameState_Unit(EventSource);
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CallbackAbilityState.OwnerStateObject.ObjectID));
        TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
        if (AbilityState != none && CallbackAbilityState != none && Attacker != none && SourceUnit != none && TargetUnit != none)
        {
            if (AbilityState.IsAbilityInputTriggered())
            {
                if (SourceUnit.IsEnemyUnit(TargetUnit) && SourceUnit.IsFriendlyUnit(Attacker) && SourceUnit.ObjectID != Attacker.ObjectID)
                {
                    AbilityTemplate = AbilityState.GetMyTemplate();
                    bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);
                    if (AbilityTemplate.Hostility == eHostility_Offensive && bDealsDamage)
                    {
                        if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit, SourceUnit) == 'AA_Success')
                            CallbackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false);
                    }

                }
            }

        }
    }

    return ELR_NoInterrupt;
}