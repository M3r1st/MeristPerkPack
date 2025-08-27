class X2Effect_LowProfileNest extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit UnitState;

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    UnitState = XComGameState_Unit(kNewTargetState);
    if (UnitState != none)
    {
        UnitState.bTreatLowCoverAsHigh = true;
    }
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit UnitState;

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (UnitState != none)
    {
        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
        UnitState.bTreatLowCoverAsHigh = false;
    }
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local GameRulesCache_VisibilityInfo VisInfo;
    local ShotModifierInfo ShotInfo;
    local X2AbilityToHitCalc_StandardAim StandardAim;
    local bool bAbilityIgnoresCover;

    if (Target != none)
    {
        if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
        {
            StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
            if (StandardAim != none && (StandardAim.bMeleeAttack || StandardAim.bIgnoreCoverBonus))
                bAbilityIgnoresCover = true;

            if (Target.CanTakeCover() && Target.bTreatLowCoverasHigh && VisInfo.TargetCover == CT_Midlevel && !bAbilityIgnoresCover)
            {
                ShotInfo.ModType = eHit_Success;
                ShotInfo.Reason = FriendlyName;
                ShotInfo.Value = -1 * (class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS - class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS);
                ShotModifiers.AddItem(ShotInfo);
            }
        }
    }
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
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    if (!bMelee && Attacker.HasHeightAdvantageOver(Target, true))
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = `GetConfigInt("M31_LowProfileNest_AimBonus");
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = `GetConfigInt("M31_LowProfileNest_CritBonus");
        ShotModifiers.AddItem(CritInfo);
    }
}