class X2Ability_Extended extends X2Ability;

// Used by ActionPointCost and related functions
enum EActionPointCost
{
    eCost_Free,                 // No action point cost, but you must have an action point available.
    eCost_Single,               // Costs a single action point.
    eCost_SingleConsumeAll,     // Costs a single action point, ends the turn.
    eCost_Double,               // Costs two action points.
    eCost_DoubleConsumeAll,     // Costs two action points, ends the turn.
    eCost_Weapon,               // Costs as much as a weapon shot.
    eCost_WeaponConsumeAll,     // Costs as much as a weapon shot, ends the turn.
    eCost_Overwatch,            // No action point cost, but displays as ending the turn. Used for 
                                // abilities that have an X2Effect_ReserveActionPoints or similar.
    eCost_OverwatchWeapon,
    eCost_None,                 // No action point cost. For abilities which may be triggered during
                                // the enemy turn. You should use eCost_Free for activated abilities.
};

static function X2AbilityTemplate Passive(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bDisplayInUI = false)
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    if (bDisplayInUI)
    {
        PersistentEffect = new class'X2Effect_Persistent';
        PersistentEffect.EffectName = name(TemplateName $ "_Passive");
        PersistentEffect.BuildPersistentEffect(1, true, false);
        PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
        Template.AddTargetEffect(PersistentEffect);
    }

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    Template.bShowActivation = false;
    Template.bCrossClassEligible = bCrossClassEligible;

    return Template;
}

static function X2AbilityTemplate SelfTargetActivated(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false)
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.DisplayTargetHitChance = false;
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.bShowActivation = true;
    Template.bSkipFireAction = true;

    return Template;
}

static function X2AbilityTemplate SelfTargetTrigger(name TemplateName, string IconImage)
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipFireAction = true;

    Template.bCrossClassEligible = false;

    return Template;
}

static function X2AbilityTemplate Attack(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bAddDefaultEffects = true,
    optional bool bAllowBurning = false, optional bool bAllowDisoriented = false)
{
    local X2AbilityTemplate             Template;
    local X2Condition_Visibility        VisibilityCondition;
    local array<name>                   SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;

    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    if (bAllowDisoriented)
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (bAllowBurning)
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

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

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    return Template;
}

// Requires:
// * Exclusions
static function X2AbilityTemplate StandardMelee(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.bAllowBonusWeaponEffects = true;

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    }
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;
        
    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

// Requires:
// * Exclusions
static function X2AbilityTemplate MovingMelee(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.bAllowBonusWeaponEffects = true;

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    }
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;
        
    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function AddCooldown(X2AbilityTemplate Template, int iNumTurns)
{
    local X2AbilityCooldown AbilityCooldown;

    if (iNumTurns > 0)
    {
        AbilityCooldown = new class'X2AbilityCooldown';
        AbilityCooldown.iNumTurns = iNumTurns;
        Template.AbilityCooldown = AbilityCooldown;
    }
}

static function AddAmmoCost(X2AbilityTemplate Template, int iAmmo, optional bool bFreeCost)
{
    local X2AbilityCost_Ammo AmmoCost;
    if (iAmmo > 0)
    {
        AmmoCost = new class'X2AbilityCost_Ammo';
        AmmoCost.iAmmo = iAmmo;
        AmmoCost.bFreeCost = bFreeCost;
        Template.AbilityCosts.AddItem(AmmoCost);
    }
}

static function AddCharges(X2AbilityTemplate Template, int InitialCharges)
{
    local X2AbilityCharges Charges;
    local X2AbilityCost_Charges ChargeCost;

    if (InitialCharges > 0)
    {
        Charges = new class'X2AbilityCharges';
        Charges.InitialCharges = InitialCharges;
        Template.AbilityCharges = Charges;

        ChargeCost = new class'X2AbilityCost_Charges';
        ChargeCost.NumCharges = 1;
        Template.AbilityCosts.AddItem(ChargeCost);
    }
}

static function AddActionPointCost(X2AbilityTemplate Template, EActionPointCost Cost)
{
    if (Cost != eCost_None)
    {
        Template.AbilityCosts.AddItem(ActionPointCost(Cost));
    }
}

// Helper function for creating an X2AbilityCost_ActionPoints.
static function X2AbilityCost_ActionPoints ActionPointCost(EActionPointCost Cost)
{
    local X2AbilityCost_ActionPoints AbilityCost;

    AbilityCost = new class'X2AbilityCost_ActionPoints';
    switch (Cost)
    {
        case eCost_Free:                AbilityCost.iNumPoints = 1; AbilityCost.bFreeCost = true; break;
        case eCost_Single:              AbilityCost.iNumPoints = 1; break;
        case eCost_SingleConsumeAll:    AbilityCost.iNumPoints = 1; AbilityCost.bConsumeAllPoints = true; break;
        case eCost_Double:              AbilityCost.iNumPoints = 2; break;
        case eCost_DoubleConsumeAll:    AbilityCost.iNumPoints = 2; AbilityCost.bConsumeAllPoints = true; break;
        case eCost_Weapon:              AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; break;
        case eCost_WeaponConsumeAll:    AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; AbilityCost.bConsumeAllPoints = true; break;
        case eCost_Overwatch:           AbilityCost.iNumPoints = 1; AbilityCost.bConsumeAllPoints = true; AbilityCost.bFreeCost = true; break;
        case eCost_OverwatchWeapon:     AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; AbilityCost.bConsumeAllPoints = true; AbilityCost.bFreeCost = true; break;
        case eCost_None:                AbilityCost.iNumPoints = 0; break;
    }

    return AbilityCost;
}

static function SetFireAnim(out X2AbilityTemplate Template, name Anim)
{
    Template.CustomFireAnim = Anim;
    Template.CustomFireKillAnim = Anim;
    Template.CustomMovingFireAnim = Anim;
    Template.CustomMovingFireKillAnim = Anim;
    Template.CustomMovingTurnLeftFireAnim = Anim;
    Template.CustomMovingTurnLeftFireKillAnim = Anim;
    Template.CustomMovingTurnRightFireAnim = Anim;
    Template.CustomMovingTurnRightFireKillAnim = Anim;
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

static function AddSuppressedCondition(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffects SuppressedCondition;

    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    // SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    SuppressedCondition.AddExcludeEffect('AreaSuppression', 'AA_UnitIsSuppressed'); // Not building against LWOTC
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);
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

static function AddUnitValueCondition(out X2AbilityTemplate Template, name ValueName, int MaxValue, optional EUnitValueCleanup CleanupType)
{
    local X2Condition_UnitValue             ValueCondition;
    local X2Effect_IncrementUnitValue       UnitValueEffect;

    if (MaxValue > 0)
    {
        ValueCondition = new class'X2Condition_UnitValue';
        ValueCondition.AddCheckValue(ValueName, MaxValue, eCheck_LessThan);
        Template.AbilityShooterConditions.AddItem(ValueCondition);
    }

    UnitValueEffect = new class'X2Effect_IncrementUnitValue';
    UnitValueEffect.UnitName = ValueName;
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = CleanupType;
    UnitValueEffect.bApplyOnMiss = true;
    Template.AddShooterEffect(UnitValueEffect);
}

static function AddOverwatchTrigger(out X2AbilityTemplate Template, optional bool bMovement = true, optional bool bAttack = true)
{
    local X2AbilityTrigger_EventListener Trigger;

    if (bMovement)
    {
        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.EventID = 'ObjectMoved';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.Filter = eFilter_None;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
        Template.AbilityTriggers.AddItem(Trigger);
    }

    if (bAttack)
    {
        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.EventID = 'AbilityActivated';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.Filter = eFilter_None;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
        Template.AbilityTriggers.AddItem(Trigger);
    }
}