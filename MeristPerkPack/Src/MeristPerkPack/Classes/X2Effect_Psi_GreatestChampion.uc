class X2Effect_Psi_GreatestChampion extends X2Effect_Persistent;

var int DamageBonusPrc;
var int DRBonusPrc;
var int DefensePenalty;
var array<name> DamageImmunities;
var privatewrite name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local XComGameState_Unit UnitState;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, default.EventName, EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, , UnitState);
}

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    return CurrentDamage * DamageBonusPrc / 100;
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
    return -1 * Min(WeaponDamage, WeaponDamage * DRBonusPrc / 100);
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
    local ShotModifierInfo  ModInfo;

    ModInfo.ModType = eHit_Success;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = DefensePenalty;
    ShotModifiers.AddItem(ModInfo);
}


function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
    return DamageImmunities.Find(DamageType) != INDEX_NONE;
}

defaultproperties
{
    EffectName = M31_GreatestChampion
    DuplicateResponse = eDupe_Ignore
    EventName = M31_GreatestChampion_Remove
}