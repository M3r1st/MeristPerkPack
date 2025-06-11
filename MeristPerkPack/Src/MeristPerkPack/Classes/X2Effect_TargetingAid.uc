class X2Effect_TargetingAid extends X2Effect_Persistent;

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
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    AimInfo.ModType = eHit_Success;
    AimInfo.Reason = FriendlyName;
    AimInfo.Value = `GetConfigInt("M31_TargetingAid_AimBonus");
    ShotModifiers.AddItem(AimInfo);

    CritInfo.ModType = eHit_Crit;
    CritInfo.Reason = FriendlyName;
    CritInfo.Value = `GetConfigInt("M31_TargetingAid_CritBonus");
    ShotModifiers.AddItem(CritInfo);
}