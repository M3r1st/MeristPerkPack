class X2Condition_FineControl extends X2Condition;

var array<name> FineControlAbilities;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
    local XComGameState_Unit TargetUnit;
    local XComGameState_Unit SourceUnit;
    local name AbilityName;

    SourceUnit = XComGameState_Unit(kSource);
    TargetUnit = XComGameState_Unit(kTarget);

    if (SourceUnit != none && TargetUnit != none)
    {
        if (SourceUnit.IsFriendlyUnit(TargetUnit))
        {
            foreach FineControlAbilities(AbilityName)
            {
                if (SourceUnit.HasSoldierAbility(AbilityName, true))
                {
                    return 'AA_UnitIsFriendly';
                    // return 'AA_UnitIsImmune';
                }
            }
        }
    }

    return 'AA_Success';
}