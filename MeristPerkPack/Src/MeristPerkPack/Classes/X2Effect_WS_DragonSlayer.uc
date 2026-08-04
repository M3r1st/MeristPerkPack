class X2Effect_WS_DragonSlayer extends X2Effect_Persistent;

var int DamageBonusToUnflankable;
var int DamageBonusToLarge;

function float GetPostDefaultAttackingDamageModifier_CH(
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

    TargetUnit = XComGameState_Unit(Target);

    if (TargetUnit != none)
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
                {
                    return 0;
                }

                if (TargetUnit.UnitSize > 1)
                {
                    return CurrentDamage * (DamageBonusToLarge + DamageBonusToUnflankable) / 100;
                }
                else if (!TargetUnit.GetMyTemplate().bCanTakeCover)
                {
                    return CurrentDamage * DamageBonusToUnflankable / 100;
                }
            }
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = M31_PA_WS_DragonSlayer
    bDisplayInSpecialDamageMessageUI = true
}
