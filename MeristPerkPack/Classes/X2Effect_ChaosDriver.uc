class X2Effect_ChaosDriver extends X2Effect_Persistent;

var float AttackingDamageMultiplierPerCharge;
var float DefendingDamageMultiplierPerCharge;

var private float AttackingDamageMultiplier;
var private float DefendingDamageMultiplier;

simulated protected function OnEffectAdded(
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState_BaseObject kNewTargetState,
	XComGameState NewGameState,
	XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory		History;
	local XComGameState_Unit		UnitState;
	local XComGameState_Ability		AbilityState;

	History = `XCOMHISTORY;

	UnitState = XComGameState_Unit(kNewTargetState);
	
	if (UnitState != none)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if (AbilityState != none)
		{
			AttackingDamageMultiplier = AbilityState.iCharges * AttackingDamageMultiplierPerCharge;
			DefendingDamageMultiplier = AbilityState.iCharges * DefendingDamageMultiplierPerCharge;
		}
	}
}

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
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(Target);

	if (TargetUnit != none)
	{
		return CurrentDamage * AttackingDamageMultiplier / 100.0;
	}

	return 0.0;
}

function float GetPostDefaultDefendingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	XComGameState_Unit TargetUnit,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData ApplyEffectParameters,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	return CurrentDamage * DefendingDamageMultiplier / 100.0;
}

defaultproperties
{
	DuplicateResponse = eDupe_Refresh
	EffectName = "M31_CA_ChaosDriver"
}
