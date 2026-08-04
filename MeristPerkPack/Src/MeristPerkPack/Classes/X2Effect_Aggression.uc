class X2Effect_Aggression extends X2Effect_Persistent;

var bool bApplyToSquadsight;

var int AimPerEnemy;
var int AimMinCount;
var int CritPerEnemy;
var int CritMinCount;
var int DodgePerEnemy;
var int DodgeMinCount;
var int DefensePerEnemy;
var int DefenseMinCount;

var int DamageBonus;
var int DamageBonusMinCount;

var array<name> DamageImmunities;
var int DamageImmunityMinCount;

function int GetTargetCount(XComGameState_Unit UnitState)
{
    local array<StateObjectReference> Targets;
    local int BadGuys;

    BadGuys = UnitState.GetNumVisibleEnemyUnits(true, false, false, -1, false, false);
    if (UnitState.HasSquadsight() && bApplyToSquadsight)
    {
        class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(UnitState.ObjectID, Targets, -1, false);
        BadGuys += Targets.Length;
    }

    return BadGuys;
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
    local ShotModifierInfo ShotInfo;
    local int BadGuys;

    if (bMelee)
    {
        BadGuys = GetTargetCount(Attacker);

        if (BadGuys > AimMinCount && AimPerEnemy != 0)
        {
            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = AimPerEnemy * (BadGuys - AimMinCount);
            ShotModifiers.AddItem(ShotInfo);
        }
        if (BadGuys > CritMinCount && CritPerEnemy != 0)
        {
            ShotInfo.ModType = eHit_Crit;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = CritPerEnemy * (BadGuys - CritMinCount);
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

function GetToHitAsTargetModifiers(
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
    local ShotModifierInfo ShotInfo;
    local int BadGuys;

    BadGuys = GetTargetCount(Target);

    if (BadGuys > DodgeMinCount && DodgePerEnemy != 0)
    {
        ShotInfo.ModType = eHit_Graze;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = DodgePerEnemy * (BadGuys - DodgeMinCount);
        ShotModifiers.AddItem(ShotInfo);
    }
    if (BadGuys > DefenseMinCount && DefensePerEnemy != 0)
    {
        ShotInfo.ModType = eHit_Success;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = -1 * DefensePerEnemy * (BadGuys - DefenseMinCount);
        ShotModifiers.AddItem(ShotInfo);
    }
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
    if (GetTargetCount(SourceUnit) >= DamageBonusMinCount && AbilityState.IsMeleeAbility())
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
                {
                    return 0;
                }

                return CurrentDamage * DamageBonus / 100;
            }
        }
    }

    return 0;
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (TargetUnit != none && GetTargetCount(TargetUnit) >= DamageImmunityMinCount)
    {
        return DamageImmunities.Find(DamageType) != INDEX_NONE;
    }

    return false;
}