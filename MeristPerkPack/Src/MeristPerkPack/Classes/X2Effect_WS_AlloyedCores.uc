class X2Effect_WS_AlloyedCores extends X2Effect_Persistent;

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
    local ShotModifierInfo AimInfo;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (Target == none)
        return;

    if (Attacker.TileDistanceBetween(Target) < `GetConfigInt("M31_PA_WS_AlloyedCores_Range"))
    {
        AimInfo.ModType = eHit_Crit;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = `GetConfigInt("M31_PA_WS_AlloyedCores_CritBonus");
        ShotModifiers.AddItem(AimInfo);
    }
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (TargetUnit == none)
        return 0;

    if (Attacker.TileDistanceBetween(TargetUnit) < `GetConfigInt("M31_PA_WS_AlloyedCores_Range"))
    {
        return `GetConfigInt("M31_PA_WS_AlloyedCores_PierceBonus");
    }
}