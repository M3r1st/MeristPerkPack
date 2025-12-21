class X2Condition_SoldierAbilities extends X2Condition;

var array<name> ExcludedAbilities;
var array<name> RequiredAbilities;
var bool bRequireAll;
var bool bMatchSourceWeapon;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit    SourceUnit;
    local StateObjectReference  SourceWeaponRef;
    local name                  AbilityName;
    local bool                  bHasRequiredAbility;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

    if (SourceUnit == none)
        return 'AA_NotAUnit';

    if (bMatchSourceWeapon)
    {
        SourceWeaponRef = kAbility.SourceWeapon;
    }

    if (RequiredAbilities.Length > 0)
    {
        if (bRequireAll)
        {
            foreach RequiredAbilities(AbilityName)
            {
                if (SourceUnit.FindAbility(AbilityName, SourceWeaponRef).ObjectID > 0)
                {
                    return 'AA_AbilityUnavailable';
                }
            }
        }
        else
        {
            foreach RequiredAbilities(AbilityName)
            {
                if (SourceUnit.FindAbility(AbilityName, SourceWeaponRef).ObjectID > 0)
                {
                    bHasRequiredAbility = true;
                    break;
                }
            }
            if (!bHasRequiredAbility)
            {
                return 'AA_AbilityUnavailable';
            }
        }
    }

    foreach ExcludedAbilities(AbilityName)
    {
        if (SourceUnit.FindAbility(AbilityName, SourceWeaponRef).ObjectID > 0)
        {
            return 'AA_AbilityUnavailable';
        }
    }

    return 'AA_Success';
}

defaultproperties
{
    bRequireAll = true
}