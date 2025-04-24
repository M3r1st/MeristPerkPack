class X2Effect_FrostBonus extends X2Effect_Persistent;

var int AimBase, AimPerTier;
var int CritBase, CritPerTier;
var int DamageBase, DamagePerTier;
var int CritDamageBase, CritDamagePerTier;
var int PierceBase, PiercePerTier;
var int ShredBase, ShredPerTier;
var bool bGetChillFromSource;
var bool bDisabledByBurningOnSource;
var bool bDisabledByBurningOnTarget;
var bool bDisabledByFrostImmunityOnSource;
var bool bDisabledByFrostImmunityOnTarget;
var bool bCheckSourceWeapon;

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    local int Tier;

    if (IsDisabled(Attacker, Target))
        return;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    Tier = GetCurrentTier(Attacker, Target);

    if (AimBase + Tier * AimBase != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBase + Tier * AimBase;
        ShotModifiers.AddItem(AimInfo);
    }

    if (CritBase + Tier * CritPerTier != 0)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBase + Tier * CritPerTier;
        ShotModifiers.AddItem(CritInfo);
    }

}

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    local XComGameState_Unit SourceUnit;
    local XComGameState_Unit TargetUnit;
    local int Tier;
    local int DamageBonus;

    SourceUnit = Attacker;
    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (IsDisabled(SourceUnit, TargetUnit))
        return 0;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    Tier = GetCurrentTier(SourceUnit, TargetUnit);

    if (CurrentDamage > 0)
    {
        DamageBonus = DamageBase + Tier * DamagePerTier;
        if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
        {
            DamageBonus += CritDamageBase + Tier * CritDamagePerTier;
        }
    }

    return DamageBonus;
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local XComGameState_Unit SourceUnit;
    local XComGameState_Unit TargetUnit;
    local int Tier;

    SourceUnit = Attacker;
    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (IsDisabled(SourceUnit, TargetUnit))
        return 0;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    Tier = GetCurrentTier(SourceUnit, TargetUnit);

    return PierceBase + Tier * PiercePerTier;
}

function int GetExtraShredValue(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local XComGameState_Unit SourceUnit;
    local XComGameState_Unit TargetUnit;
    local int Tier;

    SourceUnit = Attacker;
    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (IsDisabled(SourceUnit, TargetUnit))
        return 0;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    Tier = GetCurrentTier(SourceUnit, TargetUnit);

    return ShredBase + Tier * ShredPerTier;
}

private function int GetCurrentTier(optional XComGameState_Unit SourceUnit = none, optional XComGameState_Unit TargetUnit = none)
{
    local XComGameState_Unit UnitState;

    UnitState = TargetUnit;
    if (bGetChillFromSource)
        UnitState = SourceUnit;

    if (UnitState != none)
    {
        if (UnitState.AffectedByEffectNames.Find('Freeze') != INDEX_NONE)
        {
            return 3;
        }
        else if (UnitState.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE)
        {
            return 2;
        }
        else if (UnitState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || UnitState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
        {
            return 1;
        }
    }

    return 0;
}

private function bool IsDisabled(optional XComGameState_Unit SourceUnit = none, optional XComGameState_Unit TargetUnit = none)
{
    return SourceUnit != none &&
            ((bDisabledByBurningOnSource && SourceUnit.AffectedByEffectNames.Find('Burning') != INDEX_NONE) ||
            (bDisabledByFrostImmunityOnSource && SourceUnit.IsImmuneToDamage('Frost'))) ||
        TargetUnit != none &&
            ((bDisabledByBurningOnTarget && TargetUnit.AffectedByEffectNames.Find('Burning') != INDEX_NONE) ||
            (bDisabledByFrostImmunityOnTarget && TargetUnit.IsImmuneToDamage('Frost')));
}