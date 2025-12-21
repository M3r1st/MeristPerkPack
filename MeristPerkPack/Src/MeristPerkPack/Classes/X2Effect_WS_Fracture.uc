class X2Effect_WS_Fracture extends X2Effect_Persistent;

var bool bApplyToFlanked;
var int AimBonus;
var int ShredBonus;

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

    if (!Target.CanTakeCover() || bApplyToFlanked && class'M31_Helpers'.static.IsFlanking(Attacker, Target))
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);
    }
}

function int GetExtraShredValue(
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

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (TargetUnit == none)
        return 0;

    if (!TargetUnit.CanTakeCover() || bApplyToFlanked && class'M31_Helpers'.static.IsFlanking(Attacker, TargetUnit))
    {
        return ShredBonus;
    }

    return 0;
}

defaultproperties
{
    EffectName = M31_PA_WS_Fracture
}