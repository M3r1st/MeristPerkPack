class X2NXMeleePawn extends X2MeleePathingPawn;

function Init(XComGameState_Unit InUnitState, XComGameState_Ability InAbilityState, X2TargetingMethod_MeleePath InTargetingMethod)
{
	local XComPresentationLayer Pres;

	super.Init(InUnitState, InAbilityState, InTargetingMethod);
	
	// This is an absolutely filthy way of doing this, but we need to signal Gotcha Again to clear its LOS indicators
	Pres = `PRES;
	Pres.m_kUnitFlagManager.OnAbilityActivated(none, none, none, 'AbilityActivated', none);
}

function GetTargetMeleePath(out array<TTile> OutPathTiles);

simulated function UpdatePuckVisuals(XComGameState_Unit ActiveUnitState, 
												const out TTile PathDestination, 
												Actor TargetActor,
												X2AbilityTemplate MeleeAbilityTemplate)
{
	local XComWorldData WorldData;
	local XGUnit Unit;
	local vector MeshTranslation;
	local Rotator MeshRotation;	
	local vector MeshScale;
	local vector FromTargetTile;
	local float UnitSize;

	WorldData = `XWORLD;

	MeshTranslation = TargetActor.Location;

	Unit = XGUnit(TargetActor);
	if(Unit != none)
	{
		UnitSize = Unit.GetVisualizedGameState().UnitSize;
		MeshTranslation = Unit.GetPawn().CollisionComponent.Bounds.Origin;
	}
	else
	{
		UnitSize = 1.0f;
	}

	MeshTranslation.Z = WorldData.GetFloorZForPosition(MeshTranslation) + PathHeightOffset;

	OutOfRangeMeshComponent.SetHidden(true);
	SlashingMeshComponent.SetHidden(false);
	SlashingMeshComponent.SetTranslation(MeshTranslation);

	FromTargetTile = WorldData.GetPositionFromTileCoordinates(PathDestination) - MeshTranslation; 
	MeshRotation.Yaw = atan2(FromTargetTile.Y, FromTargetTile.X) * RadToUnrRot;
		
	SlashingMeshComponent.SetRotation(MeshRotation);
	SlashingMeshComponent.SetScale(UnitSize);
	
	PuckMeshComponent.SetHidden(false);
	PuckMeshComponent.SetStaticMeshes(GetMeleePuckMeshForAbility(MeleeAbilityTemplate), PuckMeshConfirmed);

	PuckMeshCircleComponent.SetHidden(false);
	PuckMeshCircleComponent.SetStaticMesh(GetMeleePuckMeshForAbility(MeleeAbilityTemplate));

	if (ActiveUnitState.NumActionPointsForMoving() == 1)
	{
		RenderablePath.SetMaterial(PathMaterialDashing);
	}

	MeshTranslation = WorldData.GetPositionFromTileCoordinates(PathDestination); // Replace this with the destination tile, since we're not using pathing data
	MeshTranslation.Z = WorldData.GetFloorZForPosition(MeshTranslation) + PathHeightOffset;
	PuckMeshComponent.SetTranslation(MeshTranslation);
	PuckMeshCircleComponent.SetTranslation(MeshTranslation);

	MeshScale.X = ActiveUnitState.UnitSize;
	MeshScale.Y = ActiveUnitState.UnitSize;
	MeshScale.Z = 1.0f;
	PuckMeshComponent.SetScale3D(MeshScale);
	PuckMeshCircleComponent.SetScale3D(MeshScale);
}

simulated function UpdateMeleeTarget(XComGameState_BaseObject Target)
{
	local X2AbilityTemplate AbilityTemplate;
	local vector TileLocation;
	
	local TTile InvalidTile;
	InvalidTile.X = -1;
	InvalidTile.Y = -1;
	InvalidTile.Z = -1;

	if(Target == none)
	{
		`Redscreen("X2MeleePathingPawn::UpdateMeleeTarget: Target is none!");
		return;
	}

	TargetVisualizer = Target.GetVisualizer();
	AbilityTemplate = AbilityState.GetMyTemplate();

	PossibleTiles.Length = 0;

	// We need to always use the workaround method, since X2AbilityTarget_MovingMelee.SelectAttackTile() will filter for our movement range
	UpdatePossibleTilesForAdjacentTarget(Target);

	RebuildPathingInformation(PossibleTiles[0], TargetVisualizer, AbilityTemplate, InvalidTile);

	UpdatePossibleTilesVisuals();

	if(`ISCONTROLLERACTIVE)
	{
		if(`XWORLD.GetFloorPositionForTile(PossibleTiles[0], TileLocation))
		{
			`CURSOR.m_iRequestedFloor = `CURSOR.WorldZToFloor(TargetVisualizer.Location);
			`CURSOR.CursorSetLocation(TileLocation, true, true);
		}
	}

	DoUpdatePuckVisuals(PossibleTiles[0], Target.GetVisualizer(), AbilityTemplate);
}

private function UpdatePossibleTilesForAdjacentTarget(XComGameState_BaseObject Target)
{
	local XComWorldData              WorldData;
	local array<TTile>               TargetTiles;
	local TTile                      TargetTile;
	local array<TTile>               AdjacentTiles;
	local TTile                      AdjacentTile;
	local XComGameState_Unit         TargetUnit;
	local XComGameState_Destructible TargetObject;
	local XComDestructibleActor      DestructibleActor;

	TargetUnit = XComGameState_Unit(Target);
	if (TargetUnit != none)
	{
		GatherTilesOccupiedByUnit(TargetUnit, TargetTiles);
	}
	else
	{
		TargetObject = XComGameState_Destructible(Target);
		if (TargetObject == none)
		{
			`LOG(self.Class.Name @ GetFuncName() @ ":: WARNING, target is not a unit and not a destructible object! Its class is:" @ Target.Class.Name @ ", unable to detect additional tiles to melee attack from. Attacking unit:" @ UnitState.GetFullName());
			return;
		}

		DestructibleActor = XComDestructibleActor(TargetObject.GetVisualizer());
		if (DestructibleActor == none)
		{
			`LOG(self.Class.Name @ GetFuncName() @ ":: WARNING, no visualizer found for destructible object with ID:" @ TargetObject.ObjectID @ ", unable to detect additional tiles to melee attack from. Attacking unit:" @ UnitState.GetFullName());
			return;
		}

		TargetTiles = DestructibleActor.AssociatedTiles;
	}

	GatherTilesAdjacentToTiles(TargetTiles, AdjacentTiles);

	WorldData = `XWORLD;

	foreach TargetTiles(TargetTile)
	{
		foreach AdjacentTiles(AdjacentTile)
		{
			if (class'Helpers'.static.FindTileInList(AdjacentTile, PossibleTiles) != INDEX_NONE)
				continue;
			
			// Likewise, X2AbilityTarget_MovingMelee.IsValidAttackTile() will consider movement range, so we have to do our own validity checks
			if (WorldData.IsFloorTileAndValidDestination(AdjacentTile) && WorldData.CanUnitsEnterTile(AdjacentTile) && !WorldData.IsAdjacentTileBlocked(AdjacentTile, TargetTile))
			{
				PossibleTiles.AddItem(AdjacentTile);
			}			
		}
	}
}

private function GatherTilesOccupiedByUnit(const XComGameState_Unit TargetUnit, out array<TTile> OccupiedTiles)
{	
	local XComWorldData      WorldData;
	local array<TilePosPair> TilePosPairs;
	local TilePosPair        TilePair;
	local Box                VisibilityExtents;

	TargetUnit.GetVisibilityExtents(VisibilityExtents);
	
	WorldData = `XWORLD;
	WorldData.CollectTilesInBox(TilePosPairs, VisibilityExtents.Min, VisibilityExtents.Max);

	foreach TilePosPairs(TilePair)
	{
		OccupiedTiles.AddItem(TilePair.Tile);
	}
}

private function GatherTilesAdjacentToTiles(out array<TTile> TargetTiles, out array<TTile> AdjacentTiles)
{	
	local XComWorldData      WorldData;
	local array<TilePosPair> TilePosPairs;
	local TilePosPair        TilePair;
	local TTile              TargetTile;
	local vector             Minimum;
	local vector             Maximum;
	
	WorldData = `XWORLD;

	foreach TargetTiles(TargetTile)
	{
		Minimum = WorldData.GetPositionFromTileCoordinates(TargetTile);
		Maximum = Minimum;

		Minimum.X -= WorldData.WORLD_StepSize;
		Minimum.Y -= WorldData.WORLD_StepSize;
		Minimum.Z -= WorldData.WORLD_FloorHeight;

		Maximum.X += WorldData.WORLD_StepSize;
		Maximum.Y += WorldData.WORLD_StepSize;
		Maximum.Z += WorldData.WORLD_FloorHeight;

		WorldData.CollectTilesInBox(TilePosPairs, Minimum, Maximum);

		foreach TilePosPairs(TilePair)
		{
			if (class'Helpers'.static.FindTileInList(TilePair.Tile, AdjacentTiles) != INDEX_NONE)
				continue;

			// Add an additional check here to prevent it pushing target tiles into the list of "adjacent" tiles
			if (class'Helpers'.static.FindTileInList(TilePair.Tile, TargetTiles) != INDEX_NONE)
				continue;

			AdjacentTiles.AddItem(TilePair.Tile);
		}
	}
}

// We need to override this function such that it doesn't do any path calculation, but does update the markers/info for things like Overwatch, Reveal, etc.
simulated function RebuildPathingInformation(TTile PathDestination, Actor TargetActor, X2AbilityTemplate MeleeAbilityTemplate, TTile CursorTile)
{
	local XComWorldData WorldData;
	local XComGameState_Unit ActiveUnitState;
	local array<PathPoint> PathPoints;
	local int i;
	local TTile kTile;
	//local float OriginalOriginZ;
	//local XComCoverPoint CoverPoint;
	local bool bCursorOnOriginalUnit;
	
	WorldData = `XWORLD;

	if(LastActiveUnit == none)
	{
		`Redscreen("RebuildPathingInformation(): Unable to update, no unit was set with SetActive()");
		return;
	}

	ActiveUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LastActiveUnit.ObjectID));
	bCursorOnOriginalUnit = CursorOnOriginalUnit();
	
	// Awkward workaround to make Gotcha Again update correctly
	PathTiles[0] = ActiveUnitState.TileLocation;
	PathTiles[1] = PathDestination;
	PathTiles[2] = PathDestination;
	
	// And then draw a line to our target destination
	for (i = 0; i < PathTiles.Length - 1; i++)
	{
		kTile = PathTiles[i];
		PathPoints[i] = CreatePathPoint(WorldData.GetPositionFromTileCoordinates(kTile), eTraversal_Launch, i + 1);
	}

	VisualPath.SetPathPointsDirect(PathPoints);
	BuildSpline();

	UpdateConcealmentTiles();
	UpdateHazardTileMarkerInfo();
	UpdateLaserScopeMarkers();
	UpdateKillZoneMarkers(ActiveUnitState);
	UpdateObjectiveTiles(ActiveUnitState);
	UpdateBondmateTiles(ActiveUnitState);
	UpdateReviveTiles(ActiveUnitState);
	UpdateHuntersMarkTiles(ActiveUnitState);
	UpdateHazardMarkerInfo(ActiveUnitState);
	UpdateNoiseMarkerInfo(ActiveUnitState);
	UpdatePathMarkers();

	UpdatePathTileData();		
	UpdateRenderablePath(`CAMERASTACK.GetCameraLocationAndOrientation().Location);
	if( `ISCONTROLLERACTIVE )
	{
		RenderablePath.SetHidden(bCursorOnOriginalUnit);
	}

	UpdateTileCacheVisuals();
	UpdateBorderHideHeights();

	if( `ISCONTROLLERACTIVE == FALSE )
		UpdatePuckVisuals(ActiveUnitState, PathDestination, TargetActor, MeleeAbilityTemplate);
	UpdatePuckFlyovers(ActiveUnitState);
	UpdatePuckAudio();
}

simulated function PathPoint CreatePathPoint(Vector InPosition, ETraversalType InTraversal, int InPathTileIndex)
{
	local PathPoint OutPathPoint;

	OutPathPoint.Position = InPosition;
	OutPathPoint.Traversal = InTraversal;
	OutPathPoint.PathTileIndex = InPathTileIndex;

	return OutPathPoint;
}