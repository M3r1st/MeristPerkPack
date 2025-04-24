class X2Effect_WS_BoltBonus_Maelstrom extends X2Effect_WS_BoltBonus;

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
    local XComGameState_Unit	TargetUnit;
    local int					ExtraDamage;

    if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        TargetUnit = XComGameState_Unit(Target);
        if (TargetUnit != none)
        {
            if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
            {
                if (CurrentDamage > 0)
                {
                    if (IsSourceWeaponBallista(AbilityState))
                    {
                        ExtraDamage = TargetUnit.GetMaxStat(eStat_HP) * (`GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamage_Ballista") / 100);
                    }
                    else
                    {
                        ExtraDamage = TargetUnit.GetMaxStat(eStat_HP) * (`GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamage") / 100);
                    }
                    return ExtraDamage;
                }
            }
        }
    }
    return 0;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "M31_PA_WS_Bolt_Maelstrom_Bonus"
    bDisplayInSpecialDamageMessageUI = true
}