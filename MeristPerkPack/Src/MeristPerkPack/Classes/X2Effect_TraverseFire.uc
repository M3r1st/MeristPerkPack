class X2Effect_TraverseFire extends X2Effect_RefundActionPoints;

static function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_RefundActionPoints   Effect;
    local XComGameState                 NewGameState;
    local UnitValue                     CountUnitValue;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        EffectState = XComGameState_Effect(CallbackData);

        if (SourceUnit != none && AbilityState != none && EffectState != none)
        {
            Effect = X2Effect_RefundActionPoints(EffectState.GetX2Effect());

            if (Effect != none)
            {
                if (Effect.IsEffectCurrentlyRelevant(EffectState, SourceUnit))
                {
                    if (Effect.IsAbilityRelevant(AbilityState, SourceUnit, EffectState))
                    {
                        if (!WasAbilityFree(AbilityState, SourceUnit, GameState.HistoryIndex - 1))
                        {
                            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                            SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));

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

                            SourceUnit.ActionPoints.AddItem(Effect.GetActionPointType());

                            `TACTICALRULES.SubmitGameState(NewGameState);
                        }
                    }
                    else
                    {
                        if (AbilityState.IsAbilityInputTriggered())
                        {
                            if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive || !WasAbilityFree(AbilityState, SourceUnit, GameState.HistoryIndex - 1))
                            {
                                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                                SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
                                SourceUnit.SetUnitFloatValue(Effect.CountValueName, Effect.ActivationsPerTurn + 1, eCleanup_BeginTurn);
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

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Ability EffectAbilityState;
    local UnitValue             CountUnitValue;

    if (bRefundAll)
    {
        if (IsEffectCurrentlyRelevant(EffectState, SourceUnit))
        {
            if (IsAbilityRelevant(kAbility, SourceUnit, EffectState))
            {
                if (!WasAbilityFree(kAbility, SourceUnit))
                {
                    if (CountValueName != '')
                    {
                        SourceUnit.GetUnitValue(CountValueName, CountUnitValue);
                        SourceUnit.SetUnitFloatValue(CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
                    }

                    if (bShowFlyover && FlyoverEventName != '')
                    {
                        EffectAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
                        `XEVENTMGR.TriggerEvent(FlyoverEventName, EffectAbilityState, SourceUnit, NewGameState);
                    }

                    SourceUnit.ActionPoints = PreCostActionPoints;
                    return true;
                }
            }
            else
            {
                if (kAbility.IsAbilityInputTriggered())
                {
                    if (kAbility.GetMyTemplate().Hostility == eHostility_Offensive || !WasAbilityFree(kAbility, SourceUnit))
                    {
                        SourceUnit.SetUnitFloatValue(CountValueName, ActivationsPerTurn + 1, eCleanup_BeginTurn);
                    }
                }
            }
        }
    }

    return false;
}

static function bool ValidateAbilityCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
    local X2AbilityTemplate Template;
    local X2AbilityCost Cost;
    local X2AbilityCost_ActionPoints ActionPointCost;

    Template = AbilityState.GetMyTemplate();

    foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none && !ActionPointCost.bFreeCost && ActionPointCost.GetPointCost(AbilityState, AbilityOwner) > 0)
            return false;
    }
    return true;
}

defaultproperties
{
    EffectName = M31_TraverseFire
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_TraverseFire_Activations
    FlyoverEventName = M31_TraverseFire_Flyover

    bRefundAll = false

    bMatchSourceWeapon = true
}
