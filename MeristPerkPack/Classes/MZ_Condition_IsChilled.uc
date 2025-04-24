class MZ_Condition_IsChilled extends X2Condition;
/* condition to check for applying stage 2, also for some abilities that require a chilled target */

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit	TargetState;

	TargetState = XComGameState_Unit(kTarget);

	if (TargetState == none) { return 'AA_NotAUnit'; }

	// MZChill is bitterfrost stage 1, chilled is from arctic rounds
	if ( TargetState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || TargetState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
	{
		return 'AA_Success';
	}

	return 'AA_MissingRequiredEffect';

}