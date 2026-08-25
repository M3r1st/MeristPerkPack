class X2Effect_ApplyDamage_RequiredAbility extends X2Effect_ApplyWeaponDamage;

var name RequiredAbility;
var name BonusDamageTag;

function WeaponDamageValue GetBonusEffectDamageValue(
    XComGameState_Ability AbilityState,
    XComGameState_Unit SourceUnit,
    XComGameState_Item SourceWeapon,
    StateObjectReference TargetRef)
{
    local XComGameStateHistory History;
    local WeaponDamageValue EmptyDamageValue, ExtraDamageValue;
    local XComGameState_BaseObject TargetObject;

    if (!SourceUnit.HasSoldierAbility(RequiredAbility, true))
    {
        return EmptyDamageValue;
    }

    History = `XCOMHISTORY;
    TargetObject = History.GetGameStateForObjectID(TargetRef.ObjectID);
    SourceWeapon.GetWeaponDamageValue(TargetObject, BonusDamageTag, ExtraDamageValue);
    return ExtraDamageValue;
}