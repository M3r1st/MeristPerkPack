class X2Effect_CrystallineCornea extends X2Effect_Persistent;

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
    local int AimBonus;

    AimBonus = `GetConfigInt("M31_PA_CrystallineCornea_AimBonus");

    if (bMelee || bFlanking)
    {
        AimBonus += `GetConfigInt("M31_PA_CrystallineCornea_FlankAimBonus");
        
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);
    }
}