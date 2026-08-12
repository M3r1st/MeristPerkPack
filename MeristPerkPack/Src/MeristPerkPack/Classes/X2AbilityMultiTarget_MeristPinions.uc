class X2AbilityMultiTarget_MeristPinions extends X2AbilityMultiTarget_Radius;

var float fAreaTargetRadius;
var float fAreaHeight;
var array<AbilityGrantedBonusRadius> AreaAbilityBonusRadii;

var int NumTargets;

function AddAbilityBonusAreaRadius(name AbilityName, float BonusRadius)
{
    local AbilityGrantedBonusRadius Bonus;

    Bonus.RequiredAbility = AbilityName;
    Bonus.fBonusRadius = BonusRadius;
    AreaAbilityBonusRadii.AddItem(Bonus);
}

simulated function float GetAreaTargetRadius(const XComGameState_Ability Ability)
{
    local XComGameState_Unit SourceUnit;
    local float fRadius;
    local int i;

    fRadius = fAreaTargetRadius;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    if (SourceUnit != none)
    {
        for (i = 0; i < AreaAbilityBonusRadii.Length; i++)
        {
            if (SourceUnit.HasSoldierAbility(AreaAbilityBonusRadii[i].RequiredAbility, true))
            {
                fRadius += AreaAbilityBonusRadii[i].fBonusRadius;
            }
        }
    }

    fRadius = `METERSTOUNITS(fRadius);

    if (fRadius < 0.5)
    {
        return 0.5;
    }

    return fRadius;
}

function int GetNumTargets()
{
    return NumTargets;
}

function GetTilesForLockedArea(const XComGameState_Ability Ability, const Vector Location, out array<Actor> TargetActors, out array<TTile> TargetTiles)
{
    local Vector                NewLocation;
    local XComWorldData         World;
    local array<TilePosPair>    TilePairs;
    local TilePosPair           TilePair;
    local TTile                 TestTile;

    World = `XWORLD;

    NewLocation = Location;
    NewLocation.Z -= `METERSTOUNITS(fAreaHeight) / 2;
    World.CollectTilesInCylinder(TilePairs, NewLocation, GetAreaTargetRadius(Ability), `METERSTOUNITS(fAreaHeight));

    foreach TilePairs(TilePair)
    {
        TestTile = TilePair.Tile;
        if (IsTileValid(TestTile))
        {
            TargetTiles.AddItem(TestTile);
        }
    }
}

static function ValidateAreaTiles(out array<TTile> TargetTiles)
{
    local TTile TestTile;
    local int i;

    for (i = TargetTiles.Length - 1; i >= 0; i--)
    {
        TestTile = TargetTiles[i];
        if (!IsTileValid(TestTile))
        {
            TargetTiles.Remove(i, 1);
        }
    }
}

static function bool IsTileValid(const TTile TestTile)
{
    local XComWorldData World;
    // local Vector        TestLocation;
    local Vector        LandingLocation;
    local TTile         LandingTile;
    local int           MaxZ;

    World = `XWORLD;

    MaxZ = World.WORLD_FloorHeightsPerLevel * World.WORLD_TotalLevels * World.WORLD_FloorHeight;

    // TestLocation = World.GetPositionFromTileCoordinates(TestTile);
    // if (!World.HasOverheadClearance(TestLocation, MaxZ))
    // {
    //     return false;
    // }

    if (!World.IsFloorTile(TestTile))
    {
        return false;
    }

    LandingLocation = World.GetPositionFromTileCoordinates(TestTile);
    LandingLocation.Z = MaxZ;
    LandingLocation.Z = World.GetFloorZForPosition(LandingLocation, true);
    LandingTile = World.GetTileCoordinatesFromPosition(LandingLocation);
    if (TestTile != LandingTile)
    {
        return false;
    }

    return true;
}

defaultproperties
{
    fAreaHeight = 12.0f
}