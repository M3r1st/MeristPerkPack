//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_Chain.uc
//  AUTHOR:  Merist
//  PURPOSE: Denativized version of X2AbilityMultiTarget_Volt that allows
//           overriding the number of targets and the distance between them
//---------------------------------------------------------------------------------------
class X2AbilityMultiTarget_Chain extends X2AbilityMultiTarget_Volt;

// If `true`, all additional targets will be based on the primary target
// If `false`, every next additional target will be based on the previous one
var bool bCentered;

var config bool bLog;

simulated function GetMultiTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
    local XComGameStateHistory          History;
    local XComWorldData                 WorldData;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local X2AbilityTemplate             AbilityTemplate;
    local AvailableTarget               Target;
    local float                         MaxDistanceSq;
    local float                         MaxDistance;
    local int                           MaxTargets;
    local int                           i, j;

    local Vector                        TargetLoc;
    local array<TilePosPair>            Tiles;
    local array<TTile>                  ValidTiles;
    local TTile                         Tile;
    local array<StateObjectReference>   UnitRefs;
    local StateObjectReference          UnitRef;
    local XComGameState_Unit            UnitState;
    local StateObjectReference          ClosestUnitRef, EmptyRef;
    local float                         ClosestDistanceSq;

    `LOG("Init", default.bLog, self.Class.Name);

    History = `XCOMHISTORY;
    WorldData = `XWORLD;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    AbilityTemplate = Ability.GetMyTemplate();
    MaxTargets = GetMaxNumTargets(Ability, SourceUnit);
    MaxDistanceSq = GetDistanceBetweenTargets(Ability, SourceUnit);
    MaxDistance = Sqrt(MaxDistanceSq);

    `LOG("MaxTargets: " $ MaxTargets $ " | MaxDistanceSq: " $ MaxDistanceSq $ " | MaxDistance: " $ MaxDistance, default.bLog, self.Class.Name);

    for (i = 0; i < Targets.Length; i++)
    {
        Target = Targets[i];
        TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(Target.PrimaryTarget.ObjectID));
        if (TargetUnit != none)
        {
            `LOG("Target: " $ TargetUnit.GetMyTemplateName() $ " (" $ Target.PrimaryTarget.ObjectID $ ")", default.bLog, self.Class.Name);
            TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
            Tiles.Length = 0;
            ValidTiles.Length = 0;
            WorldData.CollectTilesInSphere(Tiles, TargetLoc, MaxDistance);
            for (j = 0; j < Tiles.Length; j++)
            {
                ValidTiles.AddItem(Tiles[j].Tile);
            }
            while (Target.AdditionalTargets.Length < MaxTargets)
            {
                ClosestUnitRef = EmptyRef;
                ClosestDistanceSq = 100000000.0;

                foreach ValidTiles(Tile)
                {
                    UnitRefs = WorldData.GetUnitsOnTile(Tile);
                    foreach UnitRefs(UnitRef)
                    {
                        if (UnitRef.ObjectID > 0 && Target.PrimaryTarget.ObjectID != UnitRef.ObjectID)
                        {
                            UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
                            if (UnitState != none
                                && VSizeSq(TargetLoc - WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation)) < ClosestDistanceSq
                                && Target.AdditionalTargets.Find('ObjectID', UnitRef.ObjectID) == INDEX_NONE
                                && AbilityTemplate.CheckMultiTargetConditions(Ability, SourceUnit, UnitState) == 'AA_Success')
                            {
                                ClosestUnitRef = UnitRef;
                                ClosestDistanceSq = VSizeSq(TargetLoc - WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation));
                            }
                        }
                    }
                }

                if (ClosestUnitRef.ObjectID > 0)
                {
                    if (!bCentered)
                    {
                        TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ClosestUnitRef.ObjectID));
                        `LOG("    Next target: " $ TargetUnit.GetMyTemplateName() $ " (" $ ClosestUnitRef.ObjectID $ ")", default.bLog, self.Class.Name);
                        TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
                        Tiles.Length = 0;
                        ValidTiles.Length = 0;
                        WorldData.CollectTilesInSphere(Tiles, TargetLoc, MaxDistance);
                        for (j = 0; j < Tiles.Length; j++)
                        {
                            ValidTiles.AddItem(Tiles[j].Tile);
                        }
                    }
                    else
                    {
                        `LOG("    Next target: " $ " (" $ ClosestUnitRef.ObjectID $ ")", default.bLog, self.Class.Name);
                    }
                    Target.AdditionalTargets.AddItem(ClosestUnitRef);
                }
                else
                {
                    `LOG("    There is no next target", default.bLog, self.Class.Name);
                    break;
                }
            }
        }
        Targets[i] = Target;
    }
}

simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
    // no-op
}

// in Units^2
simulated function float GetDistanceBetweenTargets(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit)
{
    return default.DistanceBetweenTargets;
}

simulated function int GetMaxNumTargets(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit)
{
    return SourceUnit.GetTemplarFocusLevel();
}

defaultproperties
{
    bCentered = false
}