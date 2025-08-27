class X2Condition_SawedOffReload extends X2Condition;

var EInventorySlot SpecificSlot;
var int AmmoLimitBase;
var int PumpActionBonus;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit SourceUnit;
    local XComGameState_Item WeaponState;
    local int AmmoLimit;
    
    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

    if (SourceUnit == none)
        return 'AA_NotAUnit';

    if (SpecificSlot != eInvSlot_Unknown)
        WeaponState = SourceUnit.GetItemInSlot(SpecificSlot);
    else
        WeaponState = kAbility.GetSourceWeapon();

    if (AmmoLimitBase > 0)
        AmmoLimit = AmmoLimitBase;
    else
        AmmoLimit = WeaponState.GetClipSize();

    if (SourceUnit.HasSoldierAbility('PumpAction', true))
        AmmoLimit += PumpActionBonus;

    if (AmmoLimit > 0 && WeaponState.Ammo >= AmmoLimit)
        return 'AA_AmmoAlreadyFull';

    return 'AA_Success';
}