class X2Effect_DeathAdderBonus extends X2Effect_Persistent;

var int DamageFromHP;
var int MaxDamageBonus;
var array<name> AllowedAbilities;

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
    local XComGameState_Unit TargetUnit;
    local int   MaxHP, CurrentHP;
    local int   ExtraDamage;

    if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        TargetUnit = XComGameState_Unit(Target);
        if (TargetUnit != none)
        {
            if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
                return 0;

            if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
            {
                if (CurrentDamage > 0)
                {
                    MaxHP = TargetUnit.GetMaxStat(eStat_HP);
                    CurrentHP = TargetUnit.GetCurrentStat(eStat_HP);
                    ExtraDamage = (MaxHP - CurrentHP) * DamageFromHP / 100;
                    if (MaxDamageBonus > 0)
                    {
                        ExtraDamage = Min(ExtraDamage, CurrentDamage * MaxDamageBonus / 100);
                    }
                    return ExtraDamage;
                }
            }
        }
    }
    return 0;
}

DefaultProperties
{
    EffectName = M31_DeathAdder_Bonus
    DuplicateResponse = eDupe_Ignore

    bDisplayInSpecialDamageMessageUI = true
}
