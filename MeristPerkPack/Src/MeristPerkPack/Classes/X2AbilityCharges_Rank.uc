class X2AbilityCharges_Rank extends X2AbilityCharges;

var array<int> InitialChargesFromRank;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit) 
{ 
    local int Charges;
    local int Rank;

    Charges = super.GetInitialCharges(Ability, Unit);

    if (Unit != none)
        Rank = Unit.GetSoldierRank();

    Rank = Clamp(Rank, 0, InitialChargesFromRank.Length);
    
    Charges += InitialChargesFromRank[Rank];

    return Charges;
}