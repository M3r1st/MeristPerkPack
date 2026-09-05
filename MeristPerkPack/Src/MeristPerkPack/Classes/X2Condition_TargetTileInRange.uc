class X2Condition_TargetTileInRange extends X2Condition;

var float Range;
var bool bUseVSize;
var bool bFailOnNonUnits;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
    local XComWorldData                 WorldData;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameState_Destructible    TargetObject;
    local TTile                         TargetTile;
    local Vector                        SourceLoc, TargetLoc;
    local float                         Distance;

    if (Range <= 0 || kSource.ObjectID == kTarget.ObjectID)
        return 'AA_Success';

    SourceUnit = XComGameState_Unit(kSource);
    if (SourceUnit == none || SourceUnit.bRemovedFromPlay)
        return 'AA_NotInRange';

    WorldData = `XWORLD;

    TargetObject = XComGameState_Destructible(kTarget);
    if (TargetObject != none)
    {
        if (bFailOnNonUnits)
            return 'AA_NotAUnit';

        TargetTile = TargetObject.TileLocation;
    }
    else
    {
        TargetUnit = XComGameState_Unit(kTarget);
        if (TargetUnit == none || TargetUnit.bRemovedFromPlay)
            return 'AA_NotInRange';

        TargetTile = TargetUnit.TileLocation;
    }

    if (bUseVSize)
    {
        SourceLoc = WorldData.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
        TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetTile);
        Distance = VSize(SourceLoc - TargetLoc);
        if (Distance <= `TILESTOUNITS(Range))
            return 'AA_Success';
    }
    else
    {
        if (class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetTile, Range * Range))
            return 'AA_Success';
    }

    return 'AA_NotInRange';
}

defaultproperties
{
    bUseVSize = false
    bFailOnNonUnits = true
}
