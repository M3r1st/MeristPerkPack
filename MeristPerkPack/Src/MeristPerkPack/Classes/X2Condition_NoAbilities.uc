class X2Condition_NoAbilities extends X2Condition;

var array<name> ExcludedAbilities;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit SourceUnit;
    local name AbilityName;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

    if (SourceUnit == none)
        return 'AA_NotAUnit';

    foreach ExcludedAbilities(AbilityName)
    {
        if (SourceUnit.HasSoldierAbility(AbilityName, true))
            return 'AA_AbilityUnavailable';
    }

    return 'AA_Success';
}