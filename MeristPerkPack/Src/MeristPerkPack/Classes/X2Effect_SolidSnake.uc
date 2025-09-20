class X2Effect_SolidSnake extends X2Effect_Persistent;

var int DodgeReductionBonus;
var bool bMatchSourceWeapon;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local int DodgeReduction;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    // DodgeReduction = Min(DodgeReductionBonus, Target.GetCurrentStat(eStat_Dodge));
    DodgeReduction = DodgeReductionBonus;

    ShotInfo.ModType = eHit_Graze;
    ShotInfo.Reason = FriendlyName;
    ShotInfo.Value = -1 * DodgeReduction;
    ShotModifiers.AddItem(ShotInfo);
}

defaultproperties
{
    EffectName = M31_SolidSnake
    DuplicateResponse = eDupe_Ignore
    bMatchSourceWeapon = true
}
