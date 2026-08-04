class X2Effect_ChargesLmao extends X2Effect_Persistent;

var array<name> AllowedAbilities;
var array<name> AbilitiesToTick;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', OnAbilityActivated, ELD_OnStateSubmitted, 20, TargetState,, EffectObj);
}

static function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          EffectState;
    local X2Effect_ChargesLmao          Effect;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState                 NewGameState;

    local StateObjectReference      SharedAbilityRef;
    local XComGameState_Ability     SharedAbilityState;
    local name                      SharedAbilityName;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XComGameState_Effect(CallbackData);
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        if (EffectState != none && SourceUnit != none && AbilityState != none)
        {
            Effect = X2Effect_ChargesLmao(EffectState.GetX2Effect());
            if (Effect != none)
            {
                if (Effect.AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
                {
                    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));

                    foreach Effect.AbilitiesToTick(SharedAbilityName)
                    {
                        if (SharedAbilityName != AbilityState.GetMyTemplateName())
                        {
                            SharedAbilityRef = SourceUnit.FindAbility(SharedAbilityName);
                            if (SharedAbilityRef.ObjectID > 0)
                            {
                                SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
                                if (SharedAbilityState.iCharges > 0)
                                {
                                    SharedAbilityState.iCharges = 0;
                                }
                            }
                        }
                    }

                    if (NewGameState.GetNumGameStateObjects() > 0)
                    {
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }
                    else
                    {
                        `XCOMHISTORY.CleanupPendingGameState(NewGameState);
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}
