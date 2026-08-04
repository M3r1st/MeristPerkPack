class X2Condition_SuppressingFire extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        SourceUnit;
    local StateObjectReference      SuppressionRef;
    local XComGameState_Ability     SuppressionState;
    local name                      SuppressionAbilityName;

    History = `XCOMHISTORY;

    SourceUnit = XComGameState_Unit(kSource);
    if (SourceUnit != none)
    {
        // Note of caution:
        /// `CanActivateAbilityForObserverEvent()` is a function that validates conditions.
        /// Calling it from condition events can be extremely hazardous.
        /// If there ever happens to be a closed loop of these calls, the game will instantly crash.
        /// I would advise against using this condition if you can avoid it.
        /// If you can't do that, try not to add any abilities that have similar conditions to the list.
        /// - Merist
        foreach class'X2DLCInfo_MeristPerkPack'.default.SuppressingFire_AllowedAbilities(SuppressionAbilityName)
        {
            SuppressionRef = SourceUnit.FindAbility(SuppressionAbilityName);
            if (SuppressionRef.ObjectID > 0)
            {
                SuppressionState = XComGameState_Ability(History.GetGameStateForObjectID(SuppressionRef.ObjectID));
                if (SuppressionState != none && SuppressionState.CanActivateAbilityForObserverEvent(kTarget) == 'AA_Success')
                {
                    return 'AA_Success';
                }
            }
        }
    } else return 'AA_NotAUnit';

    return 'AA_AbilityUnavailable';
}