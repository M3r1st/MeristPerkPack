class X2Effect_CrystallineCornea extends X2Effect_Persistent;

var int AimBonus;
var int ExtraAimBonus;

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
    local int Bonus;

    Bonus = AimBonus;
    if (bMelee || bFlanking)
    {
        Bonus += ExtraAimBonus;
    }

    AimInfo.ModType = eHit_Success;
    AimInfo.Reason = FriendlyName;
    AimInfo.Value = Bonus;
    ShotModifiers.AddItem(AimInfo);
}