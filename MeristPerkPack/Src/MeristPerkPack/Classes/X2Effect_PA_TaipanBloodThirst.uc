class X2Effect_PA_TaipanBloodThirst extends X2Effect_BloodThirst config(GameData_SoldierSkills);

var int BonusMaxStacks;
var int BonusMaxStacksPerTurn;
var int BonusStackDuration;
var int BonusCritPerStack;
var int BonusOtherDamage;

var config bool bUseFocusUI;
var config string strFocusColor;
var config string strFocusIcon;

var localized string strFriendlyDesc_Damage;
var localized string strFriendlyDesc_OtherDamage;
var localized string strFriendlyDesc_Crit;

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
    local XCGS_Effect_BloodThirst   EffectState;
    local X2Effect_PA_TaipanBloodThirst Effect;
    local X2AbilityTag              AbilityTag;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideUnitFocusUI');

    UnitState = XComGameState_Unit(EventSource);
    EffectState = XCGS_Effect_BloodThirst(CallbackData);

    if (UnitState != none && EffectState != none)
    {
        Effect = X2Effect_PA_TaipanBloodThirst(EffectState.GetX2Effect());
        if (Effect != none)
        {
            AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
            AbilityTag.ParseObj = EffectState;

            Tuple.Data[0].b = UnitState.IsFriendlyToLocalPlayer();
            Tuple.Data[1].i = EffectState.GetTotalStacksRemaining();
            Tuple.Data[2].i = Effect.GetMaxStackCount(UnitState);
            Tuple.Data[3].s = "0x" $ default.strFocusColor;
            Tuple.Data[4].s = default.strFocusIcon;
            Tuple.Data[5].s = `XEXPAND.ExpandString(default.strFriendlyDesc);
            Tuple.Data[6].s = default.strFriendlyName;

            AbilityTag.ParseObj = none;
        }
    }

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
    return super.GetStackDuration(SourceUnit) + (HasBonusEffects(SourceUnit) ? BonusStackDuration : 0);
}

simulated function int GetMaxStackCount(XComGameState_Unit SourceUnit)
{
    return super.GetMaxStackCount(SourceUnit) + (HasBonusEffects(SourceUnit) ? BonusMaxStacks : 0);
}

simulated function int GetMaxStackCountPerTurn(XComGameState_Unit SourceUnit)
{
    return super.GetMaxStackCountPerTurn(SourceUnit) + (HasBonusEffects(SourceUnit) ? BonusMaxStacksPerTurn : 0);
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
    local int                       DamageBonus;

    DamageBonus = super.GetPreDefaultAttackingDamageModifier_CH(EffectState, Attacker, TargetDamageable, AbilityState, AppliedData, CurrentDamage, WeaponDamageEffect, NewGameState);

    if (DamageBonus > 0)
        return DamageBonus;

    if (HasBonusEffects(Attacker))
    {
        if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
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
                    DamageBonus = BloodThirstEffectState.GetTotalStacksRemaining() * GetDamagePerStack(Attacker, EffectSourceWeapon);
                    return DamageBonus * BonusOtherDamage / 100;
                }
            }
        }
    }

    return 0;
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

    if (HasBonusEffects(Attacker))
    {
        BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

        if (BloodThirstEffectState != none)
        {
            Count = BloodThirstEffectState.GetTotalStacksRemaining();
            if (Count != 0)
            {
                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = FriendlyName;
                CritInfo.Value = Count * BonusCritPerStack;
                ShotModifiers.AddItem(CritInfo);
            }
        }
    }
}

simulated function bool HasBonusEffects(XComGameState_Unit UnitState)
{
    return UnitState.HasSoldierAbility('M31_PA_TaipanBloodHunter', true);
}

static function string GetFriendlyDescOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameStateHistory          History;
    local XCGS_Effect_BloodThirst       EffectState;
    local X2Effect_PA_TaipanBloodThirst Effect;
    local XComGameState_Unit            UnitState;
    local XComGameState_Item            SourceWeapon;
    local string    OutString;
    local string    NewString;
    local int       Index;
    local int       Count;
    local int       Damage;

    History = `XCOMHISTORY;

    EffectState = XCGS_Effect_BloodThirst(ParseObj);

    if (EffectState != none)
    {
        Effect = X2Effect_PA_TaipanBloodThirst(EffectState.GetX2Effect());
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
        if (Effect != none && UnitState != none)
        {
            Count = EffectState.GetTotalStacksRemaining();
            if (Count == 0)
            {
                return default.strFriendlyDesc_NoStacks;
            }
            else
            {
                Damage = Count * Effect.GetDamagePerStack(UnitState, SourceWeapon);
                NewString = default.strFriendlyDesc_Damage;
                NewString = Repl(NewString, "[A]", Damage);
                OutString = NewString;

                if (Effect.HasBonusEffects(UnitState))
                {
                    if (Effect.BonusOtherDamage > 0)
                    {
                        NewString = default.strFriendlyDesc_OtherDamage;
                        NewString = Repl(NewString, "[B]", Damage * Effect.BonusOtherDamage / 100);
                        OutString $= "<br>" $ NewString;
                    }
                    if (Effect.BonusCritPerStack > 0)
                    {
                        NewString = default.strFriendlyDesc_Crit;
                        NewString = Repl(NewString, "[C]", Count * Effect.BonusCritPerStack);
                        OutString $= "<br>" $ NewString;
                    }

                    for (Index = Effect.GetStackDuration(UnitState) - 1; Index >= 0; Index--)
                    {
                        if (EffectState.arrStacksRemaining[Index] > 0)
                        {
                            NewString = default.strFriendlyDesc_Stacks;
                            NewString = Repl(NewString, "[Y]", Index + 1);
                            OutString $= NewString;
                            break;
                        }
                    }
                    return OutString;
                }
            }
        }
    }

    return "";
}

defaultproperties
{
    EffectName = M31_PA_TaipanBloodThirst
}