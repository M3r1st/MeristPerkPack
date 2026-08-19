class X2Effect_Callback extends X2Effect_Persistent; 

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
    return true;
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
}