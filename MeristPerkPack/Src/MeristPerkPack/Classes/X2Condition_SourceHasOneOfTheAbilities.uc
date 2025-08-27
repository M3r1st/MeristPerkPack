class X2Condition_SourceHasOneOfTheAbilities extends X2Condition;

var array<name> AbilityNames;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit SourceUnit;
    local name AbilityName;

    SourceUnit = XComGameState_Unit(kSource);
    if (SourceUnit == none)
        return 'AA_NotAUnit';

    foreach AbilityNames(AbilityName)
    {
        if (SourceUnit.HasSoldierAbility(AbilityName, true))
        {
            return 'AA_Success';
        }
    }
    return 'AA_AbilityUnavailable';
}