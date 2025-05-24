class X2Effect_WS_Fracture extends X2Effect_Persistent;

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
    local GameRulesCache_VisibilityInfo VisInfo;
    local ShotModifierInfo AimInfo;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (Target == none)
        return;

    if (!Target.CanTakeCover()
        || `GetConfigBool("M31_PA_WS_Fracture_bAppliesAgainstFlanked") && `TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo) && VisInfo.TargetCover == CT_None)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = `GetConfigInt("M31_PA_WS_Fracture_AimBonus");
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
    local GameRulesCache_VisibilityInfo VisInfo;
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (TargetUnit == none)
        return 0;

    if (!TargetUnit.CanTakeCover()
        || `GetConfigBool("M31_PA_WS_Fracture_bAppliesAgainstFlanked") && `TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, TargetUnit.ObjectID, VisInfo) && VisInfo.TargetCover == CT_None)
    {
        return `GetConfigInt("M31_PA_WS_Fracture_ShredBonus");
    }

    return 0;
}