class X2AbilitySet_PRPA_Shieldbearer extends X2Ability_Extended;

var privatewrite name EnergyShieldAbilityName;
var privatewrite name HealingShieldAbilityName;
var privatewrite name HoloShieldAbilityName;
var privatewrite name ImprovedShieldAbilityName;
var privatewrite name AegisShieldAbilityName;
var privatewrite name HasteShieldAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(EnergyShield());
    Templates.AddItem(HealingShield());
    Templates.AddItem(HoloShield());
    Templates.AddItem(ImprovedShield());
    Templates.AddItem(AegisShield());
    Templates.AddItem(HasteShield());

    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PRPA_SB_Anims', "M31_PA_Shieldbearer.Anims.AS_EnergyShield"));

    return Templates;
}

static function X2AbilityTemplate EnergyShield()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCooldown_Extended        Cooldown;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    // local X2AbilityPassiveAOE_WeaponRadius  PassiveRadius;
    local X2Effect_PRPA_SB_EnergyShield     ShieldEffect;
    local int                               i;

    Template = SelfTargetActivated(default.EnergyShieldAbilityName, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", false);

    SetAbilityShotHUDPriority(Template, ePriorityType_None, eCost_SingleConsumeAll, eHostility_Defensive);
    Template.Hostility = eHostility_Defensive;

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PRPA_SB_EnergyShield_Cooldown");
    for (i = 0; i < class'X2Effect_PRPA_SB_EnergyShield'.default.EnergyShield_CooldownModifiers.Length; i++)
    {
        Cooldown.CooldownModifiers.AddItem(class'X2Effect_PRPA_SB_EnergyShield'.default.EnergyShield_CooldownModifiers[i]);
    }
    Cooldown.AddCooldownModifier(default.ImprovedShieldAbilityName, `GetConfigInt('M31_PRPA_SB_ImprovedShield_CooldownReduction'));
    Template.AbilityCooldown = Cooldown;

    AddCharges(Template, `GetConfigInt("M31_PRPA_SB_EnergyShield_Charges"));
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
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_PRPA_SB_EnergyShield_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    RadiusMultiTarget.AddAbilityBonusRadius(default.ImprovedShieldAbilityName, `TILESTOMETERS(`GetConfigInt("M31_PRPA_SB_ImprovedShield_RadiusBonus")));
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    // PassiveRadius = new class'X2AbilityPassiveAOE_WeaponRadius';
    // PassiveRadius.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_PRPA_SB_EnergyShield_Radius"));
    // Template.AbilityPassiveAOEStyle = PassiveRadius;

    ShieldEffect = new class'X2Effect_PRPA_SB_EnergyShield';
    ShieldEffect.ShieldAmount = `GetConfigArrayInt("M31_PRPA_SB_EnergyShield_ShieldAmount");
    for (i = 0; i < class'X2Effect_PRPA_SB_EnergyShield'.default.AdditionalShieldAmountFromConfig.Length; i++)
    {
        ShieldEffect.AdditionalShieldAmount.AddItem(class'X2Effect_PRPA_SB_EnergyShield'.default.AdditionalShieldAmountFromConfig[i]);
    }
    ShieldEffect.AddAdditionalShieldAmount(default.ImprovedShieldAbilityName, `GetConfigInt('M31_PRPA_SB_ImprovedShield_ShieldBonus'));
    ShieldEffect.ShieldPriority = `GetConfigInt("M31_PRPA_SB_EnergyShield_ShieldPriority");
    ShieldEffect.bGetShieldAmountFromArmor = true;

    ShieldEffect.Aegis_RequiredAbility = default.AegisShieldAbilityName;
    ShieldEffect.Aegis_DamageReduction = `GetConfigInt("M31_PRPA_SB_AegisShield_DamageReduction");

    ShieldEffect.Holo_RequiredAbility = default.HoloShieldAbilityName;
    ShieldEffect.Holo_AimBonus = `GetConfigArrayInt('M31_PRPA_SB_HoloShield_AimBonus');
    ShieldEffect.Holo_CritBonus = `GetConfigArrayInt('M31_PRPA_SB_HoloShield_CritBonus');

    ShieldEffect.Haste_RequiredAbility = default.HasteShieldAbilityName;
    ShieldEFfect.Haste_MobilityBonus = `GetConfigArrayInt('M31_PRPA_SB_HasteShield_MobilityBonus');

    ShieldEffect.BuildPersistentEffect(`GetConfigInt("M31_PRPA_SB_EnergyShield_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_PersonalShield'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    ShieldEffect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(ShieldEffect);
    Template.AddMultiTargetEffect(ShieldEffect);

    AddHealingShieldEffects(Template);

    Template.bSkipFireAction = false;
    
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.BuildVisualizationFn = EnergyShield_BuildVisualization;

    Template.CustomFireAnim = 'HL_M31_EnergyShield';
    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PRPA_SB_Anims');

    return Template;
}

static simulated function EnergyShield_BuildVisualization(XComGameState VisualizeGameState)
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

static function X2AbilityTemplate HealingShield()
{
    return Passive(default.HealingShieldAbilityName, "img:///UILibrary_MeristPerkIcons.UIPerk_SB_HealingShield", false, true, true);
}

static function AddHealingShieldEffects(out X2AbilityTemplate Template)
{
    local X2Condition_SoldierAbilities          AbilityCondition;
    local X2Effect_ApplyHeal                    HealEffect;
    local X2Effect_RemoveEffectsByDamageType    RemoveEffects;

    AbilityCondition = new class'X2Condition_SoldierAbilities';
    AbilityCondition.RequiredAbilities.AddItem(default.HealingShieldAbilityName);

    // Restore health effect
    HealEffect = new class'X2Effect_ApplyHeal';
    HealEffect.HealAmount = `GetConfigInt("M31_PRPA_SB_HealingShield_HealAmount");
    HealEffect.MaxHealAmount = `GetConfigInt("M31_PRPA_SB_HealingShield_MaxHealAmount");
    HealEffect.HealthRegeneratedName = 'M31_PRPA_SB_HealingShield_Heal';
    HealEffect.TargetConditions.AddItem(AbilityCondition);
    Template.AddMultiTargetEffect(HealEffect);

    // Heal the status effects that a Medkit would heal
    RemoveEffects = class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType();
    RemoveEffects.TargetConditions.AddItem(AbilityCondition);
    Template.AddMultiTargetEffect(RemoveEffects);

    return;
}

static function X2AbilityTemplate HoloShield()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    Template = Passive(default.HoloShieldAbilityName, "img:///UILibrary_MeristPerkIcons.UIPerk_SB_AimShield", false, false, true);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = default.HoloShieldAbilityName;
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    return Template;
}

static function X2AbilityTemplate ImprovedShield()
{
    return Passive(default.ImprovedShieldAbilityName, "img:///UILibrary_XPerkIconPack.UIPerk_shield_plus", false, true, true);
}

static function X2AbilityTemplate AegisShield()
{
    return Passive(default.AegisShieldAbilityName, "img:///UILibrary_MeristPerkIcons.UIPerk_SB_AegisShield", false, true, true);
}

static function X2AbilityTemplate HasteShield()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    Template = Passive(default.HasteShieldAbilityName, "img:///UILibrary_MeristPerkIcons.UIPerk_SB_HasteShield", false, false, true);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = default.HasteShieldAbilityName;
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    return Template;
}

defaultproperties
{
    EnergyShieldAbilityName = M31_PRPA_SB_EnergyShield
    HealingShieldAbilityName = M31_PRPA_SB_HealingShield
    HoloShieldAbilityName = M31_PRPA_SB_HoloShield
    ImprovedShieldAbilityName = M31_PRPA_SB_ImprovedShield
    AegisShieldAbilityName = M31_PRPA_SB_AegisShield
    HasteShieldAbilityName = M31_PRPA_SB_HasteShield
}