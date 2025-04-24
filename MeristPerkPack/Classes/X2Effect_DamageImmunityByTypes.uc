class X2Effect_DamageImmunityByTypes extends X2Effect_Persistent;

var array<name> DamageImmunities;

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return DamageImmunities.Find(DamageType) != INDEX_NONE;
}