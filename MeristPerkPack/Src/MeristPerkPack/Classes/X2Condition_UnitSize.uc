class X2Condition_UnitSize extends X2Condition;

var int iMinUnitSize;
var int iMaxUnitSize;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit == none)
        return 'AA_NotAUnit';

    if (iMinUnitSize <= TargetUnit.UnitSize && TargetUnit.UnitSize <= iMaxUnitSize)
        return 'AA_Success';

    return 'AA_UnitIsImmune';
}

defaultproperties
{
    iMinUnitSize = 0
    iMaxUnitSize = 99
}