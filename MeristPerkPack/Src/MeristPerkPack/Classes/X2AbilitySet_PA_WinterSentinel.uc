class X2AbilitySet_PA_WinterSentinel extends X2Ability_Extended config(GameData_SoldierSkills);

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

var config array<name> Ballista_Templates;
var config array<name> FrostGrenades;

var localized string MetabolicBoost_BuffText;
var localized string RebelYell_BuffText;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Hide());
    Templates.AddItem(Entwine());
    Templates.AddItem(ReinforcedScales());
    Templates.AddItem(GlacialArmor());
    Templates.AddItem(Dominance());
        Templates.AddItem(DominancePassive());
    Templates.AddItem(Indomitable());
    Templates.AddItem(RagingSerpent());

    Templates.AddItem(Vigilance());
        Templates.AddItem(VigilanceLeadTheTarget());
        Templates.AddItem(VigilanceLeadTheTargetAttack());
    Templates.AddItem(Fracture());
    Templates.AddItem(AlloyedCores());
    Templates.AddItem(HeavyOrdnance());
    Templates.AddItem(DragonSlayer());

    Templates.AddItem(WinterWarfare());
    Templates.AddItem(WinterSoldier());
    Templates.AddItem(ChillingMist());
        Templates.AddItem(ChillingMistAttack());
    Templates.AddItem(StupidSexySnake());
        Templates.AddItem(StupidSexySnakePassive());
    Templates.AddItem(RebelYell());
    Templates.AddItem(NorthernWinds());
        Templates.AddItem(NorthernWindsPassive());
    Templates.AddItem(MetabolicBoost());
    Templates.AddItem(ThrillOfTheHunt());

    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PA_WS_AnimSets', "M31_PA_Vipers.Anims.AS_Sentinel"));

    Templates.AddItem(BallistaPassive());
    Templates.AddItem(BoltToHitBonus());

    Templates.AddItem(BoltMaelstrom());
        Templates.AddItem(BoltMaelstromPassive());
        Templates.AddItem(BoltMaelstromLTT());
        Templates.AddItem(BoltMaelstromLTTAttack());

    Templates.AddItem(BoltFrost());
        Templates.AddItem(BoltFrostLTT());
        Templates.AddItem(BoltFrostLTTAttack());

    Templates.AddItem(BoltShred());
        Templates.AddItem(BoltShredLTT());
        Templates.AddItem(BoltShredLTTAttack());

    Templates.AddItem(BoltRupture());
        Templates.AddItem(BoltRuptureLTT());
        Templates.AddItem(BoltRuptureLTTAttack());

    Templates.AddItem(BoltStun());
        Templates.AddItem(BoltStunLTT());
        Templates.AddItem(BoltStunLTTAttack());
    
    Templates.AddItem(BoltCrit());
        Templates.AddItem(BoltCritLTT());
        Templates.AddItem(BoltCritLTTAttack());

    Templates.AddItem(BoltFire());
        Templates.AddItem(BoltFireLTT());
        Templates.AddItem(BoltFireLTTAttack());

    Templates.AddItem(BoltPsi());
        Templates.AddItem(BoltPsiLTT());
        Templates.AddItem(BoltPsiLTTAttack());

    Templates.AddItem(BoltPoison());
        Templates.AddItem(BoltPoisonLTT());
        Templates.AddItem(BoltPoisonLTTAttack());

    Templates.AddItem(BoltRad());
        Templates.AddItem(BoltRadLTT());
        Templates.AddItem(BoltRadLTTAttack());
    return Templates;
}

static function X2AbilityTemplate Hide()
{
    local X2AbilityTemplate         Template;
    local X2Effect_DefensiveBonus   Effect;
    local X2Effect_HealOnMissionEnd HealEffect;

    Template = Passive('M31_PA_WS_Hide', "img:///UILibrary_PerkIcons.UIPerk_takecover", false, true);

    Effect = new class'X2Effect_DefensiveBonus';
    Effect.DamageReduction = `GetConfigInt("M31_PA_WS_Hide_DamageReduction");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    HealEffect = new class'X2Effect_HealOnMissionEnd';
    HealEffect.bApplyToSelf = true;
    HealEffect.HealAmount = `GetConfigInt("M31_PA_WS_Hide_PaddingHP");
    HealEffect.BuildPersistentEffect(1, true, true);
    Template.AddTargetEffect(HealEffect);

    return Template;
}

static function X2AbilityTemplate Entwine()
{
    local X2AbilityTemplate     Template;
    local X2Effect_PA_Entwine   Effect;

    Template = Passive('M31_PA_WS_Entwine', "img:///UILibrary_MZChimeraIcons.Ability_TightSqueeze", false, true);

    Effect = new class'X2Effect_PA_Entwine';
    Effect.BindDodgeBonus = `GetConfigInt("M31_PA_WS_Entwine_DodgeBonus");
    Effect.BindDamageBonus = `GetConfigInt("M31_PA_WS_Entwine_BindDamageBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ReinforcedScales()
{
    local X2AbilityTemplate         Template;
    local X2Effect_DefensiveBonus   Effect;

    Template = Passive('M31_PA_WS_ReinforcedScales', "img:///UILibrary_PerkIcons.UIPerk_shieldwall", false, true);
    
    Effect = new class'X2Effect_DefensiveBonus';
    Effect.EffectName = 'M31_PA_WS_ReinforcedScales';
    Effect.CritResistance = `GetConfigInt("M31_PA_WS_ReinforcedScales_CritResistance");
    Effect.DamageReduction = `GetConfigInt("M31_PA_WS_ReinforcedScales_DamageReduction");
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate GlacialArmor()
{
    local X2AbilityTemplate             Template;
    local X2Effect_WS_GlacialArmor      Effect;

    Template = Passive('M31_PA_WS_GlacialArmor', "img:///UILibrary_PerkIcons.UIPerk_absorption_fields", false, true);

    Effect = new class'X2Effect_WS_GlacialArmor';
    Effect.ArmorBonus = `GetConfigInt("M31_PA_WS_GlacialArmor_ArmorBonus");
    Effect.DodgeBonus = `GetConfigInt("M31_PA_WS_GlacialArmor_DodgeBonus");
    Effect.DamageReduction = `GetConfigInt("M31_PA_WS_GlacialArmor_DamageReduction");
    Effect.DamageReductionPrc = `GetConfigInt("M31_PA_WS_GlacialArmor_DamageReduction_Prc");
    Effect.bAllowWhileBurning = `GetConfigBool("M31_PA_WS_GlacialArmor_bAllowWhileBurning");
    Effect.ActivationsPerTurn = `GetConfigInt("M31_PA_WS_GlacialArmor_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Dominance()
{
    local X2AbilityTemplate                 Template;
    local array<name>                       SkipExclusions;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_SkirmisherInterrupt      InterruptEffect;

    Template = SelfTargetTrigger('M31_PA_WS_Dominance', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_interrupt");

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    AddCooldown(Template, 1);

    if (`GetConfigBool("M31_PA_WS_Dominance_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_WS_Dominance_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.BoundName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 45;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_Dominance;
    Template.AbilityTriggers.AddItem(Trigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeStunned = true;
    UnitPropertyCondition.ExcludePanicked = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    InterruptEffect = new class'X2Effect_SkirmisherInterrupt';
    InterruptEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(InterruptEffect);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    // Template.BuildInterruptGameStateFn = 

    Template.AdditionalAbilities.AddItem('M31_PA_WS_Dominance_Passive');

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_Dominance(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit    SourceUnit;
    local XComGameState         NewGameState;
    local XComGameState_Ability AbilityState;

    AbilityState = XComGameState_Ability(CallbackData);
    SourceUnit = XComGameState_Unit(EventSource);

    `assert(SourceUnit != none);

    if (`TACTICALRULES.GetUnitActionTeam() == SourceUnit.GetTeam())
        return ELR_NoInterrupt;

    if (AbilityState.CanActivateAbilityForObserverEvent(SourceUnit) == 'AA_Success')
    {
        if (AbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false))
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.ObjectID));
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
            `TACTICALRULES.InterruptInitiativeTurn(NewGameState, SourceUnit.GetGroupMembership().GetReference());
            `TACTICALRULES.SubmitGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate DominancePassive()
{
    return Passive('M31_PA_WS_Dominance_Passive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_interrupt", false, true);
}

static function X2AbilityTemplate Indomitable()
{
    local X2AbilityTemplate         Template;
    local X2Effect_DefensiveBonus   Effect;

    Template = Passive('M31_PA_WS_Indomitable', "img:///KetarosPkg_Abilities.UIPerk_ShieldWings", false, true);
    
    Effect = new class'X2Effect_DefensiveBonus';
    Effect.DamageReduction = `GetConfigInt("M31_PA_WS_Indomitable_DamageReduction");
    Effect.AddPersistentStatChange(eStat_HP, float(`GetConfigInt("M31_PA_WS_Indomitable_HPBonus")));
    Effect.AddPersistentStatChange(eStat_Mobility, float(`GetConfigInt("M31_PA_WS_Indomitable_MobilityBonus")));
    Effect.AddPersistentStatChange(eStat_Dodge, float(`GetConfigInt("M31_PA_WS_Indomitable_DodgeBonus")));
    Effect.AddPersistentStatChange(eStat_Will, float(`GetConfigInt("M31_PA_WS_Indomitable_WillBonus")));
    Effect.AddPersistentStatChange(eStat_Defense, float(`GetConfigInt("M31_PA_WS_Indomitable_DefenseBonus")));
    Effect.AddPersistentStatChange(eStat_ArmorMitigation, float(`GetConfigInt("M31_PA_WS_Indomitable_ArmorBonus")), MODOP_Addition);
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate RagingSerpent()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Effect_Knockback                KnockbackEffect;
    local array<name>                       SkipExclusions;

    Template = MovingMelee('M31_PA_WS_RagingSerpent', "img:///UILibrary_SOCombatEngineer.UIPerk_bullrush", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_WS_RagingSerpent_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_WS_RagingSerpent_CritBonus");
    Template.AbilityToHitCalc = ToHitCalc;

    if (`GetConfigBool("M31_PA_WS_RagingSerpent_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_WS_RagingSerpent_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeLargeUnits = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    AddCooldown(Template, `GetConfigInt("M31_PA_WS_RagingSerpent_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_RagingSerpent_StunDuration"), 100, false));

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_WS_RagingSerpent_Damage");
    Template.AddTargetEffect(DamageEffect);

    KnockbackEffect = new class'X2Effect_Knockback';
    KnockbackEffect.KnockbackDistance = 18;
    KnockbackEffect.bKnockbackDestroysNonFragile = false;
    KnockbackEffect.OnlyOnDeath = true;
    Template.AddTargetEffect(KnockbackEffect);

    SetFireAnim(Template, 'HL_M31_Rush');
    Template.bOverrideMeleeDeath = true;

    Template.AdditionalAbilities.AddItem('M31_PA_WS_AnimSets');

    return Template;
}

static function X2AbilityTemplate Vigilance()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PersistentStatChange Effect;

    Template = Passive(default.LeadTheTargetRequiredAbilityName, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_squadsightprotocol", false, true);
    
    Effect = new class'X2Effect_PersistentStatChange';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.AddPersistentStatChange(eStat_SightRadius, `GetConfigInt("M31_PA_WS_Vigilance_SightRangeBonus"));
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem(GetLTTName(default.LeadTheTargetRequiredAbilityName));

    return Template;
}

static function X2AbilityTemplate VigilanceLeadTheTarget()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_AbilityProperty       AbilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ReserveActionPoints      ReservePointsEffect;
    local X2Effect_WS_LTTMark               MarkEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, GetLTTName(default.LeadTheTargetRequiredAbilityName));

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_snapshot";
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
    Template.HideErrors.AddItem('AA_WeaponIncompatible');
    Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
    Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
    Template.HideErrors.AddItem('AA_AbilityUnavailable');
    Template.Hostility = eHostility_Neutral;

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 1;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(default.LeadTheTargetRequiredAbilityName);
    Template.AbilityShooterConditions.Additem(AbilityCondition);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    MarkEffect = new class'X2Effect_WS_LTTMark';
    MarkEffect.EffectName = GetLTTMarkName(default.LeadTheTargetRequiredAbilityName);
    MarkEffect.AbilityToTrigger = GetLTTAttackName(default.LeadTheTargetRequiredAbilityName);
    MarkEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
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

    if (`GetConfigBool("M31_PA_WS_Vigilance_bUseReserveAP"))
    {
        ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
        ReservePointsEffect.ReserveType = default.LeadTheTargetReserveActionName;
        Template.AddShooterEffect(ReservePointsEffect);
    }
    
    Template.AbilityToHitCalc = default.DeadEye;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.bSkipFireAction = true;

    Template.AdditionalAbilities.AddItem(GetLTTAttackName(default.LeadTheTargetRequiredAbilityName));

    return Template;
}

static function X2AbilityTemplate VigilanceLeadTheTargetAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, GetLTTAttackName(default.LeadTheTargetRequiredAbilityName));

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_snapshot";
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(GetLTTMarkName(default.LeadTheTargetRequiredAbilityName), 'AA_MissingRequiredEffect');

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    AddBladestormMark(Template, GetLTTAttackName(default.LeadTheTargetRequiredAbilityName));

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

    if (`GetConfigBool("M31_PA_WS_Vigilance_bUseReserveAP"))
    {
        ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
        ReserveActionPointCost.iNumPoints = 1;
        ReserveActionPointCost.AllowedTypes.AddItem(default.LeadTheTargetReserveActionName);
        Template.AbilityCosts.AddItem(ReserveActionPointCost);
    }

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
        
    Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
    Template.bUsesFiringCamera = true;
    Template.CinescriptCameraType = "StandardGunFiring";

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    Template.AssociatedPassives.AddItem('HoloTargeting');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bShowActivation = true;

    Template.bCrossClassEligible = false;

    return Template;
}

static function X2AbilityTemplate Fracture()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_Fracture              Effect;

    Template = Passive('M31_PA_WS_Fracture', "img:///UILibrary_SOCombatEngineer.UIPerk_fracture", false, true);
    
    Effect = new class'X2Effect_WS_Fracture';
    Effect.AimBonus = `GetConfigInt("M31_PA_WS_Fracture_AimBonus");
    Effect.ShredBonus = `GetConfigInt("M31_PA_WS_Fracture_ShredBonus");
    Effect.bApplyToFlanked = `GetConfigBool("M31_PA_WS_Fracture_bAppliesAgainstFlanked");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate AlloyedCores()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_AlloyedCores              Effect;

    Template = Passive('M31_PA_WS_AlloyedCores', "img:///UILibrary_PerkIcons.UIPerk_throughthewall", false, true);
    
    Effect = new class'X2Effect_WS_AlloyedCores';
    Effect.Range = `GetConfigInt("M31_PA_WS_AlloyedCores_Range");
    Effect.CritBonus = `GetConfigInt("M31_PA_WS_AlloyedCores_CritBonus");
    Effect.PierceBonus = `GetConfigInt("M31_PA_WS_AlloyedCores_PierceBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate HeavyOrdnance()
{
    local X2AbilityTemplate Template;

    Template = Passive(default.HeavyOrdnanceAbilityName, "img:///UILibrary_PerkIcons.UIPerk_heavy_rockets", false, true);
    
    return Template;
}

static function X2AbilityTemplate DragonSlayer()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_DragonSlayer          Effect;

    Template = Passive('M31_PA_WS_DragonSlayer', "img:///KetarosPkg_Abilities.UIPerk_diablo", false, false);

    Effect = new class'X2Effect_WS_DragonSlayer';
    Effect.DamageBonusToUnflankable = `GetConfigFloat("M31_PA_WS_DragonSlayer_DamageBonusPrc_Unflankable");
    Effect.DamageBonusToLarge = `GetConfigFloat("M31_PA_WS_DragonSlayer_DamageBonusPrc_Large");
    Effect.BuildPersistentEffect(1, true, false);
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

    Template = Passive('M31_PA_WS_WinterWarfare', "img:///UILibrary_MZChimeraIcons.Ability_HeavyOrdinance", false, true);
    
    CostEffect = new class'XMBEffect_DoNotConsumeAllPoints';
    CostEffect.AbilityNames = class'X2DLCInfo_MeristPerkPack'.default.GrenadeAbilities;
    Condition = new class'XMBCondition_WeaponName';
    Condition.IncludeWeaponNames = default.FrostGrenades;
    Condition.bCheckAmmo = true;
    CostEffect.AbilityTargetConditions.AddItem(Condition);
    CostEffect.BuildPersistentEffect(1, true, false);
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
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_WS_WinterSoldier', "img:///UILibrary_DLC2Images.UIPerk_frostbomb", false, false);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('Frostbomb'));

    return Template;
}

static function X2AbilityTemplate ChillingMist()
{
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_PA_WS_ChillingMist', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);
        
    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_PA_WS_ChillingMist';
    WeaponEffect.AttackName = 'M31_PA_WS_ChillingMist_Attack';
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_ChillingMist_Attack');

    return Template;
}

static function X2AbilityTemplate ChillingMistAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
        'M31_PA_WS_ChillingMist_Attack',
        "img:///UILibrary_DLC2Images.UIPerk_freezingbreath",
        GetChillingMistHypothermiaEffect()
    );

    return Template;
}

static function MZ_Effect_Hypothermia GetChillingMistHypothermiaEffect()
{
    local MZ_Effect_Hypothermia         HypothermiaEffect;
    local X2Condition_AbilityProperty   AbilityCondition;

    HypothermiaEffect = class'MZ_Effect_Hypothermia'.static.CreateHypothermiaEffect(`GetConfigInt("M31_PA_WS_ChillingMist_Duration"));
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_WS_ChillingMist');
    HypothermiaEffect.TargetConditions.AddItem(AbilityCondition);

    return HypothermiaEffect;
}

static function X2AbilityTemplate StupidSexySnake()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsWithAbilitySource EffectCondition;
    local X2Effect_WS_StupidSexySnake       Effect;

    Template = SelfTargetTrigger('M31_PA_WS_StupidSexySnake', "img:///KetarosPkg_Abilities.UIPerk_holdtheline");

    Template.BuildVisualizationFn = none;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_BuffMe';
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BuffMe;
    Trigger.ListenerData.Priority = 50;
    Template.AbilityTriggers.AddItem(Trigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeInStasis = false;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddExcludeEffect(class'X2Effect_WS_StupidSexySnake'.default.EffectName, 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(EffectCondition);

    Effect = new class'X2Effect_WS_StupidSexySnake';
    Effect.AimBonus = `GetConfigInt("M31_PA_WS_StupidSexySnake_AimBonus");
    Effect.CritBonus = `GetConfigInt("M31_PA_WS_StupidSexySnake_CritBonus");
    Effect.DodgeBonus = `GetConfigInt("M31_PA_WS_StupidSexySnake_DodgeBonus");
    Effect.Radius = `GetConfigFloat("M31_PA_WS_StupidSexySnake_Radius");
    Effect.bIncludeOwner = false;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_WS_StupidSexySnake'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_StupidSexySnake_Passive');

    return Template;
}

static function X2AbilityTemplate StupidSexySnakePassive()
{
    return Passive('M31_PA_WS_StupidSexySnake_Passive', "img:///KetarosPkg_Abilities.UIPerk_holdtheline", false, true);
}

static function X2AbilityTemplate RebelYell()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2Effect_WS_RebelYell                 Effect;
    local X2Effect_RemoveEffects                RemoveEffect;

    Template = SelfTargetActivated('M31_PA_WS_RebelYell', "img:///UILibrary_LWAlienPack.LWCenturion_AbilityWarCry64");
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
    
    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_PA_WS_RebelYell_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = !`GetConfigBool("M31_PA_WS_RebelYell_bAppliesToPanicked");
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = !`GetConfigBool("M31_PA_WS_RebelYell_bAppliesToMindControlled");
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeStunned = !`GetConfigBool("M31_PA_WS_RebelYell_bAppliesToStunned");
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    AddCooldown(Template, `GetConfigInt("M31_PA_WS_RebelYell_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_WS_RebelYell_Charges"));
    AddActionPointCost(Template, eCost_Single);

    RemoveEffect = new class'X2Effect_RemoveEffects';
    if (`GetConfigBool("M31_PA_WS_RebelYell_bClearsPanic"))
        RemoveEffect.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
    if (`GetConfigBool("M31_PA_WS_RebelYell_bClearsMindControl"))
        RemoveEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
    if (`GetConfigBool("M31_PA_WS_RebelYell_bClearsStun"))
        RemoveEffect.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);
    Template.AddMultiTargetEffect(RemoveEffect);

    Effect = new class'X2Effect_WS_RebelYell';

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
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.RebelYell_BuffText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);
    Template.AddMultiTargetEffect(Effect);

    Template.bShowActivation = false;
    Template.bSkipFireAction = false;

    Template.BuildVisualizationFn = RebelYell_BuildVisualization;

    Template.ConcealmentRule = eConceal_Never;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_WS_AnimSets');

    return Template;
}

function RebelYell_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      Context;
    local StateObjectReference              InteractingUnitRef;
    local VisualizationActionMetadata       EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation            PlayAnimationAction;
    local X2Action_PlaySoundAndFlyOver      SoundAndFlyover, SoundAndFlyoverTarget;
    local XComGameState_Ability             Ability;
    local XComGameState_Effect              EffectState;
    local XComGameState_Unit                UnitState;
    
    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = Context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Xcom);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_M31_Yell';
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
                SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, Context, false, TargetTrack.LastActionAdded));
                SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Xcom);
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

    Template = SelfTargetActivated('M31_PA_WS_MetabolicBoost', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
    Template.Hostility = eHostility_Defensive;

    DodgeEffect = new class'X2Effect_ToHitModifier';
    DodgeEffect.AddEffectHitModifier(eHit_Graze, `GetConfigInt("M31_PA_WS_MetabolicBoost_DodgeBonus"), Template.LocFriendlyName);
    DodgeEffect.AddEffectHitModifier(eHit_Success, -1 * `GetConfigInt("M31_PA_WS_MetabolicBoost_DefenseBonus"), Template.LocFriendlyName);
    DodgeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    DodgeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.MetabolicBoost_BuffText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(DodgeEffect);

    RemoveEffects = class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType();
    RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddTargetEffect(RemoveEffects);

    HealingEffect = new class'X2Effect_ApplyHeal';
    HealingEffect.HealAmount = `GetConfigInt("M31_PA_WS_MetabolicBoost_Heal");
    HealingEffect.MaxHealAmount = `GetConfigInt("M31_PA_WS_MetabolicBoost_MaxHeal");
    HealingEffect.HealthRegeneratedName = 'M31_PA_WS_MetabolicBoost_Healing';
    Template.AddTargetEffect(HealingEffect);

    AddCooldown(Template, `GetConfigInt("M31_PA_WS_MetabolicBoost_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_WS_MetabolicBoost_Charges"));

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;

    return Template;
}

static function X2AbilityTemplate ThrillOfTheHunt()
{
    local X2AbilityTemplate     Template;
    local X2Effect_WS_Thrill    Effect;

    Template = Passive('M31_PA_WS_ThrillOfTheHunt', "img:///UILibrary_MeristPerkIcons.UIPerk_WS_Thrill", false, true);
        
    Effect = new class'X2Effect_WS_Thrill';
    Effect.AimBonusPerStack = `GetConfigInt("M31_PA_WS_ThrillOfTheHunt_AimPerStack");
    Effect.CritBonusPerStack = `GetConfigInt("M31_PA_WS_ThrillOfTheHunt_CritPerStack");
    Effect.MaxStacks = `GetConfigInt("M31_PA_WS_ThrillOfTheHunt_MaxStacks"); 
    Effect.bExcludeRobotic = `GetConfigBool("M31_PA_WS_ThrillOfTheHunt_bExcludeRobotic");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_WS_Thrill'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate NorthernWinds()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2AbilityTrigger_EventListener    EventListener;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffects           UnitEffects;
    local X2Effect_ApplyScalingDamage       DamageEffect;

    Template = SelfTargetTrigger('M31_PA_WS_NorthernWinds', "img:///UILibrary_MeristPerkIcons.UIPerk_WS_NorthernWinds");

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_PA_WS_NorthernWinds_Radius"));
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.EventID = 'PlayerTurnEnded';
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    // EventListener.ListenerData.Priority = 50;
    EventListener.ListenerData.Filter = eFilter_Player;
    Template.AbilityTriggers.AddItem(EventListener);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = !`GetConfigBool("M31_PA_WS_NorthernWinds_bAllowWhileConcealed");
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    if (!`GetConfigBool("M31_PA_WS_NorthernWinds_bAllowWhileBurning"))
    {
        UnitEffects = new class'X2Condition_UnitEffects';
        UnitEffects.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
        Template.AbilityShooterConditions.AddItem(UnitEffects);
    }

    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    if (`GetConfigBool("M31_PA_WS_NorthernWinds_bRequireVisibility"))
        Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);

    class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_WS_NorthernWinds_Damage");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_WS_NorthernWinds_DamagePerRank");
    DamageEffect.EffectDamageValue.DamageType = 'Frost';
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.DamageTypes.AddItem('Frost');
    Template.AddMultiTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(new class'X2Effect_RevealSourceUnit');

    Template.bSkipExitCoverWhenFiring = true;
    Template.ActionFireClass = class'X2Action_Fire_Wave_NoTarget';

    Template.AdditionalAbilities.AddItem('M31_PA_WS_NorthernWinds_Passive');

    return Template;
}

static function X2AbilityTemplate NorthernWindsPassive()
{
    return Passive('M31_PA_WS_NorthernWinds_Passive', "img:///UILibrary_MeristPerkIcons.UIPerk_WS_NorthernWinds", false, true);
}


static function X2AbilityTemplate BallistaPassive()
{
    local X2AbilityTemplate Template;

    Template = Passive(default.BallistaPassiveAbilityName, "", false, false);

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    return Template;
}

static function X2AbilityTemplate BoltToHitBonus()
{
    local X2AbilityTemplate             Template;
    local X2Effect_WS_BoltToHitBonus    Effect;

    Template = Passive(default.BoltToHitBonusAbilityName, "", false, false);

    Effect = new class'X2Effect_WS_BoltToHitBonus';
    Effect.BuildPersistentEffect(1, true, false);

    Effect.AddToHitBonus(default.BoltCritName, 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus"));
    Effect.AddToHitBonus(default.BoltCritName, 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus_Ballista", true));
    Effect.AddToHitBonus(GetLTTAttackName(default.BoltCritName), 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus"));
    Effect.AddToHitBonus(GetLTTAttackName(default.BoltCritName), 0, `GetConfigInt("M31_PA_WS_Bolt_Crit_CritBonus_Ballista", true));

    Effect.AddToHitBonus(default.BoltRuptureName, 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus"));
    Effect.AddToHitBonus(default.BoltRuptureName, 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus_Ballista", true));
    Effect.AddToHitBonus(GetLTTAttackName(default.BoltRuptureName), 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus"));
    Effect.AddToHitBonus(GetLTTAttackName(default.BoltRuptureName), 0, `GetConfigInt("M31_PA_WS_Bolt_Rupture_CritBonus_Ballista", true));

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
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    Template = BoltAttack(default.BoltMaelstromName, default.BoltMaelstromIcon);

    // StandardAim = X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc);
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.OverrideFinalHitChanceFns.AddItem(class'XCGS_Effect_WS_Maelstrom'.static.OverrideHitChance);
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bBypassSustainEffects = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    Template.AdditionalAbilities.AddItem(name(default.BoltMaelstromName $ "_Passive"));

    return Template;
}

static function X2AbilityTemplate BoltMaelstromPassive()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WS_Maelstrom     Effect;

    Template = Passive(name(default.BoltMaelstromName $ "_Passive"), default.BoltMaelstromIcon);
    
    Effect = new class'X2Effect_WS_Maelstrom';
    Effect.AllowedAbilities.AddItem(default.BoltMaelstromName);
    Effect.AllowedAbilities.AddItem(GetLTTAttackName(default.BoltMaelstromName));
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate BoltMaelstromLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltMaelstromName, default.BoltMaelstromIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltMaelstromLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    Template = BoltLeadTheTargetAttack(default.BoltMaelstromName, default.BoltMaelstromIcon);

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.OverrideFinalHitChanceFns.AddItem(class'XCGS_Effect_WS_Maelstrom'.static.OverrideHitChance);
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bBypassSustainEffects = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    return Template;
}

static function X2AbilityTemplate BoltFrost()
{
    local X2AbilityTemplate             Template;
    local X2Effect_DLC_Day60Freeze      FreezeEffect;
    local X2Effect                      FreezeCleanseEffect;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    Template = BoltAttack(default.BoltFrostName, default.BoltFrostIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltFrostName, true);

    FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect(false);
    Template.AddTargetEffect(FreezeEffect);
    Template.AddMultiTargetEffect(FreezeEffect);

    FreezeCleanseEffect = class'BitterfrostHelper'.static.FreezeCleanse(false);
    Template.AddTargetEffect(FreezeCleanseEffect);
    Template.AddMultiTargetEffect(FreezeCleanseEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltFrostName;
    DamageEffect.bExplosiveDamage = false;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FireFrost');

    return Template;
}

static function X2AbilityTemplate BoltFrostLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltFrostName, default.BoltFrostIcon);

    // Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltFrostName);
    
    return Template;
}

static function X2AbilityTemplate BoltFrostLTTAttack()
{
    local X2AbilityTemplate             Template;
    local X2Effect_DLC_Day60Freeze      FreezeEffect;
    local X2Effect                      FreezeCleanseEffect;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    Template = BoltLeadTheTargetAttack(default.BoltFrostName, default.BoltFrostIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltFrostName);

    FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect(false);
    Template.AddTargetEffect(FreezeEffect);
    Template.AddMultiTargetEffect(FreezeEffect);

    FreezeCleanseEffect = class'BitterfrostHelper'.static.FreezeCleanse(false);
    Template.AddTargetEffect(FreezeCleanseEffect);
    Template.AddMultiTargetEffect(FreezeCleanseEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltFrostName;
    DamageEffect.bExplosiveDamage = false;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FireFrost');

    return Template;
}

static function X2AbilityTemplate BoltShred()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;
    local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;

    Template = BoltAttack(default.BoltShredName, default.BoltShredIcon);

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

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bShredBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltShredLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltShredName, default.BoltShredIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltShredLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_WS_ApplyBoltDamage       DamageEffect;
    local X2Effect_ApplyDirectionalWorldDamage  WorldDamage;

    Template = BoltLeadTheTargetAttack(default.BoltShredName, default.BoltShredIcon);

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

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bShredBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    return Template;
}

static function X2AbilityTemplate BoltRupture()
{
    local X2AbilityTemplate             Template;
    local X2Effect_WS_ApplyBoltDamage   DamageEffect;

    Template = BoltAttack(default.BoltRuptureName, default.BoltRuptureIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bRuptureBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltRuptureLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltRuptureName, default.BoltRuptureIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltRuptureLTTAttack()
{
    local X2AbilityTemplate             Template;
    local X2Effect_WS_ApplyBoltDamage   DamageEffect;

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
    local X2Condition_UnitSize              SmallUnitCondition;
    local X2Condition_UnitSize              LargeUnitCondition;

    Template = BoltAttack(default.BoltStunName, default.BoltStunIcon);

    SmallUnitCondition = new class'X2Condition_UnitSize';
    SmallUnitCondition.iMaxUnitSize = 1;

    LargeUnitCondition = new class'X2Condition_UnitSize';
    LargeUnitCondition.iMinUnitSize = 2;

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    StunnedEffect.TargetConditions.AddItem(SmallUnitCondition);
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), false, false, false, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage"));
    BleedingEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);


    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration_Ballista"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetBallistaCondition());
    StunnedEffect.TargetConditions.AddItem(SmallUnitCondition);
    Template.AddTargetEffect(StunnedEffect);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDurationLarge_Ballista"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetBallistaCondition());
    StunnedEffect.TargetConditions.AddItem(LargeUnitCondition);
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty_Ballista"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), false, false, false, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage_Ballista"));
    BleedingEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltStunLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltStunName, default.BoltStunIcon);
    
    return Template;
}

static function X2AbilityTemplate BoltStunLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Persistent               StunnedEffect;
    local X2Effect_PersistentStatChange     CrippleEffect;
    local X2Effect_Persistent               BleedingEffect;
    local X2Condition_UnitSize              SmallUnitCondition;
    local X2Condition_UnitSize              LargeUnitCondition;

    Template = BoltLeadTheTargetAttack(default.BoltStunName, default.BoltStunIcon);

    SmallUnitCondition = new class'X2Condition_UnitSize';
    SmallUnitCondition.iMaxUnitSize = 1;

    LargeUnitCondition = new class'X2Condition_UnitSize';
    LargeUnitCondition.iMinUnitSize = 2;

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    StunnedEffect.TargetConditions.AddItem(SmallUnitCondition);
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), false, false, true, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage"));
    BleedingEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);


    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDuration_Ballista"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetBallistaCondition());
    StunnedEffect.TargetConditions.AddItem(SmallUnitCondition);
    Template.AddTargetEffect(StunnedEffect);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_StunDurationLarge_Ballista"), 100, false);
    StunnedEffect.TargetConditions.AddItem(GetBallistaCondition());
    StunnedEffect.TargetConditions.AddItem(LargeUnitCondition);
    Template.AddTargetEffect(StunnedEffect);

    CrippleEffect = new class'X2Effect_PersistentStatChange';
    CrippleEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_WS_Bolt_Stun_MobilityPenalty_Ballista"));
    CrippleEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), false, false, true, eGameRule_PlayerTurnBegin);
    CrippleEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(CrippleEffect);

    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Stun_BleedDamage_Ballista"));
    BleedingEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(BleedingEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate BoltCrit()
{
    local X2AbilityTemplate             Template;
    local X2Effect_WS_ApplyBoltDamage   DamageEffect;

    Template = BoltAttack(default.BoltCritName, default.BoltCritIcon);

    DamageEffect = new class'X2Effect_WS_ApplyBoltDamage';
    DamageEffect.bCritBolt = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

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
    local X2AbilityTemplate             Template;
    local X2Effect_WS_ApplyBoltDamage   DamageEffect;

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
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_Burning              BurningEffect;
    local X2Effect_ApplyFireToWorld     WorldEffect;

    Template = BoltAttack(default.BoltFireName, default.BoltFireIcon);
    
    SetBoltRadiusMultiTarget(Template, default.BoltPsiName);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance");
    BurningEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(BurningEffect);
    Template.AddMultiTargetEffect(BurningEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread_Ballista"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance_Ballista");
    BurningEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(BurningEffect);
    Template.AddMultiTargetEffect(BurningEffect);

    WorldEffect = new class'X2Effect_ApplyFireToWorld';
    WorldEffect.bApplyOnMiss = true;
    WorldEffect.bApplyToWorldOnMiss = true;
    WorldEffect.bApplyOnHit = true;
    WorldEffect.bApplyToWorldOnHit = true;
    Template.AddMultiTargetEffect(WorldEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltFireName;
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FireFire');

    return Template;
}

static function X2AbilityTemplate BoltFireLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltFireName, default.BoltFireIcon);

    // Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltFireName);
    
    return Template;
}

static function X2AbilityTemplate BoltFireLTTAttack()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_Burning              BurningEffect;
    local X2Effect_ApplyFireToWorld     WorldEffect;

    Template = BoltLeadTheTargetAttack(default.BoltFireName, default.BoltFireIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltPsiName);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance");
    BurningEffect.TargetConditions.AddItem(GetNoBallistaCondition());
    Template.AddTargetEffect(BurningEffect);
    Template.AddMultiTargetEffect(BurningEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Ballista"), `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnDamage_Spread_Ballista"));
    BurningEffect.ApplyChance = `GetConfigInt("M31_PA_WS_Bolt_Fire_BurnChance_Ballista");
    BurningEffect.TargetConditions.AddItem(GetBallistaCondition());
    Template.AddTargetEffect(BurningEffect);
    Template.AddMultiTargetEffect(BurningEffect);

    WorldEffect = new class'X2Effect_ApplyFireToWorld';
    WorldEffect.bApplyOnMiss = true;
    WorldEffect.bApplyToWorldOnMiss = true;
    WorldEffect.bApplyOnHit = true;
    WorldEffect.bApplyToWorldOnHit = true;
    Template.AddMultiTargetEffect(WorldEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltFireName;
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FireFire');

    return Template;
}

static function X2AbilityTemplate BoltPsi()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    Template = BoltAttack(default.BoltPsiName, default.BoltPsiIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltPsiName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPsiName;
    DamageEffect.bExplosiveDamage = true;
    DamageEffect.EnvironmentalDamageAmount = `GetConfigInt("M31_PA_WS_Bolt_Psi_EnvDamage");
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FirePsi');

    return Template;
}

static function X2AbilityTemplate BoltPsiLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltPsiName, default.BoltPsiIcon);

    // Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltPsiName);

    return Template;
}

static function X2AbilityTemplate BoltPsiLTTAttack()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    Template = BoltLeadTheTargetAttack(default.BoltPsiName, default.BoltPsiIcon);
    
    SetBoltRadiusMultiTarget(Template, default.BoltPsiName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPsiName;
    DamageEffect.bExplosiveDamage = true;
    DamageEffect.EnvironmentalDamageAmount = `GetConfigInt("M31_PA_WS_Bolt_Psi_EnvDamage");
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FirePsi');

    return Template;
}

static function X2AbilityTemplate BoltPoison()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Persistent               DisorientedEffect;
    local X2Effect_Persistent               PoisonedEffect;
    local X2Effect_ApplyPoisonToWorld       WorldEffect;

    Template = BoltAttack(default.BoltPoisonName, default.BoltPoisonIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltPoisonName);

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
    Template.AddTargetEffect(PoisonedEffect);
    Template.AddMultiTargetEffect(PoisonedEffect);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddTargetEffect(DisorientedEffect);
    Template.AddMultiTargetEffect(DisorientedEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPoisonName;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    WorldEffect = new class'X2Effect_ApplyPoisonToWorld';
    WorldEffect.bApplyOnMiss = true;
    WorldEffect.bApplyToWorldOnMiss = true;
    WorldEffect.bApplyOnHit = true;
    WorldEffect.bApplyToWorldOnHit = true;
    Template.AddMultiTargetEffect(WorldEffect);

    // SetFireAnim(Template, 'FF_FirePoison');

    return Template;
}

static function X2AbilityTemplate BoltPoisonLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltPoisonName, default.BoltPoisonIcon);

    return Template;
}

static function X2AbilityTemplate BoltPoisonLTTAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Persistent               DisorientedEffect;
    local X2Effect_Persistent               PoisonedEffect;
    local X2Effect_ApplyPoisonToWorld       WorldEffect;

    Template = BoltLeadTheTargetAttack(default.BoltPoisonName, default.BoltPoisonIcon);
    
    SetBoltRadiusMultiTarget(Template, default.BoltPoisonName);

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
    Template.AddTargetEffect(PoisonedEffect);
    Template.AddMultiTargetEffect(PoisonedEffect);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddTargetEffect(DisorientedEffect);
    Template.AddMultiTargetEffect(DisorientedEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltPoisonName;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    WorldEffect = new class'X2Effect_ApplyPoisonToWorld';
    WorldEffect.bApplyOnMiss = true;
    WorldEffect.bApplyToWorldOnMiss = true;
    WorldEffect.bApplyOnHit = true;
    WorldEffect.bApplyToWorldOnHit = true;
    Template.AddMultiTargetEffect(WorldEffect);

    // SetFireAnim(Template, 'FF_FirePoison');

    return Template;
}

static function X2AbilityTemplate BoltRad()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local array<X2Effect>               RadiationEffects;
    local X2Effect                      Effect;

    Template = BoltAttack(default.BoltRadName, default.BoltRadIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltRadName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    RadiationEffects = class'M31_Helpers'.static.CreateRadiationEffects();
    foreach RadiationEffects(Effect)
    {
        Template.AddTargetEffect(Effect);
        Template.AddMultiTargetEffect(Effect);
    }

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltRadName;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FireRad');

    return Template;
}

static function X2AbilityTemplate BoltRadLTT()
{
    local X2AbilityTemplate Template;

    Template = BoltLeadTheTarget(default.BoltRadName, default.BoltRadIcon);

    // Template.AbilityMultiTargetStyle = GetBoltRadiusMultiTarget(default.BoltRadName);

    return Template;
}

static function X2AbilityTemplate BoltRadLTTAttack()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local array<X2Effect>               RadiationEffects;
    local X2Effect                      Effect;

    Template = BoltLeadTheTargetAttack(default.BoltRadName, default.BoltRadIcon);

    SetBoltRadiusMultiTarget(Template, default.BoltRadName);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    // Template.AddTargetEffect(new class'X2Effect_WS_ApplyBoltDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    RadiationEffects = class'M31_Helpers'.static.CreateRadiationEffects();
    foreach RadiationEffects(Effect)
    {
        Template.AddTargetEffect(Effect);
        Template.AddMultiTargetEffect(Effect);
    }

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = default.BoltRadName;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    // SetFireAnim(Template, 'FF_FireRad');
    
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

    Template.ShotHUDPriority = GetBoltHUDPriority(TemplateName);

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

    Template.AdditionalAbilities.AddItem(GetLTTName(TemplateName));
    Template.AdditionalAbilities.AddItem(default.BoltToHitBonusAbilityName);

    Template.TargetingMethod = class'X2TargetingMethod_TopDown';
    
    return Template;
}

static function X2AbilityTemplate BoltLeadTheTarget(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_AbilityProperty       AbilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ReserveActionPoints      ReservePointsEffect;
    local X2Effect_WS_LTTMark               MarkEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, GetLTTName(TemplateName));

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
    Template.HideErrors.AddItem('AA_WeaponIncompatible');
    Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
    Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
    Template.HideErrors.AddItem('AA_AbilityUnavailable');
    Template.Hostility = eHostility_Neutral;

    Template.ShotHUDPriority = GetBoltHUDPriority(TemplateName);

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(default.LeadTheTargetRequiredAbilityName);
    Template.AbilityShooterConditions.Additem(AbilityCondition);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    MarkEffect = new class'X2Effect_WS_LTTMark';
    MarkEffect.EffectName = GetLTTMarkName(TemplateName);
    MarkEffect.AbilityToTrigger = GetLTTAttackName(TemplateName);
    MarkEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
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

    if (`GetConfigBool("M31_PA_WS_Vigilance_bUseReserveAP"))
    {
        ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
        ReservePointsEffect.ReserveType = default.LeadTheTargetReserveActionName;
        Template.AddShooterEffect(ReservePointsEffect);
    }
    
    Template.AbilityToHitCalc = default.DeadEye;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bSkipFireAction = true;
    Template.bShowActivation = true;

    Template.bCrossClassEligible = false;

    Template.AdditionalAbilities.AddItem(GetLTTAttackName(TemplateName));

    Template.TargetingMethod = class'X2TargetingMethod_TopDown';

    return Template;
}

static function X2AbilityTemplate BoltLeadTheTargetAttack(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, GetLTTAttackName(TemplateName));

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    Template.AddShooterEffectExclusions();

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(GetLTTMarkName(TemplateName), 'AA_MissingRequiredEffect');

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    AddBladestormMark(Template, GetLTTAttackName(TemplateName));

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

    if (`GetConfigBool("M31_PA_WS_Vigilance_bUseReserveAP"))
    {
        ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
        ReserveActionPointCost.iNumPoints = 1;
        ReserveActionPointCost.AllowedTypes.AddItem(default.LeadTheTargetReserveActionName);
        Template.AbilityCosts.AddItem(ReserveActionPointCost);
    }

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
        
        if (Template.DataName != GetLTTName(DefaultAbilityName))
            SharedAbilities.AddItem(GetLTTName(DefaultAbilityName));
        else
            bFreeCost = true;

        if (Template.DataName != GetLTTAttackName(DefaultAbilityName))
            SharedAbilities.AddItem(GetLTTAttackName(DefaultAbilityName));

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

static function name GetLTTName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_LTT");
}

static function name GetLTTAttackName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_LTT_Attack");
}

static function name GetLTTMarkName(name DefaultAbilityName)
{
    return name(DefaultAbilityName $ "_LTT_Mark");
}

static function int GetBoltHUDPriority(name DefaultAbilityName)
{
    switch (DefaultAbilityName)
    {
        case default.BoltMaelstromName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 4;
        case default.BoltFrostName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 5;
        case default.BoltShredName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 1;
        case default.BoltRuptureName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 5;
        case default.BoltStunName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 3;
        case default.BoltCritName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 2;
        case default.BoltFireName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 5;
        case default.BoltPsiName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 5;
        case default.BoltPoisonName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 5;
        case default.BoltRadName:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 5;
        default:
            return class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
    }
}

static function SetBoltRadiusMultiTarget(out X2AbilityTemplate Template, name DefaultAbilityName, optional bool bExcludeNonUnits)
{
    local X2AbilityToHitCalc_MultiStandardAim   ToHitCalc;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;

    ToHitCalc = new class'X2AbilityToHitCalc_MultiStandardAim';
    ToHitCalc.bMultiGuaranteedHit = true;
    ToHitCalc.bMultiAllowCrit = false;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `GetConfigFloat(DefaultAbilityName $ "_Radius");
    RadiusMultiTarget.AddAbilityBonusRadius(default.BallistaPassiveAbilityName,
        `GetConfigFloat(DefaultAbilityName $ "_Radius_Ballista") - `GetConfigFloat(DefaultAbilityName $ "_Radius"));
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = !bExcludeNonUnits;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    Template.ModifyNewContextFn = class'X2AbilitySet_PA_Harrier'.static.HarrierShot_ModifyActivatedAbilityContext;
}


static function X2Condition_ValidWeapon GetBallistaCondition()
{
    local X2Condition_ValidWeapon Condition;

    Condition = new class'X2Condition_ValidWeapon';
    Condition.AllowedWeaponTemplates = default.Ballista_Templates;

    return Condition;
}

static function X2Condition_ValidWeapon GetNoBallistaCondition()
{
    local X2Condition_ValidWeapon Condition;

    Condition = new class'X2Condition_ValidWeapon';
    Condition.ExcludedWeaponTemplates = default.Ballista_Templates;

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
    BoltMaelstromIcon = "img:///UILibrary_PerkIcons.UIPerk_stabilize"

    BoltFrostName = M31_PA_WS_Bolt_Frost
    BoltFrostIcon = "img:///UILibrary_DLC2Images.PerkIcons.UIPerk_freezingbreath"

    BoltShredName = M31_PA_WS_Bolt_Shred
    BoltShredIcon = "img:///UILibrary_PerkIcons.UIPerk_demolition"

    BoltRuptureName = M31_PA_WS_Bolt_Rupture
    BoltRuptureIcon = "img:///UILibrary_PerkIcons.UIPerk_bulletshred"

    BoltStunName = M31_PA_WS_Bolt_Stun
    BoltStunIcon = "img:///UILibrary_PerkIcons.UIPerk_schism"

    BoltCritName = M31_PA_WS_Bolt_Crit
    BoltCritIcon = "img:///UILibrary_PerkIcons.UIPerk_hithurts"

    BoltFireName = M31_PA_WS_Bolt_Fire
    BoltFireIcon = "img:///UILibrary_PerkIcons.UIPerk_flamethrower"

    BoltPsiName = M31_PA_WS_Bolt_Psi
    BoltPsiIcon = "img:///UILibrary_PerkIcons.UIPerk_psychic"

    BoltPoisonName = M31_PA_WS_Bolt_Poison
    BoltPoisonIcon = "img:///UILibrary_FavidsPerkPack.UIPerk_SaltInTheWound"

    BoltRadName = M31_PA_WS_Bolt_Rad
    BoltRadIcon = "img:///KetarosPkg_Abilities.UIPerk_radiation"
}