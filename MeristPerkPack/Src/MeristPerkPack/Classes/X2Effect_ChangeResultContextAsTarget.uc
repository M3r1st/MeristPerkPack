//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_ChangeResultContextAsTarget.uc
//  AUTHOR: Merist / Based on Mitzruti's MZ_Effect_InvertCounter
//---------------------------------------------------------------------------------------
class X2Effect_ChangeResultContextAsTarget extends X2Effect_Persistent abstract;

var EAbilityHitResult ChangeHitResults[EAbilityHitResult.EnumCount]<BoundEnum=EAbilityHitResult>;

var int EventPriority;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;

    /// EventID: PostModifyNewAbilityContext
    /// EventData: XComGameStateContext_Ability NewContext
    /// EventSource: XComGameState_Ability AbilityState
    /// NewGameState: no
    EventMgr.RegisterForEvent(EffectObj, 'PostModifyNewAbilityContext', OnPostModifyNewAbilityContext, ELD_Immediate, EventPriority,,, EffectObj);
}

static function EventListenerReturn OnPostModifyNewAbilityContext(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local XComGameState_Unit            Defender, Attacker;
    local X2Effect_ChangeResultContextAsTarget Effect;
    local int Index;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(EventData);
    AbilityState = XComGameState_Ability(EventSource);
    EffectState = XComGameState_Effect(CallbackObject);

    if (AbilityContext == none || AbilityState == none || EffectState == none)
        return ELR_NoInterrupt;

    Defender = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    Attacker = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

    if (Defender == none || Attacker == none)
        return ELR_NoInterrupt;

    Effect = X2Effect_ChangeResultContextAsTarget(EffectState.GetX2Effect());

    if (Effect != none)
    {
        if (Effect.IsAbilityRelevant(AbilityState, Defender, Attacker, EffectState))
        {
            if (Effect.IsEffectCurrentlyRelevant(EffectState, Defender))
            {
                if (AbilityContext.InputContext.PrimaryTarget.ObjectID == Defender.ObjectID)
                {
                    AbilityContext.ResultContext.HitResult = Effect.ChangeHitResults[AbilityContext.ResultContext.HitResult];
                }
                for (Index = 0; Index < AbilityContext.ResultContext.MultiTargetHitResults.Length; Index++)
                {
                    if (AbilityContext.InputContext.MultiTargets[Index].ObjectID == Defender.ObjectID)
                    {
                        AbilityContext.ResultContext.MultiTargetHitResults[Index] = Effect.ChangeHitResults[AbilityContext.ResultContext.MultiTargetHitResults[Index]];
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function bool IsAbilityRelevant(XComGameState_Ability AbilityState, XComGameState_Unit Defender, XComGameState_Unit Attacker, XComGameState_Effect EffectState)
{
    return true;
}

defaultproperties
{
    ChangeHitResults[eHit_Success] = eHit_Success
    ChangeHitResults[eHit_Crit] = eHit_Crit
    ChangeHitResults[eHit_Graze] = eHit_Graze
    ChangeHitResults[eHit_Miss] = eHit_Miss
    ChangeHitResults[eHit_LightningReflexes] = eHit_LightningReflexes
    ChangeHitResults[eHit_Untouchable] = eHit_Untouchable
    ChangeHitResults[eHit_CounterAttack] = eHit_CounterAttack
    ChangeHitResults[eHit_Parry] = eHit_Parry
    ChangeHitResults[eHit_Deflect] = eHit_Deflect
    ChangeHitResults[eHit_Reflect] = eHit_Reflect

    EventPriority = 40
}