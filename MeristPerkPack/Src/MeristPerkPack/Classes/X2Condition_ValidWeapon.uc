//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_ValidWeapon.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class X2Condition_ValidWeapon extends X2Condition;

var array<name>     ExcludedWeaponCategories;
var array<name>     ExcludedWeaponTemplates;
var array<name>     AllowedWeaponTiers;

var array<name>     AllowedWeaponCategories;
var array<name>     AllowedWeaponTemplates;
var array<name>     ExcludedWeaponTiers;

var EInventorySlot  Slot;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit    SourceUnit;
    local XComGameState_Item    ItemState;
    local X2WeaponTemplate      WeaponTemplate;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

    if (Slot != eInvSlot_Unknown)
    {
        ItemState = SourceUnit.GetItemInSlot(Slot);
    }
    else
    {
        ItemState = kAbility.GetSourceWeapon();
    }

    if (ItemState == none)
    {
        return 'AA_WeaponIncompatible';
    }

    WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
    if (WeaponTemplate == none)
    {
        return 'AA_WeaponIncompatible';
    }

    if (ExcludedWeaponTiers.Length > 0 && ExcludedWeaponTiers.Find(WeaponTemplate.WeaponTech) != INDEX_NONE)
    {
        return 'AA_WeaponIncompatible';
    }

    if (AllowedWeaponTiers.Length > 0 && AllowedWeaponTiers.Find(WeaponTemplate.WeaponTech) == INDEX_NONE)
    {
        return 'AA_WeaponIncompatible';
    }

    if (ExcludedWeaponCategories.Length > 0 && ExcludedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE
        || ExcludedWeaponTemplates.Length > 0 && ExcludedWeaponTemplates.Find(WeaponTemplate.DataName) != INDEX_NONE)
    {
        return 'AA_WeaponIncompatible';
    }

    if (AllowedWeaponCategories.Length == 0 && AllowedWeaponTemplates.Length == 0
        || AllowedWeaponCategories.Length > 0 && AllowedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE
        || AllowedWeaponTemplates.Length > 0 && AllowedWeaponTemplates.Find(WeaponTemplate.DataName) != INDEX_NONE)
    {
        return 'AA_Success';
    }
    
    return 'AA_WeaponIncompatible';
}

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
    local XComGameState_Item    ItemState;
    local X2WeaponTemplate      WeaponTemplate;

    if (Slot != eInvSlot_Unknown)
    {
        ItemState = SourceUnit.GetItemInSlot(Slot);
        if (ItemState == none)
        {
            return false;
        }

        WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
        if (WeaponTemplate == none)
        {
            return false;
        }

        if (ExcludedWeaponTiers.Length > 0 && ExcludedWeaponTiers.Find(WeaponTemplate.WeaponTech) != INDEX_NONE)
        {
            return false;
        }

        if (AllowedWeaponTiers.Length > 0 && AllowedWeaponTiers.Find(WeaponTemplate.WeaponTech) == INDEX_NONE)
        {
            return false;
        }

        if (ExcludedWeaponCategories.Length > 0 && ExcludedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE
            || ExcludedWeaponTemplates.Length > 0 && ExcludedWeaponTemplates.Find(WeaponTemplate.DataName) != INDEX_NONE)
        {
            return false;
        }

        if (AllowedWeaponCategories.Length == 0 && AllowedWeaponTemplates.Length == 0
            || AllowedWeaponCategories.Length > 0 && AllowedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE
            || AllowedWeaponTemplates.Length > 0 && AllowedWeaponTemplates.Find(WeaponTemplate.DataName) != INDEX_NONE)
        {
            return true;
        }
        
        return false;
    }

    return true;
}