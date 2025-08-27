class X2Condition_TargetCanSeeSource extends X2Condition;

var bool bRequireLOS;
var bool bRequireBasicVisibility;
var bool bRequireGameplayVisible;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local GameRulesCache_VisibilityInfo VisInfo;

    if (!`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(kTarget.ObjectID, kSource.ObjectID, VisInfo))
        return 'AA_NotVisible';

    if (bRequireLOS && !VisInfo.bClearLOS)
        return 'AA_NotVisible';

    if (bRequireBasicVisibility && !VisInfo.bVisibleBasic)
        return 'AA_NotVisible';

    if (bRequireGameplayVisible && !VisInfo.bVisibleGameplay)
        return 'AA_NotVisible';

    return 'AA_Success';
}