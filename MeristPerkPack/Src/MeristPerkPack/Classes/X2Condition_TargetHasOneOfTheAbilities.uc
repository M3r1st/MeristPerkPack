class X2Condition_TargetHasOneOfTheAbilities extends X2Condition;

var array<name> AbilityNames;
var bool bSearchAllAbilities;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
    local XComGameState_Unit    TargetUnit;
    local name                  AbilityName;
    
    TargetUnit = XComGameState_Unit(kTarget);
    
    if (TargetUnit != none)
    {
        foreach AbilityNames(AbilityName)
        {
            if (TargetUnit.HasSoldierAbility(AbilityName, bSearchAllAbilities))
            {
                return 'AA_Success';
            }
        }
        return 'AA_AbilityUnavailable';
    }
    else return 'AA_NotAUnit';
}

defaultproperties
{
    bSearchAllAbilities = true
}