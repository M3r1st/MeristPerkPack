class X2Condition_SourceAbilityInSlot extends X2Condition;

var array<name>     RequiredAbilities;
var bool            bRequireAll;
var EInventorySlot  Slot;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit    TargetUnit;
    local XComGameState_Item    Item;
    local name                  Ability;

    // `LOG("Condition triggered");
    TargetUnit = XComGameState_Unit(kTarget);
    // `LOG("  Getting Unit");
    if (TargetUnit == none)
        return 'AA_NotAUnit';

    Item = TargetUnit.GetItemInSlot(Slot);
    // `LOG("    Getting Item");
    if (Item == none)
        return 'AA_WeaponIncompatible';
    // `LOG("      Checking: " @ Item.GetMyTemplateName());
    if (bRequireAll)
    {
        foreach RequiredAbilities(Ability)
        {
            if (TargetUnit.FindAbility(Ability, Item.GetReference()).ObjectID == 0)
                return 'AA_WeaponIncompatible';
        }
        return 'AA_Success';
    }
    else
    {
        foreach RequiredAbilities(Ability)
        {
            if (TargetUnit.FindAbility(Ability, Item.GetReference()).ObjectID != 0)
                return 'AA_Success';
        }
        return 'AA_WeaponIncompatible';
    }
}

defaultproperties
{
    bRequireAll = true;
    Slot = eInvSlot_Unknown;
}