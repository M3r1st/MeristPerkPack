class X2Effect_BloodThirst extends X2Effect_Persistent;

var int iMaxStacks;
var int iMaxStacksPerTurn;
var int iStackDuration;
var bool bRefreshDuration;
var bool bApplyToAnyMelee;
var bool bIncreaseOnlyOnHit;

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
    local XComGameState_Unit    SourceUnitState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'SlashActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, SourceUnitState,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'BladestormActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, SourceUnitState,, EffectObj);
    // EventMgr.RegisterForEvent(EffectObj, 'PartingSilkActivated', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, SourceUnitState,, EffectObj);
    // EventMgr.RegisterForEvent(EffectObj, 'HarborWaveDealtDamage', AbilityTriggerEventListener_BloodThirst, ELD_OnStateSubmitted,, SourceUnitState,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_BloodThirst(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local X2Effect_BloodThirst      BloodThirstEffect;
    local XComGameState             NewGameState;
    local int Index;

    BloodThirstEffectState = XCGS_Effect_BloodThirst(XComGameState_Effect(CallbackData));
    BloodThirstEffect = X2Effect_BloodThirst(BloodThirstEffectState.GetX2Effect());

    if (BloodThirstEffect.bIncreaseOnlyOnHit && !XComGameStateContext_Ability(GameState.GetContext()).IsResultContextHit())
        return ELR_NoInterrupt;

    if (BloodThirstEffect.iMaxStacksPerTurn != 0 && BloodThirstEffectState.arrStacksRemaining[0] >= BloodThirstEffect.iMaxStacksPerTurn)
        return ELR_NoInterrupt;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
    
    BloodThirstEffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(class'XCGS_Effect_BloodThirst', BloodThirstEffectState.GetReference().ObjectID));

    if (BloodThirstEffect.iMaxStacks != 0 && BloodThirstEffectState.GetTotalStacksRemaining() >= BloodThirstEffect.iMaxStacks)
    {
        for (Index = BloodThirstEffect.iStackDuration - 1; Index >= 0; Index--)
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
        for (Index = BloodThirstEffect.iStackDuration - 1; Index > 0; Index--)
        {
            BloodThirstEffectState.arrStacksRemaining[Index - 1] = BloodThirstEffectState.arrStacksRemaining[Index];
        }
    }

    BloodThirstEffectState.arrStacksRemaining[0]++;

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
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local bool bContinueTicking;
    local int Index;

    BloodThirstEffectState = XCGS_Effect_BloodThirst(kNewEffectState);

    for (Index = iMaxStacks - 1; Index > 0; Index--)
    {
        BloodThirstEffectState.arrStacksRemaining[Index] = BloodThirstEffectState.arrStacksRemaining[Index - 1];
    }

    bContinueTicking = super.OnEffectTicked(ApplyEffectParameters, kNewEffectState, NewGameState, FirstApplication, Player);
    return bContinueTicking;
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

    if (!(AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef || bApplyToAnyMelee && AbilityState.IsMeleeAbility()))
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) != none)
        return 0;
    
    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));

    iDamagePerStack = iDefaultDamagePerStack;

    for (Index = 0; Index < DamagePerStack.Length; Index++)
    {
        if (DamagePerStack[Index].ItemTemplate == SourceWeapon.GetMyTemplateName())
        {
            iDamagePerStack = DamagePerStack[Index].iDamagePerStack;
            break;
        }
    }

    BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

    return BloodThirstEffectState.GetTotalStacksRemaining() * iDamagePerStack;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    GameStateEffectClass = class'XCGS_Effect_BloodThirst'
}