class X2Effect_AddTemporaryAbility extends X2Effect_Persistent;

var name AbilityName;
var EInventorySlot Slot;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2AbilityTemplateManager	AbilityTemplateMgr;
	local X2AbilityTemplate			AbilityTemplate;
	local StateObjectReference		AbilityRef;
	local XComGameState_Unit		Unit;
	local XComGameState_Item		Item;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityTemplateMgr.FindAbilityTemplate(AbilityName);
	Unit = XComGameState_Unit(kNewTargetState);
	Item = Unit.GetItemInSlot(Slot, NewGameState);
	// `LOG("		Trying to patch: <" @ Item.GetMyTemplateName() @ ">");
	AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, Unit, NewGameState, Item.GetReference());

	NewEffectState.CreatedObjectReference = AbilityRef;
	// `LOG("			Success!	InitAbilityForUnit: <" @ AbilityTemplate.DataName @ "> to <" @ Item.GetMyTemplateName() @ ">");
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit OwnerUnitState;
	local XComGameState_Effect AbilityEffectState;
	local StateObjectReference EffectRef;
	local int i;

	if (RemovedEffectState.CreatedObjectReference.ObjectID == 0)
		return;

	History = `XCOMHISTORY;

	OwnerUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', RemovedEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	foreach OwnerUnitState.AffectedByEffects(EffectRef)
	{
		AbilityEffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (AbilityEffectState != none && AbilityEffectState.ApplyEffectParameters.AbilityStateObjectRef == RemovedEffectState.CreatedObjectReference)
		{
			AbilityEffectState.RemoveEffect(NewGameState, NewGameState, bCleansed);
		}
	}
	foreach OwnerUnitState.AppliedEffects(EffectRef)
	{
		AbilityEffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (AbilityEffectState != none && AbilityEffectState.ApplyEffectParameters.AbilityStateObjectRef == RemovedEffectState.CreatedObjectReference)
		{
			AbilityEffectState.RemoveEffect(NewGameState, NewGameState, bCleansed);
		}
	}

	for (i = OwnerUnitState.Abilities.Length; i >= 0; i--)
	{
		if (OwnerUnitState.Abilities[i].ObjectID == RemovedEffectState.CreatedObjectReference.ObjectID)
		{
			OwnerUnitState.Abilities.Remove(i, 1);
			break;
		}
	}

	NewGameState.RemoveStateObject(RemovedEffectState.CreatedObjectReference.ObjectID);
}