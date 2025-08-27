//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_Cone_SawedOffSweeper.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class X2AbilityMultiTarget_Cone_SawedOffSweeper extends X2AbilityMultiTarget_Cone;

var float BaseConeEndDiameter;
var float BaseConeLength;
var float ConeEndDiameterPerAmmo;
var float ConeLengthPerAmmo;
var int MinAmmo;
var int MaxAmmo;

function float GetConeLength(const XComGameState_Ability Ability)
{
    UpdateParameters(Ability);
    return super.GetConeLength(Ability);
}

simulated function GetCollisionValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles, out array<TTile> InValidTiles)
{
    UpdateParameters(Ability);
    // super.GetCollisionValidTilesForLocation(Ability, Location, ValidTiles, InValidTiles);
    GetValidTilesForLocation(Ability, Location, ValidTiles);
}

simulated function UpdateParameters(XComGameState_Ability Ability)
{
    local XComGameState_Item SourceWeapon;
    local int CurrentAmmo;

    SourceWeapon = Ability.GetSourceWeapon();
    if (SourceWeapon != none)
    {
        CurrentAmmo = Clamp(SourceWeapon.Ammo - MinAmmo, 0, MaxAmmo - MinAmmo);
        ConeEndDiameter = BaseConeEndDiameter + CurrentAmmo * ConeEndDiameterPerAmmo;
        ConeLength = BaseConeLength + CurrentAmmo * ConeLengthPerAmmo;
    }
}