//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodThirst.uc
//  AUTHOR:  Merist
//  PURPOSE: Persistent effect that increases the user's melee damage for each melee attack they perform.
//           Relies on XCGS_Effect_BloodThirst.
//---------------------------------------------------------------------------------------
class X2Effect_BloodThirst extends X2Effect_Persistent;

var int iMaxStacks;
var int iMaxStacksPerTurn;
var int iStackDuration;
var bool bRefreshDuration;
var bool bIncreaseOnlyOnHit;
var bool bMatchSourceWeapon;

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

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);

    if (bChosenVersion)
    {
        // EventMgr.RegisterForEvent(EffectObj, 'PartingSilkActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
        EventMgr.RegisterForEvent(EffectObj, 'HarborWaveDealtDamage', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);
    }
}

static function EventListenerReturn AbilityTriggerEventListener_BloodThirst(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XCGS_Effect_BloodThirst       BloodThirstEffectState;
    local X2Effect_BloodThirst          BloodThirstEffect;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            UnitState;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState                 NewGameState;
    local int Index;
    local int Length;
    local int MaxCount, MaxCountPerTurn;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext == none || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
        return ELR_NoInterrupt;

    BloodThirstEffectState = XCGS_Effect_BloodThirst(CallbackData);
    BloodThirstEffect = X2Effect_BloodThirst(BloodThirstEffectState.GetX2Effect());
    
    if (BloodThirstEffectState == none || BloodThirstEffect ==  none)
        return ELR_NoInterrupt;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BloodThirstEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (UnitState == none)
        return ELR_NoInterrupt;

    if (EventID == 'AbilityActivated')
    {
        AbilityState = XComGameState_Ability(EventData);

        if (AbilityState == none)
            return ELR_NoInterrupt;

        AbilityTemplate = AbilityState.GetMyTemplate();
        if (!AbilityState.IsMeleeAbility())
        {
            if (BloodThirstEffect.bChosenVersion)
            {
                if (AbilityTemplate.PostActivationEvents.Find('PartingSilkActivated') == INDEX_NONE)
                    return ELR_NoInterrupt;
            }
            else
            {
                return ELR_NoInterrupt;
            }
        }

        if (BloodThirstEffect.bMatchSourceWeapon && AbilityState.SourceWeapon.ObjectID != BloodThirstEffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
            return ELR_NoInterrupt;

        if (BloodThirstEffect.bIncreaseOnlyOnHit && !AbilityContext.IsResultContextHit())
            return ELR_NoInterrupt;
    }

    MaxCount = BloodThirstEffect.GetMaxStackCount(UnitState);
    MaxCountPerTurn = BloodThirstEffect.GetMaxStackCountPerTurn(UnitState);

    if (MaxCountPerTurn > 0 && BloodThirstEffectState.iStacksThisTurn >= MaxCountPerTurn)
        return ELR_NoInterrupt;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
    BloodThirstEffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(class'XCGS_Effect_BloodThirst', BloodThirstEffectState.ObjectID));

    Length = BloodThirstEffect.GetStackDuration(UnitState);

    if (MaxCount > 0 && BloodThirstEffectState.GetTotalStacksRemaining() >= MaxCount)
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
        for (Index = 0; Index < Length - 1; Index++)
        {
            BloodThirstEffectState.arrStacksRemaining[Length - 1] = BloodThirstEffectState.arrStacksRemaining[Length - 1] + BloodThirstEffectState.arrStacksRemaining[Index];
            BloodThirstEffectState.arrStacksRemaining[Index] = 0;
        }
    }

    BloodThirstEffectState.iStacksThisTurn++;
    BloodThirstEffectState.arrStacksRemaining[Length - 1] = BloodThirstEffectState.arrStacksRemaining[Length - 1] + 1;

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
    local XComGameState_Unit UnitState;
    local bool bContinueTicking;

    bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);

    BloodThirstEffectState = XCGS_Effect_BloodThirst(kNewEffectState);
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BloodThirstEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (BloodThirstEffectState != none && UnitState != none)
    {
        BloodThirstEffectState.arrStacksRemaining.Remove(0, 1);
        BloodThirstEffectState.arrStacksRemaining[GetStackDuration(UnitState) - 1] = 0;
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
    local XComGameState_Unit        UnitState;
    local XComGameState_Item        SourceWeapon;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local int iDamagePerStack;
 
    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (!AbilityState.IsMeleeAbility())
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;
    
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    iDamagePerStack = GetDamagePerStack(UnitState, SourceWeapon);

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

simulated function int GetDamagePerStack(XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon)
{
    local int iDamagePerStack;
    local int Index;

    iDamagePerStack = iDefaultDamagePerStack;

    if (SourceWeapon != none)
    {
        Index = DamagePerStack.Find('ItemTemplate', SourceWeapon.GetMyTemplateName());
        if (Index != INDEX_NONE)
        {
            iDamagePerStack = DamagePerStack[Index].iDamagePerStack;
        }
    }

    return iDamagePerStack;
}

defaultproperties
{
    EffectName = M31_BloodThirst
    DuplicateResponse = eDupe_Ignore
    GameStateEffectClass = class'XCGS_Effect_BloodThirst'
    iDefaultDamagePerStack = 1
}