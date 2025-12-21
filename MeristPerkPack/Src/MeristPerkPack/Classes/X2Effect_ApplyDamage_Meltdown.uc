class X2Effect_ApplyDamage_Meltdown extends X2Effect_ApplyWeaponDamage;

var name AdditionalDamageTag;

function WeaponDamageValue GetBonusEffectDamageValue(
    XComGameState_Ability AbilityState,
    XComGameState_Unit SourceUnit,
    XComGameState_Item SourceWeapon,
    StateObjectReference TargetRef)
{
    local XComGameState_Unit    TargetUnit;
    local WeaponDamageValue     BaseAdditionalDamage;
    local WeaponDamageValue     Damage;
    local ArmorMitigationResults ArmorResults;
    local int ArmorMitigation;
    local int DamageMin;
    local int DamageMax;
    local int PlusOne;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));

    SourceWeapon.GetWeaponDamageValue(TargetUnit, AdditionalDamageTag, BaseAdditionalDamage);

    ArmorMitigation = int(TargetUnit.GetArmorMitigation(ArmorResults));

    DamageMin = ArmorMitigation * ((BaseAdditionalDamage.Damage - BaseAdditionalDamage.Spread) * 100);
    DamageMax = ArmorMitigation * ((BaseAdditionalDamage.Damage + BaseAdditionalDamage.Spread) * 100 + BaseAdditionalDamage.PlusOne);

    if ((DamageMax / 100 - DamageMin / 100) % 2 == 0)
    {
        PlusOne = DamageMax % 100;
        DamageMax = DamageMax / 100;
        DamageMin = DamageMin / 100;
    }
    else
    {
        DamageMax = DamageMax / 100 + 1;
        DamageMin = DamageMin / 100;
    }

    Damage.Damage = (DamageMax + DamageMin) / 2;
    Damage.Spread = (DamageMax - DamageMin) / 2;
    Damage.PlusOne = PlusOne;
    Damage.Crit = ArmorMitigation * BaseAdditionalDamage.Crit;
    Damage.Pierce = ArmorMitigation * BaseAdditionalDamage.Pierce;
    Damage.Rupture = ArmorMitigation * BaseAdditionalDamage.Rupture;
    Damage.Shred = ArmorMitigation * BaseAdditionalDamage.Shred;

    return Damage;
}

defaultproperties
{
    bIgnoreBaseDamage = true
}