class X2Effect_Blademaster extends X2Effect_Persistent;

var int AimBonus;
var int DamageBonus;
var array<name> AdditionalAbilities;

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if (bMelee || AdditionalAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        ShotInfo.ModType = eHit_Success;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = AimBonus;
        ShotModifiers.AddItem(ShotInfo);
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
    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.IsMeleeAbility() || AdditionalAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        return DamageBonus;

    return 0;
}

defaultproperties
{
    EffectName = M31_Blademaster
}