class X2Condition_SuppressingFire extends X2Condition;

var name SuppressionAbilityName;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit        TargetState, SourceState;
    local XComGameState_Ability     SuppressionState;

    TargetState = XComGameState_Unit(kTarget);
    if (TargetState == none)
        return 'AA_NotAUnit';
        
    SourceState = XComGameState_Unit(kSource);
    if (SourceState == none)
        return 'AA_NotAUnit';

    SuppressionState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceState.FindAbility(SuppressionAbilityName).ObjectID));
    if (SuppressionState == none)
        return 'AA_AbilityUnavailable';

    return SuppressionState.CanActivateAbilityForObserverEvent(kTarget);
}

defaultproperties
{
    SuppressionAbilityName = "Suppression_LW"
}