class X2Effect_DamagePenalty extends X2Effect_Persistent;

var int DamagePenaltyPrc;
var bool bCeiling;

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local int DamageModifier;

    if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (bCeiling)
        DamageModifier = FCeil(CurrentDamage * DamagePenaltyPrc / 100.0);
    else
        DamageModifier = int(CurrentDamage * DamagePenaltyPrc / 100.0);

    return -1 * DamageModifier;
}