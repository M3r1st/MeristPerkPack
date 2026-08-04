class X2Effect_ZoneOfControl extends X2Effect_PersistentAuraWithStats;

var bool bAllowWhileImpaired;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XComGameState_Unit SourceUnit;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (!bAllowWhileImpaired && SourceUnit.IsImpaired())
    {
        return false;
    }

    return super.IsEffectCurrentlyRelevant(EffectGameState, TargetUnit);
}

defaultproperties
{
    EffectName = M31_ZoneOfControl
    UpdateEventName = M31_ZoneOfControl_Update
    UnApplyFromStatsEventName = M31_ZoneOfControl_UnApplied
    OnEffectRemovedEventName = M31_ZoneOfControl_Removed

    bIncludeFriendly = false
    bIncludeHostile = true
    bIncludeOwner = false

    bAllowWhileImpaired = false
}
