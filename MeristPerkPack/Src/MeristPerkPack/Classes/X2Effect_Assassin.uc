class X2Effect_Assassin extends X2Effect_Persistent;

var bool bAllowMultiTarget;
var bool bMatchSourceWeapon;
var name CountValueName;
var int ActivationsPerTurn;
var bool bShowFlyover;

var localized string strFriendlyDesc;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local XComGameState_Unit TargetUnit;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_Assassin, ELD_OnStateSubmitted, 15, TargetUnit,, EffectObj);
}

static function EventListenerReturn EffectEventListener_Assassin(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_Assassin             Effect;
    local XComGameState                 NewGameState;
    local UnitValue                     CountUnitValue;
    local int                           Index;
    local bool                          bShouldApply;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        EffectState = XComGameState_Effect(CallbackData);

        if (SourceUnit != none && AbilityState != none && EffectState != none)
        {
            Effect = X2Effect_Assassin(EffectState.GetX2Effect());

            if (Effect != none)
            {
                if (!Effect.bMatchSourceWeapon || AbilityState.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
                {
                    if (Effect.IsEffectCurrentlyRelevant(EffectState, SourceUnit))
                    {
                        if (!SourceUnit.IsConcealed())
                        {
                            TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
                            if (TargetUnit != none)
                            {
                                if (TargetUnit.IsDead() && WasTargetAliveAndFlanked(SourceUnit, TargetUnit, GameState.HistoryIndex - 1))
                                {
                                    bShouldApply = true;
                                }
                            }
                            if (!bShouldApply && Effect.bAllowMultiTarget)
                            {
                                for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
                                {
                                    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[Index].ObjectID));
                                    if (TargetUnit != none)
                                    {
                                        if (TargetUnit.IsDead() && WasTargetAliveAndFlanked(SourceUnit, TargetUnit, GameState.HistoryIndex - 1))
                                        {
                                            bShouldApply = true;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (bShouldApply)
                            {
                                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                                SourceUnit.EnterConcealmentNewGameState(NewGameState);
                                SourceUnit.m_bSpotted = false;

                                if (Effect.CountValueName != '')
                                {
                                    SourceUnit.GetUnitValue(Effect.CountValueName, CountUnitValue);
                                    SourceUnit.SetUnitFloatValue(Effect.CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
                                }

                                if (Effect.bShowFlyover)
                                {
                                    NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                                    XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.TriggerAbilityFlyoverVisualizationFn;
                                }

                                `TACTICALRULES.SubmitGameState(NewGameState);
                            }
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function bool WasTargetAliveAndFlanked(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, int HistoryIndex)
{
    local XComGameState_Unit OldTargetState;

    if (TargetUnit != none)
    {
        OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetUnit.ObjectID,, HistoryIndex));
        if (OldTargetState != none)
        {
            if (OldTargetState.IsAlive())
            {
                if (!TargetUnit.CanTakeCover() || class'M31_Helpers'.static.IsFlanking(SourceUnit, TargetUnit, HistoryIndex))
                {
                    return true;
                }
            }
        }
    }

    return false;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue CountUnitValue;

    if (CountValueName != '')
    {
        TargetUnit.GetUnitValue(CountValueName, CountUnitValue);
        if (ActivationsPerTurn > 0 && CountUnitValue.fValue >= ActivationsPerTurn)
            return false;
    }

    return true;
}

defaultproperties
{
    EffectName = M31_Assassin
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_Assassin_Activations
}