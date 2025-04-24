class X2Effect_WS_GlacialArmor extends X2Effect_BonusArmor;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return `GetConfigInt("M31_PA_WS_GlacialArmor_ArmorBonus");
}

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;

    ModInfo.ModType = eHit_Graze;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = -1 * `GetConfigInt("M31_PA_WS_GlacialArmor_DodgeBonus");
    ShotModifiers.AddItem(ModInfo);

}