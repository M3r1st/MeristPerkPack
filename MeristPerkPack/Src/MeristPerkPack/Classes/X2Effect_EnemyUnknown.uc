class X2Effect_EnemyUnknown extends X2Effect_PersistentStatChange;

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo CritInfo;
    local ShotModifierInfo AimInfo;

    AimInfo.ModType = eHit_Success;
    AimInfo.Reason = FriendlyName;
    AimInfo.Value = `GetConfigInt("M31_EnemyUnknown_AimBonus");
    ShotModifiers.AddItem(AimInfo);

    CritInfo.ModType = eHit_Crit;
    CritInfo.Reason = FriendlyName;
    CritInfo.Value = `GetConfigInt("M31_EnemyUnknown_CritBonus");
    ShotModifiers.AddItem(CritInfo);
}

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    local X2AbilityToHitCalc_StandardAim StandardHit;
    local int DamageBonus;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
    if (StandardHit != none && StandardHit.bIndirectFire)
        return 0;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    DamageBonus = `GetConfigInt("M31_EnemyUnknown_DamageBonus");

    if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
    {
        DamageBonus += `GetConfigInt("M31_EnemyUnknown_CritDamageBonus");
    }

    return DamageBonus;
}