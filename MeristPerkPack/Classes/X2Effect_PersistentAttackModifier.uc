class X2Effect_PersistentAttackModifier extends X2Effect_Persistent;

var int AimBonus;
var int CritBonus;
var int DamageBonus;
var int CritDamageBonus;
var int PierceBonus;
var int ShredBonus;
var array<name> AllowedAbilities;
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

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return;

    if (AimBonus != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);
    }

    if (CritBonus != 0)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus;
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
    local int Bonus;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (CurrentDamage > 0)
    {
        Bonus = DamageBonus;
        if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
        {
            Bonus += CritDamageBonus;
        }
    }

    return Bonus;
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    return PierceBonus;
}

function int GetExtraShredValue(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    return ShredBonus;
}
