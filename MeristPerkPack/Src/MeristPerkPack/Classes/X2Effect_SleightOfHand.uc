class X2Effect_SleightOfHand extends X2Effect_Persistent;

var privatewrite name UnitValueName;
var bool bMatchSourceWeapon;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    UnitState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_SleightOfHand, ELD_OnStateSubmitted, 30, UnitState,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_SleightOfHand(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Ability             AbilityState;
    local XComGameState_Effect              EffectState;
    local X2AbilityTemplate                 AbilityTemplate;
    local X2AbilityMultiTarget_BurstFire    BurstFire;
    local XComGameState                     NewGameState;
    local int                               NumShots;
    local int                               NewStackCount;

    SourceUnit = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(EventData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    EffectState = XComGameState_Effect(CallbackData);

    if (SourceUnit == none || AbilityState == none || AbilityContext == none || EffectState == none)
        return ELR_NoInterrupt;

    if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
        return ELR_NoInterrupt;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return ELR_NoInterrupt;

    AbilityTemplate = AbilityState.GetMyTemplate();

    if (AbilityTemplate.Hostility == eHostility_Offensive && AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState))
    {
        if (AbilityContext.InputContext.PrimaryTarget.ObjectID != 0)
            NumShots += 1;

        if (AbilityTemplate.AbilityMultiTargetStyle != none)
        {
            BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
            if (BurstFire != none)
            {
                NumShots += BurstFire.NumExtraShots;
            }
            else
            {
                NumShots += AbilityContext.ResultContext.MultiTargetHitResults.Length;
            }
        }

        if (NumShots > 0)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
            SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceUnit.ObjectID));
            NewStackCount = Min(GetMaxStacks(SourceUnit), GetCurrentStackCount(SourceUnit) + NumShots);
            SourceUnit.SetUnitFloatValue(default.UnitValueName, NewStackCount, eCleanup_BeginTactical);
            `TACTICALRULES.SubmitGameState(NewGameState);
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

    Counter = GetCurrentStackCount(Attacker);

    if (Counter != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = Counter * `GetConfigInt("M31_SleightOfHand_AimPerStack");
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Counter * `GetConfigInt("M31_SleightOfHand_CritPerStack");
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
        NewStackCount = Max(0, GetCurrentStackCount(UnitState) - GetStackDecay(UnitState));
        UnitState.SetUnitFloatValue(default.UnitValueName, NewStackCount, eCleanup_BeginTactical);
    }

    return bContinueTicking;
}

static function int GetCurrentStackCount(XComGameState_Unit UnitState)
{
    local UnitValue Counter;
    local int CurrentCount;

    UnitState.GetUnitValue(default.UnitValueName, Counter);
    CurrentCount = int(Counter.fValue);

    return CurrentCount;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return GetCurrentStackCount(TargetUnit) > 0;
}

static function int GetMaxStacks(optional XComGameState_Unit SourceUnit)
{
    return `GetConfigInt("M31_SleightOfHand_MaxStacks");
}

static function int GetStackDecay(optional XComGameState_Unit SourceUnit)
{
    return `GetConfigInt("M31_SleightOfHand_StackDecay");
}

defaultproperties
{
    EffectName = M31_SleightOfHand
    DuplicateResponse = eDupe_Ignore
    UnitValueName = M31_SleightOfHand_Counter
}