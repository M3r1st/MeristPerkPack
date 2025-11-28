class X2Effect_PA_TaipanBloodThirst extends X2Effect_BloodThirst config(GameData_SoldierSkills);

var config bool bUseFocusUI;
var config string TaipanBloodThirstColor;
var config string TaipanBloodThirstIcon;
var localized string TaipanBloodThirstTitle;
var localized string TaipanBloodThirstDesc;
var localized string TaipanBloodThirstDesc_NoStacks;
var localized string TaipanBloodThirstDesc_Stacks;
var localized string TaipanBloodThirstDesc_Damage;
var localized string TaipanBloodThirstDesc_OtherDamage;
var localized string TaipanBloodThirstDesc_Crit;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;
    local XComGameState_Unit    TargetState;

    super.RegisterForEvents(EffectGameState);

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (bUseFocusUI)
    {
        EventMgr.RegisterForEvent(EffectObj, 'OverrideUnitFocusUI', OnOverrideFocus, ELD_Immediate,, TargetState,, EffectObj);
    }
}

static function EventListenerReturn OnOverrideFocus(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComLWTuple               Tuple;
    local XComGameState_Unit        UnitState;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local X2Effect_PA_TaipanBloodThirst BloodThirstEffect;
    local X2AbilityTag              AbilityTag;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideUnitFocusUI');

    UnitState = XComGameState_Unit(EventSource);
    BloodThirstEffectState = XCGS_Effect_BloodThirst(CallbackData);
    BloodThirstEffect = X2Effect_PA_TaipanBloodThirst(BloodThirstEffectState.GetX2Effect());

    if (UnitState == none || BloodThirstEffectState == none || BloodThirstEffect == none)
        return ELR_NoInterrupt;

    AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
    AbilityTag.ParseObj = BloodThirstEffectState;

    Tuple.Data[0].b = UnitState.IsFriendlyToLocalPlayer();
    Tuple.Data[1].i = BloodThirstEffectState.GetTotalStacksRemaining();
    Tuple.Data[2].i = BloodThirstEffect.GetMaxStackCount(UnitState);
    Tuple.Data[3].s = "0x" $ default.TaipanBloodThirstColor;
    Tuple.Data[4].s = default.TaipanBloodThirstIcon;
    Tuple.Data[5].s = `XEXPAND.ExpandString(default.TaipanBloodThirstDesc);
    Tuple.Data[6].s = default.TaipanBloodThirstTitle;

    AbilityTag.ParseObj = none;

    return ELR_NoInterrupt;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    if (bUseFocusUI)
        return false;
    
    return super.IsEffectCurrentlyRelevant(EffectGameState, TargetUnit);
}

simulated function int GetStackDuration(XComGameState_Unit SourceUnit)
{
    return super.GetStackDuration(SourceUnit)
        + (SourceUnit.HasSoldierAbility('M31_PA_TaipanBloodHunter', true) ? `GetConfigInt("M31_PA_TaipanBloodHunter_BonusDuration") : 0);
}

simulated function int GetMaxStackCount(XComGameState_Unit SourceUnit)
{
    return super.GetMaxStackCount(SourceUnit)
        + (SourceUnit.HasSoldierAbility('M31_PA_TaipanBloodHunter', true) ? `GetConfigInt("M31_PA_TaipanBloodHunter_BonusMaxCount") : 0);
}

simulated function int GetMaxStackCountPerTurn(XComGameState_Unit SourceUnit)
{
    return super.GetMaxStackCountPerTurn(SourceUnit)
        + (SourceUnit.HasSoldierAbility('M31_PA_TaipanBloodHunter', true) ? `GetConfigInt("M31_PA_TaipanBloodHunter_BonusMaxCountPerTurn") : 0);
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
    local int DamageBonus;

    DamageBonus = super.GetPreDefaultAttackingDamageModifier_CH(EffectState, Attacker, TargetDamageable, AbilityState, AppliedData, CurrentDamage, WeaponDamageEffect, NewGameState);

    if (DamageBonus > 0)
        return DamageBonus;

    if (!Attacker.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
        return 0;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;
    
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    iDamagePerStack = GetDamagePerStack(UnitState, SourceWeapon);

    BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

    if (BloodThirstEffectState == none)
        return 0;

    DamageBonus = BloodThirstEffectState.GetTotalStacksRemaining() * iDamagePerStack;
    
    return DamageBonus * `GetConfigInt("M31_PA_TaipanBloodHunter_DamageModifierPrc") / 100;
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
    local XCGS_Effect_BloodThirst BloodThirstEffectState;
    local ShotModifierInfo CritInfo;
    local int Count;

    if (Attacker.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
    {
        BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

        if (BloodThirstEffectState != none)
        {
            Count = BloodThirstEffectState.GetTotalStacksRemaining();
            if (Count != 0)
            {
                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = FriendlyName;
                CritInfo.Value = Count * `GetConfigInt("M31_PA_TaipanBloodHunter_CritBonusPerStack");
                ShotModifiers.AddItem(CritInfo);
            }
        }
    }
}