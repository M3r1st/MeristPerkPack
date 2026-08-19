class X2Effect_PA_Coil extends X2Effect_Persistent;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local XComGameState_Unit TargetUnit;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_Coil, ELD_OnStateSubmitted,, TargetUnit,, EffectObj);
}

static function EventListenerReturn EffectEventListener_Coil(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local XComGameState                 NewGameState;
    local XComGameStateContext_EffectRemoved RemoveContext;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        EffectState = XComGameState_Effect(CallbackData);

        if (SourceUnit != none && AbilityState != none && EffectState != none)
        {
            if (AbilityState.ObjectID != EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)
            {
                if (AbilityState.IsAbilityInputTriggered() && AbilityState.GetMyTemplate().Hostility != eHostility_Movement)
                {
                    if (!class'M31_Helpers'.static.WasAbilityFree(AbilityState, SourceUnit, GameState.HistoryIndex - 1))
                    {
                        if (!EffectState.bRemoved)
                        {
                            RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
                            NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
                            EffectState.RemoveEffect(NewGameState, GameState);
                            `TACTICALRULES.SubmitGameState(NewGameState);
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
}

defaultproperties
{
    EffectName = DLC_3Overdrive
    DuplicateResponse = eDupe_Refresh
}