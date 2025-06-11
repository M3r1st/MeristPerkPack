class X2Effect_AdvancedAidProtocol extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;

    ModInfo.ModType = eHit_Crit;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = -1 * `GetConfigInt("M31_AdvancedAidProtocol_CritResistance");
    ShotModifiers.AddItem(ModInfo);

    ModInfo.ModType = eHit_Graze;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = `GetConfigInt("M31_AdvancedAidProtocol_DodgeBonus");
    ShotModifiers.AddItem(ModInfo);
}