class X2Effect_KeenEdge extends X2Effect_Persistent;

var array<int> DamageBonus;
var array<int> PierceBonus;
var array<name> AdditionalAbilities;

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local int Damage;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    SourceWeapon = AbilityState.GetSourceWeapon();
    if (SourceWeapon != none)
    {
        if (SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID
            || AdditionalAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            Damage = GetBonusValue(SourceWeapon, DamageBonus);
        }
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
    local XComGameState_Item SourceWeapon;
    local int Pierce;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    SourceWeapon = AbilityState.GetSourceWeapon();
    if (SourceWeapon != none)
    {
        if (SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID
            || AdditionalAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            Pierce = GetBonusValue(SourceWeapon, PierceBonus);
        }
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