class X2Effect_NXGetOverThere extends X2Effect_GetOverThere;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComWorldData World;
	local XComGameState_Unit SourceUnitState;
	local X2EventManager EventManager;
	local vector TeleportLocation;
	local TTile TeleportToTile;

	World = `XWORLD;

	SourceUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnitState == none)
		SourceUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnitState != none);

	if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0)
	{
		EventManager = `XEVENTMGR;
		
		TeleportLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
		TeleportToTile = World.GetTileCoordinatesFromPosition(TeleportLocation);
		SourceUnitState.SetVisibilityLocation(TeleportToTile);

		EventManager.TriggerEvent('ObjectMoved', SourceUnitState, SourceUnitState, NewGameState);
		EventManager.TriggerEvent('UnitMoveFinished', SourceUnitState, SourceUnitState, NewGameState);
		return;
	}
	
	// Fall back to the default behavior if no target location was provided (bug, AI-controlled, etc)
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}