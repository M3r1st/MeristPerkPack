class X2Condition_BindRange extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
    local XComGameState_Unit    SourceUnit, TargetUnit;
    local Object                PassToDelegate;

    SourceUnit = XComGameState_Unit(kSource);
    TargetUnit = XComGameState_Unit(kTarget);

    if (SourceUnit != none && TargetUnit != none)
    {
        if (class'X2Condition_BindableTile'.static.IsTileValidForBind(TargetUnit.TileLocation, SourceUnit.TileLocation, PassToDelegate))
        {
            return 'AA_Success';
        }
        return 'AA_NotInRange';
    }
    else return 'AA_NotAUnit';
}