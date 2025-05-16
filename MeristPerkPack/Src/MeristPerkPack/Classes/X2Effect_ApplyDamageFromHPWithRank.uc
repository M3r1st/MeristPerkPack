class X2Effect_ApplyDamageFromHPWithRank extends X2Effect_ApplyDamageFromHP;

var float fPrcDmgPerRank;
var float fBaseDmgPerRank;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local XComGameState_Unit TargetUnit;
    local WeaponDamageValue Damage;
    local int iRank;
    local float fDmgFromHP;

    Damage = EffectDamageValue;

    if (SourceUnit != none)
        iRank = SourceUnit.GetSoldierRank();

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
    if (TargetUnit != none)
    {
        if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * (fPrcDmg + iRank * fPrcDmgPerRank) / 100 * fPrcDamage_RulerMultiplier;
        else if (TargetUnit.IsChosen())
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * (fPrcDmg + iRank * fPrcDmgPerRank) / 100 * fPrcDamage_ChosenMultiplier;
        else
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * (fPrcDmg + iRank * fPrcDmgPerRank) / 100;
    }

    if (bCeiling)
        Damage.Damage += int(iRank * fBaseDmgPerRank) + FCeil(fDmgFromHP);
    else
        Damage.Damage += int(iRank * fBaseDmgPerRank) + int(fDmgFromHP);

    Damage.Damage = Max(Damage.Damage, iMinDamage);

    return Damage;
}

function GetDamageBrackets(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit,
    out int iDmgLow, out int iDmgHigh)
{
    local float fDmgFromHP;
    local int iRank;

    if (SourceUnit != none)
        iRank = SourceUnit.GetSoldierRank();

    if (TargetUnit != none)
    {
        if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * (fPrcDmg + iRank * fPrcDmgPerRank) / 100 * fPrcDamage_RulerMultiplier;
        else if (TargetUnit.IsChosen())
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * (fPrcDmg + iRank * fPrcDmgPerRank) / 100 * fPrcDamage_ChosenMultiplier;
        else
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * (fPrcDmg + iRank * fPrcDmgPerRank) / 100;
    }

    if (bCeiling)
    {
        iDmgLow = EffectDamageValue.Damage - EffectDamageValue.Spread + int(iRank * fBaseDmgPerRank) + (EffectDamageValue.PlusOne == 100 ? 1 : 0)
            + FCeil(fDmgFromHP);
        iDmgHigh = EffectDamageValue.Damage + EffectDamageValue.Spread + int(iRank * fBaseDmgPerRank) + (EffectDamageValue.PlusOne > 0 ? 1 : 0)
            + FCeil(fDmgFromHP);
    }
    else
    {
        iDmgLow = EffectDamageValue.Damage - EffectDamageValue.Spread + (EffectDamageValue.PlusOne == 100 ? 1 : 0) + int(fDmgFromHP);
        iDmgHigh = EffectDamageValue.Damage + EffectDamageValue.Spread + (EffectDamageValue.PlusOne > 0 ? 1 : 0) + int(fDmgFromHP);
    }

    iDmgLow = Max(iDmgLow, iMinDamage);
    iDmgHigh = Max(iDmgHigh, iMinDamage);
}

function GetDamagePrc(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit,
    out float fDmgPrc)
{
    local int iRank;

    if (SourceUnit != none)
        iRank = SourceUnit.GetSoldierRank();

    fDmgPrc = fPrcDmg + iRank * fPrcDmgPerRank;
}