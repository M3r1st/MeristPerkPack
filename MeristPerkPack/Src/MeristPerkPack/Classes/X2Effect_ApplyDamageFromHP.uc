class X2Effect_ApplyDamageFromHP extends X2Effect_ApplyWeaponDamage;

var float fPrcDmg;
var bool bCeiling;
var float fPrcDamage_ChosenMultiplier;
var float fPrcDamage_RulerMultiplier;
var int iMinDamage;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local XComGameState_Unit TargetUnit;
    local WeaponDamageValue Damage;
    local float fDmgFromHP;

    Damage = EffectDamageValue;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
    if (TargetUnit != none)
    {
        if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100 * fPrcDamage_RulerMultiplier;
        else if (TargetUnit.IsChosen())
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100 * fPrcDamage_ChosenMultiplier;
        else
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100;
    }
    
    if (bCeiling)
        Damage.Damage += FCeil(fDmgFromHP);
    else
        Damage.Damage += int(fDmgFromHP);

    Damage.Damage = Max(Damage.Damage, iMinDamage);

    return Damage;
}

function GetDamageBrackets(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit,
    out int iDmgLow, out int iDmgHigh, optional out int iDmgLowBase, optional out int iDmgHighBase)
{
    local float fDmgFromHP;

    if (TargetUnit != none)
    {
        if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100 * fPrcDamage_RulerMultiplier;
        else if (TargetUnit.IsChosen())
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100 * fPrcDamage_ChosenMultiplier;
        else
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100;
    }
        
    iDmgLowBase = EffectDamageValue.Damage - EffectDamageValue.Spread + (EffectDamageValue.PlusOne == 100 ? 1 : 0);
    iDmgHighBase = EffectDamageValue.Damage + EffectDamageValue.Spread + (EffectDamageValue.PlusOne > 0 ? 1 : 0);

    if (bCeiling)
    {
        iDmgLow = iDmgLowBase + FCeil(fDmgFromHP);
        iDmgHigh = iDmgHighBase + FCeil(fDmgFromHP);
    }
    else
    {
        iDmgLow = iDmgLowBase + int(fDmgFromHP);
        iDmgHigh = iDmgHighBase + int(fDmgFromHP);
    }
}

defaultproperties
{
    bIgnoreBaseDamage = true
    iMinDamage = 1
    fPrcDamage_ChosenMultiplier = 1.0
    fPrcDamage_RulerMultiplier = 1.0
}