class X2Effect_ZoneOfControl extends X2Effect_PersistentAuraWithStats;

var bool bAllowWhileImpaired;
var bool bAllowWhileImpairedMomentarily;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XComGameState_Unit SourceUnit;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    // if (!bAllowWhileImpaired && SourceUnit.IsImpaired())
    if (!bAllowWhileImpaired && UnitIsImpairedSkipMC(SourceUnit, bAllowWhileImpairedMomentarily))
    {
        `LOG("Source is impaired", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, EffectName);
        return false;
    }

    return super.IsEffectCurrentlyRelevant(EffectGameState, TargetUnit);
}

static function bool UnitIsImpairedSkipMC(const XComGameState_Unit UnitState, optional bool bIgnoreImpairingMomentarily = false)
{
    local XComGameStateHistory History;
    local XComGameState_Effect EffectState;
    local StateObjectReference EffectRef;
    local X2Effect_Persistent  EffectTemplate;

    History = `XCOMHISTORY;

    foreach UnitState.AffectedByEffects(EffectRef)
    {
        EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
        EffectTemplate = EffectState.GetX2Effect();

        if (X2Effect_MindControl(EffectTemplate) == none)
        {
            if (EffectTemplate.bIsImpairing || !bIgnoreImpairingMomentarily && EffectTemplate.bIsImpairingMomentarily)
            {
                return true;
            }
        }
    }

    return false;
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
    bAllowWhileImpairedMomentarily = false
}
