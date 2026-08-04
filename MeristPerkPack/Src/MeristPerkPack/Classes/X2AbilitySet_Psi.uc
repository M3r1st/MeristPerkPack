class X2AbilitySet_Psi extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> LetItGo_AllowedAbilities;

var privatewrite name SpectralZombieLinkName;
var privatewrite name SpectralLancerLinkName;
var privatewrite name SpectralCreatureLinkName;

var privatewrite name SpectralZombieSpawnName;
var privatewrite name SpectralLancerSpawnName;
var privatewrite name SpectralCreatureSpawnName;

var privatewrite name ImprovedSpectresAbilityName;
var privatewrite name KillDuplicateSpectresEventName;
var privatewrite name PsiZombieLinkName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_Psi_Animations', ""));
    
    // Templates.AddItem(Meltdown());

    Templates.AddItem(PsionicReaper());
    Templates.AddItem(SectoidPsionicReaper());
    // Templates.AddItem(FrostChainLightning());
    Templates.AddItem(NullWard());
    Templates.AddItem(ShadowPhase());
    Templates.AddItem(ShadowPhaseFortress());
    Templates.AddItem(TeleportAlly());

    Templates.AddItem(Compulsion());
    Templates.AddItem(GreatestChampion());

    Templates.AddItem(PsiStealth('M31_Psi_Stealth', ""));
    Templates.AddItem(PsiStealth('M31_Psi_Blend', "", true));

    Templates.AddItem(Cryotherapy());
    Templates.AddItem(MassCryotherapy());

    Templates.AddItem(LetItGo());

    Templates.AddItem(ImprovedSpectres());

    Templates.AddItem(SummonSpectralZombie());
        Templates.AddItem(KillSpectralZombie());
        Templates.AddItem(CreateSpectreLink(default.SpectralZombieLinkName, "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate", default.SpectralZombieLinkName));

    Templates.AddItem(SummonSpectralLancer());
        Templates.AddItem(KillSpectralLancer());
        Templates.AddItem(CreateSpectreLink(default.SpectralLancerLinkName, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_possess", default.SpectralLancerLinkName));

    Templates.AddItem(SummonSpectralCreature());
        Templates.AddItem(KillSpectralCreature());
        Templates.AddItem(CreateSpectreLink(default.SpectralCreatureLinkName, "img:///UILibrary_PerkIcons.UIPerk_chryssalid_burrow", default.SpectralCreatureLinkName));
    
    Templates.AddItem(SpectralUnitInit('M31_Psi_SpectralZombieInit', "", 'ADD_SpectralFrost_Start', 'ADD_SpectralFrost_Stop'));
    Templates.AddItem(SpectralUnitInit('M31_Psi_SpectralLancerInit', "", 'ADD_SpectralArmy_Restart', 'ADD_SpectralArmy_Stop'));
    Templates.AddItem(SpectralUnitInit('M31_Psi_SpectralCreatureInit', "", '', ''));

    return Templates;
}

static function X2AbilityTemplate Meltdown()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyDamage_Meltdown DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_Meltdown');

    Template.IconImage = "";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Psi_Meltdown_Cooldown"));

    DamageEffect = new class'X2Effect_ApplyDamage_Meltdown';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTag = 'M31_Psi_Meltdown';
    DamageEffect.AdditionalDamageTag = 'M31_Psi_MeltdownArmor';
    Template.AddTargetEffect(DamageEffect);

    if (`GetConfigBool("M31_Psi_Meltdown_bApplyRadiation"))
    {
        class'M31_Helpers'.static.AddRadiationToTarget(Template);
    }

    Template.ActivationSpeech = 'Mindblast';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CustomFireAnim = 'HL_M31_Psi_ProjectileMedium';
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bShowActivation = true;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function X2AbilityTemplate PsionicReaper()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PsiDamageBonus   Effect;

    Template = Passive('M31_PsionicReaper', "", false, true);
    
    Effect = new class'X2Effect_PsiDamageBonus';
    Effect.bMatchSourceWeapon = true;
    Effect.bCeiling = false;
    Effect.PsiFactor_Damage = `GetConfigInt("M31_PsionicReaper_DamagePsiFactor");
    Effect.PsiFactor_Pierce = `GetConfigInt("M31_PsionicReaper_PiercePsiFactor");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SectoidPsionicReaper()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PsiDamageBonus   Effect;

    Template = Passive('M31_PA_PsionicReaper', "", false, true);
    
    Effect = new class'X2Effect_PsiDamageBonus';
    Effect.bMatchSourceWeapon = true;
    Effect.bCeiling = false;
    Effect.PsiFactor_Damage = `GetConfigInt("M31_PA_PsionicReaper_DamagePsiFactor");
    Effect.PsiFactor_Pierce = `GetConfigInt("M31_PA_PsionicReaper_PiercePsiFactor");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

// static function X2AbilityTemplate FrostChainLightning()
// {
//     local X2AbilityTemplate             Template;
//     local X2Effect_ApplyWeaponDamageExtended    DamageEffect;
//     local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
//     local X2Condition_UnitImmunities    UnitImmunityCondition;

//     `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_FrostChainLightning');

//     Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_amplify";
//     Template.AbilitySourceName = 'eAbilitySource_Psionic';
//     Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
//     Template.Hostility = eHostility_Offensive;

//     Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

//     Template.AbilityToHitCalc = default.DeadEye;
//     Template.AbilityTargetStyle = default.SimpleSingleTarget;

//     RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
//     RadiusMultiTarget.bIgnoreBlockingCover = true;
//     RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
//     RadiusMultiTarget.fTargetRadius = `GetConfigFloat("M31_Psi_FrostChainLightning_Radius");
//     // RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(default.VOLT_TILE_RADIUS) + 0.01;
//     // RadiusMultiTarget.AddAbilityBonusRadius('VoltDangerZone', `TILESTOMETERS(default.VOLT_DANGER_ZONE_BONUS_RADIUS) + 0.01);
//     // RadiusMultiTarget.AddAbilityBonusRadius('TemplarTerror', `TILESTOMETERS(default.VOLT_TERRORIZE_BONUS) + 0.01);
//     Template.AbilityMultiTargetStyle = RadiusMultiTarget;

//     Template.TargetingMethod = class'X2TargetingMethod_AreaTopDown';

//     Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
//     Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    
//     Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
//     Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

//     Template.AddShooterEffectExclusions();

//     UnitImmunityCondition = new class'X2Condition_UnitImmunities';
//     UnitImmunityCondition.AddExcludeDamageType('Frost');
//     UnitImmunityCondition.AddExcludeDamageType('Electrical');
//     UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
//     Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);
//     Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

//     AddActionPointCost(Template, eCost_SingleConsumeAll);
//     AddCooldown(Template, `GetConfigInt("M31_Psi_FrostChainLightning_Cooldown"));
//     AddCharges(Template, `GetConfigInt("M31_Psi_FrostChainLightning_Charges"));

//     class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);
//     class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

//     DamageEffect = new class'X2Effect_ApplyWeaponDamageExtended';
//     DamageEffect.bIgnoreBaseDamage = true;
//     DamageEffect.bIgnoreArmor = true;
//     DamageEffect.DamageTag = 'M31_Psi_FrostChainLightning';
//     DamageEffect.OverrideDamageTypes.AddItem('Frost');
//     DamageEffect.OverrideDamageTypes.AddItem('Electrical');
//     Template.AddTargetEffect(DamageEffect);
//     Template.AddMultiTargetEffect(DamageEffect);

//     Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//     Template.CustomFireAnim = 'HL_M31_Psi_Volt';
//     Template.ActionFireClass = class'X2Action_Fire_Volt';

//     Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//     Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//     Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

//     Template.bShowActivation = true;

//     Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
//     Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//     Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

//     Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

//     return Template;
// }

static function X2AbilityTemplate NullWard()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_PersonalShield           ShieldEffect;

    Template = SelfTargetActivated('M31_Psi_NullWard', "img:///UILibrary_PerkIcons.UIPerk_aethershift", false);

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Defensive);

    Template.Hostility = eHostility_Defensive;

    AddCooldown(Template, `GetConfigInt("M31_Psi_NullWard_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    // UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_Psi_NullWard_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    ShieldEffect = new class'X2Effect_PersonalShield';
    ShieldEffect.EffectName = 'M31_Psi_NullWard';
    ShieldEffect.ShieldAmount = `GetConfigArrayInt("M31_Psi_NullWard_ShieldAmount");
    ShieldEffect.ShieldPriority = `GetConfigInt("M31_Psi_NullWard_ShieldPriority");
    ShieldEffect.bGetShieldAmountFromWeapon = true;
    ShieldEffect.BuildPersistentEffect(`GetConfigInt("M31_Psi_NullWard_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_PersonalShield'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    ShieldEffect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(ShieldEffect);
    Template.AddMultiTargetEffect(ShieldEffect);
        
    Template.BuildVisualizationFn = PsiEnergyShield_BuildVisualization;

    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    return Template;
}

simulated function PsiEnergyShield_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference InteractingUnitRef;
    local VisualizationActionMetadata EmptyTrack;
    local VisualizationActionMetadata ActionMetadata;
    local X2Action_PlayAnimation PlayAnimationAction;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = Context.InputContext.SourceObject;

    // Configure the visualization track for the shooter
    // ****************************************************************************************
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_M31_Psi_EnergyShield';
}

static function X2AbilityTemplate ShadowPhase()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WallPhasing      Effect;

    Template = Passive('M31_ShadowPhase', "img:///UILibrary_PerkIcons.UIPerk_item_wraith", false, true);
    // Thanks, Firaxis.
    Template.bIsPassive = false;

    Effect = new class'X2Effect_WallPhasing';
    Effect.EffectName = 'M31_ShadowPhase';
    Effect.AddTraversalChange(eTraversal_Phasing, true);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.OverrideAbilities.AddItem('WallPhasing');

    return Template;
}

static function X2AbilityTemplate ShadowPhaseFortress()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_ShadowPhaseFortress', "img:///UILibrary_PerkIcons.UIPerk_item_wraith", false, false);

    Template.AdditionalAbilities.AddItem('M31_ShadowPhase');
    Template.AdditionalAbilities.AddItem('Fortress');

    return Template;
}

static function X2AbilityTemplate TeleportAlly()
{
    local X2AbilityTemplate             Template;
    local X2AbilityTarget_TeleportAlly  TeleportAllyTarget;
    local X2Condition_UnitProperty      UnitPropertyCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_TeleportAlly');

    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_teleportally";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_Single, eHostility_Neutral);

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    TeleportAllyTarget = new class'X2AbilityTarget_TeleportAlly';
    TeleportAllyTarget.Range = `TILESTOMETERS(`GetConfigInt("M31_Psi_TeleportAlly_Range"));
    TeleportAllyTarget.bRequireVisibility = `GetConfigBool("M31_Psi_TeleportAlly_bRequireVisibility");
    Template.AbilityTargetStyle = TeleportAllyTarget;
    Template.TargetingMethod = class'X2TargetingMethod_TeleportAlly';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeLargeUnits = true;
    UnitPropertyCondition.ExcludeTurret = true;
    UnitPropertyCondition.RequireSquadmates = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_Psi_TeleportAlly_Cooldown"));

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ModifyNewContextFn = class'X2Ability_ChosenWarlock'.static.TeleportAlly_ModifyActivatedAbilityContext;
    Template.BuildNewGameStateFn = class'X2Ability_ChosenWarlock'.static.TeleportAlly_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_ChosenWarlock'.static.TeleportAlly_BuildVisualization;

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;
    Template.CinescriptCameraType = "ChosenWarlock_TeleportAlly";

    return Template;
}

static function X2AbilityTemplate Compulsion()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_MindControl              MindControlEffect;
    local X2Effect_StunRecover              StunRecoverEffect;
    local X2Condition_UnitEffects           EffectCondition;
    local X2Condition_SoldierAbilities      NoAdvancedEffectCondition;
    local X2Condition_SoldierAbilities      AdvancedEffectCondition;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Effect_Persistent               ActionPointPersistEffect;
    local X2Effect_Psi_GreatestChampion     GreatestChampionEffect;
    local X2AbilityCooldown_Extended        Cooldown;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_Compulsion');

    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mindscorch";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
    StatCheck.BaseValue = `GetConfigInt("M31_Psi_Compulsion_BaseChance");
    Template.AbilityToHitCalc = StatCheck;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_Psi_Compulsion_Cooldown");
    Cooldown.AddCooldownModifier('M31_Psi_GreatestChampion', -1 * `GetConfigInt("M31_Psi_GreatestChampion_CooldownReduction"));
    Template.AbilityCooldown = Cooldown;

    EffectCondition = new class'X2Condition_UnitEffects';
    EffectCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
    Template.AbilityTargetConditions.AddItem(EffectCondition);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Mental');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

    NoAdvancedEffectCondition = new class'X2Condition_SoldierAbilities';
    NoAdvancedEffectCondition.ExcludedAbilities.AddItem('M31_Psi_GreatestChampion');

    AdvancedEffectCondition = new class'X2Condition_SoldierAbilities';
    AdvancedEffectCondition.RequiredAbilities.AddItem('M31_Psi_GreatestChampion');

    MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(0, false, false);
    MindControlEffect.bCanBeRedirected = false;
    MindControlEffect.EffectRemovedFn = CompulsionRemoved;
    MindControlEffect.TargetConditions.AddItem(NoAdvancedEffectCondition);
    Template.AddTargetEffect(MindControlEffect);

    MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(`GetConfigInt("M31_Psi_GreatestChampion_Duration"), false, false);
    MindControlEffect.bCanBeRedirected = false;
    MindControlEffect.EffectRemovedFn = CompulsionRemoved;
    MindControlEffect.TargetConditions.AddItem(AdvancedEffectCondition);
    Template.AddTargetEffect(MindControlEffect);

    StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
    StunRecoverEffect.bCanBeRedirected = false;
    Template.AddTargetEffect(StunRecoverEffect);

    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
    
    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = `GetConfigInt("M31_Psi_GreatestChampion_NumPoints");
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
    ActionPointEffect.bSelectUnit = true;
    Template.AddTargetEffect(ActionPointEffect);

    ActionPointPersistEffect = new class'X2Effect_Persistent';
    ActionPointPersistEffect.EffectName = 'Inspiration';
    ActionPointPersistEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
    ActionPointPersistEffect.bRemoveWhenTargetDies = true;
    ActionPointPersistEffect.TargetConditions.AddItem(NoAdvancedEffectCondition);
    Template.AddTargetEffect(ActionPointPersistEffect);

    ActionPointPersistEffect = new class'X2Effect_Persistent';
    ActionPointPersistEffect.EffectName = 'Inspiration';
    ActionPointPersistEffect.BuildPersistentEffect(1 + `GetConfigInt("M31_Psi_GreatestChampion_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    ActionPointPersistEffect.bRemoveWhenTargetDies = true;
    ActionPointPersistEffect.TargetConditions.AddItem(AdvancedEffectCondition);
    Template.AddTargetEffect(ActionPointPersistEffect);

    GreatestChampionEffect = new class'X2Effect_Psi_GreatestChampion';
    GreatestChampionEffect.DamageBonusPrc = `GetConfigInt("M31_Psi_GreatestChampion_DamageBonusPrc");
    GreatestChampionEffect.DRBonusPrc = `GetConfigInt("M31_Psi_GreatestChampion_DRBonusPrc");
    GreatestChampionEffect.DefensePenalty = `GetConfigInt("M31_Psi_GreatestChampion_DefensePenalty");
    GreatestChampionEffect.DamageImmunities.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType);
    GreatestChampionEffect.DamageImmunities.AddItem('Stun');
    GreatestChampionEffect.DamageImmunities.AddItem('Unconscious');
    GreatestChampionEffect.DamageImmunities.AddItem('Panic');
    GreatestChampionEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
    GreatestChampionEffect.TargetConditions.AddItem(AdvancedEffectCondition);
    Template.AddTargetEffect(GreatestChampionEffect);

    Template.ActivationSpeech = 'Domination';
    Template.SourceMissSpeech = 'SoldierFailsControl';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CustomFireAnim = 'HL_M31_Psi_ProjectileMedium';
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bFrameEvenWhenUnitIsHidden = true;
    Template.bShowActivation = true;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function CompulsionRemoved(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed)
{
    local XComGameState_Unit    TargetUnitState;

    TargetUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (TargetUnitState == none)
        TargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (TargetUnitState != none)
        `XEVENTMGR.TriggerEvent(class'X2Effect_Psi_GreatestChampion'.default.EventName, TargetUnitState, TargetUnitState, NewGameState);
}

static function X2AbilityTemplate GreatestChampion()
{
    local X2AbilityTemplate     Template;
    
    Template = Passive('M31_Psi_GreatestChampion', "img:///UILibrary_XPACK_Common.UIPerk_divinearmor", false, false);

    return Template;
}

static function X2AbilityTemplate PsiStealth(name DataName, string IconImage, optional bool bBlend = false)
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Effect_SustainedStealth     StealthEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_Stealth');

    if (bBlend)
    {
        AddActionPointCost(Template, eCost_Single);
        AddCooldown(Template, `GetConfigInt("M31_Psi_Blend_Cooldown"));
        AddCharges(Template, `GetConfigInt("M31_Psi_Blend_Charges"));

        StealthEffect = new class'X2Effect_SustainedStealth';
        StealthEffect.EffectRemovedFn = class'X2AbilitySet_Merist'.static.Meld_EffectRemoved;
        StealthEffect.BuildPersistentEffect(`GetConfigInt("M31_Psi_Blend_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
        StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, "", Template.IconImage, true);
        StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
        StealthEffect.bRemoveWhenSourceImpaired = `GetConfigBool("M31_Psi_Blend_bRemoveWhenSourceImpaired");
        Template.AddTargetEffect(StealthEffect);
    }
    else
    {
        AddActionPointCost(Template, eCost_SingleConsumeAll);
        AddCooldown(Template, `GetConfigInt("M31_Psi_Stealth_Cooldown"));
        AddCharges(Template, `GetConfigInt("M31_Psi_Stealth_Charges"));

        StealthEffect = new class'X2Effect_SustainedStealth';
        StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
        StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, "", Template.IconImage, true);
        StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
        StealthEffect.bRemoveWhenSourceImpaired = `GetConfigBool("M31_Psi_Stealth_bRemoveWhenSourceImpaired");
        Template.AddTargetEffect(StealthEffect);
    }

    Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

    Template.ActivationSpeech = 'Inspire';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CustomFireAnim = 'HL_M31_Psi_ProjectileMedium';
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bShowActivation = true;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function X2AbilityTemplate Cryotherapy()
{
    local X2AbilityTemplate             Template;
    local X2AbilityPassiveAOE_WeaponRadius  PassiveRadius;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Condition_CanBeHealed       CanBeHealedCondition;
    local X2AbilityCooldown_Extended    AbilityCooldown;
    local X2AbilityCharges              Charges;
    local X2AbilityCost_Charges         ChargeCost;
    local X2Effect_HealFromWeapon       HealEffect;
    local X2Effect_RemoveEffectsByDamageType RemoveEffectsByDamageType;
    local X2Effect_RemoveEffects        RemoveEffects;
    local X2Effect_Persistent           UnconsciousEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_Cryotherapy');

    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_chosenrevive";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;

    PassiveRadius = new class'X2AbilityPassiveAOE_WeaponRadius';
    PassiveRadius.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_Psi_Cryotherapy_Range"));
    Template.AbilityPassiveAOEStyle = PassiveRadius;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = !`GetConfigBool("M31_Psi_Cryotherapy_bStabilize");
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeTurret = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    if (`GetConfigInt("M31_Psi_Cryotherapy_Range") > 0)
    {
        UnitPropertyCondition.RequireWithinRange = true;
        UnitPropertyCondition.WithinRange = `TILESTOUNITS(`GetConfigInt("M31_Psi_Cryotherapy_Range"));
    }
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    CanBeHealedCondition = new class'X2Condition_CanBeHealed';
    CanBeHealedCondition.EffectDamageTypes.AddItem('Frost');
    CanBeHealedCondition.EffectDamageTypes.AddItem('Fire');
    CanBeHealedCondition.EffectNames.AddItem('Freeze');
    Template.AbilityTargetConditions.AddItem(CanBeHealedCondition);

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_Single);

    AbilityCooldown = new class'X2AbilityCooldown_Extended';
    AbilityCooldown.iNumTurns = `GetConfigInt("M31_Psi_Cryotherapy_Cooldown");
    if (`GetConfigBool("M31_Psi_Cryotherapy_bSharedCooldown"))
    {
        AbilityCooldown.AddAdditionalCooldownInfo('M31_Psi_MassCryotherapy', `GetConfigInt("M31_Psi_Cryotherapy_Cooldown"), true);
    }
    Template.AbilityCooldown = AbilityCooldown;

    Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = `GetConfigInt("M31_Psi_Cryotherapy_Charges");
    Charges.AddBonusCharge('M31_Psi_MassCryotherapy', `GetConfigInt("M31_Psi_MassCryotherapy_Charges"));
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    ChargeCost.SharedAbilityCharges.AddItem('M31_Psi_MassCryotherapy');
    Template.AbilityCosts.AddItem(ChargeCost);

    HealEffect = new class'X2Effect_HealFromWeapon';
    HealEffect.HealAmount = `GetConfigArrayInt("M31_Psi_Cryotherapy_HealAmount");
    Template.AddTargetEffect(HealEffect);

    RemoveEffectsByDamageType = new class'X2Effect_RemoveEffectsByDamageType';
    RemoveEffectsByDamageType.DamageTypesToRemove.AddItem('Frost');
    RemoveEffectsByDamageType.DamageTypesToRemove.AddItem('Fire');
    RemoveEffectsByDamageType.EffectNamesToRemove.AddItem('Freeze');
    Template.AddTargetEffect(RemoveEffectsByDamageType);

    if (`GetConfigBool("M31_Psi_Cryotherapy_bStabilize"))
    {
        UnitPropertyCondition = new class'X2Condition_UnitProperty';
        UnitPropertyCondition.ExcludeAlive = false;
        UnitPropertyCondition.ExcludeDead = false;
        UnitPropertyCondition.ExcludeHostileToSource = true;
        UnitPropertyCondition.ExcludeFriendlyToSource = false;
        UnitPropertyCondition.IsBleedingOut = true;
        UnitPropertyCondition.FailOnNonUnits = true;

        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
        RemoveEffects.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddTargetEffect(RemoveEffects);

        UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
        UnconsciousEffect.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddTargetEffect(UnconsciousEffect);
    }

    Template.ActivationSpeech = 'HealingAlly';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CustomFireAnim = 'HL_M31_Psi_SelfCast';
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bShowActivation = true;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function X2AbilityTemplate MassCryotherapy()
{
    local X2AbilityTemplate             Template;
    local X2AbilityPassiveAOE_WeaponRadius  PassiveRadius;
    local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Condition_CanBeHealed       CanBeHealedCondition;
    local X2AbilityCooldown_Extended    AbilityCooldown;
    local X2AbilityCharges              Charges;
    local X2AbilityCost_Charges         ChargeCost;
    local X2Effect_HealFromWeapon       HealEffect;
    local X2Effect_RemoveEffectsByDamageType RemoveEffectsByDamageType;
    local X2Effect_RemoveEffects        RemoveEffects;
    local X2Effect_Persistent           UnconsciousEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_MassCryotherapy');

    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_chosenrevive";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    PassiveRadius = new class'X2AbilityPassiveAOE_WeaponRadius';
    PassiveRadius.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_Psi_MassCryotherapy_Radius"));
    Template.AbilityPassiveAOEStyle = PassiveRadius;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_Psi_MassCryotherapy_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = !`GetConfigBool("M31_Psi_MassCryotherapy_bStabilize");
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeTurret = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    CanBeHealedCondition = new class'X2Condition_CanBeHealed';
    CanBeHealedCondition.EffectDamageTypes.AddItem('Frost');
    CanBeHealedCondition.EffectDamageTypes.AddItem('Fire');
    CanBeHealedCondition.EffectNames.AddItem('Freeze');
    Template.AbilityMultiTargetConditions.AddItem(CanBeHealedCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_SingleConsumeAll);

    AbilityCooldown = new class'X2AbilityCooldown_Extended';
    AbilityCooldown.iNumTurns = `GetConfigInt("M31_Psi_MassCryotherapy_Cooldown");
    if (`GetConfigBool("M31_Psi_Cryotherapy_bSharedCooldown"))
    {
        AbilityCooldown.AddAdditionalCooldownInfo('M31_Psi_Cryotherapy', `GetConfigInt("M31_Psi_MassCryotherapy_Cooldown"), true);
    }
    Template.AbilityCooldown = AbilityCooldown;

    Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = `GetConfigInt("M31_Psi_MassCryotherapy_Charges");
    Charges.AddBonusCharge('M31_Psi_Cryotherapy', `GetConfigInt("M31_Psi_Cryotherapy_Charges"));
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = `GetConfigInt("M31_Psi_MassCryotherapy_ChargeCost");
    ChargeCost.SharedAbilityCharges.AddItem('M31_Psi_Cryotherapy');
    Template.AbilityCosts.AddItem(ChargeCost);

    HealEffect = new class'X2Effect_HealFromWeapon';
    HealEffect.HealAmount = `GetConfigArrayInt("M31_Psi_Cryotherapy_HealAmount");
    Template.AddMultiTargetEffect(HealEffect);

    RemoveEffectsByDamageType = new class'X2Effect_RemoveEffectsByDamageType';
    RemoveEffectsByDamageType.DamageTypesToRemove.AddItem('Frost');
    RemoveEffectsByDamageType.DamageTypesToRemove.AddItem('Fire');
    RemoveEffectsByDamageType.EffectNamesToRemove.AddItem('Freeze');
    Template.AddMultiTargetEffect(RemoveEffectsByDamageType);

    if (`GetConfigBool("M31_Psi_MassCryotherapy_bApplyToSelf"))
    {
        HealEffect = new class'X2Effect_HealFromWeapon';
        HealEffect.HealAmount = `GetConfigArrayInt("M31_Psi_Cryotherapy_HealAmount");
        HealEffect.TargetConditions.AddItem(UnitPropertyCondition);
        HealEffect.TargetConditions.AddItem(CanBeHealedCondition);
        Template.AddTargetEffect(HealEffect);

        RemoveEffectsByDamageType = new class'X2Effect_RemoveEffectsByDamageType';
        RemoveEffectsByDamageType.DamageTypesToRemove.AddItem('Frost');
        RemoveEffectsByDamageType.DamageTypesToRemove.AddItem('Fire');
        RemoveEffectsByDamageType.EffectNamesToRemove.AddItem('Freeze');
        RemoveEffectsByDamageType.TargetConditions.AddItem(UnitPropertyCondition);
        RemoveEffectsByDamageType.TargetConditions.AddItem(CanBeHealedCondition);
        Template.AddTargetEffect(RemoveEffectsByDamageType);
    }

    if (`GetConfigBool("M31_Psi_MassCryotherapy_bStabilize"))
    {
        UnitPropertyCondition = new class'X2Condition_UnitProperty';
        UnitPropertyCondition.ExcludeAlive = false;
        UnitPropertyCondition.ExcludeDead = false;
        UnitPropertyCondition.ExcludeHostileToSource = true;
        UnitPropertyCondition.ExcludeFriendlyToSource = false;
        UnitPropertyCondition.IsBleedingOut = true;
        UnitPropertyCondition.FailOnNonUnits = true;

        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
        RemoveEffects.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddMultiTargetEffect(RemoveEffects);

        UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
        UnconsciousEffect.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddMultiTargetEffect(UnconsciousEffect);
    }

    Template.ActivationSpeech = 'HealingAlly';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CustomFireAnim = 'HL_M31_Psi_Corrupt';
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bShowActivation = true;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function X2AbilityTemplate LetItGo()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_LetItGo', "", false, true);

    return Template;
}

static function X2AbilityTemplate CreateSummonAbility(name DataName, string IconImage)
{
    local X2AbilityTemplate             Template;
    local X2AbilityTarget_Cursor        CursorTarget;
    local X2AbilityMultiTarget_Radius   RadiusMultiTarget;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityToHitCalc = default.DeadEye;

    Template.TargetingMethod = class'X2TargetingMethod_Teleport';

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

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CustomFireAnim = 'HL_M31_Psi_Corrupt';
    Template.CinescriptCameraType = "Warlock_SpectralZombie";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = SpawnUnit_BuildVisualization;

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.ConcealmentRule = eConceal_Never;
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

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

    //Add a look at camera to the spawned units
    //****************************************************************************************
    VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ShowSpawnedUnit', FoundActions);
    FireAction = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', , Context.InputContext.SourceObject.ObjectID);

    if( (FoundActions.Length > 0) &&
        (FireAction != none) )
    {
        ActionMetadata.StateObject_OldState = FoundActions[0].MetaData.StateObject_OldState;
        ActionMetadata.StateObject_NewState = FoundActions[0].MetaData.StateObject_NewState;
        ActionMetadata.VisualizeActor = FoundActions[0].MetaData.VisualizeActor;

        GameStateUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

        if( GameStateUnit != none )
        {
            WorldData = `XWORLD;

            LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, true, FireAction));
            LookAtAction.LookAtLocation = WorldData.GetPositionFromTileCoordinates(GameStateUnit.TileLocation);
            LookAtAction.LookAtDuration = class'X2Ability_ChosenWarlock'.default.CORRESS_LOOKAT_DURATION * (`XPROFILESETTINGS.Data.bEnableZipMode ? class'X2TacticalGameRuleset'.default.ZipModeDelayModifier : 1.0);;
            LookAtAction.BlockUntilActorOnScreen = true;
            LookAtAction.AddInputEvent('Visualizer_AbilityHit');

            ActionMetadata.StateObject_NewState = `XCOMHISTORY.GetGameStateForObjectID( Context.InputContext.SourceObject.ObjectID );
            ActionMetadata.StateObject_OldState = ActionMetadata.StateObject_NewState.GetPreviousVersion( );
            ActionMetadata.VisualizeActor = `XCOMHISTORY.GetVisualizer( Context.InputContext.SourceObject.ObjectID );

            RemoveCamera = X2Action_CameraRemove( class'X2Action_CameraRemove'.static.AddToVisualizationTree( ActionMetadata, Context, true, ActionMetadata.LastActionAdded ) );
            RemoveCamera.CameraTagToRemove = 'AbilityFraming';
        }
    }
}

static function X2AbilityTemplate ImprovedSpectres()
{
    local X2AbilityTemplate Template;
    
    Template = Passive(default.ImprovedSpectresAbilityName, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ghost", false, true);

    return Template;
}

static function X2AbilityTemplate SummonSpectralZombie()
{
    local X2AbilityTemplate     Template;
    local X2Effect_SummonUnit   SpawnUnitEffect;
    
    Template = CreateSummonAbility('M31_Psi_SummonSpectralZombie', "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 3;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Psi_SummonSpectralZombie_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_Psi_SummonSpectralZombie_Charges"));

    SpawnUnitEffect = new class'X2Effect_SummonUnit';
    SpawnUnitEffect.UnitToSpawnName = 'M31_SpectralZombie_M1';
    SpawnUnitEffect.UnitToSpawnNameT2 = 'M31_SpectralZombie_M2';
    SpawnUnitEffect.UnitToSpawnNameT3 = 'M31_SpectralZombie_M3';

    SpawnUnitEffect.AltReqAbilityName = default.ImprovedSpectresAbilityName;
    SpawnUnitEffect.AltUnitToSpawnName = 'M31_AdvSpectralZombie_M1';
    SpawnUnitEffect.AltUnitToSpawnNameT2 = 'M31_AdvSpectralZombie_M2';
    SpawnUnitEffect.AltUnitToSpawnNameT3 = 'M31_AdvSpectralZombie_M3';

    SpawnUnitEffect.NumStartingPoints = 1;
    SpawnUnitEffect.SpawnAnim = 'HL_FrostZombieRise';
    SpawnUnitEffect.LinkName = default.SpectralZombieLinkName;
    SpawnUnitEffect.SpawnUnitValueName = default.SpectralZombieSpawnName;
    Template.AddShooterEffect(SpawnUnitEffect);

    Template.AdditionalAbilities.AddItem('M31_Psi_KillSpectralZombie');
    Template.PostActivationEvents.AddItem(default.KillDuplicateSpectresEventName);

    return Template;
}

static function X2AbilityTemplate KillSpectralZombie()
{
    local X2AbilityTemplate Template;
    
    Template = KillLinkedSpectres('M31_Psi_KillSpectralZombie', "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate", default.SpectralZombieLinkName, default.SpectralZombieSpawnName);

    return Template;
}

static function X2AbilityTemplate SummonSpectralLancer()
{
    local X2AbilityTemplate     Template;
    local X2Effect_SummonUnit   SpawnUnitEffect;
    
    Template = CreateSummonAbility('M31_Psi_SummonSpectralLancer', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_possess");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 2;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Psi_SummonSpectralLancer_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_Psi_SummonSpectralLancer_Charges"));

    SpawnUnitEffect = new class'X2Effect_SummonUnit';
    SpawnUnitEffect.UnitToSpawnName = 'M31_SpectralLancer_M1';
    SpawnUnitEffect.UnitToSpawnNameT2 = 'M31_SpectralLancer_M2';
    SpawnUnitEffect.UnitToSpawnNameT3 = 'M31_SpectralLancer_M3';

    SpawnUnitEffect.AltReqAbilityName = default.ImprovedSpectresAbilityName;
    SpawnUnitEffect.AltUnitToSpawnName = 'M31_AdvSpectralLancer_M1';
    SpawnUnitEffect.AltUnitToSpawnNameT2 = 'M31_AdvSpectralLancer_M2';
    SpawnUnitEffect.AltUnitToSpawnNameT3 = 'M31_AdvSpectralLancer_M3';

    SpawnUnitEffect.NumStartingPoints = 1;
    SpawnUnitEffect.SpawnAnim = 'HL_SpectralArmy_Target';
    SpawnUnitEffect.LinkName = default.SpectralLancerLinkName;
    SpawnUnitEffect.SpawnUnitValueName = default.SpectralLancerSpawnName;
    Template.AddShooterEffect(SpawnUnitEffect);

    Template.AdditionalAbilities.AddItem('M31_Psi_KillSpectralLancer');
    Template.PostActivationEvents.AddItem(default.KillDuplicateSpectresEventName);

    return Template;
}

static function X2AbilityTemplate KillSpectralLancer()
{
    local X2AbilityTemplate Template;
    
    Template = KillLinkedSpectres('M31_Psi_KillSpectralLancer', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_possess", default.SpectralLancerLinkName, default.SpectralLancerSpawnName);

    return Template;
}

static function X2AbilityTemplate SummonSpectralCreature()
{
    local X2AbilityTemplate     Template;
    local X2Effect_SummonUnit   SpawnUnitEffect;
    
    Template = CreateSummonAbility('M31_Psi_SummonSpectralCreature', "img:///UILibrary_PerkIcons.UIPerk_chryssalid_burrow");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    AddActionPointCost(Template, eCost_DoubleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Psi_SummonSpectralCreature_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_Psi_SummonSpectralCreature_Charges"));

    SpawnUnitEffect = new class'X2Effect_SummonUnit';
    SpawnUnitEffect.UnitToSpawnName = 'M31_SpectralCreature_M1';
    SpawnUnitEffect.UnitToSpawnNameT2 = 'M31_SpectralCreature_M2';
    SpawnUnitEffect.UnitToSpawnNameT3 = 'M31_SpectralCreature_M3';

    SpawnUnitEffect.AltReqAbilityName = default.ImprovedSpectresAbilityName;
    SpawnUnitEffect.AltUnitToSpawnName = 'M31_AdvSpectralCreature_M1';
    SpawnUnitEffect.AltUnitToSpawnNameT2 = 'M31_AdvSpectralCreature_M2';
    SpawnUnitEffect.AltUnitToSpawnNameT3 = 'M31_AdvSpectralCreature_M3';

    SpawnUnitEffect.NumStartingPoints = 1;
    SpawnUnitEffect.SpawnAnim = 'NO_CocoonHatch';
    // SpawnUnitEffect.SpawnAnim = 'AHW_SpectralBug';
    SpawnUnitEffect.LinkName = default.SpectralCreatureLinkName;
    SpawnUnitEffect.SpawnUnitValueName = default.SpectralCreatureSpawnName;
    Template.AddShooterEffect(SpawnUnitEffect);

    Template.AdditionalAbilities.AddItem('M31_Psi_KillSpectralCreature');
    Template.PostActivationEvents.AddItem(default.KillDuplicateSpectresEventName);

    return Template;
}

static function X2AbilityTemplate KillSpectralCreature()
{
    local X2AbilityTemplate Template;
    
    Template = KillLinkedSpectres('M31_Psi_KillSpectralCreature', "img:///UILibrary_PerkIcons.UIPerk_chryssalid_burrow", default.SpectralCreatureLinkName, default.SpectralCreatureSpawnName);

    return Template;
}

static function X2AbilityTemplate CreateSpectreLink(name DataName, string IconImage, name LinkName)
{
    local X2AbilityTemplate Template;
    local X2Effect_Persistent SpectralArmyLinkEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    // Create an effect that will be attached to the spawned unit
    SpectralArmyLinkEffect = new class'X2Effect_Persistent';
    SpectralArmyLinkEffect.BuildPersistentEffect(1, true, false, true);
    SpectralArmyLinkEffect.bRemoveWhenTargetDies = true;
    SpectralArmyLinkEffect.EffectName = LinkName;
    Template.AddTargetEffect(SpectralArmyLinkEffect);

    Template.BuildNewGameStateFn = class'X2Ability_Sectoid '.static.Empty_BuildGameState;
    Template.BuildVisualizationFn = none;

    return Template;
}

static function X2AbilityTemplate KillLinkedSpectres(name DataName, string IconImage, name LinkName, name SpawnName)
{
    local X2AbilityTemplate                         Template;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_UnitEffectsWithAbilitySource  EffectCondition;
    local X2Effect_KillUnit                         KillUnitEffect;
    local X2Condition_UnitValue                     ValueCondition;
    local X2Effect_SetUnitValue                     UnitValueEffect;
    
    Template = SelfTargetTrigger(DataName, IconImage);

    // Trigger if the source dies
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitDied';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfWithAdditionalTargets;
    Template.AbilityTriggers.AddItem(Trigger);

    // Trigger if the source is removed from play (e.g. evacs)
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitRemovedFromPlay';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfIgnoreCache;
    Trigger.ListenerData.Priority = 75;	// We need this to happen before the unit is actually removed from play
    Template.AbilityTriggers.AddItem(Trigger);

    // Trigger if we need to remove the old summon
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.KillDuplicateSpectresEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_SelfWithAdditionalTargets;
    Trigger.ListenerData.Priority = 40;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';

    // Match the link name
    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddRequireEffect(LinkName, 'AA_UnitIsImmune');
    Template.AbilityMultiTargetConditions.AddItem(EffectCondition);

    // Condition to not kill the new summon
    ValueCondition = new class'X2Condition_UnitValue';
    ValueCondition.AddCheckValue(SpawnName, 1, eCheck_LessThan);
    Template.AbilityMultiTargetConditions.AddItem(ValueCondition);

    // Kill the old summon
    KillUnitEffect = new class'X2Effect_KillUnit';
    KillUnitEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    KillUnitEffect.DeathActionClass = class'X2Action_ZombieSireDeath';
    KillUnitEffect.VisualizationFn = class'X2Ability_Sectoid'.static.BuildVisualization_SireDeathEffect;
    Template.AddMultiTargetEffect(KillUnitEffect);

    // Remove protection from the new summon
    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.UnitName = SpawnName;
    UnitValueEffect.NewValueToSet = 0;
    UnitValueEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddMultiTargetEffect(UnitValueEffect);

    return Template;
}

static function X2AbilityTemplate SpectralUnitInit(name DataName, string IconImage, name AddEffectAnimName, name RemoveEffectAnimName)
{
    local X2AbilityTemplate         Template;
    local X2Effect_SpectralUnit     Effect;
    
    Template = Passive(DataName, IconImage, false, false);

    Effect = new class'X2Effect_SpectralUnit';
    Effect.AddEffectAnimName = AddEffectAnimName;
    Effect.RemoveEffectAnimName =  RemoveEffectAnimName;
    Effect.BuildPersistentEffect(1, true, true);
    Effect.bRemoveWhenTargetDies = true;
    Template.AddTargetEffect(Effect);

    return Template;
}


defaultproperties
{
    SpectralZombieLinkName = M31_Psi_SpectralZombieLink
    SpectralLancerLinkName = M31_Psi_SpectralLancerLink
    SpectralCreatureLinkName = M31_Psi_SpectralCreatureLink

    SpectralZombieSpawnName = M31_Psi_SpectralZombieSpawn
    SpectralLancerSpawnName = M31_Psi_SpectralLancerSpawn
    SpectralCreatureSpawnName = M31_Psi_SpectralCreatureSpawn

    ImprovedSpectresAbilityName = M31_Psi_StrongerSpectres

    KillDuplicateSpectresEventName = M31_Psi_KillDuplicateSpectres

    PsiZombieLinkName = M31_Psi_PsiZombieLink

}