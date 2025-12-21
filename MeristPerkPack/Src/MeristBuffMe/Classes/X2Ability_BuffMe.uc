class X2Ability_BuffMe extends X2Ability;

var const name BuffMeAbilityName;
var const name BuffMeEventName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(BuffMe());

    return Templates;
}

static function X2AbilityTemplate BuffMe()
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, default.BuffMeAbilityName);

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

    Template.bHideOnClassUnlock = true;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    Template.PostActivationEvents.AddItem(default.BuffMeEventName);

    return Template;
}

defaultproperties
{
    BuffMeAbilityName = "M31_BuffMe"
    BuffMeEventName = "M31_BuffMe"
}