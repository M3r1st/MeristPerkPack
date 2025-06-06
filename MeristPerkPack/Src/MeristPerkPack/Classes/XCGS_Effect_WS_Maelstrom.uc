class XCGS_Effect_WS_Maelstrom extends XComGameState_Effect;

var private int FinalOverflow;

final function int GetFinalOverflow(X2AbilityTemplate Template, XComGameState_Ability AbilityState, XComGameState_Unit TargetUnit)
{
    local ShotBreakdown     Breakdown;
    local AvailableTarget   AvTarget;

    if (TargetUnit == none)
        return 0;

    Template = AbilityState.GetMyTemplate();
    if (Template == none)
        return 0;

    AvTarget.PrimaryTarget.ObjectID = TargetUnit.ObjectID;

    if (class'X2DLCInfo_MeristPerkPack'.default.bLWOTC)
    {
        Template.AbilityToHitCalc.OverrideFinalHitChanceFns.InsertItem(0, OverrideHitChanceHack);
        Template.AbilityToHitCalc.GetShotBreakdown(AbilityState, AvTarget, Breakdown);
        Template.AbilityToHitCalc.OverrideFinalHitChanceFns.RemoveItem(OverrideHitChanceHack);

        return FinalOverflow;
    }

    Template.AbilityToHitCalc.GetShotBreakdown(AbilityState, AvTarget, Breakdown);

    return Breakdown.ResultTable[eHit_Crit] - 100;
}

private function bool OverrideHitChanceHack(X2AbilityToHitCalc AbilityToHitCalc, out ShotBreakdown ShotBreakdown)
{
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local ShotModifierInfo                  ModInfo;
    local int AimOverflow;
    local int CritOverflow;

    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityToHitCalc);

    if (StandardAim == none)
        return false;

    AimOverflow = ShotBreakdown.ResultTable[eHit_Success] - 100;

    if (AimOverflow <= 0)
        return false;

    ModInfo.ModType = eHit_Crit;
    ModInfo.Value   = AimOverflow;
    ModInfo.Reason  = `GetLocalizedString("M31_PA_WS_Bolt_Maelstrom_FriendlyName");
    Shotbreakdown.Modifiers.AddItem(ModInfo);

    ShotBreakdown.ResultTable[eHit_Crit] += AimOverflow;

    CritOverflow = ShotBreakdown.ResultTable[eHit_Crit] - 100;

    FinalOverflow = Max(CritOverflow, 0);

    return false;
}

static final function bool OverrideHitChance(X2AbilityToHitCalc AbilityToHitCalc, out ShotBreakdown ShotBreakdown)
{
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local ShotModifierInfo                  ModInfo;
    local int AimOverflow;
    local int CritOverflow;

    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityToHitCalc);

    if (StandardAim == none)
        return false;

    AimOverflow = ShotBreakdown.ResultTable[eHit_Success] - 100;

    if (AimOverflow <= 0)
        return false;

    ModInfo.ModType = eHit_Crit;
    ModInfo.Value   = AimOverflow;
    ModInfo.Reason  = `GetLocalizedString("M31_PA_WS_Bolt_Maelstrom_FriendlyName");
    Shotbreakdown.Modifiers.AddItem(ModInfo);

    ShotBreakdown.ResultTable[eHit_Crit] += AimOverflow;

    CritOverflow = ShotBreakdown.ResultTable[eHit_Crit] - 100;

    if (CritOverflow <= 0)
        return false;

    return false;
}