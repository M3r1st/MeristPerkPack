class X2AbilitySet_Reaper extends X2Ability_Extended config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    // Templates.AddItem(Aim());
    // Templates.AddItem(Tricks());
    
    return Templates;
}
// weak_EasyTarget
// static function X2AbilityTemplate Aim()
// {
//     local X2AbilityTemplate     Template;
//     local X2Effect_RE_Aim       Effect;

//     Template = Passive('M31_RP_Aim', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_vektorrifle", false, true);

//     Effect = new class'X2Effect_RE_Aim';
//     Effect.RangeOffsetPrc = `GetConfigInt("M31_RP_Aim_PenaltyModifier");
//     Effect.BaseRange = `GetConfigInt("M31_RP_Aim_BaseRange");
//     Effect.bLongRange = true;
//     Effect.BuildPersistentEffect(1, true, false);
//     Template.AddTargetEffect(Effect);
    
//     return Template;
// }

// static function X2AbilityTemplate Tricks()
// {
//     local X2AbilityTemplate     Template;

//     Template = Passive('M31_RP_Tricks', "", false, true);
    
//     return Template;
// }