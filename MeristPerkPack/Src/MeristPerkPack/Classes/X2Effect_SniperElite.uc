class X2Effect_SniperElite extends X2Effect_Persistent;

var array<name> AllowedEffects;

function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{
    return true; 
}

function bool ShotsCannotGraze()
{
    return true;
}

function ModifyReactionFireSuccess(XComGameState_Unit UnitState, XComGameState_Unit TargetState, out int Modifier)
{
    if (true) // ValidateVisibility(UnitState, TargetState) || ValidateEffects(TargetState))
    {
        Modifier = `GetConfigInt("M31_SniperElite_AimBonus");
    }
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local X2AbilityToHitCalc_StandardAim StandardAim;
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    if (true) // ValidateVisibility(Attacker, Target) || ValidateEffects(Target))
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = `GetConfigInt("M31_SniperElite_CritBonus");
        ShotModifiers.AddItem(CritInfo);

        StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
        if (StandardAim == none || !StandardAim.bReactionFire)
        {
            AimInfo.ModType = eHit_Success;
            AimInfo.Reason = FriendlyName;
            AimInfo.Value = `GetConfigInt("M31_SniperElite_AimBonus");
            ShotModifiers.AddItem(AimInfo);
        }
    }
}

protected function bool ValidateVisibility(XComGameState_Unit UnitState, XComGameState_Unit TargetState)
{
    local GameRulesCache_VisibilityInfo VisInfo;

    if (!UnitState.CanFlank())
        return false;

    if (TargetState.GetMyTemplate().bCanTakeCover)
        return true;

    if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(UnitState.ObjectID, TargetState.ObjectID, VisInfo) && VisInfo.TargetCover == CT_None)
        return true;
    
    return false;
}

protected function bool ValidateEffects(XComGameState_Unit UnitState)
{
    local name Effect;

    if (UnitState == none)
        return false;

    foreach AllowedEffects(Effect)
    {
        if (UnitState.AffectedByEffectNames.Find(Effect) != INDEX_NONE)
        {
            return true;
        }
    }
    
    return false;
}
