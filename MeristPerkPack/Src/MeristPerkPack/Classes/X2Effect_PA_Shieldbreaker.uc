class X2Effect_PA_Shieldbreaker extends X2Effect_ChangeResultContext;

function bool IsAbilityRelevant(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Effect EffectState)
{
    if (AbilityState.IsMeleeAbility())
    {
        return super.IsAbilityRelevant(AbilityState, SourceUnit, EffectState);
    }

    return false;
}