//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_Fork.uc
//  AUTHOR:  Merist
//  PURPOSE: An alternative version of X2AbilityMultiTarget_Chain that uses Dijkstra's
//           algorithm to choose additional targets
//---------------------------------------------------------------------------------------
class X2AbilityMultiTarget_Fork extends X2AbilityMultiTarget_Volt;

struct TargetNode
{
    var int TargetID;
    var float fTentativeCost;
    var int iDepth;
    var int iPrevNode;
    
    structdefaultproperties
    {
        fTentativeCost = 100000000.0
        iPrevNode = -1
    }
};

var protected array<TargetNode> TargetNodes;

var config bool bLog;

simulated function GetMultiTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
    local XComGameStateHistory          History;
    local XComWorldData                 WorldData;

    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState_Unit            SourceUnit;

    local float                         MaxDistanceSq;
    local float                         MaxDistance;
    local int                           MaxTargets;

    local AvailableTarget               Target;
    local int                           i, j, k, Index;

    local XComGameState_Unit            TargetUnit;
    local Vector                        TargetLoc;
    local array<TilePosPair>            Tiles;
    local array<TTile>                  ValidTiles;
    local TTile                         Tile;
    local array<StateObjectReference>   UnitRefs;
    local StateObjectReference          UnitRef;
    local XComGameState_Unit            UnitState;
    local float                         fNewTentativeCost;
    
    local TargetNode                    NewNode, EmptyNode;

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

        TargetNodes.Length = 0;

        `LOG("Primary target #" $ i $ " (ObjectID = " $ Target.PrimaryTarget.ObjectID $ ")", default.bLog, self.Class.Name);

        NewNode = EmptyNode;
        NewNode.TargetID = Target.PrimaryTarget.ObjectID;
        NewNode.fTentativeCost = 0;
        NewNode.iDepth = 0;
        TargetNodes.AddItem(NewNode);

        for (j = 0; j < TargetNodes.Length; j++)
        {
            if (TargetNodes[j].iDepth < MaxTargets)
            {
                TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetNodes[j].TargetID));
                if (TargetUnit != none)
                {
                    TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
                    Tiles.Length = 0;
                    ValidTiles.Length = 0;
                    WorldData.CollectTilesInSphere(Tiles, TargetLoc, MaxDistance);
                    for (k = 0; k < Tiles.Length; k++)
                    {
                        ValidTiles.AddItem(Tiles[k].Tile);
                    }
                    foreach ValidTiles(Tile)
                    {
                        UnitRefs = WorldData.GetUnitsOnTile(Tile);
                        foreach UnitRefs(UnitRef)
                        {
                            if (UnitRef.ObjectID > 0 && Target.PrimaryTarget.ObjectID != UnitRef.ObjectID)
                            {
                                UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
                                if (UnitState != none)
                                {
                                    `LOG("  Target: " $ TargetUnit.GetMyTemplateName() $ " (" $ UnitRef.ObjectID $ ")", default.bLog, self.Class.Name);
                                    Index = TargetNodes.Find('TargetID', UnitRef.ObjectID);
                                    fNewTentativeCost = TargetNodes[j].fTentativeCost + VSizeSq(TargetLoc - WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation));
                                    if (Index != INDEX_NONE)
                                    {
                                        `LOG("    Target is already present", default.bLog, self.Class.Name);
                                        if (fNewTentativeCost < TargetNodes[Index].fTentativeCost)
                                        {
                                            `LOG("      ... but this chain is better", default.bLog, self.Class.Name);
                                            TargetNodes[Index].fTentativeCost = fNewTentativeCost;
                                            TargetNodes[Index].iDepth = TargetNodes[j].iDepth + 1;
                                            TargetNodes[Index].iPrevNode = j;
                                        }
                                    }
                                    else if (AbilityTemplate.CheckMultiTargetConditions(Ability, SourceUnit, UnitState) == 'AA_Success')
                                    {
                                        `LOG("    Adding a new node", default.bLog, self.Class.Name);
                                        NewNode = EmptyNode;
                                        NewNode.TargetID = UnitRef.ObjectID;
                                        NewNode.fTentativeCost = fNewTentativeCost;
                                        NewNode.iDepth = TargetNodes[j].iDepth + 1;
                                        NewNode.iPrevNode = j;
                                        TargetNodes.AddItem(NewNode);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        `LOG("Found " $ TargetNodes.Length $ " nodes", default.bLog, self.Class.Name);
        TargetNodes.Sort(SortTargetNodes);

        for (j = 1; j < TargetNodes.Length && j < MaxTargets + 1; j++)
        {
            UnitRef = History.GetGameStateForObjectID(TargetNodes[j].TargetID).GetReference();
            Target.AdditionalTargets.AddItem(UnitRef);
        }

        Targets[i] = Target;
    }
}

delegate int SortTargetNodes(TargetNode A, TargetNode B)
{
    if (A.fTentativeCost > B.fTentativeCost)
        return -1;
    else if (A.fTentativeCost < B.fTentativeCost)
        return 1;
    else
    {
        if (A.iDepth > B.iDepth)
            return -1;
        else if (A.iDepth < B.iDepth)
            return 1;
        else
        {
            return 0;
        }
    }
}

simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles);

// in Units^2
simulated function float GetDistanceBetweenTargets(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit)
{
    return default.DistanceBetweenTargets;
}

simulated function int GetMaxNumTargets(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit)
{
    return SourceUnit.GetTemplarFocusLevel();
}