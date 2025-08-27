//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodThirst.uc
//  AUTHOR:  Merist
//  PURPOSE: Persistent effect that increases the user's melee damage for each melee attack they perform.
//           Relies on XCGS_Effect_BloodThirst.
//---------------------------------------------------------------------------------------
class X2Effect_BloodThirst extends X2Effect_Persistent;

var privatewrite bool bLog;
var privatewrite bool bLog2;

var int iMaxStacks;
var int iMaxStacksPerTurn;
var int iStackDuration;
var bool bRefreshDuration;
var bool bApplyToAnyMelee;
var bool bActivateFromAnyMelee;
var bool bIncreaseOnlyOnHit;
var bool bChosenVersion;

struct DamagePerStackInfo
{
    var name ItemTemplate;
    var int iDamagePerStack;
};

var int iDefaultDamagePerStack;
var array<DamagePerStackInfo> DamagePerStack;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (bActivateFromAnyMelee)
    {
        EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
    }
    else
    {
        EventMgr.RegisterForEvent(EffectObj, 'SlashActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
        EventMgr.RegisterForEvent(EffectObj, 'BladestormActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
    }
    if (bChosenVersion)
    {
        EventMgr.RegisterForEvent(EffectObj, 'PartingSilkActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
        EventMgr.RegisterForEvent(EffectObj, 'HarborWaveDealtDamage', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
    }
}

static function EventListenerReturn AbilityTriggerEventListener_BloodThirst(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XCGS_Effect_BloodThirst       BloodThirstEffectState;
    local X2Effect_BloodThirst          BloodThirstEffect;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState_Unit            EffectSourceUnit;
    local XComGameState                 NewGameState;
    local int Index;
    local int Length;
    local int MaxCount, MaxCountPerTurn;

    BloodThirstEffectState = XCGS_Effect_BloodThirst(CallbackData);
    BloodThirstEffect = X2Effect_BloodThirst(BloodThirstEffectState.GetX2Effect());
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    EffectSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BloodThirstEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (BloodThirstEffectState == none || BloodThirstEffect ==  none || AbilityContext == none || EffectSourceUnit == none)
        return ELR_NoInterrupt; 

    if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
        return ELR_NoInterrupt;

    `LOG("Blood Thirst Listener Start", default.bLog, GetFuncName());

    if (BloodThirstEffect.bActivateFromAnyMelee)
    {
        AbilityState = XComGameState_Ability(EventData);
        if (AbilityState != none)
        {
            `LOG("Validating" $ AbilityState.GetMyTemplateName(), default.bLog, GetFuncName());
            AbilityTemplate = AbilityState.GetMyTemplate();
            if (!AbilityState.IsMeleeAbility() && (!BloodThirstEffect.bChosenVersion || AbilityTemplate.PostActivationEvents.Find('PartingSilkActivated') == INDEX_NONE))
                return ELR_NoInterrupt;
        }
    }

    if (BloodThirstEffect.bIncreaseOnlyOnHit && !AbilityContext.IsResultContextHit())
        return ELR_NoInterrupt;

    MaxCount = BloodThirstEffect.GetMaxStackCount(EffectSourceUnit);
    MaxCountPerTurn = BloodThirstEffect.GetMaxStackCountPerTurn(EffectSourceUnit);

    if (MaxCountPerTurn != 0 && BloodThirstEffectState.iStacksThisTurn >= MaxCountPerTurn)
        return ELR_NoInterrupt;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
    
    BloodThirstEffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(class'XCGS_Effect_BloodThirst', BloodThirstEffectState.GetReference().ObjectID));

    Length = BloodThirstEffect.GetStackDuration(EffectSourceUnit);

    `LOG("Before:", default.bLog, GetFuncName());
    `LOG("This turn:" $ BloodThirstEffectState.iStacksThisTurn, default.bLog, GetFuncName());
    for (Index = 0; Index < Length; Index++)
    {
        `LOG(Index $ ": " $ BloodThirstEffectState.arrStacksRemaining[Index], default.bLog, GetFuncName());
    }

    if (MaxCount != 0 && BloodThirstEffectState.GetTotalStacksRemaining() >= MaxCount)
    {
        for (Index = 0; Index < Length; Index++)
        {
            if (BloodThirstEffectState.arrStacksRemaining[Index] > 0)
            {
                BloodThirstEffectState.arrStacksRemaining[Index]--;
                break;
            }
        }
    }

    if (BloodThirstEffect.bRefreshDuration)
    {
        `LOG("Refrishing existing stacks:", default.bLog2, GetFuncName());
        `LOG("Before:", default.bLog2, GetFuncName());
        for (Index = 0; Index < Length; Index++)
        {
            `LOG(Index $ ": " $ BloodThirstEffectState.arrStacksRemaining[Index], default.bLog2, GetFuncName());
        }
        for (Index = 0; Index < Length - 1; Index++)
        {
            BloodThirstEffectState.arrStacksRemaining[Length - 1] = BloodThirstEffectState.arrStacksRemaining[Length - 1] + BloodThirstEffectState.arrStacksRemaining[Index];
            BloodThirstEffectState.arrStacksRemaining[Index] = 0;
        }
        `LOG("After:", default.bLog2, GetFuncName());
        for (Index = 0; Index < Length; Index++)
        {
            `LOG(Index $ ": " $ BloodThirstEffectState.arrStacksRemaining[Index], default.bLog2, GetFuncName());
        }

    }

    BloodThirstEffectState.iStacksThisTurn++;
    BloodThirstEffectState.arrStacksRemaining[Length - 1] = BloodThirstEffectState.arrStacksRemaining[Length - 1] + 1;

    `LOG("After:", default.bLog, GetFuncName());
    `LOG("This turn:" $ BloodThirstEffectState.iStacksThisTurn, default.bLog, GetFuncName());
    for (Index = 0; Index < Length; Index++)
    {
        `LOG(Index $ ": " $ BloodThirstEffectState.arrStacksRemaining[Index], default.bLog, GetFuncName());
    }

    `TACTICALRULES.SubmitGameState(NewGameState);

    return ELR_NoInterrupt;
}

simulated function bool OnEffectTicked(
    const out EffectAppliedData ApplyEffectParameters,
    XComGameState_Effect kNewEffectState,
    XComGameState NewGameState,
    bool FirstApplication,
    XComGameState_Player Player)
{
    local XCGS_Effect_BloodThirst BloodThirstEffectState;
    local XComGameState_Unit EffectSourceUnit;
    local bool bContinueTicking;

    `LOG("Begin", default.bLog, GetFuncName());

    bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);

    BloodThirstEffectState = XCGS_Effect_BloodThirst(kNewEffectState);
    EffectSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BloodThirstEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (BloodThirstEffectState != none && EffectSourceUnit != none)
    {
        BloodThirstEffectState.arrStacksRemaining.Remove(0, 1);
        BloodThirstEffectState.arrStacksRemaining[GetStackDuration(EffectSourceUnit) - 1] = 0;
        BloodThirstEffectState.iStacksThisTurn = 0;
    }

    return bContinueTicking;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XCGS_Effect_BloodThirst BloodThirstEffectState;

    BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectGameState);
    
    return BloodThirstEffectState != none && BloodThirstEffectState.GetTotalStacksRemaining() > 0;
}

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local XComGameState_Item        SourceWeapon;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local int Index;
    local int iDamagePerStack;
 
    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (!AbilityState.IsMeleeAbility())
        return 0;

    if (!bApplyToAnyMelee && AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;
    
    iDamagePerStack = iDefaultDamagePerStack;

    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    if (SourceWeapon != none)
    {
        for (Index = 0; Index < DamagePerStack.Length; Index++)
        {
            if (DamagePerStack[Index].ItemTemplate == SourceWeapon.GetMyTemplateName())
            {
                iDamagePerStack = DamagePerStack[Index].iDamagePerStack;
                break;
            }
        }
    }

    BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

    if (BloodThirstEffectState == none)
        return 0;
    
    return BloodThirstEffectState.GetTotalStacksRemaining() * iDamagePerStack;
}

simulated function int GetStackDuration(XComGameState_Unit SourceUnit)
{
    return iStackDuration;
}

simulated function int GetMaxStackCount(XComGameState_Unit SourceUnit)
{
    return iMaxStacks;
}

simulated function int GetMaxStackCountPerTurn(XComGameState_Unit SourceUnit)
{
    return iMaxStacksPerTurn;
}

defaultproperties
{
    EffectName = M31_BloodThirst
    DuplicateResponse = eDupe_Ignore
    GameStateEffectClass = class'XCGS_Effect_BloodThirst'
    iDefaultDamagePerStack = 1

    bLog = false
    bLog2 = false
}