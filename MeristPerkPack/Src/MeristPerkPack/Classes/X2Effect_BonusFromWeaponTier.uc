class X2Effect_BonusFromWeaponTier extends X2Effect_Persistent;

var array<int> AimBonus;
var array<int> CritBonus;
var array<int> DamageBonus;
var array<int> CritDamageBonus;
var array<int> PierceBonus;
var array<int> ShredBonus;

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
    local int Bonus;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    Bonus = GetBonusValue(AbilityState, AimBonus);
    if (Bonus != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = Bonus;
        ShotModifiers.AddItem(AimInfo);
    }

    Bonus = GetBonusValue(AbilityState, CritBonus);
    if (Bonus != 0)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Bonus;
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
    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
                return GetBonusValue(AbilityState, DamageBonus) + GetBonusValue(AbilityState, CritDamageBonus);
            else
                return GetBonusValue(AbilityState, DamageBonus);
        }
    }

    return 0;
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;; 

    return GetBonusValue(AbilityState, PierceBonus);
}

function int GetExtraShredValue(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    return GetBonusValue(AbilityState, ShredBonus);
}

protected function int GetBonusValue(XComGameState_Ability AbilityState, array<int> BonusArray)
{
    local int Tier;

    Tier = class'X2DLCInfo_MeristPerkPack'.static.GetItemTech(AbilityState.GetSourceWeapon().GetMyTemplate());
    Tier = Clamp(Tier, 0, BonusArray.Length - 1);

    return BonusArray[Tier];
}