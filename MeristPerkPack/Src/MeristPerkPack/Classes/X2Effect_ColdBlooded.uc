class X2Effect_ColdBlooded extends X2Effect_RefundActionPoints;

var array<name> AllowedEffects;
var bool bIncludeDefaultEffects;

static function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            OldTargetState;
    local XComGameState_Effect          EffectState;
    local X2Effect_ColdBlooded          Effect;
    
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XComGameState_Effect(CallbackData);
        if (EffectState != none)
        {
            Effect = X2Effect_ColdBlooded(EffectState.GetX2Effect());
            if (Effect != none)
            {
                OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID,, GameState.HistoryIndex - 1));
                if (OldTargetState != none && Effect.ValidateEffects(OldTargetState))
                {
                    return class'X2Effect_RefundActionPoints'.static.OnAbilityActivated(EventData, EventSource, GameState, EventID, CallbackData);
                }
            }
        }
    }
}

function bool PostAbilityCostPaid(
    XComGameState_Effect EffectState,
    XComGameStateContext_Ability AbilityContext,
    XComGameState_Ability kAbility,
    XComGameState_Unit SourceUnit,
    XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Unit OldTargetState;

    OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

    if (OldTargetState != none && ValidateEffects(OldTargetState))
    {
        return super.PostAbilityCostPaid(EffectState, AbilityContext, kAbility, SourceUnit, AffectWeapon, NewGameState, PreCostActionPoints, PreCostReservePoints);;
    }

    return false;
}

simulated function bool ValidateEffects(XComGameState_Unit UnitState)
{
    local name Effect;

    if (UnitState == none)
        return false;

    if (bIncludeDefaultEffects)
    {
        if (UnitState.IsBurning() || UnitState.IsPoisoned() || UnitState.IsAcidBurning() ||
            UnitState.AffectedByEffectNames.Find(class'X2StatusEffects'.default.BleedingName) != INDEX_NONE)
        {
            return true;
        }
    }

    foreach AllowedEffects(Effect)
    {
        if (UnitState.AffectedByEffectNames.Find(Effect) != INDEX_NONE)
        {
            return true;
        }
    }
    
    return false;
}

defaultproperties
{
    EffectName = M31_ColdBlooded

    CountValueName = M31_ColdBlooded_Counter
    FlyoverEventName = M31_ColdBlooded_Flyover

    bRefundAll = false

    bMatchSourceWeapon = true
    bIncludeDefaultEffects = true
}
