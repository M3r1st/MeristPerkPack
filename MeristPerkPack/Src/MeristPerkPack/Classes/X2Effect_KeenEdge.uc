class X2Effect_KeenEdge extends X2Effect_Persistent;

var array<int> DamageBonus;
var array<int> PierceBonus;

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    local int Damage;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon.ObjectID > 0 && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        Damage = GetBonusValue(AbilityState.GetSourceWeapon(), DamageBonus);
    }

    return Damage;
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local int Pierce;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon.ObjectID > 0 && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        Pierce = GetBonusValue(AbilityState.GetSourceWeapon(), PierceBonus);
    }

    return Pierce;
}

protected function int GetBonusValue(XComGameState_Item ItemState, array<int> BonusArray)
{
    local int Tech;

    if (ItemState != none)
    {
        Tech = `GetTechLevel(ItemState.GetMyTemplate());
        Tech = Clamp(Tech, 0, BonusArray.Length - 1);

        return BonusArray[Tech];
    }

    return 0;
}

defaultproperties
{
    EffectName = M31_KeenEdge
}