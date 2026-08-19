class X2Effect_ApplyDamageFromTech extends X2Effect_ApplyWeaponDamage;

var array<WeaponDamageValue> EffectDamageValues;
var EInventorySlot SpecificSlot;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local XComGameState_Item    ItemState;
    local int                   Tech;

    if (SpecificSlot != eInvSlot_Unknown)
    {
        ItemState = SourceUnit.GetItemInSlot(SpecificSlot);
    }
    else
    {
        ItemState = AbilityState.GetSourceWeapon();
    }

    if (ItemState != none)
    {
        Tech = `GetTechLevel(ItemState.GetMyTemplate());
        Tech = Clamp(Tech, 0, EffectDamageValues.Length - 1);
        return EffectDamageValues[Tech];
    }

    return super.GetBonusEffectDamageValue(AbilityState, SourceUnit, SourceWeapon, TargetRef);
}