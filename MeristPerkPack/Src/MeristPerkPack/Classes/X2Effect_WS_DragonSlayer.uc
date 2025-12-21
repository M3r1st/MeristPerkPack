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
    local float Bonus;

    if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    TargetUnit = XComGameState_Unit(Target);

    if (TargetUnit == none)
        return 0;

    if (!TargetUnit.CanTakeCover())
        Bonus += DamageBonusToUnflankable;
    
    if (TargetUnit.UnitSize > 1)
        Bonus += DamageBonusToLarge;

    return CurrentDamage * Bonus / 100;
}

defaultproperties
{
    EffectName = M31_PA_WS_DragonSlayer

    bDisplayInSpecialDamageMessageUI = true
}
