//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_ModifyRangePenalties.uc
//  AUTHOR:  Merist / Based on Grobobobo's version for LWOTC / Inspired by Shadow Ops
//  PURPOSE: Modifies the weapon's range penalties.
//---------------------------------------------------------------------------------------
class X2Effect_ModifyRangePenalties extends X2Effect_Persistent;

var float RangePenaltyMultiplier;
var bool bShowNamedModifier;
var int BaseRange;
var bool bShortRange, bLongRange;
var array<name> AllowedAbilities;
var bool bCheckSourceWeapon;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate;
    local ShotModifierInfo ShotInfo;
    local int Tiles, Modifier;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return;

    SourceWeapon = AbilityState.GetSourceWeapon();	
    
    if (Attacker != none && Target != none && SourceWeapon != none)
    {
        WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

        if (WeaponTemplate != none)
        {
            Tiles = Attacker.TileDistanceBetween(Target);
            if (Tiles < BaseRange && !bShortRange)
                return;
            if (Tiles > BaseRange && !bLongRange)
                return;

            if (WeaponTemplate.RangeAccuracy.Length > 0)
            {
                if (Tiles < WeaponTemplate.RangeAccuracy.Length)
                    Modifier = WeaponTemplate.RangeAccuracy[Tiles];
                else  //  if this tile is not configured, use the last configured tile					
                    Modifier = WeaponTemplate.RangeAccuracy[WeaponTemplate.RangeAccuracy.Length-1];

                if (BaseRange > 0)
                {
                    if (BaseRange < WeaponTemplate.RangeAccuracy.Length)
                        Modifier -= WeaponTemplate.RangeAccuracy[BaseRange];
                    else  //  if this tile is not configured, use the last configured tile					
                        Modifier -= WeaponTemplate.RangeAccuracy[WeaponTemplate.RangeAccuracy.Length-1];
                }
            }
        }
    
        if (Modifier < 0)
        {
            ShotInfo.ModType = eHit_Success;
            if (bShowNamedModifier)
                ShotInfo.Reason = FriendlyName;
            else
                ShotInfo.Reason = class'XLocalizedData'.default.WeaponRange;
            ShotInfo.Value = int(RangePenaltyMultiplier * Modifier);
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bCheckSourceWeapon = true
}