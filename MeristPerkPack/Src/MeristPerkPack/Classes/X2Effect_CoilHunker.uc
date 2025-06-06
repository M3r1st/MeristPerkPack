class X2Effect_CoilHunker extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local GameRulesCache_VisibilityInfo VisInfo;
    local ShotModifierInfo ShotInfo;
    local float fModifier;

    if (Target != none)
    {
        if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
        {
            if (!Attacker.CanFlank() || !Target.CanTakeCover() || VisInfo.TargetCover == CT_None || AbilityState.IsMeleeAbility())
                fModifier = `GetConfigFloat("M31_PA_Coil_NoCoverModifier");
            else if (VisInfo.TargetCover == CT_Midlevel && !Target.bTreatLowCoverasHigh)
                fModifier = `GetConfigFloat("M31_PA_Coil_LowCoverModifier");
            else if (VisInfo.TargetCover == CT_Standing || VisInfo.TargetCover == CT_Midlevel && Target.bTreatLowCoverasHigh)
                fModifier = `GetConfigFloat("M31_PA_Coil_HighCoverModifier");
            else
                fModifier = 1.0;

            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = -1 * FFloor(`GetConfigInt("M31_PA_Coil_DefenseBonus") * fModifier + 0.5);
            ShotModifiers.AddItem(ShotInfo);

            ShotInfo.ModType = eHit_Graze;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = FFloor(`GetConfigInt("M31_PA_Coil_DodgeBonus") * fModifier + 0.5);
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    EffectName = "HunkerDown"
}