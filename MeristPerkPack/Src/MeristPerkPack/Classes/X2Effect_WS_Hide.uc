class X2Effect_WS_Hide extends X2Effect_Persistent;

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
    return -1 * Min(CurrentDamage, `GetConfigInt("M31_PA_WS_Hide_DamageReduction"));
}