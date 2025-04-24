class X2AbilitySet_WinterSentinel extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name LeadTheTargetRequiredAbilityName;
var privatewrite name LeadTheTargetReserveActionName;

var privatewrite name BoltMaelstromName;
var privatewrite string BoltMaelstromIcon;
var privatewrite name BoltLeadTheTargetMaelstromMarkEffectName;

var config array<name> Ballista_Categories;

static function array<X2DataTemplate> CreateTemplates()
{
    // local array<X2DataTemplate> Templates;

    // Templates.AddItem(Hide());
    // Templates.AddItem(Entwine());
    // Templates.AddItem(ReinforcedScales());
    // Templates.AddItem(GlacialArmor());
    // Templates.AddItem(GlacialArmorTrigger());
    
    // Templates.AddItem(BoltMaelstrom());
    //     Templates.AddItem(BoltMaelstromBonus());
    //     Templates.AddItem(BoltMaelstromAddLTT());
    //     Templates.AddItem(BoltMaelstromLTT());
    //     Templates.AddItem(BoltMaelstromLTTAttack());

    // return Templates;
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

    Template = Passive('M31_PA_WS_Entwine', "img:///UILibrary_PerkIcons.UIPerk_viper_bind", false, true);

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
    local X2AbilityTemplate     Template;

    Template = Passive('M31_PA_WS_GlacialArmor', "img:///KetarosPkg_Abilities.UIPerk_punisher", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_WS_GlacialArmor_Trigger');
    Template.AdditionalAbilities.AddItem('M31_PA_WS_GlacialArmor_Cleanse');

    return Template;
}

static function X2AbilityTemplate GlacialArmorTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_WS_GlacialArmor          Effect;

    Template = Passive('M31_PA_WS_GlacialArmor_Trigger', "img:///KetarosPkg_Abilities.UIPerk_punisher", false, false);

    Template.bDontDisplayInAbilitySummary = true;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'PlayerTurnBegun';
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Priority = 50;
    Trigger.ListenerData.Filter = eFilter_Player;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_WS_GlacialArmor';
    Effect.EffectName = 'M31_PA_WS_GlacialArmor_Buff';
    Effect.DuplicateResponse = eDupe_Refresh;
    Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddShooterEffect(Effect);

    return Template;
}

static function X2AbilityTemplate GlacialArmorCleanse()
{
    local X2AbilityTemplate						Template;
    local X2AbilityTrigger_EventListener		EventListener;
    local X2Effect_RemoveEffects				RemoveEffect;
    local X2Condition_UnitEffects				RequireEffect;

    Template = Passive('M31_PA_WS_GlacialArmor_Cleanse', "img:///KetarosPkg_Abilities.UIPerk_punisher", false, false);

    Template.AbilityTriggers.Length = 0;

    Template.bShowActivation = true;
    Template.bSkipFireAction = true;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    // EventListener.ListenerData.Priority = 50;
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    RequireEffect = new class'X2Condition_UnitEffects';
    RequireEffect.AddRequireEffect('M31_PA_WS_GlacialArmor_Buff', 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(RequireEffect);

    RemoveEffect = new class'X2Effect_RemoveEffects';
    RemoveEffect.EffectNamesToRemove.AddItem('M31_PA_WS_GlacialArmor_Buff');
    Template.AddTargetEffect(RemoveEffect);

    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Return Template;
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

    //Trigger on movement - interrupt the move
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'ObjectMoved';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = LeadTheTargetListener;
    Template.AbilityTriggers.AddItem(Trigger);
    //  trigger on an attack
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
    LeadTheTargetRequiredAbilityName = M31_PA_WS_Vigilance
    LeadTheTargetReserveActionName = WS_LeadTheTargetAction

    BoltMaelstromName = M31_PA_WS_Bolt_Maelstrom
    BoltMaelstromIcon = ""
    BoltLeadTheTargetMaelstromMarkEffectName = M31_PA_WS_Bolt_Maelstrom_LTT_MarkName
}