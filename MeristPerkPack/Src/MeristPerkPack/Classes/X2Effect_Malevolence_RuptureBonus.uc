class X2Effect_Malevolence_RuptureBonus extends X2Effect_MarkedBonus;

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
    local XComGameState_Unit Target;
    local X2AbilityToHitCalc_StandardAim StandardAim;
    local X2AbilityToHitCalc_DeadEye DeadEye;

    Target = XComGameState_Unit(TargetDamageable);

    if (Target == none)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
    DeadEye = X2AbilityToHitCalc_DeadEye(AbilityState.GetMyTemplate().AbilityToHitCalc);

    if (DeadEye == none && StandardAim == none)
        return 0;
    
    if (StandardAim != none && StandardAim.bIndirectFire || AbilityState.IsMeleeAbility() && !bApplyToMelee || !AbilityState.IsMeleeAbility() && !bApplyToRanged)
        return 0;

    if (!ValidateEffects(Target))
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            return Target.GetRupturedValue();
        }
    }

    return 0;
}