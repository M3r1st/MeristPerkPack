class XCGS_Effect_HackBreakdown extends XComGameState_Effect;

var private ShotBreakdown HackedBreakdown;

final function int GetUncappedHitChance(X2AbilityTemplate Template, XComGameState_Ability AbilityState, XComGameState_Unit TargetUnit, EAbilityHitResult Type)
{
	local ShotBreakdown						Breakdown;
	local AvailableTarget					AvTarget;

	if (TargetUnit == none)
		return 0;

	Template = AbilityState.GetMyTemplate();
	if (Template == none)
		return 0;

	AvTarget.PrimaryTarget.ObjectID = TargetUnit.ObjectID;

	if (class'X2DLCInfo_MeristPerkPack'.default.bLWOTC)
	{
		Template.AbilityToHitCalc.OverrideFinalHitChanceFns.InsertItem(0, ShotBreakdownHack);
		Template.AbilityToHitCalc.GetShotBreakdown(AbilityState, AvTarget, Breakdown);
		Template.AbilityToHitCalc.OverrideFinalHitChanceFns.RemoveItem(ShotBreakdownHack);

		return HackedBreakdown.ResultTable[Type];
	}

	Template.AbilityToHitCalc.GetShotBreakdown(AbilityState, AvTarget, Breakdown);

	return Breakdown.ResultTable[Type];	
}

private function bool ShotBreakdownHack(X2AbilityToHitCalc AbilityToHitCalc, out ShotBreakdown ShotBreakdown)
{
	HackedBreakdown = ShotBreakdown;

	return true;
}
