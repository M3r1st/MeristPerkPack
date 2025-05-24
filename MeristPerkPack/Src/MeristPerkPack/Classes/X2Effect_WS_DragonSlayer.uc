class X2Effect_WS_DragonSlayer extends X2Effect_Persistent;

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
    local float fModifier;

    TargetUnit = XComGameState_Unit(Target);

    if (TargetUnit == none)
        return 0;

    if (!TargetUnit.CanTakeCover())
        fModifier += `GetConfigFloat("M31_PA_WS_DragonSlayer_DamageBonusPrc_Unflankable");
    
    if (TargetUnit.UnitSize > 1)
        fModifier += `GetConfigFloat("M31_PA_WS_DragonSlayer_DamageBonusPrc_Large");

    return CurrentDamage * fModifier / 100;
}

defaultproperties
{
    bDisplayInSpecialDamageMessageUI = true
}
