class X2Effect_Rider_ConcussiveBlows extends X2Effect_WeaponEffect;

function bool IsAbilityRelevant(
    XComGameState_Ability AbilityState,
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameStateContext_Ability AbilityContext)
{
    if (!AbilityState.IsMeleeAbility())
    {
        return false;
    }

    return super.IsAbilityRelevant(AbilityState, EffectState, SourceUnit, AbilityContext);
}

defaultproperties
{
    bMatchSourceWeapon = false
}