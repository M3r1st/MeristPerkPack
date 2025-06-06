class X2Condition_SuppressingFire extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit        TargetState, SourceState;
    local XComGameState_Ability     SuppressionState;
    local name                      SuppressionAbilityName;

    TargetState = XComGameState_Unit(kTarget);
    if (TargetState == none)
        return 'AA_NotAUnit';
        
    SourceState = XComGameState_Unit(kSource);
    if (SourceState == none)
        return 'AA_NotAUnit';

    foreach class'X2DLCInfo_MeristPerkPack'.default.SuppressingFire_AllowedAbilities(SuppressionAbilityName)
    {
        SuppressionState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceState.FindAbility(SuppressionAbilityName).ObjectID));
        if (SuppressionState != none && SuppressionState.CanActivateAbilityForObserverEvent(kTarget) == 'AA_Success')
            return 'AA_Success';
    }

    return 'AA_AbilityUnavailable';
}