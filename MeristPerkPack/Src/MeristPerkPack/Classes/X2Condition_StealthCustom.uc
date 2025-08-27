class X2Condition_StealthCustom extends X2Condition;

var bool bCheckConcealed;
var bool bCheckFlanking;
var bool bCheckObjectiveItems;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
    local XComGameState_Unit UnitState;
    local array<XComGameState_Item> arrItems;
    local XComGameState_Item ItemIter;

    UnitState = XComGameState_Unit(kTarget);

    if (UnitState == none)
        return 'AA_NotAUnit';

    if (bCheckConcealed && UnitState.IsConcealed())
        return 'AA_UnitIsConcealed';

    if (bCheckFlanking && class'X2TacticalVisibilityHelpers'.static.GetNumFlankingEnemiesOfTarget(kTarget.ObjectID) > 0)
        return 'AA_UnitIsFlanked';

    if (bCheckObjectiveItems)
    {
        arrItems = UnitState.GetAllInventoryItems();
        foreach arrItems(ItemIter)
        {
            if (ItemIter.IsMissionObjectiveItem() && !ItemIter.GetMyTemplate().bOkayToConcealAsObjective)
                return 'AA_NotWithAnObjectiveItem';
        }
    }

    return 'AA_Success'; 
}

DefaultProperties
{
    bCheckConcealed = true
    bCheckFlanking = true
    bCheckObjectiveItems = true
}