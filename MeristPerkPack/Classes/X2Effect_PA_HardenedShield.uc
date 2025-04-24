class X2Effect_PA_HardenedShield extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;

    if (Target.IsUnitAffectedByEffectName('M31_PA_PersonalShield'))
    {
        ModInfo.ModType = eHit_Crit;
        ModInfo.Reason = `GetLocalizedString("M31_PA_HardenedShield_FriendlyName");
        ModInfo.Value = -1 * `GetConfigInt("M31_PA_HardenedShield_CritResistance");
        ShotModifiers.AddItem(ModInfo);
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "M31_PA_HardenedShield"
}