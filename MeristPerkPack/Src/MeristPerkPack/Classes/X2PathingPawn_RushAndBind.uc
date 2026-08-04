class X2PathingPawn_RushAndBind extends X2MeleePathingPawn;

function bool SelectAttackTile(
    XComGameState_Unit _UnitState,
    XComGameState_BaseObject _TargetState,
    X2AbilityTemplate _MeleeAbilityTemplate,
    optional out array<TTile> _SortedPossibleTiles, // index 0 is the best option.
    optional out TTile _IdealTile, // If this tile is available, will just return it
    optional bool _Unsorted = false
)
{
    local X2AbilityTarget_MovingMelee MeleeTarget;

    MeleeTarget = X2AbilityTarget_MovingMelee(AbilityState.GetMyTemplate().AbilityTargetStyle);

    if (MeleeTarget != none)
    {
        return MeleeTarget.SelectAttackTile(_UnitState, _TargetState, _MeleeAbilityTemplate, _SortedPossibleTiles, _IdealTile, _Unsorted);
    }

    return class'X2AbilityTarget_RushAndBind'.static.SelectAttackTile(_UnitState, _TargetState, _MeleeAbilityTemplate, _SortedPossibleTiles, _IdealTile, _Unsorted);
}

function bool IsValidAttackTile(XComGameState_Unit _UnitState, const out TTile _SourceTile, const out TTile _TargetTile, X2ReachableTilesCache _TileCache)
{
    local X2AbilityTarget_MovingMelee MeleeTarget;

    MeleeTarget = X2AbilityTarget_MovingMelee(AbilityState.GetMyTemplate().AbilityTargetStyle);

    if (MeleeTarget != none)
    {
        return MeleeTarget.IsValidAttackTile(_UnitState, _SourceTile, _TargetTile, _TileCache);
    }

    return class'X2AbilityTarget_RushAndBind'.static.IsValidAttackTile(_UnitState, _SourceTile, _TargetTile, _TileCache);
}

simulated function UpdateMeleeTarget(XComGameState_BaseObject Target)
{
    local X2AbilityTemplate AbilityTemplate;
    local vector TileLocation;

    //<workshop> Francois' Smooth Cursor AMS 2016/04/07
    //INS:
    local TTile InvalidTile;
    InvalidTile.X = -1;
    InvalidTile.Y = -1;
    InvalidTile.Z = -1;
    //</workshop>

    if(Target == none)
    {
        `Redscreen("X2MeleePathingPawn::UpdateMeleeTarget: Target is none!");
        return;
    }

    TargetVisualizer = Target.GetVisualizer();
    AbilityTemplate = AbilityState.GetMyTemplate();

    PossibleTiles.Length = 0;

    if (SelectAttackTile(UnitState, Target, AbilityTemplate, PossibleTiles))
    {
        // Start Issue #1084
        // The native `class'X2AbilityTarget_MovingMelee'.static.SelectAttackTile` function
        // gives only one possible attack tile for adjacent targets, so we use our own
        // script logic to add more possible attack tiles for adjacent targets.
        // If there's only one possible melee attack tile and the unit is standing on it,
        // then the target is directly adjacent.
        if (UnitState.UnitSize == 1 && PossibleTiles.Length == 1 && UnitState.TileLocation == PossibleTiles[0])
        {
            UpdatePossibleTilesForAdjacentTarget(Target);
        }
        // End Issue #1084

        // build a path to the default (best) tile
        //<workshop> Francois' Smooth Cursor AMS 2016/04/07
        //WAS:
        //RebuildPathingInformation(PossibleTiles[0], TargetVisualizer, AbilityTemplate);	
        RebuildPathingInformation(PossibleTiles[0], TargetVisualizer, AbilityTemplate, InvalidTile);
        //</workshop>

        // and update the tiles to reflect the new target options
        UpdatePossibleTilesVisuals();

        if (`ISCONTROLLERACTIVE)
        {
            // move the 3D cursor to the new target
            if (`XWORLD.GetFloorPositionForTile(PossibleTiles[0], TileLocation))
            {
                // Single Line for #520
                /// HL-Docs: ref:Bugfixes; issue:520
                /// Controller input now allows choosing melee attack destination tile despite floor differences
                `CURSOR.m_iRequestedFloor = `CURSOR.WorldZToFloor(TargetVisualizer.Location);
                `CURSOR.CursorSetLocation(TileLocation, true, true);
            }
        }
    }
    //<workshop> TACTICAL_CURSOR_PROTOTYPING AMS 2015/12/07
    //INS:
    DoUpdatePuckVisuals(PossibleTiles[0], Target.GetVisualizer(), AbilityTemplate);
    //</workshop>
}

protected function UpdatePossibleTilesForAdjacentTarget(XComGameState_BaseObject Target)
{
    local array<TTile>               TargetTiles; // Array of tiles occupied by the target; these tiles can be attacked by melee.
    local TTile                      TargetTile;
    local array<TTile>               AdjacentTiles;	// Array of tiles adjacent to Target Tiles; the attacking unit can move to these tiles to attack.
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

        // AssociatedTiles is the array of tiles occupied by the destructible object.
        // In theory, every tile from that array can be targeted by a melee attack.
        TargetTiles = DestructibleActor.AssociatedTiles;
    }

    // Collect non-duplicate tiles around every Target Tile to see which tiles we can attack from.
    GatherTilesAdjacentToTiles(TargetTiles, AdjacentTiles);

    foreach TargetTiles(TargetTile)
    {
        foreach AdjacentTiles(AdjacentTile)
        {
            if (class'Helpers'.static.FindTileInList(AdjacentTile, PossibleTiles) != INDEX_NONE)
                continue;

            if (IsValidAttackTile(UnitState, AdjacentTile, TargetTile, ActiveCache))
            {
                PossibleTiles.AddItem(AdjacentTile);
            }
        }
    }
}