class X2AbilityCharges_Tech extends X2AbilityCharges;

var array<int> InitialChargesFromTech;
var EInventorySlot SpecificSlot;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit) 
{ 
    local XComGameState_Item SourceWeapon;
    local int Charges;
    local int Tech;

    Charges = super.GetInitialCharges(Ability, Unit);

    if (SpecificSlot != eInvSlot_Unknown)
        SourceWeapon = Unit.GetItemInSlot(SpecificSlot);
    else
        SourceWeapon = Ability.GetSourceWeapon();

    if (SourceWeapon != none)
    {
        Tech = class'X2DLCInfo_MeristPerkPack'.static.GetItemTech(SourceWeapon.GetMyTemplate());
        Tech = Clamp(Tech, 0, InitialChargesFromTech.Length - 1);
        Charges += InitialChargesFromTech[Tech];
    }

    return Charges;
}