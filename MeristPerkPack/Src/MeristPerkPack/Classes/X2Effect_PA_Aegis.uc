class X2Effect_PA_Aegis extends X2Effect_Persistent;

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    if (Target.IsUnitAffectedByEffectName('M31_PA_PersonalShield'))
        return -CurrentDamage * `GetConfigInt("M31_PA_Aegis_DamageReduction") / 100;

    return 0;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "M31_PA_Aegis"
}