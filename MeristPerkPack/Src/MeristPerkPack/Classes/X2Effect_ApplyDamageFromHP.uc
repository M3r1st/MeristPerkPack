class X2Effect_ApplyDamageFromHP extends X2Effect_ApplyWeaponDamage;

var float fPrcDmg;
var bool bCeiling;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local XComGameState_Unit TargetUnit;
    local WeaponDamageValue Damage;
    local float fDmgFromHP;

    Damage = EffectDamageValue;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
    if (TargetUnit != none)
    {
        if (TargetUnit.IsChosen() || class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100 * 0.5;
        else
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100;
    }
    
    if (bCeiling)
        Damage.Damage += FCeil(fDmgFromHP);
    else
        Damage.Damage += int(fDmgFromHP);

    return Damage;
}

function GetDamageBrackets(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit,
    out int iDmgLow, out int iDmgHigh)
{
    local float fDmgFromHP;

    if (TargetUnit != none)
    {
        if (TargetUnit.IsChosen() || class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100 * 0.5;
        else
            fDmgFromHP = TargetUnit.GetMaxStat(eStat_HP) * fPrcDmg / 100;
    }
        
    if (bCeiling)
    {
        iDmgLow = EffectDamageValue.Damage - EffectDamageValue.Spread + (EffectDamageValue.PlusOne == 100 ? 1 : 0) + FCeil(fDmgFromHP);
        iDmgHigh = EffectDamageValue.Damage + EffectDamageValue.Spread + (EffectDamageValue.PlusOne > 0 ? 1 : 0) + FCeil(fDmgFromHP);
    }
    else
    {
        iDmgLow = EffectDamageValue.Damage - EffectDamageValue.Spread + (EffectDamageValue.PlusOne == 100 ? 1 : 0) + int(fDmgFromHP);
        iDmgHigh = EffectDamageValue.Damage + EffectDamageValue.Spread + (EffectDamageValue.PlusOne > 0 ? 1 : 0) + int(fDmgFromHP);
    }
}

defaultproperties
{
    bIgnoreBaseDamage = true
}