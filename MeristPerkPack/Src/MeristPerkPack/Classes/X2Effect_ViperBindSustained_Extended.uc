class X2Effect_ViperBindSustained_Extended extends X2Effect_ViperBindSustained;

var int iTurnsForFirstIncrease;
var bool bUseExponentialDamageIncrease;
var bool bUseGeometricDamageIncrease;

function float GetPreDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameState_Unit TargetUnit,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    // This effect scales the damage based upon the number of full turns the unit has been bound by the viper
    if (class'X2AbilitySet_ViperBindAndPull'.default.BindCrush_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        if ((EffectState.FullTurnsTicked > iTurnsForFirstIncrease))
        {
            if (bUseGeometricDamageIncrease)
                return CurrentDamage * (EffectState.FullTurnsTicked - iTurnsForFirstIncrease) - CurrentDamage;
            
            if (bUseExponentialDamageIncrease)
                return CurrentDamage * (2 ** (EffectState.FullTurnsTicked - iTurnsForFirstIncrease)) - CurrentDamage;
        }
    }

    return 0;
}

defaultproperties
{
    iTurnsForFirstIncrease = 1
}
