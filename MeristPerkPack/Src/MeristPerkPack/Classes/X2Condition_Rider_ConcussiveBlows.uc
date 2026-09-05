class X2Condition_Rider_ConcussiveBlows extends X2Condition;

var bool bExcludeStunned;
var bool bRequireDisoriented;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kTarget);
    if (TargetUnit == none)
        return 'AA_NotAUnit';

    if (!TargetUnit.IsAlive())
        return 'AA_UnitIsDead';

    if (TargetUnit.IsIncapacitated() || TargetUnit.IsDazed())
        return 'AA_UnitIsImpaired';

    if (bExcludeStunned && TargetUnit.IsStunned())
        return 'AA_UnitIsStunned';

    if (bRequireDisoriented && !TargetUnit.IsDisoriented())
        return 'AA_UnitIsNotImpaired';

    return 'AA_Success';
}