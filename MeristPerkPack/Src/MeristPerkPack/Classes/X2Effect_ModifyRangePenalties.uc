//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ModifyRangePenalties.uc
//  AUTHOR:  Merist / / Based on Grobobobo's version for LWOTC / Inspired by Shadow Ops
//  PURPOSE: Modifies the weapon's range penalties.
//---------------------------------------------------------------------------------------
class X2Effect_ModifyRangePenalties extends X2Effect_Persistent;

var int RangeOffsetPrc;
var bool bShowNamedModifier;

var int BaseRange;
var bool bShortRange, bLongRange;

var array<name> AllowedAbilities;
var bool bMatchSourceWeapon;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate;
    local ShotModifierInfo ShotInfo;
    local int Tiles;
    local int CurrentRangeIndex;
    local int CurrentRangeAccuracy;
    local int OffsetRangeIndex;
    local int OffsetRangeAccuracy;
    local int OffsetValue;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
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
                CurrentRangeIndex = Min(WeaponTemplate.RangeAccuracy.Length - 1, Tiles);
                CurrentRangeAccuracy = WeaponTemplate.RangeAccuracy[CurrentRangeIndex];

                if (BaseRange > 0)
                {
                    OffsetRangeIndex = Min(WeaponTemplate.RangeAccuracy.Length - 1, BaseRange);
                    OffsetRangeAccuracy = WeaponTemplate.RangeAccuracy[OffsetRangeIndex];
                }

            }
        }
    
        OffsetValue = int((OffsetRangeAccuracy - CurrentRangeAccuracy) * RangeOffsetPrc / 100.0);

        if (OffsetValue > 0)
        {
            ShotInfo.ModType = eHit_Success;
            if (bShowNamedModifier)
                ShotInfo.Reason = FriendlyName;
            else
                ShotInfo.Reason = class'XLocalizedData'.default.WeaponRange;
            ShotInfo.Value = OffsetValue;
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bMatchSourceWeapon = true
    RangeOffsetPrc = 100
}