class X2Effect_MalevolentFocus extends X2Effect_Persistent;

var bool bApplyOnlyOnReaction;
var int CritBonus;

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
    local X2AbilityTemplate                 AbilityTemplate;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local ShotModifierInfo                  CritInfo;

    AbilityTemplate = AbilityState.GetMyTemplate();
    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);

    if (!bApplyOnlyOnReaction || StandardAim != none && StandardAim.bReactionFire)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus;
        ShotModifiers.AddItem(CritInfo);
    }
}