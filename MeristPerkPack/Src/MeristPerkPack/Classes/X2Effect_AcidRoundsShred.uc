class X2Effect_AcidRoundsShred extends X2Effect_Persistent;

var int ShredBonus;
var array<name> AdditionalWeaponCategories;

function int GetExtraShredValue(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local X2WeaponTemplate WeaponTemplate;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon.ObjectID == 0)
        return 0;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
        if (WeaponTemplate == none || AdditionalWeaponCategories.Find(WeaponTemplate.WeaponCat) == INDEX_NONE)
            return 0;
    }

    return ShredBonus;
}