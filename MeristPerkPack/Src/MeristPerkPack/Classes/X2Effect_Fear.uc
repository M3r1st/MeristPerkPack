class X2Effect_Fear extends X2Effect_Panicked;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit UnitState;
    
    UnitState = XComGameState_Unit(kNewTargetState);
    if (m_aStatChanges.Length > 0)
    {
        NewEffectState.StatChanges = m_aStatChanges;

        //  Civilian panic does not modify stats and does not need to call the parent functions (which will result in a RedScreen for having no stats!)
        super(X2Effect_PersistentStatChange).OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
    }

    // UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
    
    UnitState.bPanicked = true;

    `XEVENTMGR.TriggerEvent('UnitPanicked', UnitState, UnitState, NewGameState);

    // Delayed behavior tree kick-off.  Points must be added and game state submitted before the behavior tree can 
    // update, since it requires the ability cache to be refreshed with the new action points.
    // UnitState.AutoRunBehaviorTree('IRI_Rider_WithdrawRoot', 1, `XCOMHISTORY.GetCurrentHistoryIndex() + 1, true);
}