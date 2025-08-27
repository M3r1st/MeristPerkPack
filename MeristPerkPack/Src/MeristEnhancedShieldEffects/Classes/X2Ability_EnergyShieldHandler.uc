class X2Ability_EnergyShieldHandler extends X2Ability;

var privatewrite name ShieldHandlerAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;
    
    Templates.AddItem(EnergyShieldHandler());

    return Templates;
}

static function X2AbilityTemplate EnergyShieldHandler()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_EnergyShieldHandler    Effect;

    `CREATE_X2ABILITY_TEMPLATE(Template, default.ShieldHandlerAbilityName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    Template.bCrossClassEligible = false;

    Effect = new class'X2Effect_EnergyShieldHandler';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.bHideOnClassUnlock = true;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    return Template;
}

defaultproperties
{
    ShieldHandlerAbilityName = M31_EnergyShieldHandler
}

