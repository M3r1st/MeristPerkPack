class X2AbilityTarget_TeleportAlly extends X2AbilityTarget_Single;

var bool bRequireVisibility;
var float Range;

struct AbilityGrantedBonusRange
{
    var name RequiredAbility;
    var float fBonusRange;
};

var array<AbilityGrantedBonusRange> AbilityBonusRanges;

function AddAbilityBonusRadius(name AbilityName, float BonusRadius)
{
    local AbilityGrantedBonusRange Bonus;

    Bonus.RequiredAbility = AbilityName;
    Bonus.fBonusRange = BonusRadius;

    AbilityBonusRanges.AddItem(Bonus);
}

// simulated function bool IsFreeAiming(const XComGameState_Ability Ability)
// {
//     return true;
// }

simulated function float GetCursorRangeMeters(const XComGameState_Ability Ability)
{
    local XComGameState_Unit AbilityOwner;
    local int Index;
    local float BonusRange;

    if (Range == -1)
        return Range;

    AbilityOwner = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    for (Index = 0; Index < AbilityBonusRanges.Length; Index++)
    {
        if (AbilityOwner.HasSoldierAbility(AbilityBonusRanges[Index].RequiredAbility, true))
        {
            BonusRange += AbilityBonusRanges[Index].fBonusRange;
        }
    }

    return Range + BonusRange;
}

defaultproperties
{
    Range = -1
}