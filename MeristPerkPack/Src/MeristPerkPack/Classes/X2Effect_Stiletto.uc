class X2Effect_Stiletto extends X2Effect_Persistent;

var array<int> PierceBonus;

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon.ObjectID > 0 && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        return GetBonusValue(AbilityState.GetSourceWeapon(), PierceBonus);
    }

    return 0;
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