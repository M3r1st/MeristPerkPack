class X2Effect_WS_ReinforcedScales extends X2Effect_Persistent;

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
    local int CritResistance;

    CritResistance = `GetConfigInt("M31_PA_WS_ReinforcedScales_CritResistance");

    if (CritResistance != 0)
    {
        ModInfo.ModType = eHit_Crit;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = -1 * CritResistance;
        ShotModifiers.AddItem(ModInfo);
    }
}

function int GetDefendingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    optional XComGameState NewGameState)
{
    return -1 * Min(CurrentDamage, `GetConfigInt("M31_PA_WS_ReinforcedScales_DamageReduction"));
}