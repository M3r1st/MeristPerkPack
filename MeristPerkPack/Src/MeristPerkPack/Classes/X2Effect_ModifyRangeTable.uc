//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ModifyRangeTable.uc
//  AUTHOR:  Merist
//  PURPOSE: Morphs an interval in the weapon's range table
//           I'm sorry, this entire effect is math
//---------------------------------------------------------------------------------------
class X2Effect_ModifyRangeTable extends X2Effect_Persistent;

var privatewrite bool bLog;

var int IndexFirst, IndexLast;
var int NewIndexLast;

var bool bShowNamedModifier;

var array<name> AllowedAbilities;
var bool bMatchSourceWeapon;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local X2WeaponTemplate WeaponTemplate;
    local ShotModifierInfo ShotInfo;
    local array<int> NewRangeTable;
    local int Left, Right, NewRight;
    local int Length, NewLength;
    local float fTargetIndex;
    local float Weight;
    local float dX, dY;
    local int Tiles;
    local int OffsetValue;
    local int Index;

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
            Length = WeaponTemplate.RangeAccuracy.Length;
            Left = Min(Length, IndexFirst);
            Right = Min(Length, IndexLast);

            NewLength = Length + NewIndexLast - IndexLast;
            NewRight = Min(NewLength, NewIndexLast);

            Weight = 1.0f * (Right - Left) / (NewRight - Left);
            
            for (Index = 0; Index < Left; Index++)
            {
                NewRangeTable[Index] = WeaponTemplate.RangeAccuracy[Index];
            }
            for (Index = Left; Index < NewRight; Index++)
            {
                fTargetIndex = Left + Weight * (Index - Left) + 0.001;
                `LOG("Target Index: " $ fTargetIndex, default.bLog, GetFuncName());
                // NewRangeTable[Index] = 
                dX = fTargetIndex - int(fTargetIndex);
                dY = WeaponTemplate.RangeAccuracy[Min(Length - 1, FCeil(fTargetIndex))] - WeaponTemplate.RangeAccuracy[Min(Length - 1, int(fTargetIndex))];
                `LOG("dX: " $ dX, default.bLog, GetFuncName());
                `LOG("dY: " $ dY, default.bLog, GetFuncName());
                NewRangeTable[Index] = WeaponTemplate.RangeAccuracy[int(fTargetIndex)] + Round(dX * dY);
            }

            for (Index = NewRight; Index < NewLength; Index++)
            {
                NewRangeTable[Index] = WeaponTemplate.RangeAccuracy[Min(Length - 1, Index - NewRight + Right)];
            }

            `LOG("New range table: ", default.bLog, GetFuncName());
            for (Index = 0; Index < NewLength; Index++)
                `LOG(Index $ ": " $ NewRangeTable[Index], default.bLog, GetFuncName());

            Tiles = Attacker.TileDistanceBetween(Target);
            OffsetValue = NewRangeTable[Min(NewLength - 1, Tiles)] -  WeaponTemplate.RangeAccuracy[Min(Length - 1, Tiles)];
            `LOG("OffsetValue: " $ OffsetValue, default.bLog, GetFuncName());
            if (OffsetValue != 0)
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
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bMatchSourceWeapon = true

    IndexFirst = 1
    IndexLast = 1
    NewIndexLast = 1

    bLog = false
}