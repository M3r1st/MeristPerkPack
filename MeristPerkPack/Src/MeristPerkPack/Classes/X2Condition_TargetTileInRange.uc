class X2Condition_TargetTileInRange extends X2Condition;

var float Range;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
    local XComGameState_Unit SourceUnit, TargetUnit;

    SourceUnit = XComGameState_Unit(kSource);
    TargetUnit = XComGameState_Unit(kTarget);

    if (SourceUnit != none && TargetUnit != none)
    {
        if (SourceUnit.bRemovedFromPlay || TargetUnit.bRemovedFromPlay)
        {
            return 'AA_NotInRange';
        }
        if (SourceUnit.ObjectID != TargetUnit.ObjectID)
        {
            if (Range > 0 && !class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, Range * Range))
            {
                return 'AA_NotInRange';
            }
        }
        return 'AA_Success';
    }
    else return 'AA_NotAUnit';
}
