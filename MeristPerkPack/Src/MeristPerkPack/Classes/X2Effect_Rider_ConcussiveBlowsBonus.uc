class X2Effect_Rider_ConcussiveBlowsBonus extends X2Effect_Persistent;

var int CritBonus;
var int DamageBonusPrc;
var array<name> AdditionalAbilities;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if (bMelee || AdditionalAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        ShotInfo.ModType = eHit_Crit;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = CritBonus;
        ShotModifiers.AddItem(ShotInfo);
    }
}

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
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(Target);
    if (TargetUnit == none)
        return 0;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.IsMeleeAbility() || AdditionalAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        if (TargetUnit.IsStunned() || TargetUnit.IsDazed() || TargetUnit.IsUnconscious())
        {
            return CurrentDamage * DamageBonusPrc / 100.0f;
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = M31_Rider_ConcussiveBlows_Bonus
}