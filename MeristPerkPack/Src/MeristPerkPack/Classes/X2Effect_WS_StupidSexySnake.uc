class X2Effect_WS_StupidSexySnake extends X2Effect_PersistentAura;

var int AimBonus;
var int CritBonus;
var int DodgeBonus;

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

    if (IsEffectCurrentlyRelevant(EffectState, Target))
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus;
        ShotModifiers.AddItem(CritInfo);
    }
}

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

    if (IsEffectCurrentlyRelevant(EffectState, Target))
    {
        ModInfo.ModType = eHit_Graze;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = DodgeBonus;
        ShotModifiers.AddItem(ModInfo);
    }
}

defaultproperties
{
    EffectName = M31_PA_WS_StupidSexySnake
}