class X2Effect_DeathAdderBonus extends X2Effect_Persistent;

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local XComGameState_Unit    TargetUnit;
    local int                   ExtraDamage;

    if (AbilityState.GetMyTemplateName() == 'M31_DeathAdder')
    {
        TargetUnit = XComGameState_Unit(Target);
        if (TargetUnit != none)
        {
            if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
            {
                ExtraDamage = Min((TargetUnit.GetMaxStat(eStat_HP) - TargetUnit.GetCurrentStat(eStat_HP)) * (`GetConfigFloat("M31_DeathAdder_HPToDamage") / 100),
                    CurrentDamage * (`GetConfigFloat("M31_DeathAdder_MaxDamageBonus") / 100));
                return ExtraDamage;
            }
        }
    }
    return 0;
}

DefaultProperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "M31_DeathAdder_Bonus"
    bDisplayInSpecialDamageMessageUI = true
}
