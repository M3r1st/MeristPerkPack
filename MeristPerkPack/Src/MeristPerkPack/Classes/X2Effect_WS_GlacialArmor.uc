class X2Effect_WS_GlacialArmor extends X2Effect_BonusArmor;

var int ActivationsPerTurn;
var int ArmorBonus;
var int DodgeBonus;
var int CritResistance;
var int DamageReduction;
var int DamageReductionPrc;
var bool bAllowWhileBurning;

var name CountValueName;
var name UnShreddedValueName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectEventListener_GlacialArmor, ELD_Immediate, 10, TargetState,, EffectObj);
}

static function EventListenerReturn EffectEventListener_GlacialArmor(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XComGameState_Effect      EffectState;
    local X2Effect_WS_GlacialArmor  Effect;
    local XComGameState_Unit        NewSourceState, OldSourceState;
    local UnitValue                 CountUnitValue;
    local DamageResult              LastDamageResult;
    local int                       iUnshred;

    EffectState = XComGameState_Effect(CallbackData);
    OldSourceState = XComGameState_Unit(EventSource);
    OldSourceState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OldSourceState.ObjectID));
    if (OldSourceState != none)
    {
        NewSourceState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(OldSourceState.ObjectID));
        if (NewSourceState == none)
        {
            NewSourceState = XComGameState_Unit(NewGameState.ModifyStateObject(OldSourceState.Class, OldSourceState.ObjectID));
        }
    }
    if (EffectState != none && NewSourceState != none)
    {
        Effect = X2Effect_WS_GlacialArmor(EffectState.GetX2Effect());
        if (Effect != none)
        {
            // if (Effect.IsEffectCurrentlyRelevant(EffectState, OldSourceState))
            if (Effect.GetCurrentStackCount(NewSourceState) < Effect.ActivationsPerTurn && (Effect.bAllowWhileBurning || !OldSourceState.IsBurning()))
            {
                if (NewSourceState.DamageResults.Length > 0)
                {
                    LastDamageResult = NewSourceState.DamageResults[NewSourceState.DamageResults.Length - 1];
                    NewSourceState.GetUnitValue(Effect.UnShreddedValueName, CountUnitValue);
                    iUnshred = Min(LastDamageResult.Shred, Effect.ArmorBonus - CountUnitValue.fValue);
                    iUnshred = Min(iUnshred, NewSourceState.Shredded);
                    if (iUnshred > 0)
                    {
                        NewSourceState.DamageResults[NewSourceState.DamageResults.Length - 1].Shred -= iUnshred;
                        NewSourceState.Shredded -= iUnshred;
                        NewSourceState.SetUnitFloatValue(Effect.UnShreddedValueName, CountUnitValue.fValue + iUnshred, eCleanup_BeginTurn);
                    }
                }
                NewSourceState.GetUnitValue(Effect.CountValueName, CountUnitValue);
                NewSourceState.SetUnitFloatValue(Effect.CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
            }
        }
    }

    return ELR_NoInterrupt;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    local UnitValue CountUnitValue;

    if (IsEffectCurrentlyRelevant(EffectState, UnitState))
    {
        return Max(0, ArmorBonus - CountUnitValue.fValue);
    }

    return 0;
}

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo  DodgeInfo, CritInfo;

    if (IsEffectCurrentlyRelevant(EffectState, Target))
    {
        DodgeInfo.ModType = eHit_Graze;
        DodgeInfo.Reason = FriendlyName;
        DodgeInfo.Value = DodgeBonus;
        ShotModifiers.AddItem(DodgeInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = -1 * CritResistance;
        ShotModifiers.AddItem(CritInfo);
    }
}

function int GetDefendingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    optional XComGameState NewGameState)
{
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (IsEffectCurrentlyRelevant(EffectState, XComGameState_Unit(TargetDamageable)))
            {
                return -1 * Min(CurrentDamage, DamageReduction);
            }
        }
    }
    
    return 0;
}

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameState_Unit TargetUnit,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float WeaponDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
    {
        if (WeaponDamage > 0)
        {
            if (IsEffectCurrentlyRelevant(EffectState, TargetUnit))
            {
                return -1 * Min(WeaponDamage, WeaponDamage * DamageReductionPrc / 100); 
            }
        }
    }

    return 0;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return GetCurrentStackCount(TargetUnit) < ActivationsPerTurn && (bAllowWhileBurning || !TargetUnit.IsBurning());
}

function int GetCurrentStackCount(XComGameState_Unit UnitState)
{
    local UnitValue CountUnitValue;

    UnitState.GetUnitValue(CountValueName, CountUnitValue);

    return CountUnitValue.fValue;
}

defaultproperties
{
    EffectName = M31_PA_WS_GlacialArmor
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_PA_WS_GlacialArmor_Counter
    UnShreddedValueName = M31_PA_WS_GlacialArmor_UnShredded
}