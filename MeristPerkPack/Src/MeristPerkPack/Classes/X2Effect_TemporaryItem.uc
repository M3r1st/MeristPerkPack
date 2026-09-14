//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TemporaryItem
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Effect for adding temporary items to a unit
//--------------------------------------------------------------------------------------- 
class X2Effect_TemporaryItem extends X2Effect_Persistent config(GameData_SoldierSkills);

struct ResearchConditional
{
    var name ResearchProjectName;
    var name ItemName;
};
var array<ResearchConditional> ResearchOptionalItems;

var name ItemName;
var array<name> AlternativeItemNames;
var array<name> AdditionalAbilities;
var array<name> ForceCheckAbilities;
var bool bIgnoreItemEquipRestrictions;
var bool bReplaceExistingItemOnly;
var name ExistingItemName;
var bool bOverrideInventorySlot;
var EInventorySlot InventorySlotOverride;

var name UnitValueName;

// @Merist:
var bool bAllowUpgrades;

struct UpgradeInfo
{
    var name ResearchName;
    var name BaseItemName;
    var name ItemName;
    var array<name> RDLC;
};
var config array<UpgradeInfo> Upgrades;
var config array<name> GrenadeForceCheckAbilities;

// Start @Merist
simulated protected function ApplyResearchUpgrades(out name ItemToAdd)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local ResearchConditional Conditional;
    local UpgradeInfo Upgrade;

    XComHQ = `XCOMHQ;
    if (XComHQ != none)
    {
        if (ResearchOptionalItems.Length > 0)
        {
            foreach ResearchOptionalItems(Conditional)
            {
                if (XComHQ.IsTechResearched(Conditional.ResearchProjectName))
                {
                    ItemToAdd = Conditional.ItemName;
                    break;
                }
            }
        }
        else
        {
            foreach default.Upgrades(Upgrade)
            {
                if (Upgrade.BaseItemName == ItemToAdd && XComHQ.IsTechResearched(Upgrade.ResearchName))
                {
                    if (class'X2DLCInfo_MeristPerkPack'.static.AreModsActive(Upgrade.RDLC))
                    {
                        ItemToAdd = Upgrade.ItemName;
                    }
                }
            }
        }
    }
}

static function X2Effect CreateGrenadeEffect(X2AbilityTemplate Template, name ItemToAdd, optional bool bCanUpgrade = true)
{
    local X2Effect_TemporaryItem Effect;

    Effect = new class'X2Effect_TemporaryItem';
    Effect.EffectName = name(Template.DataName $ "_Temporary" $ ItemToAdd);
    Effect.DuplicateResponse = eDupe_Allow;
    Effect.ItemName = ItemToAdd;
    Effect.bAllowUpgrades = bCanUpgrade;
    Effect.ForceCheckAbilities = default.GrenadeForceCheckAbilities;
    Effect.bIgnoreItemEquipRestrictions = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false,, Template.AbilitySourceName);

    return Effect;
}
// End @Merist

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local name                      UseItemName, AltItemName;
    local XComGameState_Unit        UnitState; 
    local XComGameState_Item        OldItemState, UpdatedItemState, NewItemState;
    local X2EquipmentTemplate       EquipmentTemplate;
    local X2WeaponTemplate          WeaponTemplate;
    local XGS_Effect_TemporaryItem  EffectState;
    local EInventorySlot            InventorySlot;

    UnitState = XComGameState_Unit(kNewTargetState);
    if (UnitState == none)
        return;

    EffectState = XGS_Effect_TemporaryItem(NewEffectState);
    if (EffectState == none)
        return;

    // Don't add temp stuff twice.
    if (SkipForDirectMissionTransfer(ApplyEffectParameters))
        return;

    // check if we meet any of the optional research conditions to add a better item
    UseItemName = ItemName;
    if (bAllowUpgrades)
    {
        ApplyResearchUpgrades(UseItemName);
    }

    EquipmentTemplate = X2WeaponTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(UseItemName));
    if (bOverrideInventorySlot)
        InventorySlot = InventorySlotOverride;
    else
        InventorySlot = EquipmentTemplate.InventorySlot;

    if (bReplaceExistingItemOnly)
        OldItemState = GetItem(UnitState, ExistingItemName);
    else
        OldItemState = GetItem(UnitState, UseItemName);

    if (OldItemState == none && !bReplaceExistingItemOnly)
    {
        // check and see if any of the alternative options are available to replace before adding a new item
        foreach AlternativeItemNames(AltItemName)
        {
            OldItemState = GetItem(UnitState, AltItemName);
            if (OldItemState != none)
            {
                UseItemName = AltItemName;
                EquipmentTemplate = X2WeaponTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(UseItemName));
                if (EquipmentTemplate != none)
                    break;
            }
        }
    }

    if (EquipmentTemplate == none)
        return;

    if (OldItemState == none && bReplaceExistingItemOnly)
        return;

    if (OldItemState != none && !bReplaceExistingItemOnly)
    {
        // The unit has this item already, so add ammo/charges if appropriate, otherwise silently ignore
        WeaponTemplate = X2WeaponTemplate(EquipmentTemplate);
        if (WeaponTemplate != none && WeaponTemplate.bMergeAmmo)
        {
            UpdatedItemState = XComGameState_Item(NewGameState.ModifyStateObject(OldItemState.Class, OldItemState.ObjectID));
            UpdatedItemState.Ammo += WeaponTemplate.iClipSize;
        }
    }
    else // Unit either doesn't have item, or it has it and it has to be replaced
    {
        // Create a new XCGS_Item instance
        NewItemState = AddNewItemToUnit(EquipmentTemplate, UnitState, InventorySlot, NewGameState);

        if (bReplaceExistingItemOnly)
        {
            //transfer ammo information over
            NewItemState.Ammo = OldItemState.Ammo;
            NewItemState.MergedItemCount = OldItemState.MergedItemCount;

            //mark old item as having no ammo -- this hides grenades and the like
            OldItemState.Ammo = 0;
            OldItemState.MergedItemCount = 0;
            OldItemState.bMergedOut = true;
        }

        EffectState.TemporaryItems.AddItem(NewItemState.GetReference());
    }

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function XComGameState_Item AddNewItemToUnit(X2EquipmentTemplate EquipmentTemplate, XComGameState_Unit UnitState, EInventorySlot InventorySlot, XComGameState NewGameState)
{
    local XComGameStateHistory          History;
    local XGUnit                        Visualizer;
    local XComGameState_Item            ItemState;
    // local XComGameState_Item            TempItem;
    local X2AbilityTemplateManager      AbilityManager;
    local X2AbilityTemplate             AbilityTemplate;
    local bool                          bCachedIgnoredItemEquipRestrictions;
    local array<name>                   EquipmentAbilities;
    local name                          AbilityName;
    local StateObjectReference          AbilityRef;
    local XComGameState_Ability         AbilityState;

    History = `XCOMHISTORY;
    AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    Visualizer = XGUnit(UnitState.GetVisualizer());

    // Create a new XCGS_Item instance
    ItemState = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
    NewGameState.AddStateObject(ItemState);
    NewGameState.AddStateObject(UnitState);

    bCachedIgnoredItemEquipRestrictions = UnitState.bIgnoreItemEquipRestrictions;
    UnitState.bIgnoreItemEquipRestrictions = bIgnoreItemEquipRestrictions;

    // Add the temporary item to the unit's inventory, adding the new state object to the NewGameState container
    if (!UnitState.AddItemToInventory(ItemState, InventorySlot, NewGameState))
        `REDSCREEN("TempItem : Failed to add Item" @ ItemState.GetMyTemplateName() @ "to inventory.");

    UnitState.bIgnoreItemEquipRestrictions = bCachedIgnoredItemEquipRestrictions;

    // Store it in a UnitValue too.
    UnitState.SetUnitFloatValue(GetItemUnitValueName_Static(EffectName), ItemState.ObjectID, eCleanup_BeginTacticalChain);

    // At this point the item has been created and added to the unit's inventory, but any item (or additional) abilities have yet to be added
    EquipmentAbilities = GatherAbilitiesForItem(EquipmentTemplate);

    // First, create any abilities that are missing
    foreach EquipmentAbilities(AbilityName)
    {
        AbilityRef = UnitState.FindAbility(AbilityName, ItemState.GetReference());
        if (AbilityRef.ObjectID == 0)
        {
            AddAbilityToUnit(AbilityName, UnitState, ItemState.GetReference(), NewGameState);
        }
    }

    // special handling for LaunchGrenade and maybe some other stuff
    foreach ForceCheckAbilities(AbilityName)
    {
        AbilityRef = UnitState.FindAbility(AbilityName);
        if (AbilityRef.ObjectID > 0)
        {
            AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
            if (AbilityState.SourceWeapon.ObjectID > 0)
            {
                AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
                `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, AbilityState.SourceWeapon, ItemState.GetReference());
            }
            else
            {
                `REDSCREEN("TempItem : No source weapon found for AbilityName=" $ AbilityName);
            }
        }
        else
        {
            if (UnitState.HasSoldierAbility(AbilityName))
            {
                AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
                `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, UnitState.GetSecondaryWeapon().GetReference(), ItemState.GetReference());
            }
        }
    }

    // Create the visualizer for the new item, and attach it if needed
    Visualizer.ApplyLoadoutFromGameState(UnitState, NewGameState);

    return ItemState;
}

static function XComGameState_Item GetItem(XComGameState_Unit Unit, name TemplateName, optional XComGameState CheckGameState)
{
    local array<XComGameState_Item> Items;
    local XComGameState_Item Item;

    Items = Unit.GetAllInventoryItems(CheckGameState);
    foreach Items(Item)
    {
        if (Item.GetMyTemplateName() == TemplateName && !Item.bMergedOut)
            return Item;
    }
    return none;
} 

function array<name> GatherAbilitiesForItem(X2EquipmentTemplate EquipmentTemplate)
{
    local name AbilityName, AdditionalAbilityName;
    local array<name> EquipmentAbilities;
    local X2AbilityTemplateManager AbilityTemplateMan;
    local X2AbilityTemplate AbilityTemplate, AdditionalAbilityTemplate;

    AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    EquipmentAbilities = AdditionalAbilities;

    if (EquipmentTemplate != none)
    {
        foreach EquipmentTemplate.Abilities(AbilityName)
        {
            AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
            if (AbilityTemplate != none && AbilityName != 'SmallItemWeight' && EquipmentAbilities.Find(AbilityName) == INDEX_NONE) // add ability if not duplicate
            {
                EquipmentAbilities.AddItem(AbilityName);
                foreach AbilityTemplate.AdditionalAbilities(AdditionalAbilityName)  // handle any additional abilities
                {
                    AdditionalAbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AdditionalAbilityName);
                    if (AdditionalAbilityTemplate != none && EquipmentAbilities.Find(AdditionalAbilityName) == INDEX_NONE)
                    {
                        EquipmentAbilities.AddItem(AdditionalAbilityName);
                    }
                    else if (AdditionalAbilityTemplate == none)
                    {
                        `RedScreen("Equipment template" @ EquipmentTemplate.DataName @ "specifies unknown additional ability:" @ AdditionalAbilityName);
                    }
                }
            }
            else if (AbilityTemplate == none)
            {
                `RedScreen("Equipment template" @ EquipmentTemplate.DataName @ "specifies unknown ability:" @ AbilityName);
            }
        }
    }
    return EquipmentAbilities;
}

function array<X2AbilityTemplate> AddAbilityToUnit(name AbilityName, XComGameState_Unit AbilitySourceUnitState, StateObjectReference ItemRef, XComGameState NewGameState, optional StateObjectReference AmmoRef)
{
    local X2AbilityTemplate RootAbilityTemplate, AbilityTemplate;
    local array<X2AbilityTemplate> AllAbilityTemplates, ReturnAbilityTemplates;
    local X2AbilityTemplateManager AbilityManager;
    local StateObjectReference AbilityRef;
    local Name AdditionalAbilityName;

    AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    RootAbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);

    if (RootAbilityTemplate != none)
    {
        AllAbilityTemplates.AddItem(RootAbilityTemplate);
        foreach RootAbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
        {
            AbilityTemplate = AbilityManager.FindAbilityTemplate(AdditionalAbilityName);
            if (AbilityTemplate != none)
            {
                AllAbilityTemplates.AddItem(AbilityTemplate);
            }
        }
    }

    foreach AllAbilityTemplates(AbilityTemplate)
    {
        AbilityRef = AbilitySourceUnitState.FindAbility(AbilityTemplate.DataName, ItemRef);
        if (AbilityRef.ObjectID == 0)
        {
            AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, AbilitySourceUnitState, NewGameState, ItemRef, AmmoRef);
            ReturnAbilityTemplates.AddItem(AbilityTemplate);
        }

        // WOTC TODO: Don't know if this is doing anything useful.
        NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityRef.ObjectID);
    }
    return ReturnAbilityTemplates;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XGS_Effect_TemporaryItem EffectState;
    local XComGameState_Unit UnitState;

    EffectState = XGS_Effect_TemporaryItem(RemovedEffectState);
    UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (UnitState == none)
    {
        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    }

    ClearTemporaryItems(EffectState, NewGameState, UnitState);

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

// let's handle this function too so we can cover all possible things
function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    local XComGameState NewGameState;
    local XGS_Effect_TemporaryItem TemporaryEffectState;

    TemporaryEffectState = XGS_Effect_TemporaryItem(EffectState);
    NewGameState = UnitState.GetParentGameState();

    if (TemporaryEffectState != none)
    {
        ClearTemporaryItems(TemporaryEffectState, NewGameState, UnitState);
    }
}


static function ClearTemporaryItems(XGS_Effect_TemporaryItem EffectState, XComGameState NewGameState, XComGameState_Unit OriginalUnitState)
{
    local XComGameStateHistory      History;
    local StateObjectReference      ItemRef;
    local XComGameState_Item        ItemState;
    local XComGameState_Unit        UnitState;
    local UnitValue                 ItemUnitValue;
    local bool                      bDontRemove;

    History = `XCOMHISTORY;

    foreach EffectState.TemporaryItems(ItemRef)
    {
        bDontRemove = false;
        if (ItemRef.ObjectID > 0)
        {
            ItemState = XComGameState_Item(NewGameState.GetGameStateForObjectID(ItemRef.ObjectID));

            if (ItemState == none)
            {
                ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
            }

            if (ItemState != none)
            {
                // Hardcoding this handling here since this one always will fail to be removed.
                if (ItemState.GetMyTemplateName() == 'EvacFlare')
                {
                    continue;
                }

                UnitState = OriginalUnitState;

                if (UnitState == none)
                {
                    UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
                }

                if (UnitState != none)
                {
                    if (!UnitState.RemoveItemFromInventory(ItemState))
                    {
                        bDontRemove = true;
                    }
                }

                if (!bDontRemove)
                {
                    // Remove the temporary item's gamestate object from history
                    NewGameState.RemoveStateObject(ItemRef.ObjectID);
                }
            }
        }
    }

    // catch multi phase missions
    if (EffectState.TemporaryItems.Length == 0)
    {
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OriginalUnitState.ObjectID));

        UnitState.GetUnitValue(GetItemUnitValueName_Static(EffectState.GetX2Effect().EffectName), ItemUnitValue);

        if (ItemUnitValue.fValue > 0)
        {
            ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemUnitValue.fValue));
            UnitState.RemoveItemFromInventory(ItemState);
            NewGameState.RemoveStateObject(ItemState.ObjectID);
        }
    }

    // Remove this gamestate object from history
    NewGameState.RemoveStateObject(EffectState.ObjectID);
}

// borrowed from XMB
static function bool SkipForDirectMissionTransfer(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameState_Ability AbilityState;
    local XComGameStateHistory History;
    local XComGameState_BattleData BattleData;
    local int Priority;

    History = `XCOMHISTORY;

    BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    if (!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
        return false;

    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    if (!AbilityState.IsAbilityTriggeredOnUnitPostBeginTacticalPlay(Priority))
        return false;

    return true;
}

static function name GetItemUnitValueName_Static(name DataName)
{
    return name(DataName $ default.UnitValueName);
}

defaultproperties
{
    EffectName = M31_TemporaryItem
    DuplicateResponse = eDupe_Ignore
    bInfiniteDuration = true

    GameStateEffectClass = class'XGS_Effect_TemporaryItem'

    UnitValueName = "_LWTemporaryItemEffectUnitValue"
}
