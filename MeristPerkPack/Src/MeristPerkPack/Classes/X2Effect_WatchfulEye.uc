class X2Effect_WatchfulEye extends X2Effect_Persistent;

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
    return true;
}

defaultproperties
{
    EffectName = M31_WatchfulEye
    DuplicateResponse = eDupe_Refresh
}