class X2Effect_GetOverHereNew extends X2Effect_GetOverHere;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnitState, TargetUnitState;
    local XComWorldData World;
    local TTIle TeleportToTile;
    local Vector TeleportLocation;
    local X2EventManager EventManager;

    World = `XWORLD;

    SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    `assert(SourceUnitState != none);
    TargetUnitState = XComGameState_Unit(kNewTargetState);
    `assert(TargetUnitState != none);

    if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0)
    {
        EventManager = `XEVENTMGR;
        
        TeleportLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
        TeleportToTile = World.GetTileCoordinatesFromPosition(TeleportLocation);
        TargetUnitState.SetVisibilityLocation(TeleportToTile);

        EventManager.TriggerEvent('ObjectMoved', TargetUnitState, TargetUnitState, NewGameState);
        EventManager.TriggerEvent('UnitMoveFinished', TargetUnitState, TargetUnitState, NewGameState);
        return;
    }
    
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
