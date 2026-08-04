class X2AbilityTarget_RushAndBind extends X2AbilityTarget_MovingMelee;

simulated function bool ValidatePrimaryTargetOption(const XComGameState_Ability Ability, XComGameState_Unit SourceUnit, XComGameState_BaseObject TargetObject)
{
    if (super.ValidatePrimaryTargetOption(Ability, SourceUnit, TargetObject))
    {
        return self.SelectAttackTile(SourceUnit, TargetObject, Ability.GetMyTemplate());
    }

    return false;
}

simulated static function bool SelectAttackTile(
    XComGameState_Unit UnitState,
    XComGameState_BaseObject TargetState,
    X2AbilityTemplate MeleeAbilityTemplate,
    optional out array<TTile> SortedPossibleTiles, // index 0 is the best option.
    optional out TTile IdealTile, // If this tile is available, will just return it
    optional bool Unsorted = false)
{
    local XComGameState_Unit    TargetUnit;
    local Object                PassToDelegate;
    local TTile                 TargetTile, EmptyTile;
    local int                   Index;

    if (class'X2AbilityTarget_MovingMelee'.static.SelectAttackTile(UnitState, TargetState, MeleeAbilityTemplate, SortedPossibleTiles, IdealTile, Unsorted))
    {
        TargetUnit = XComGameState_Unit(TargetState);
        if (TargetUnit != none)
        {
            for (Index = SortedPossibleTiles.Length - 1; Index >= 0; Index--)
            {
                TargetTile = SortedPossibleTiles[Index];
                if (!class'X2Condition_BindableTile'.static.IsTileValidForBind(TargetUnit.TileLocation, TargetTile, PassToDelegate))
                {
                    SortedPossibleTiles.Remove(Index, 1);
                }
            }

            if (SortedPossibleTiles.Length > 0)
            {
                IdealTile = SortedPossibleTiles[0];
                return true;
            }
        }

        IdealTile = EmptyTile;
        return false;
    }

    return false;
}

simulated static function bool IsValidAttackTile(XComGameState_Unit UnitState, const out TTile SourceTile, const out TTile TargetTile, X2ReachableTilesCache TileCache)
{
    local Object PassToDelegate;

    if (class'X2AbilityTarget_MovingMelee'.static.IsValidAttackTile(UnitState, SourceTile, TargetTile, TileCache))
    {
        return class'X2Condition_BindableTile'.static.IsTileValidForBind(TargetTile, SourceTile, PassToDelegate);
    }

    return false;
}