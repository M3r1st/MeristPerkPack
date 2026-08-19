class OrdnanceInventorySlot extends CHItemSlotSet config(OrdnanceSlot);

var localized string strSlotDisplayLetter;
var localized string strSlotLocName;

struct AbilityBonusSlotCount
{
    var name AbilityName;
    var int NumSlots;
};

var config EInventorySlot UseSlot;
var config array<AbilityBonusSlotCount> AbilityUnlocksSlot;

var config bool bAlwaysAllowsGrenades;
var config bool bAlwaysAllowsRockets;
var config bool bAlwaysAllowsAmmo;
var config array<name> AbilityAllowsGrenadesInSlot;
var config array<name> AbilityAllowsRocketsInSlot;
var config array<name> AbilityAllowsAmmoInSlot;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    if (default.UseSlot != eInvSlot_Unknown)
    {
        if (default.UseSlot != eInvSlot_ExtraGrenadePocket || !IsModActive('ExtraGrenadePocket'))
            Templates.AddItem(CreateSlotTemplate());
    }
    return Templates;
}

static final function bool IsModActive(name ModName)
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
    {
        if (EventManager.GetDLCNames(Index) == ModName)
        {
            return true;
        }
    }

    return false;
}

static function X2DataTemplate CreateSlotTemplate()
{
    local CHItemSlot Template;

    `CREATE_X2TEMPLATE(class'CHItemSlot', Template, 'M31_OrdnanceSlot');

    Template.InvSlot = default.UseSlot;
    Template.SlotCatMask = Template.SLOT_ITEM;
    Template.IsUserEquipSlot = true;

    Template.IsEquippedSlot = false;
    Template.BypassesUniqueRule = false;

    Template.IsMultiItemSlot = true;
    Template.IsSmallSlot = true;
    Template.NeedsPresEquip = false;
    Template.ShowOnCinematicPawns = false;
    Template.MinimumEquipped = 0;

    Template.CanAddItemToSlotFn = CanAddItemToSlot;
    Template.UnitHasSlotFn = HasSlot;
    Template.GetPriorityFn = SlotGetPriority;
    Template.GetMaxItemCountFn = SlotGetMaxItemCount;

    Template.ShowItemInLockerListFn = ShowItemInLockerList;
    Template.ValidateLoadoutFn = SlotValidateLoadout;
    Template.GetSlotUnequipBehaviorFn = SlotGetUnequipBehavior;
    Template.GetBestGearForSlotFn = GetBestGearForSlot;
    Template.GetDisplayLetterFn = GetSlotDisplayLetter;
    Template.GetDisplayNameFn = GetDisplayName;

    return Template;
}

static function bool CanAddItemToSlot(CHItemSlot Slot, XComGameState_Unit UnitState, X2ItemTemplate ItemTemplate, optional XComGameState CheckGameState, optional int Quantity = 1, optional XComGameState_Item ItemState)
{
    return IsItemValidForSlot(ItemTemplate, UnitState);
}

static function bool ShowItemInLockerList(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_Item ItemState, X2ItemTemplate ItemTemplate, XComGameState CheckGameState)
{
    return IsItemValidForSlot(ItemTemplate, Unit);
}

private static function bool IsItemValidForSlot(const X2ItemTemplate ItemTemplate, XComGameState_Unit UnitState)
{
    local X2GrenadeTemplate GrenadeTemplate;

    GrenadeTemplate = X2GrenadeTemplate(ItemTemplate);

    if (GrenadeTemplate != none)
    {
        if (GrenadeTemplate.WeaponCat == 'rocket')
        {
            return default.bAlwaysAllowsRockets || UnitState.HasAnyOfTheAbilitiesFromAnySource(default.AbilityAllowsRocketsInSlot);
        }
        else
        {
            return default.bAlwaysAllowsGrenades || UnitState.HasAnyOfTheAbilitiesFromAnySource(default.AbilityAllowsGrenadesInSlot);
        }
    }
    else if (X2AmmoTemplate(ItemTemplate) != none)
    {
        return default.bAlwaysAllowsAmmo || UnitState.HasAnyOfTheAbilitiesFromAnySource(default.AbilityAllowsAmmoInSlot);
    }

    return false;
}

static function bool HasSlot(CHItemSlot Slot, XComGameState_Unit UnitState, out string LockedReason, optional XComGameState CheckGameState)
{
    local int Index;

    for (Index = 0; Index < default.AbilityUnlocksSlot.Length; Index++)
    {
        if (UnitState.HasAbilityFromAnySource(default.AbilityUnlocksSlot[Index].AbilityName) && default.AbilityUnlocksSlot[Index].NumSlots > 0)
        {
            return true;
        }
    }

    return false;
}

static function int SlotGetPriority(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
    return 115;
}

static function int SlotGetMaxItemCount(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
    local int NumSlots;
    local int Index;

    for (Index = 0; Index < default.AbilityUnlocksSlot.Length; Index++)
    {
        if (UnitState.HasAbilityFromAnySource(default.AbilityUnlocksSlot[Index].AbilityName))
        {
            NumSlots += default.AbilityUnlocksSlot[Index].NumSlots;
        }
    }

    return NumSlots;
}

static function SlotValidateLoadout(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
    local XComGameState_Item ItemState;
    local array<XComGameState_Item> ItemStates;
    local string strDummy;
    local bool HasSlot;
    local int i, iMaxItems;

    ItemStates = Unit.GetAllItemsInSlot(Slot.InvSlot, NewGameState);
    HasSlot = Slot.UnitHasSlot(Unit, strDummy, NewGameState);

    iMaxItems = Slot.GetMaxItemCountFn(Slot, Unit, NewGameState);

    //  Unit has slot
    if (HasSlot)
    {
        // for (i = ; i < ItemStates.Length; i++)
        // {
        //     ItemState = FindBestWeapon(Unit, Slot.InvSlot, XComHQ, NewGameState);
        //     if (ItemState != none)
        //     {
        //         Unit.AddItemToInventory(ItemState, Slot.InvSlot, NewGameState);
        //     }
        //     else return;    //  Could not find a weapon to put into the slot - exit.
        // }

        //  ... but too many items equipped.
        for (i = ItemStates.Length; i > iMaxItems; i--)
        {
            ItemState = ItemStates[i];

            ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', ItemState.ObjectID));
            if (ItemState != none)
            {
                if (Unit.RemoveItemFromInventory(ItemState, NewGameState))
                {
                    //`LOG("Successfully unequipped the item. Putting it into HQ Inventory.",, 'WOTCMoreSparkWeapons');
                    XComHQ.PutItemInInventory(NewGameState, ItemState);
                }
            }
        }
        
        return; // All done equipping or unequipping items into the slot, exit.
    }

    //  Unit doesn't have the slot, but has some items equipped into it.
    if (ItemStates.Length > 0 && !HasSlot)
    {
        foreach ItemStates(ItemState)
        {
            ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', ItemState.ObjectID));

            if (Unit.RemoveItemFromInventory(ItemState, NewGameState))
            {
                XComHQ.PutItemInInventory(NewGameState, ItemState);
            }
        }
    }
}

private static function XComGameState_Item FindBestWeapon(const XComGameState_Unit UnitState, EInventorySlot Slot, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
    local X2GrenadeTemplate     GrenadeTemplate;
    local XComGameStateHistory  History;
    local XComGameState_Item    ItemState;
    local XComGameState_Item    BestItemState;
    local StateObjectReference  ItemRef;
    local int                   HighestTier;

    HighestTier = -999;
    History = `XCOMHISTORY;

    //  Cycle through all items in HQ Inventory
    foreach XComHQ.Inventory(ItemRef)
    {
        ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
        if (ItemState != none)
        {
            GrenadeTemplate = X2GrenadeTemplate(ItemState.GetMyTemplate());

            //  If this is an infinite item, it's tier is higher than the current recorded highest tier,
            //  it is allowed on the soldier by config entries that are relevant to this soldier
            //  and it can be equipped on the soldier
            if (GrenadeTemplate != none
                && GrenadeTemplate.bInfiniteItem
                && GrenadeTemplate.Tier > HighestTier
                && UnitState.CanAddItemToInventory(GrenadeTemplate, Slot, NewGameState, ItemState.Quantity, ItemState))
            {
                //  then remember this item as the currently best replacement option.
                HighestTier = GrenadeTemplate.Tier;
                BestItemState = ItemState;
            }
        }
    }

    if (BestItemState != none)
    {
        //  This will set up the Item State for modification automatically, or create a new Item State in the NewGameState if the template is infinite.
        XComHQ.GetItemFromInventory(NewGameState, BestItemState.GetReference(), BestItemState);
    }

    //  If we didn't find any fitting items, then BestItemState will be "none", and we're okay with that.
    return BestItemState;
}

function ECHSlotUnequipBehavior SlotGetUnequipBehavior(CHItemSlot Slot, ECHSlotUnequipBehavior DefaultBehavior, XComGameState_Unit UnitState, XComGameState_Item ItemState, optional XComGameState CheckGameState)
{
    return eCHSUB_AttemptReEquip;
}

static function array<X2EquipmentTemplate> GetBestGearForSlot(CHItemSlot Slot, XComGameState_Unit Unit)
{
    local array<X2EquipmentTemplate>    arr;
    local X2EquipmentTemplate           ItemTemplate;

    ItemTemplate = X2EquipmentTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate('FragGrenade'));

    arr.AddItem(ItemTemplate);

    return arr;
}

static function string GetSlotDisplayLetter(CHItemSlot Slot)
{
    return default.strSlotDisplayLetter;
}

static function string GetDisplayName(CHItemSlot Slot)
{
    return default.strSlotLocName;
}
