//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodThirst.uc
//  AUTHOR:  Merist
//  PURPOSE: Persistent effect that increases the user's melee damage for each melee attack they perform.
//           Relies on XCGS_Effect_BloodThirst.
//---------------------------------------------------------------------------------------
class X2Effect_BloodThirst extends X2Effect_Persistent;

var int MaxStacks;
var int MaxStacksPerTurn;
var int StackDuration;
var bool bRefreshDuration;
var bool bIncreaseOnlyOnHit;
var bool bMatchSourceWeapon;
var array<name> IncludeAbilities;

// var bool bChosenVersion;

var int DamagePerStack;

var localized string strFriendlyName;
var localized string strFriendlyDesc;
var localized string strFriendlyDesc_NoStacks;
var localized string strFriendlyDesc_Stacks;
var localized string strFriendlyDesc_StacksTurn;
var localized string strFriendlyDesc_StacksFirst;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_BloodThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);

    // if (bChosenVersion)
    // {
    //     EventMgr.RegisterForEvent(EffectObj, 'HarborWaveDealtDamage', EffectEventListener_OnHarborWaveDealtDamage, ELD_Immediate,, TargetState,, EffectObj);
    // }
}

static function EventListenerReturn EffectEventListener_BloodThirst(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XCGS_Effect_BloodThirst       EffectState;
    local X2Effect_BloodThirst          Effect;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState                 NewGameState;
    local int                           MaxCountPerTurn;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XCGS_Effect_BloodThirst(CallbackData);
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        if (EffectState != none && SourceUnit != none && AbilityState != none)
        {
            Effect = X2Effect_BloodThirst(EffectState.GetX2Effect());
            if (Effect != none)
            {
                MaxCountPerTurn = Effect.GetMaxStackCountPerTurn(SourceUnit);
                if (MaxCountPerTurn <= 0 || EffectState.iStacksThisTurn < MaxCountPerTurn)
                {
                    if (Effect.IsAbilityRelevant(AbilityState, EffectState, SourceUnit, AbilityContext))
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                        EffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                        EffectState.AddStacks(, SourceUnit);
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn EffectEventListener_OnHarborWaveDealtDamage(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XCGS_Effect_BloodThirst   EffectState, NewEffectState;
    local X2Effect_BloodThirst      Effect;
    local XComGameState_Unit        SourceUnit;
    local XComGameState_Ability     AbilityState;
    local int                       MaxCountPerTurn;

    EffectState = XCGS_Effect_BloodThirst(CallbackData);
    SourceUnit = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(EventData);
    if (EffectState != none && SourceUnit != none && AbilityState != none)
    {
        Effect = X2Effect_BloodThirst(EffectState.GetX2Effect());
        if (Effect != none)
        {
            MaxCountPerTurn = Effect.GetMaxStackCountPerTurn(SourceUnit);
            NewEffectState = XCGS_Effect_BloodThirst(NewGameState.GetGameStateForObjectID(EffectState.ObjectID));
            if (NewEffectState == none)
            {
                if (MaxCountPerTurn <= 0 || EffectState.iStacksThisTurn < MaxCountPerTurn)
                {
                    NewEffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                    NewEffectState.AddStacks(, SourceUnit);
                }
            }
            else
            {
                if (MaxCountPerTurn <= 0 || NewEffectState.iStacksThisTurn < MaxCountPerTurn)
                {
                    NewEffectState.AddStacks(, SourceUnit);
                }
            }
        }
    }

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

function bool IsAbilityRelevant(
    XComGameState_Ability AbilityState,
    XCGS_Effect_BloodThirst EffectState,
    XComGameState_Unit SourceUnit,
    XComGameStateContext_Ability AbilityContext)
{
    local X2AbilityTemplate AbilityTemplate;
    local bool bDealsDamage;

    if (IncludeAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();

        bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);
        if (AbilityTemplate.Hostility == eHostility_Offensive && bDealsDamage && !AbilityTemplate.bIsASuppressionEffect)
        {
            if (!AbilityTemplate.IsMelee())
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    if (bMatchSourceWeapon)
    {
        if (AbilityState.SourceWeapon.ObjectID > 0)
        {
            if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    if (bIncreaseOnlyOnHit)
    {
        if (!AbilityContext.IsResultContextHit())
        {
            return false;
        }
    }

    return true;
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
    local XComGameState_Item        EffectSourceWeapon;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (!AbilityState.IsMeleeAbility() && IncludeAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);
            EffectSourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
            if (BloodThirstEffectState != none)
            {
                return BloodThirstEffectState.GetTotalStacksRemaining() * GetDamagePerStack(Attacker, EffectSourceWeapon);
            }
        }
    }

    return 0;
}

simulated function int GetStackDuration(XComGameState_Unit SourceUnit)
{
    return StackDuration;
}

simulated function int GetMaxStackCount(XComGameState_Unit SourceUnit)
{
    return MaxStacks;
}

simulated function int GetMaxStackCountPerTurn(XComGameState_Unit SourceUnit)
{
    return MaxStacksPerTurn;
}

simulated function int GetDamagePerStack(XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon)
{
    return DamagePerStack;
}

static function string GetFriendlyDescOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameStateHistory      History;
    local XCGS_Effect_BloodThirst   EffectState;
    local X2Effect_BloodThirst      Effect;
    local XComGameState_Unit        UnitState;
    local string    OutString;
    local string    NewString;
    local int       Index;
    local int       Count;

    History = `XCOMHISTORY;

    EffectState = XCGS_Effect_BloodThirst(ParseObj);

    if (EffectState != none)
    {
        Effect = X2Effect_BloodThirst(EffectState.GetX2Effect());
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

        if (Effect != none && UnitState != none)
        {
            Count = EffectState.GetTotalStacksRemaining();
            if (Count == 0)
            {
                return default.strFriendlyDesc_NoStacks;
            }
            else
            {
                NewString = default.strFriendlyDesc_Stacks;
                NewString = Repl(NewString, "[X]", Count);
                OutString = NewString $ "<br>";
            }
            for (Index = 0; Index < Effect.GetStackDuration(UnitState); Index++)
            {
                if (EffectState.arrStacksRemaining[Index] > 0)
                {                 
                    if (Index == 0)
                    {
                        NewString = default.strFriendlyDesc_StacksFirst;
                        NewString = Repl(NewString, "[X]", EffectState.arrStacksRemaining[Index]);
                        OutString $= "<br>" $ NewString;
                    }
                    else
                    {
                        NewString = default.strFriendlyDesc_StacksTurn;
                        NewString = Repl(NewString, "[X]", EffectState.arrStacksRemaining[Index]);
                        NewString = Repl(NewString, "[Y]", Index + 1);
                        OutString $= "<br>" $ NewString;
                    }
                }
            }
            return OutString;
        }
    }

    return "";
}

defaultproperties
{
    EffectName = M31_BloodThirst
    DuplicateResponse = eDupe_Ignore
    GameStateEffectClass = class'XCGS_Effect_BloodThirst'
    DamagePerStack = 1
}