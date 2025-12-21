class X2Effect_SleightOfHand extends X2Effect_Persistent;

var int AimPerStack;
var int CritPerStack;
var int MaxStacks;
var int StackDecay;

var name CountValueName;
var bool bMatchSourceWeapon;

var localized string strFriendlyName;
var localized string strFriendlyDesc;
var localized string strFriendlyDesc_Stacks;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EventEventListener_SleightOfHand, ELD_OnStateSubmitted,, TargetState,, EffectObj);
}

static function EventListenerReturn EventEventListener_SleightOfHand(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Ability             AbilityState;
    local XComGameState_Effect              EffectState;
    local X2Effect_SleightOfHand            Effect;
    local X2AbilityTemplate                 AbilityTemplate;
    local XComGameState                     NewGameState;
    local int                               NumShots;
    local int                               NewStackCount;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XComGameState_Effect(CallbackData);
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        if (EffectState != none && SourceUnit != none && AbilityState != none)
        {
            Effect = X2Effect_SleightOfHand(EffectState.GetX2Effect());
            if (Effect != none)
            {
                if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
                    return ELR_NoInterrupt;

                AbilityTemplate = AbilityState.GetMyTemplate();
                if (AbilityTemplate.Hostility == eHostility_Offensive && AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState))
                {
                    if (AbilityContext.InputContext.PrimaryTarget.ObjectID != 0)
                    {
                        NumShots += 1;
                    }
                    if (AbilityTemplate.AbilityMultiTargetStyle != none)
                    {
                        NumShots += AbilityContext.ResultContext.MultiTargetHitResults.Length;
                    }

                    if (NumShots > 0)
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                        SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceUnit.ObjectID));
                        NewStackCount = Min(Effect.GetMaxStacks(SourceUnit), Effect.GetCurrentStacks(SourceUnit) + NumShots);
                        SourceUnit.SetUnitFloatValue(Effect.CountValueName, NewStackCount, eCleanup_BeginTactical);
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }
                }
            }
        }

    }

    return ELR_NoInterrupt;
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local int Counter;
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    Counter = GetCurrentStacks(Attacker);

    if (Counter != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = Counter * AimPerStack;
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Counter * CritPerStack;
        ShotModifiers.AddItem(CritInfo);
    }
}

simulated function bool OnEffectTicked(
    const out EffectAppliedData ApplyEffectParameters,
    XComGameState_Effect kNewEffectState,
    XComGameState NewGameState,
    bool FirstApplication,
    XComGameState_Player Player)
{
    local XComGameState_Unit    UnitState;
    local bool                  bContinueTicking;
    local int                   NewStackCount;

    bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (UnitState != none)
    {
        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
        NewStackCount = Max(0, GetCurrentStacks(UnitState) - GetStackDecay(UnitState));
        UnitState.SetUnitFloatValue(default.CountValueName, NewStackCount, eCleanup_BeginTactical);
    }

    return bContinueTicking;
}

function int GetCurrentStacks(XComGameState_Unit UnitState)
{
    local UnitValue Counter;
    local int CurrentCount;

    UnitState.GetUnitValue(default.CountValueName, Counter);
    CurrentCount = int(Counter.fValue);

    return CurrentCount;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return GetCurrentStacks(TargetUnit) > 0;
}

function int GetMaxStacks(optional XComGameState_Unit SourceUnit)
{
    return MaxStacks;
}

function int GetStackDecay(optional XComGameState_Unit SourceUnit)
{
    return StackDecay;
}

static function string GetFriendlyDescOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameStateHistory  History;
    local XComGameState_Effect  EffectState;
    local X2Effect_WS_Thrill    Effect;
    local XComGameState_Unit    UnitState;
    local string    OutString;
    local int       Count;

    History = `XCOMHISTORY;

    EffectState = XComGameState_Effect(ParseObj);

    if (EffectState != none)
    {
        Effect = X2Effect_WS_Thrill(EffectState.GetX2Effect());
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (Effect != none && UnitState != none)
        {
            Count = Effect.GetCurrentStacks(UnitState);

            OutString = default.strFriendlyDesc_Stacks;

            OutString = Repl(OutString, "[X]", Count * Effect.AimBonusPerStack);
            OutString = Repl(OutString, "[Y]", Count * Effect.CritBonusPerStack);
            OutString = Repl(OutString, "[Z]", Count);

            return OutString;
        }
    }

    return "";
}

defaultproperties
{
    EffectName = M31_SleightOfHand
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_SleightOfHand_Counter
}