class X2Effect_WS_BoltBonus_Maelstrom extends X2Effect_WS_BoltBonus;

var float fPrcDamage_RulerMultiplier;
var float fPrcDamage_ChosenMultiplier;

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
    local float                 fModifier;

    if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        TargetUnit = XComGameState_Unit(Target);
        if (TargetUnit != none)
        {
            if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
                fModifier = fPrcDamage_RulerMultiplier;
            else if (TargetUnit.IsChosen())
                fModifier = fPrcDamage_ChosenMultiplier;
            else
                fModifier = 1.0;

            if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
            {
                if (CurrentDamage > 0)
                {
                    if (IsSourceWeaponBallista(AbilityState))
                    {
                        ExtraDamage = TargetUnit.GetMaxStat(eStat_HP) * (`GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamage_Ballista") / 100) * fModifier;
                    }
                    else
                    {
                        ExtraDamage = TargetUnit.GetMaxStat(eStat_HP) * (`GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamage") / 100) * fModifier;
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

    fPrcDamage_RulerMultiplier = 0.5
    fPrcDamage_ChosenMultiplier = 0.5
}