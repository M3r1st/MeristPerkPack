class X2Effect_ApplyWeaponDamageExtended extends X2Effect_ApplyWeaponDamage;

var array<name> OverrideDamageTypes;

simulated function bool ModifyDamageValue(out WeaponDamageValue DamageValue, Damageable Target, out array<Name> AppliedDamageTypes)
{
    local WeaponDamageValue EmptyDamageValue;
    local name NewDamageType;
    local bool bImmune;

    if (Target != none)
    {
        if (OverrideDamageTypes.Length == 0)
        {
            if (Target.IsImmuneToDamage(DamageValue.DamageType))
            {
                DamageValue = EmptyDamageValue;
                return true;
            }
            else if (AppliedDamageTypes.Find(DamageValue.DamageType) == INDEX_NONE)
            {
                AppliedDamageTypes.AddItem(DamageValue.DamageType);
            }
            return false;
        }
        else
        {
            bImmune = true;
            DamageValue.DamageType = '';
            foreach OverrideDamageTypes(NewDamageType)
            {
                if (!Target.IsImmuneToDamage(NewDamageType))
                {
                    bImmune = false;
                    if (AppliedDamageTypes.Find(NewDamageType) == INDEX_NONE)
                        AppliedDamageTypes.AddItem(NewDamageType);
                }
            }

            if (bImmune)
            {
                foreach OverrideDamageTypes(NewDamageType)
                {
                    if (AppliedDamageTypes.Find(NewDamageType) == INDEX_NONE)
                        AppliedDamageTypes.AddItem(NewDamageType);
                }
            }
        }
    }
    return false;
}
