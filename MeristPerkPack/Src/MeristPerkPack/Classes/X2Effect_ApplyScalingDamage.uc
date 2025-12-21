class X2Effect_ApplyScalingDamage extends X2Effect_ApplyWeaponDamage;

var float DamagePerRank;
var float CritDamagePerRank;
var float DamageFromHP;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local XComGameState_Unit    TargetUnit;
    local WeaponDamageValue     Damage;
    local int                   Rank, MaxHP;

    Damage = EffectDamageValue;

    if (SourceUnit != none)
        Rank = SourceUnit.GetSoldierRank();

    Damage.Damage += int(Rank * DamagePerRank);
    Damage.Crit += int(Rank * CritDamagePerRank);

    if (DamageFromHP > 0)
    {
        if (TargetRef.ObjectID > 0)
        {
            TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
            if (TargetUnit != none)
            {
                MaxHP = TargetUnit.GetMaxStat(eStat_HP);
                if (!class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit) && !TargetUnit.IsChosen())
                {
                    Damage.Damage += FCeil(MaxHP * DamageFromHP / 100);
                }
                else
                {
                    Damage.Damage += 1;
                }
            }
        }
    }

    return Damage;
}

defaultproperties
{
    bIgnoreBaseDamage = true
}