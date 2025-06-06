class X2Effect_MalevolentFocus extends X2Effect_Persistent;

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
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

    if (!`GetConfigBool("M31_PA_MalevolentFocus_bOnlyForReaction") ||
        AbilityState != none
        && X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none
        && X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = `GetConfigInt("M31_PA_MalevolentFocus_CritBonus");
        ShotModifiers.AddItem(CritInfo);
    }
}