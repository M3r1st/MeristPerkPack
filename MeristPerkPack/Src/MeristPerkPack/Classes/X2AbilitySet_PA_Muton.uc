class X2AbilitySet_PA_Muton extends X2Ability_Extended;

var config array<name> ExcessiveForce_RifleCategories;
var config array<name> ExcessiveForce_CannonCategories;
var config array<name> ChargeIn_RifleCategories;
var config array<name> Barbarian_RifleCategories;

var privatewrite name PersonalShieldEffectName;

var localized string CripplingBlow_DebuffText;
var localized string HunterDedication_BuffText;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(PersonalShield());
    Templates.AddItem(Aegis());
    Templates.AddItem(HardenedShield());
    Templates.AddItem(BayonetAttack());
    Templates.AddItem(BayonetCharge());
    Templates.AddItem(Counterattack());
    /*>>*/Templates.AddItem(CounterattackAttack());
    Templates.AddItem(CripplingBlow());
    Templates.AddItem(Bladestorm());
    Templates.AddItem(Barbarian());
    Templates.AddItem(ExcessiveForce());
    Templates.AddItem(ChargeIn());
    Templates.AddItem(Shieldbreaker());
    Templates.AddItem(MutonBullRush());
    Templates.AddItem(HunterMark());
    Templates.AddItem(HunterWatchfulEye());
    /*>>*/Templates.AddItem(HunterWatchfulEyePassive());
    Templates.AddItem(HunterDedication());
    Templates.AddItem(StayFrosty());
    /*>>*/Templates.AddItem(StayFrostyPassive());

    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PA_MutonPunch_Anims', "M31_PA_Mutons.Anims.AS_MutonPunch"));

    return Templates;
}

static function X2DataTemplate PersonalShield()
{
    local X2AbilityTemplate         Template;
    local array<name>               SkipExclusions;
    local X2Effect_PersonalShield   Effect;

    Template = SelfTargetActivated('M31_PA_PersonalShield', "img:///UILibrary_MZChimeraIcons.Ability_Phalanx", false);

    SetAbilityShotHUDPriority(Template, ePriorityType_None, eCost_Single, eHostility_Defensive);
    Template.Hostility = eHostility_Defensive;

    if (`GetConfigBool("M31_PA_PersonalShield_bAllowWhileDisoriented"))
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddCooldown(Template, `GetConfigInt("M31_PA_PersonalShield_Cooldown"));
    AddActionPointCost(Template, eCost_Single);

    Effect = new class'X2Effect_PersonalShield';
    Effect.EffectName = default.PersonalShieldEffectName;
    Effect.ShieldAmount = `GetConfigArrayInt("M31_PA_PersonalShield_ShieldAmount");
    Effect.ShieldPriority = `GetConfigInt("M31_PA_PersonalShield_ShieldPriority");
    Effect.bGetShieldAmountFromArmor = true;
    Effect.AddAdditionalShieldAmount('M31_PA_HardenedShield', `GetConfigInt("M31_PA_HardenedShield_ShieldAmount"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_PersonalShield_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_PersonalShield'.default.strFriendlyDesc, Template.IconImage,, , Template.AbilitySourceName);
    Effect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(Effect);

    Template.CustomFireAnim = 'HL_SignalPositive';

    Template.BuildVisualizationFn = PersonalShield_BuildVisualization;

    return Template;
}

simulated function PersonalShield_BuildVisualization(XComGameState VisualizeGameState)
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
    local X2AbilityTemplate Template;
    local X2Effect_PA_Aegis Effect;

    Template = Passive('M31_PA_Aegis', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_aegis", false, true);

    Effect = new class'X2Effect_PA_Aegis';
    Effect.DamageReduction = `GetConfigInt("M31_PA_Aegis_DamageReduction");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_PA_PersonalShield');

    return Template;
}

static function X2AbilityTemplate HardenedShield()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_HardenedShield    Effect;

    Template = Passive('M31_PA_HardenedShield', "img:///UILibrary_PerkIcons.UIPerk_extrapadding", false, true);

    Effect = new class'X2Effect_PA_HardenedShield';
    Effect.CritResistance = `GetConfigInt("M31_PA_HardenedShield_CritResistance");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_PA_PersonalShield');

    return Template;
}

static function X2AbilityTemplate BayonetAttack()
{
    local X2AbilityTemplate             Template;
    local array<name>                   SkipExclusions;
    local X2AbilityCost_ActionPoints    ActionPointCost;

    Template = StandardMelee('M31_PA_Bayonet', "img:///UILibrary_PerkIcons.UIPerk_muton_bayonet", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Melee, eCost_SingleConsumeAll, eHostility_Offensive);

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_PA_Bladestorm');
    Template.AbilityCosts.AddItem(ActionPointCost);

    Template.bShowActivation = false;

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}


static function X2AbilityTemplate BayonetCharge()
{
    local X2AbilityTemplate Template;
    local array<name>       SkipExclusions;

    Template = MovingMelee('M31_PA_BayonetCharge', "img:///UILibrary_LWAlienPack.LWCenturion_AbilityBayonetCharge32", false, true);

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    SetAbilityShotHUDPriority(Template, ePriorityType_Melee, eCost_SingleConsumeAll, eHostility_Offensive);

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    if (`GetConfigBool("M31_PA_BayonetCharge_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Template.bShowActivation = false;

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate Counterattack()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_Counterattack CounterattackEffect;

    Template = Passive('M31_PA_Counterattack', "img:///UILibrary_PerkIcons.UIPerk_muton_counterattack", false, true);

    CounterattackEffect = new class'X2Effect_PA_Counterattack';
    CounterattackEffect.DodgeBase = `GetConfigInt("M31_PA_Counterattack_Dodge");
    CounterattackEffect.DodgeReductionPerHit = `GetConfigInt("M31_PA_Counterattack_Dodge_ReductionPerHit");
    CounterattackEffect.ActivationsPerTurn = `GetConfigInt("M31_PA_Counterattack_ActivationsPerTurn");
    CounterattackEffect.bOnlyOnEnemyTurn = `GetConfigBool("M31_PA_Counterattack_bOnlyOnEnemyTurn");
    CounterattackEffect.BuildPersistentEffect(1, true, false);
    CounterattackEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(CounterattackEffect);

    Template.AdditionalAbilities.AddItem('M31_PA_Counterattack_Attack');

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate CounterattackAttack()
{
    local X2AbilityTemplate Template;
    local array<name>       SkipExclusions;

    Template = StandardMelee('M31_PA_Counterattack_Attack', "img:///UILibrary_PerkIcons.UIPerk_muton_counterattack", false, true);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AbilityTriggers.Length = 0;
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    class'X2Effect_Counterattack'.static.AddCounterattackActionPointCost(Template);

    Template.MergeVisualizationFn = class'X2Effect_Counterattack'.static.CounterAttack_MergeVisualization_MrNice;

    Template.bShowActivation = false;

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate CripplingBlow()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PersistentStatChange Effect;
    local array<name>                   SkipExclusions;

    Template = MovingMelee('M31_PA_CripplingBlow', "img:///UILibrary_XPerkIconPack.UIPerk_knife_crit", false);

    SetAbilityShotHUDPriority(Template, ePriorityType_Melee, eCost_SingleConsumeAll, eHostility_Offensive);

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddCooldown(Template, `GetConfigInt("M31_PA_CripplingBlow_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Effect = new class'X2Effect_PersistentStatChange';
    Effect.EffectName = 'HamstringEffect';
    Effect.EffectRank = 2;
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_CripplingBlow_AimPenalty"));
    Effect.AddPersistentStatChange(eStat_Defense, -1 * `GetConfigInt("M31_PA_CripplingBlow_DefensePenalty"));
    Effect.AddPersistentStatChange(eStat_Dodge, -1 * `GetConfigInt("M31_PA_CripplingBlow_DodgePenalty"));
    Effect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_CripplingBlow_MobilityPenalty"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_CripplingBlow_Duration"), `GetConfigBool("M31_PA_CripplingBlow_bInfiniteDuration"), false, true, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, default.CripplingBlow_DebuffText, Template.IconImage,,, Template.AbilitySourceName);
    Effect.DuplicateResponse = (`GetConfigBool("M31_PA_CripplingBlow_bAllowStack") ? eDupe_Allow : eDupe_Refresh);
    Template.AddTargetEffect(Effect);

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate Bladestorm()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_Bladestorm', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, false);

    Template.AdditionalAbilities.AddItem('Bladestorm');

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate Barbarian()
{
    local X2AbilityTemplate Template;
    local X2Effect_PA_Barbarian Effect;

    Template = Passive('M31_PA_Barbarian', "img:///UILibrary_MZChimeraIcons.Ability_Knife", false, true);

    Effect = new class'X2Effect_PA_Barbarian';
    Effect.AimBonus = `GetConfigInt("M31_PA_Barbarian_AimBonus");
    Effect.CritBonus = `GetConfigInt("M31_PA_Barbarian_CritBonus");
    Effect.CritCategories = default.Barbarian_RifleCategories;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
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

    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.ExcessiveForce_RifleCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('TraverseFire');

    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.ExcessiveForce_CannonCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

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

    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.ChargeIn_RifleCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate Shieldbreaker()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_Shieldbreaker Effect;
    
    Template = Passive('M31_PA_Shieldbreaker', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_parry", false, true);

    Effect = new class'X2Effect_PA_Shieldbreaker';
    Effect.ChangeHitResults[eHit_Graze] = eHit_Success;
    Effect.ChangeHitResults[eHit_Deflect] = eHit_Success;
    Effect.ChangeHitResults[eHit_Reflect] = eHit_Success;
    Effect.ChangeHitResults[eHit_Parry] = eHit_Success;
    Effect.ChangeHitResults[eHit_CounterAttack] = eHit_Success;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate MutonBullRush()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local array<name>                       SkipExclusions;
    local X2Effect_Stunned                  StunnedEffect;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = MovingMelee('M31_PA_MutonBullRush', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_bullrush", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_MutonBullRush_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_MutonBullRush_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    AddCooldown(Template, `GetConfigInt("M31_PA_MutonBullRush_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_MutonBullRush_StunDuration"), 100, false);
    StunnedEffect.bRemoveWhenSourceDies = false;
    Template.AddTargetEffect(StunnedEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_MutonBullRush_Damage");
    DamageEffect.bIgnoreBaseDamage = true;
    Template.AddTargetEffect(DamageEffect);

    Template.bAllowBonusWeaponEffects = false;

    SetFireAnim(Template, 'FF_MutonPunch');
    Template.bOverrideMeleeDeath = true;

    Template.AdditionalAbilities.AddItem('M31_PA_MutonPunch_Anims');

    return Template;
}

static function X2AbilityTemplate HunterMark()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_HunterMark    Effect;
    local X2Condition_UnitEffectsWithAbilitySource EffectCondition;

    Template = SelfTargetActivated('M31_PA_HunterMark', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_thisonesmine", false);

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddExcludeEffect(class'X2Effect_PA_HunterMark'.default.EffectName, 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(EffectCondition);

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
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Effect_PA_HunterMark'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate HunterWatchfulEye()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    Template = Attack('M31_PA_HunterWatchfulEye', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_watchfuleye", false, true);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;

    Template.AbilityTriggers.Length = 0;
    AddOverwatchTriggers(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    // Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_HunterWatchfulEye_Activations', `GetConfigInt("M31_PA_HunterWatchfulEye_ActivationsPerTurn"));

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(class'X2Effect_PA_HunterMark'.default.EffectName, 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);
    AddBladestormMark(Template, 'M31_PA_HunterWatchfulEye_MarkTarget');

    AddAmmoCost(Template, 1);

    Template.AdditionalAbilities.AddItem('M31_PA_HunterWatchfulEye_Passive');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate HunterWatchfulEyePassive()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_HunterWatchfulEye_Passive', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_watchfuleye", false, true);

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate HunterDedication()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_HunterDedication  Effect;

    Template = SelfTargetActivated('M31_PA_HunterDedication', "img:///UILibrary_MeristOtherPerkIcons.Perk_Ph_Dedication", false);

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
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.HunterDedication_BuffText, Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate StayFrosty()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_Visibility            VisibilityCondition;

    Template = Attack('M31_PA_StayFrosty', "img:///KetarosPkg_Abilities.UIPerk_shootingtarget", false, true);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = `GetConfigBool("M31_PA_StayFrosty_bReactionFire");
    Template.AbilityToHitCalc = ToHitCalc;

    Template.AbilityTriggers.Length = 0;
    AddOverwatchTriggers(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_StayFrosty_Counter', `GetConfigInt("M31_PA_StayFrosty_ActivationsPerTurn"));

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
    AddBladestormMark(Template, 'M31_PA_StayFrosty_MarkTarget');

    AddAmmoCost(Template, 1);

    Template.AdditionalAbilities.AddItem('M31_PA_StayFrosty_Passive');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate StayFrostyPassive()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_StayFrosty_Passive', "img:///KetarosPkg_Abilities.UIPerk_shootingtarget", false, true);

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate ChargeAndShoot()
{
    local X2AbilityTemplate         Template;
    local X2Condition_CanAffordCost CostCondition;

    Template = MovingMelee('M31_PA_ChargeAndShoot', "", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Melee, eCost_SingleConsumeAll, eHostility_Offensive);

    CostCondition = new class'X2Condition_CanAffordCost';
    CostCondition.AbilityName = 'M31_PA_ChargeAndShoot2';
    CostCondition.bValidateAmmoCost = true;
    Template.AbilityShooterConditions.AddItem(CostCondition);
    Template.AddShooterEffectExclusions();

    AddCooldown(Template, `GetConfigInt("M31_PA_ChargeAndShoot_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Template.DamagePreviewFn = ChargeAndShootDamagePreview;
    Template.PostActivationEvents.AddItem('M31_PA_ChargeAndShoot2');

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    return Template;
}

static function X2AbilityTemplate ChargeAndShoot2()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;

    Template = Attack('M31_PA_ChargeAndShoot2', "", false, true);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.AbilityTriggers.Length = 0;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'M31_PA_ChargeAndShoot2';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
    Trigger.ListenerData.Priority = 80;
    Template.AbilityTriggers.AddItem(Trigger);

    AddAmmoCost(Template, 1);

    Template.bShowActivation = false;

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

function bool ChargeAndShootDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    return ChainShot_DamagePreview_Static('M31_PA_ChargeAndShoot2', AbilityState, TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
}

defaultproperties
{
    PersonalShieldEffectName = M31_PA_PersonalShield
}