class X2Effect_Duskborn extends X2Effect_Persistent;

var privatewrite name RequiredEffect;

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
    local ShotModifierInfo AimInfo;

    if (Attacker.IsConcealed() || Attacker.AffectedByEffectNames.Find(default.RequiredEffect) != INDEX_NONE)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = `GetConfigInt("M31_Duskborn_AimBonus");
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = `GetConfigInt("M31_Duskborn_CritBonus");
        ShotModifiers.AddItem(CritInfo);
    }
}

defaultproperties
{
    RequiredEffect = M31_Duskborn_Valid
}