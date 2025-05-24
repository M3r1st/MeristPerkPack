class X2Effect_ApplyDamageWithRank extends X2Effect_ApplyWeaponDamage;

var float fDamagePerRank;
var float fCritDamagePerRank;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local WeaponDamageValue Damage;
    local int iRank;

    Damage = EffectDamageValue;

    if (SourceUnit != none)
        iRank = SourceUnit.GetSoldierRank();

    Damage.Damage += int(iRank * fDamagePerRank);
    Damage.Crit += int(iRank * fCritDamagePerRank);

    return Damage;
}

function GetDamageBrackets(XComGameState_Unit SourceUnit,
    out int iDmgLow, out int iDmgHigh, optional out int iDmgLowBase, optional out int iDmgHighBase)
{
    local int iRank;

    if (SourceUnit != none)
        iRank = SourceUnit.GetSoldierRank();
    
    iDmgLowBase = EffectDamageValue.Damage - EffectDamageValue.Spread + (EffectDamageValue.PlusOne == 100 ? 1 : 0);
    iDmgHighBase = EffectDamageValue.Damage + EffectDamageValue.Spread + (EffectDamageValue.PlusOne > 0 ? 1 : 0);

    iDmgLow = iDmgLowBase + int(iRank * fDamagePerRank);
    iDmgHigh = iDmgHighBase + int(iRank * fDamagePerRank);
}

function GetCritDamage(XComGameState_Unit SourceUnit,
    out int iCritDmg)
{
    local int iRank;

    if (SourceUnit != none)
        iRank = SourceUnit.GetSoldierRank();

    iCritDmg = EffectDamageValue.Crit + int(iRank * fCritDamagePerRank);
}

defaultproperties
{
    bIgnoreBaseDamage = true
}