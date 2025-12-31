class X2Effect_PersistentAura extends X2Effect_Persistent;

var float Radius;
var bool bIncludeOwner;
var bool bIncludeFriendly;
var bool bIncludeHostile;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XComGameState_Unit SourceUnit;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit == none || SourceUnit.IsDead() || TargetUnit == none || TargetUnit.IsDead())
    {
        return false;
    }

    if (SourceUnit.ObjectID == TargetUnit.ObjectID)
    {
        return bIncludeOwner;
    }
    else
    {
        if (!bIncludeFriendly && SourceUnit.IsFriendlyUnit(TargetUnit))
        {
            return false;
        }
        if (!bIncludeHostile && SourceUnit.IsEnemyUnit(TargetUnit))
        {
            return false;
        }
        if (Radius > 0 && !class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, Radius * Radius))
        {
            return false;
        }
    }
    
    return true;
}

defaultproperties
{
    DuplicateResponse = eDupe_Allow

    bIncludeFriendly = true
    bIncludeHostile = false
}