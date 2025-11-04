class X2TargetingMethod_NXWrath extends X2TargetingMethod_MeleePath;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComPresentationLayer Pres;

	super(X2TargetingMethod).Init(InAction, NewTargetIndex);

	Pres = `PRES;

	Cursor = `CURSOR;
	PathingPawn = Cursor.Spawn(class'X2NXMeleePawn', Cursor); // This is a copy of the base Init(), but using our custom pawn instead
	PathingPawn.SetVisible(true);
	PathingPawn.Init(UnitState, Ability, self);
	IconManager = Pres.GetActionIconMgr();
	LevelBorderManager = Pres.GetLevelBorderMgr();

	IconManager.ShowIcons(true);
	LevelBorderManager.ShowBorder(true);
	IconManager.UpdateCursorLocation(true);
	LevelBorderManager.UpdateCursorLocation(Cursor.Location, true);

	DirectSelectNearestTarget();
}

protected function Vector GetPathDestination()
{
	local XComWorldData WorldData;
	local TTile Tile;

	WorldData = `XWORLD;
	if (PathingPawn.PathTiles.Length > 0)
	{
		Tile = PathingPawn.PathTiles[PathingPawn.PathTiles.Length - 1];
	}
	else
	{
		Tile = UnitState.TileLocation;
	}

	return WorldData.GetPositionFromTileCoordinates(Tile);
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.AddItem(GetPathDestination());
}

defaultproperties
{
	ProvidesPath=false
}
