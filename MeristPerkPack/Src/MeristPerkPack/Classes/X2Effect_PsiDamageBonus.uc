class X2Effect_PsiDamageBonus extends X2Effect_Persistent;

var bool bMatchSourceWeapon;
var bool bCeiling;
var int PsiFactor_Damage;
var int PsiFactor_Pierce;

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (bCeiling)
                return FCeil(Attacker.GetCurrentStat(eStat_PsiOffense) * PsiFactor_Damage);
            else
                return int(Attacker.GetCurrentStat(eStat_PsiOffense) * PsiFactor_Damage);
        }
    }

    return 0;
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (bCeiling)
        return FCeil(Attacker.GetCurrentStat(eStat_PsiOffense) * PsiFactor_Pierce);
    else
        return int(Attacker.GetCurrentStat(eStat_PsiOffense) * PsiFactor_Pierce);
}

defaultproperties
{
    bMatchSourceWeapon = true
}