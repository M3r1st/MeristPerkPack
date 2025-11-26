class X2Effect_Assassin extends X2Effect_Persistent;

var privatewrite name CounterName;
var privatewrite name ActivatedValueName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'RetainConcealmentOnActivation', OnRetainConcealmentOnActivation, ELD_Immediate,,,, EffectObj);
}
static function EventListenerReturn OnRetainConcealmentOnActivation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComLWTuple                   Tuple;
    local bool                          bRetainConcealmentOnActivation;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          EffectState;
    local XComGameState_Unit            UnitState;
    local UnitValue                     UnitValue;
    local XComGameState                 NewGameState;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'RetainConcealmentOnActivation');

    bRetainConcealmentOnActivation = Tuple.Data[0].b;

    if (!bRetainConcealmentOnActivation)
    {
        AbilityContext = XComGameStateContext_Ability(EventSource);
        EffectState = XComGameState_Effect(CallbackData);
        if (AbilityContext != none && EffectState != none
            && EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID)
        {
            UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
            if (UnitState != none)
            {
                if (UnitState.GetUnitValue(default.ActivatedValueName, UnitValue) && int(UnitValue.fValue) == 1)
                {
                    bRetainConcealmentOnActivation = true;
                    Tuple.Data[0].b = bRetainConcealmentOnActivation;

                    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                    UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.GetReference().ObjectID));
                    UnitState.ClearUnitValue(default.ActivatedValueName);
                    `TACTICALRULES.SubmitGameState(NewGameState);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn AbilityTriggerEventListener_Assassin(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability             AbilityState;
    local XComGameState_Ability             KillingAbilityState;
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Unit                TargetUnit;
    local GameRulesCache_VisibilityInfo     VisInfo;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        TargetUnit = XComGameState_Unit(EventData);
        AbilityState = XComGameState_Ability(CallbackData);
        KillingAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

        if (SourceUnit != none && TargetUnit != none && AbilityState != none && KillingAbilityState != none)
        {
            if (AbilityState.SourceWeapon.ObjectID == AbilityContext.InputContext.ItemObject.ObjectID)
            {
                if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo, AbilityContext.AssociatedState.HistoryIndex))
                {
                    if (!TargetUnit.CanTakeCover() || VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0 && TargetUnit.GetTeam() != eTeam_XCom)
                    {
                        if (AbilityState.CanActivateAbility(SourceUnit) == 'AA_Success')
                        {
                            if (!SourceUnit.IsConcealed() || !KillingAbilityState.RetainConcealmentOnActivation(AbilityContext))
                            {
                                if (SourceUnit.IsConcealed())
                                {
                                    SourceUnit.BreakConcealment();
                                }
                                return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
                            }
                        }
                    }
                }
            }
        }
    }
    return ELR_NoInterrupt;
}

defaultproperties
{
    EffectName = M31_Assassin
    DuplicateResponse = eDupe_Ignore

    CounterName = M31_Assassin_Counter
    ActivatedValueName = M31_Assassin_Activated
}