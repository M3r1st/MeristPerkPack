class X2AbilitySet_Skirmisher extends X2Ability_Extended config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(ForwardOperator());
    Templates.AddItem(FullKit());

    return Templates;
}

static function X2AbilityTemplate ForwardOperator()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_MeristForwardOperator    Effect;

    Template = Passive('M31_ForwardOperator', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ForwardOperator", false, true);

    Effect = new class'X2Effect_MeristForwardOperator';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_ForwardOperator_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_MeristForwardOperator'.default.strFriendlyDesc, Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate FullKit()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_SK_FullKit', "img:///UILibrary_XPerkIconPack.UIPerk_grenade_plus", false, true);

    return Template;
}
