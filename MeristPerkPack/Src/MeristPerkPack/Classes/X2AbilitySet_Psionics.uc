class X2AbilitySet_Psionics extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> LetItGo_AllowedAbilities;

var localized string strNullGuardFriendlyDesc;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    // Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_Psi_Animations', ""));

    // Templates.AddItem(PsionicReaper());
    // Templates.AddItem(SectoidPsionicReaper());
    // Templates.AddItem(WallPhasing());

    // Templates.AddItem(NullWard());
    // Templates.AddItem(NullGuard());
    // Templates.AddItem(TeleportAlly());
    // Templates.AddItem(Compulsion());
    // Templates.AddItem(GreatestChampion());
    // Templates.AddItem(PsiStealth('M31_Psi_Stealth', ""));
    // Templates.AddItem(PsiStealth('M31_Psi_Blend', "", true));

    // Templates.AddItem(Cryotherapy());
    // Templates.AddItem(MassCryotherapy());
    // Templates.AddItem(LetItGo());

    // Templates.AddItem(Mindspin());
    // Templates.AddItem(ArcMindspin());
    // Templates.AddItem(Domination());

    return Templates;
}

static function X2AbilityTemplate PsionicReaper()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PsiDamageBonus   Effect;

    Template = Passive('M31_PsionicReaper', "", false, true);

    Template.AbilitySourceName = 'eAbilitySource_Psionic';

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

    Template.AbilitySourceName = 'eAbilitySource_Psionic';

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

static function X2AbilityTemplate WallPhasing()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WallPhasing      Effect;

    Template = Passive('M31_WallPhasing', "img:///UILibrary_PerkIcons.UIPerk_item_wraith", false, true);
    // Thanks, Firaxis.
    Template.bIsPassive = false;

    Template.AbilitySourceName = 'eAbilitySource_Psionic';

    Effect = new class'X2Effect_WallPhasing';
    Effect.EffectName = 'M31_WallPhasing';
    Effect.AddTraversalChange(eTraversal_Phasing, true);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.OverrideAbilities.AddItem('WallPhasing');

    return Template;
}

static function X2AbilityTemplate NullWard()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_PersonalShield           ShieldEffect;

    Template = SelfTargetActivated('M31_Psi_NullWard', "img:///UILibrary_PerkIcons.UIPerk_aethershift", false);

    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.Hostility = eHostility_Defensive;
    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Defensive);

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
        
    Template.BuildVisualizationFn = NullWard_BuildVisualization;

    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    return Template;
}

static function NullWard_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;
    local X2AbilityTemplate             AbilityTemplate;
    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   ActionMetadata;
    local X2Action_PlayAnimation        PlayAnimationAction;

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

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = AbilityTemplate.CustomFireAnim;
}

static function X2AbilityTemplate NullGuard()
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
    local X2Effect_BlockDamage          ShieldEffect;

    Template = SelfTargetActivated('M31_Psi_NullGuard', "img:///UILibrary_PerkIcons.UIPerk_aethershift", false);

    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.Hostility = eHostility_Defensive;
    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Defensive);

    AddCooldown(Template, `GetConfigInt("M31_Psi_NullGuard_Cooldown"));
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
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_Psi_NullGuard_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    ShieldEffect = new class'X2Effect_BlockDamage';
    ShieldEffect.EffectName = 'M31_Psi_NullGuard';
    ShieldEffect.BuildPersistentEffect(`GetConfigInt("M31_Psi_NullGuard_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.strNullGuardFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(ShieldEffect);
    Template.AddMultiTargetEffect(ShieldEffect);
        
    Template.BuildVisualizationFn = NullWard_BuildVisualization;

    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate TeleportAlly()
{
    local X2AbilityTemplate             Template;
    local X2AbilityTarget_TeleportAlly  TeleportAllyTarget;
    local X2Condition_UnitProperty      UnitPropertyCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_TeleportAlly');

    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_teleportally";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
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
    local X2Condition_UnitEffects           ExcludeEffects;
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

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Offensive);

    StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
    StatCheck.BaseValue = `GetConfigInt("M31_Psi_Compulsion_BaseChance");
    Template.AbilityToHitCalc = StatCheck;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
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

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
    ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
    Template.AbilityTargetConditions.AddItem(ExcludeEffects);

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

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

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
        SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_Single, eHostility_Neutral);

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
        SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Neutral);

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
    Template.Hostility = eHostility_Defensive;

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_Single, eHostility_Defensive);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

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

        UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
        UnconsciousEffect.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddTargetEffect(UnconsciousEffect);

        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
        RemoveEffects.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddTargetEffect(RemoveEffects);
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
    Template.Hostility = eHostility_Defensive;

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Defensive);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

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

        UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
        UnconsciousEffect.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddMultiTargetEffect(UnconsciousEffect);

        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
        RemoveEffects.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddMultiTargetEffect(RemoveEffects);
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

static function X2AbilityTemplate Mindspin(name DataName = 'M31_Psi_Mindspin')
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Condition_UnitEffects           ExcludeEffects;
    local X2Effect_PersistentStatChange     DisorientedEffect;
    local X2Effect_Panicked                 PanickedEffect;
    local X2Effect_MindControl              MindControlEffect;
    local X2Effect_RemoveEffects            MindControlRemoveEffects;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_Mindspin";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Offensive);

    StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
    StatCheck.BaseValue = `GetConfigInt("M31_Psi_Mindspin_BaseChance");
    Template.AbilityToHitCalc = StatCheck;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
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

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
    ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
    Template.AbilityTargetConditions.AddItem(ExcludeEffects);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Mental');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

    AddCooldown(Template, `GetConfigInt("M31_Psi_Mindspin_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    //  Disorient effect for 1 unblocked psi hit
    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.iNumTurns = class'X2Ability_Sectoid'.default.SECTOID_Mindspin_DISORIENTED_DURATION;
    DisorientedEffect.MinStatContestResult = 1;
    DisorientedEffect.MaxStatContestResult = 1;
    Template.AddTargetEffect(DisorientedEffect);
    //  Disorient effect for 2 unblocked psi hits
    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.iNumTurns = class'X2Ability_Sectoid'.default.SECTOID_Mindspin_DISORIENTED_DURATION + 1;
    DisorientedEffect.MinStatContestResult = 2;
    DisorientedEffect.MaxStatContestResult = 2;
    Template.AddTargetEffect(DisorientedEffect);

    PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
    PanickedEffect.MinStatContestResult = 3;
    PanickedEffect.MaxStatContestResult = 4;
    Template.AddTargetEffect(PanickedEffect);

    MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(class'X2Ability_Sectoid'.default.SECTOID_Mindspin_CONTROL_DURATION);
    MindControlEffect.MinStatContestResult = 5;
    MindControlEffect.MaxStatContestResult = 0;
    Template.AddTargetEffect(MindControlEffect);

    MindControlRemoveEffects = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
    MindControlRemoveEffects.MinStatContestResult = 5;
    MindControlRemoveEffects.MaxStatContestResult = 0;
    MindControlRemoveEffects.DamageTypes.AddItem('Mental');
    Template.AddTargetEffect(MindControlRemoveEffects);

    Template.CustomFireAnim = 'HL_M31_Psi_ProjectileMedium';

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'Insanity';
    Template.SourceMissSpeech = 'SoldierFailsControl';
    Template.TargetMissSpeech = 'SoldierResistsMindControl';

    Template.CinescriptCameraType = "Sectoid_Mindspin";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.bShowActivation = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function X2AbilityTemplate ArcMindspin()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
    local X2AbilityMultiTarget_ChainingJolt ChainMultiTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Condition_UnitEffects           ExcludeEffects;
    local X2Effect_PersistentStatChange     DisorientedEffect;
    local X2Effect_Panicked                 PanickedEffect;
    local X2Effect_MindControl              MindControlEffect;
    local X2Effect_RemoveEffects            MindControlRemoveEffects;

    Template = Mindspin('M31_Psi_ArcMindspin');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_Mindspin";

    StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
    StatCheck.BaseValue = `GetConfigInt("M31_Psi_Mindspin_BaseChance");
    Template.AbilityToHitCalc = StatCheck;

    ChainMultiTarget = new class'X2AbilityMultiTarget_ChainingJolt';
    ChainMultiTarget.fTargetRadius = `GetConfigFloat("M31_Psi_ArcMindspin_Radius");
    ChainMultiTarget.MaxTargets = `GetConfigInt("M31_Psi_ArcMindspin_MaxTargets");
    Template.AbilityMultiTargetStyle = ChainMultiTarget;
    Template.TargetingMethod = class'X2TargetingMethod_Chain';

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityMultiTargetConditions.AddItem(default.MeleeVisibilityCondition);

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
    ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
    Template.AbilityMultiTargetConditions.AddItem(ExcludeEffects);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Mental');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    AddCooldown(Template, `GetConfigInt("M31_Psi_ArcMindspin_Cooldown"));

    Template.AbilityCosts.Length = 0;
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    //  Disorient effect for 1 unblocked psi hit
    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.iNumTurns = class'X2Ability_Sectoid'.default.SECTOID_Mindspin_DISORIENTED_DURATION;
    DisorientedEffect.MinStatContestResult = 1;
    DisorientedEffect.MaxStatContestResult = 1;
    Template.AddMultiTargetEffect(DisorientedEffect);
    //  Disorient effect for 2 unblocked psi hits
    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.iNumTurns = class'X2Ability_Sectoid'.default.SECTOID_Mindspin_DISORIENTED_DURATION + 1;
    DisorientedEffect.MinStatContestResult = 2;
    DisorientedEffect.MaxStatContestResult = 2;
    Template.AddMultiTargetEffect(DisorientedEffect);

    PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
    PanickedEffect.MinStatContestResult = 3;
    PanickedEffect.MaxStatContestResult = 4;
    Template.AddMultiTargetEffect(PanickedEffect);

    MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(class'X2Ability_Sectoid'.default.SECTOID_Mindspin_CONTROL_DURATION);
    MindControlEffect.MinStatContestResult = 5;
    MindControlEffect.MaxStatContestResult = 0;
    Template.AddMultiTargetEffect(MindControlEffect);

    MindControlRemoveEffects = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
    MindControlRemoveEffects.MinStatContestResult = 5;
    MindControlRemoveEffects.MaxStatContestResult = 0;
    MindControlRemoveEffects.DamageTypes.AddItem('Mental');
    Template.AddMultiTargetEffect(MindControlRemoveEffects);

    Template.CustomFireAnim = 'HL_M31_Psi_ProjectileMedium';

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'Insanity';
    Template.SourceMissSpeech = 'SoldierFailsControl';
    Template.TargetMissSpeech = 'SoldierResistsMindControl';

    Template.CinescriptCameraType = "Sectoid_Mindspin";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.bShowActivation = true;

    Template.ActionFireClass = class'X2Action_Fire_ArcMindspin';

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}

static function X2AbilityTemplate Domination()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Condition_UnitEffects           ExcludeEffects;
    local X2Effect_MindControl              MindControlEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_Psi_Domination');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_domination";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    SetAbilityShotHUDPriority(Template, ePriorityType_Psi, eCost_SingleConsumeAll, eHostility_Offensive);

    StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
    StatCheck.BaseValue = `GetConfigInt("M31_Psi_Domination_BaseChance");
    Template.AbilityToHitCalc = StatCheck;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
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

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
    ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
    Template.AbilityTargetConditions.AddItem(ExcludeEffects);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Mental');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Psi_Domination_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_Psi_Domination_Charges"));

    MindControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(1, false, true);
    Template.AddTargetEffect(MindControlEffect);
    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());
    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());

    Template.CustomFireAnim = 'HL_M31_Psi_MindControl';

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'Domination';
    Template.SourceMissSpeech = 'SoldierFailsControl';

    Template.CinescriptCameraType = "Psionic_FireAtUnit";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.bShowActivation = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_Psi_Animations');

    return Template;
}