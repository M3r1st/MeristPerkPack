class X2Effect_GetOverHere_New extends X2Effect_GetOverHere;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComWorldData         WorldData;
    local X2EventManager        EventManager;
    local XComGameState_Unit    TargetUnit;
    local Vector                NewLocation;
    local TTIle                 NewTileLocation;
    local int i;
    
    TargetUnit = XComGameState_Unit(kNewTargetState);
    if (TargetUnit != none)
    {
        WorldData = `XWORLD;
        `LOG("TargetLocations.Length = " $ ApplyEffectParameters.AbilityInputContext.TargetLocations.Length, class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
        for (i = 0; i < ApplyEffectParameters.AbilityInputContext.TargetLocations.Length; i++)
        {
            NewLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[i];
            NewTileLocation = WorldData.GetTileCoordinatesFromPosition(NewLocation);
            `LOG(i $ ": " $ NewTileLocation.X @ NewTileLocation.Y @ NewTileLocation.Z, class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
        }
        if (ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0)
        {
            NewLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
            NewTileLocation = WorldData.GetTileCoordinatesFromPosition(NewLocation);

            EventManager = `XEVENTMGR;

            // Move the target to this space
            TargetUnit.SetVisibilityLocation(NewTileLocation);

            EventManager.TriggerEvent('ObjectMoved', TargetUnit, TargetUnit, NewGameState);
            EventManager.TriggerEvent('UnitMoveFinished', TargetUnit, TargetUnit, NewGameState);

            return;
        }
    }

    `LOG("Using super fallback", class'X2TargetingMethod_GetOverHere'.default.bLog, default.Class.Name);
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}