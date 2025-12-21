class X2Effect_PA_Aegis extends X2Effect_Persistent;

var int DamageReduction;

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    if (IsEffectCurrentlyRelevant(EffectState, Target))
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                return -1 * CurrentDamage * DamageReduction / 100;
            }
        }
    }

    return 0;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return TargetUnit.IsUnitAffectedByEffectName(class'X2AbilitySet_PA_Muton'.default.PersonalShieldEffectName);
}

defaultproperties
{
    EffectName = M31_PA_Aegis
    DuplicateResponse = eDupe_Ignore
}