//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_ValidWeapon.uc
//  AUTHOR:  Merist / based on X2Condition_WOTC_APA_Class_ValidWeaponCategory
//---------------------------------------------------------------------------------------
class X2Condition_ValidWeapon extends X2Condition;

// Variables to pass into the condition check:
var array<name>     ExcludedWeaponCategories;
var array<name>     ExcludedWeaponTemplates;
var array<name>     AllowedWeaponCategories;
var array<name>     AllowedWeaponTemplates;

var array<name>     AllowedWeaponTiers;
var array<name>     ExcludedWeaponTiers;
var bool            bValidateTier;

var EInventorySlot  SpecificSlot;
var bool            bFailOnSourceWeapon;
var bool            bCheckSpecificSlot;
var bool            bSkipAbilitySourceWeaponCheck;
var bool            bSkipCanEverBeValidCheck;


event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit;
    local XComGameState_Item    InventoryItem;
    local EInventorySlot        InventorySlot;
    local X2WeaponTemplate      WeaponTemplate;
    local name                  WeaponCategory;
    local name                  WeaponName;

    if (bSkipAbilitySourceWeaponCheck)
        return 'AA_Success';

    History = `XCOMHISTORY;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
    InventoryItem = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceWeapon.ObjectID));
    if (InventoryItem != none)
        InventorySlot = InventoryItem.InventorySlot;
    
    if (bCheckSpecificSlot)
        InventoryItem = SourceUnit.GetItemInSlot(SpecificSlot);
    else
        InventoryItem = SourceUnit.GetItemInSlot(InventorySlot);

    if (InventoryItem == none)
        return 'AA_WeaponIncompatible';

    if (bFailOnSourceWeapon && kAbility.SourceWeapon.ObjectID == InventoryItem.GetReference().ObjectID)
        return 'AA_WeaponIncompatible';

    WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
    if (WeaponTemplate == none)
        return 'AA_WeaponIncompatible';
    
    if (bValidateTier)
    {
        if (ExcludedWeaponTiers.Length > 0 && ExcludedWeaponTiers.Find(WeaponTemplate.WeaponTech) != INDEX_NONE)
            return 'AA_WeaponIncompatible';

        if (AllowedWeaponTiers.Length > 0 && AllowedWeaponTiers.Find(WeaponTemplate.WeaponTech) == INDEX_NONE)
            return 'AA_WeaponIncompatible';
    }

    WeaponCategory = WeaponTemplate.WeaponCat;
    WeaponName = WeaponTemplate.DataName;

    if (ExcludedWeaponCategories.Length > 0 && ExcludedWeaponCategories.Find(WeaponCategory) != INDEX_NONE
        || ExcludedWeaponTemplates.Length > 0 && ExcludedWeaponTemplates.Find(WeaponName) != INDEX_NONE)
        return 'AA_WeaponIncompatible';

    if (AllowedWeaponCategories.Length == 0 && AllowedWeaponTemplates.Length == 0
        || AllowedWeaponCategories.Length > 0 && AllowedWeaponCategories.Find(WeaponCategory) != INDEX_NONE
        || AllowedWeaponTemplates.Length > 0 && AllowedWeaponTemplates.Find(WeaponName) != INDEX_NONE)
        return 'AA_Success';
    
    return 'AA_WeaponIncompatible';
}


function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
    local XComGameState_Item            InventoryItem;
    local array<XComGameState_Item>     CurrentInventory;
    local X2WeaponTemplate              WeaponTemplate;
    local name WeaponCategory;
    local name WeaponName;

    if (bSkipCanEverBeValidCheck)
        return true;

    // Check SourceUnit's inventory to make sure ONE of their equipped items matches the required weapon type.
    // If not, the ability will not even be added to the unit for the tactical battle. This does not verify
    // that the item of the correct weapon category is equipped as the correct item slot - that will be handled
    // in CallAbilityMeetsCondition. This should be an edge case and wont be handled as cleanly - the ability
    // will still show up on the SourceUnit's toolbar, they just wont be able to use it. Any excluded weapon
    // categories are NOT checked here, because (again, edge case) an excluded weapon type in a different
    // inventory slot should not prevent the ability from being used with a proper item type in the ability's
    // assigned inventory slot. Skip if no AllowedWeaponCategories are defined.
    if (AllowedWeaponCategories.Length == 0 && AllowedWeaponTemplates.Length == 0)
        return true;

    CurrentInventory = SourceUnit.GetAllInventoryItems(, true);
    foreach CurrentInventory(InventoryItem)
    {
        WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
        WeaponCategory = WeaponTemplate.WeaponCat;
        WeaponName = WeaponTemplate.DataName;
    
        if (AllowedWeaponCategories.Find(WeaponCategory) != INDEX_NONE || AllowedWeaponTemplates.Find(WeaponName) != INDEX_NONE)
            return true;
    }
    
    // No valid weapon category was found - do not add ability to SourceUnit for this tactical battle.
    return false;
}