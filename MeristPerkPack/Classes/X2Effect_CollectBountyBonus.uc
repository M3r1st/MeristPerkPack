class X2Effect_CollectBountyBonus extends X2Effect_Persistent;

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	Damageable Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData ApplyEffectParameters,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState) 
{
	if (AbilityState.GetMyTemplateName() == 'M31_CA_CollectBounty' && ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
	{
		return CurrentDamage * (`GetConfigFloat("M31_CA_CollectBounty_DamagePrc") / 100);
	}
	return 0;
}