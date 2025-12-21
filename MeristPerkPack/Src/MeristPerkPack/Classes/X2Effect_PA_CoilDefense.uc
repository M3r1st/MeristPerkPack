class X2Effect_PA_CoilDefense extends X2Effect_Persistent;

var int DefenseBonus;
var int DodgeBonus;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local GameRulesCache_VisibilityInfo     VisInfo;
    local ShotModifierInfo                  DefenseInfo, DodgeInfo;
    local bool                              bAbilityIgnoresCover;
    local int                               Modifier;

    Modifier = 1;

    if (Target.CanTakeCover())
    {
        bAbilityIgnoresCover = true;
        StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
        if (StandardAim != none)
        {
            bAbilityIgnoresCover = StandardAim.bMeleeAttack || StandardAim.bIgnoreCoverBonus;
        }

        if (bAbilityIgnoresCover)
        {
            Modifier = 1;
        }
        else
        {
            if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
            {
                switch (VisInfo.TargetCover)
                {
                    case CT_None:
                        Modifier = (Attacker.CanFlank() ? 1 : 2);
                        break;
                    case CT_Midlevel:
                        if (!Target.bTreatLowCoverasHigh)
                        {
                            Modifier = 2;
                            break;
                        }
                    case CT_Standing:
                        Modifier = 3;
                        break;
                }
            }
        }
    }
    else
    {
        Modifier = 2;
    }

    DefenseInfo.ModType = eHit_Success;
    DefenseInfo.Reason = FriendlyName;
    DefenseInfo.Value = -1 * DefenseBonus * Modifier;
    ShotModifiers.AddItem(DefenseInfo);

    DodgeInfo.ModType = eHit_Graze;
    DodgeInfo.Reason = FriendlyName;
    DodgeInfo.Value = DodgeBonus * Modifier;
    ShotModifiers.AddItem(DodgeInfo);
}

defaultproperties
{
    EffectName = HunkerDown
    DuplicateResponse = eDupe_Refresh
}