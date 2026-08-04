class X2Effect_RevealSourceUnit extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
    {
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    }

    if (SourceUnit != none && SourceUnit.IsConcealed())
    {
        `XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', SourceUnit, SourceUnit, NewGameState);
    }
}