class X2Effect_Rider_AutoGuard extends X2Effect_Persistent;

static function EventListenerReturn AbilityTriggerEventListener_AutoGuard(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory      History;
    local XComGameState_AIGroup     GroupState;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        SourceUnit;
    local XComGameState             NewGameState;

    History = `XCOMHISTORY;

    GroupState = XComGameState_AIGroup(EventSource);
    AbilityState = XComGameState_Ability(CallbackData);
    if (AbilityState != none && GroupState != none)
    {
        SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

        if (SourceUnit != none
            && SourceUnit.GetGroupMembership().ObjectID == GroupState.ObjectID
            && SourceUnit.HasSoldierAbility('M31_Rider_AutoGuard', true)
            && !SourceUnit.IsPanicked()
            && !SourceUnit.IsMindControlled())
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
            SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
            SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
            
            if (AbilityState.CanActivateAbility(SourceUnit) == 'AA_Success')
            {
                `GAMERULES.SubmitGameState(NewGameState);
                AbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false);
            }
            else
            {
                History.CleanupPendingGameState(NewGameState);
            }
        }
    }
    return ELR_NoInterrupt;
}