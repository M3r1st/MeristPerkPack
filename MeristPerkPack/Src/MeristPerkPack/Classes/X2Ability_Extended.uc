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
    eCost_None,                 // No action point cost. For abilities which may be triggered during
                                // the enemy turn. You should use eCost_Free for activated abilities.
};

static function X2AbilityTemplate Passive(
    name TemplateName,
    string IconImage,
    optional bool bCrossClassEligible = false,
    optional bool bDisplayInUI = false)
{
    local X2AbilityTemplate             Template;
    local X2Effect_Persistent           PersistentEffect;

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
        PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
        Template.AddTargetEffect(PersistentEffect);
    }

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    Template.bCrossClassEligible = bCrossClassEligible;

    return Template;
}

static function X2AbilityTemplate SelfTargetActivated(
    name TemplateName,
    string IconImage,
    optional bool bCrossClassEligible = false)
{
    local X2AbilityTemplate     Template;

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

    Template.bSkipFireAction = true;

    Template.bCrossClassEligible = bCrossClassEligible;

    return Template;
}

static function X2AbilityTemplate SelfTargetTrigger(
    name TemplateName,
    string IconImage)
{
    local X2AbilityTemplate     Template;

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
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bSkipFireAction = true;

    Template.bCrossClassEligible = false;

    return Template;
}

static function X2AbilityTemplate Attack(
    name TemplateName,
    string IconImage,
    optional bool bCrossClassEligible = false,
    optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate                 Template;	
    local X2Condition_Visibility            VisibilityCondition;

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

static function AddAmmoCost(X2AbilityTemplate Template, int iAmmo)
{
	local X2AbilityCost_Ammo AmmoCost;
    if (iAmmo > 0)
    {
        AmmoCost = new class'X2AbilityCost_Ammo';	
        AmmoCost.iAmmo = iAmmo;
        Template.AbilityCosts.AddItem(AmmoCost);
    }
}

static function AddCharges(X2AbilityTemplate Template, int InitialCharges)
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
        case eCost_None:                AbilityCost.iNumPoints = 0; break;
    }

    return AbilityCost;
}