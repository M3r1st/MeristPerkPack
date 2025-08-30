class X2Effect_PA_HunterDedication extends X2Effect_PersistentStatChange;

var int DefenseBonus;
var int DodgeBonus;

var bool bExcludeFlanking;
var bool bExcludeMelee;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo DefenseInfo;
    local ShotModifierInfo DodgeInfo;

    if ((!bExcludeMelee || !bMelee) && (!bExcludeFlanking || !bFlanking))
    {
        DefenseInfo.ModType = eHit_Success;
        DefenseInfo.Reason = FriendlyName;
        DefenseInfo.Value = -1 * DefenseBonus;
        ShotModifiers.AddItem(DefenseInfo);

        DodgeInfo.ModType = eHit_Graze;
        DodgeInfo.Reason = FriendlyName;
        DodgeInfo.Value = DodgeBonus;
        ShotModifiers.AddItem(DodgeInfo);
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    EffectName = M31_PA_HunterDedication
}