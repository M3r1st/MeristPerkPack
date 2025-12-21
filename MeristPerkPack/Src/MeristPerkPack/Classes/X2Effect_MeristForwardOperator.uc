class X2Effect_MeristForwardOperator extends X2Effect_ForwardOperator;

var name ActionPointType;
var int ActivationsPerTurn;
var name CountValueName;
var name PendingValueName;

var localized string strFriendlyDesc;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local Object EffectObj;

    EffectObj = EffectGameState;

    `XEVENTMGR.RegisterForEvent(EffectObj, 'ScamperEnd', EffectEventListener_ForwardOperator, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn EffectEventListener_ForwardOperator(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameState_Effect              EffectState;
    local X2Effect_MeristForwardOperator    Effect;
    local XComGameState_Unit                UnitState;
    local XComGameState                     NewGameState;
    local UnitValue                         UnitValue;
    local UnitValue                         PendingUnitValue;

    EffectState = XComGameState_Effect(CallbackData);
    if (EffectState == none)
        return ELR_NoInterrupt;

    Effect = X2Effect_MeristForwardOperator(EffectState.GetX2Effect());
    if (Effect == none)
        return ELR_NoInterrupt;

    UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (UnitState == none)
        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    UnitState.GetUnitValue(Effect.CountValueName, UnitValue);
    if (Effect.ActivationsPerTurn > 0 && int(UnitValue.fValue) >= Effect.ActivationsPerTurn)
        return ELR_NoInterrupt;

    if (UnitState.IsAbleToAct() && !UnitState.IsMindControlled())
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
        
        //  if it is the unit's current turn, add an action point immediately
        if (UnitState.ControllingPlayer == `TACTICALRULES.GetCachedUnitActionPlayerRef())
        {
            UnitState.ActionPoints.AddItem(Effect.GetActionPointType());
        }
        //  otherwise, mark the point to be awarded next turn
        else
        {
            UnitState.GetUnitValue(Effect.PendingValueName, PendingUnitValue);
            UnitState.SetUnitFloatValue(Effect.PendingValueName, PendingUnitValue.fValue + 1, eCleanup_BeginTactical);
        }
        UnitState.SetUnitFloatValue(Effect.CountValueName, UnitValue.fValue + 1, eCleanup_BeginTurn);
        NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
        XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.ForwardOperatorVisualizationFn;

        `GAMERULES.SubmitGameState(NewGameState);
    }
    
    return ELR_NoInterrupt;
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    local UnitValue PendingPointsValue;
    local int i, Points;

    if (UnitState.IsAbleToAct() && !UnitState.IsMindControlled())
    {
        UnitState.GetUnitValue(PendingValueName, PendingPointsValue);
        Points = PendingPointsValue.fValue;
        for (i = 0; i < Points; i++)
        {
            ActionPoints.AddItem(GetActionPointType());
        }
    }
    UnitState.ClearUnitValue(PendingValueName);
}

function name GetActionPointType()
{
    if (ActionPointType != '')
    {
        return ActionPointType;
    }
    else
    {
        return class'X2CharacterTemplateManager'.default.StandardActionPoint;
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue CountUnitValue;

    if (CountValueName != '')
    {
        TargetUnit.GetUnitValue(CountValueName, CountUnitValue);
        if (ActivationsPerTurn > 0 && CountUnitValue.fValue >= ActivationsPerTurn)
            return true;
    }

    return false;
}

defaultproperties
{
    EffectName = M31_ForwardOperator
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_ForwardOperator_Counter
    PendingValueName = M31_ForwardOperator_Pending
}