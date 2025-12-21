class X2Effect_ClutchShotCrit extends X2Effect_Persistent;

function bool AllowCritOverride()
{
    return true;
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo CritInfo;

    if (AbilityState.GetMyTemplateName() == 'M31_ClutchShot')
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = AbilityState.GetMyTemplate().LocFriendlyName;
        CritInfo.Value = 100;
        ShotModifiers.AddItem(CritInfo);
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
}