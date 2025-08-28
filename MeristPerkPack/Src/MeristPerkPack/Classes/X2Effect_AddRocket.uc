class X2Effect_AddRocket extends XMBEffect_AddUtilityItem config(GameData_SoldierSkills);

struct RocketUpgradeInfo
{
    var name ResearchName;
    var name RequiredTech;
    var name BaseItemName;
    var name ItemName;
};

var config array<RocketUpgradeInfo> RocketUpgrades;

var bool bAllowUpgrades;
var EInventorySlot Slot;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local X2WeaponTemplate          WeaponTemplate;
    local X2ItemTemplateManager     ItemTemplateMgr;
    local X2ItemTemplate            ItemTemplate;
    local XComGameState_Unit        NewUnit;
    local RocketUpgradeInfo         Upgrade;
    local name                      TemplateName;

    XComHQ = `XCOMHQ;

    NewUnit = XComGameState_Unit(kNewTargetState);
    if (NewUnit == none)
        return;

    if (class'XMBEffectUtilities'.static.SkipForDirectMissionTransfer(ApplyEffectParameters))
        return;

    ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    TemplateName = DataName;
    if (bAllowUpgrades)
    {
        WeaponTemplate = X2WeaponTemplate(NewUnit.GetItemInSlot(Slot).GetMyTemplate());

        if (WeaponTemplate != none)
        {
            foreach RocketUpgrades(Upgrade)
            {
                if (Upgrade.BaseItemName == TemplateName
                    && XComHQ.IsTechResearched(Upgrade.ResearchName)
                    && IsRocketCompatible(WeaponTemplate.WeaponTech, Upgrade.RequiredTech))
                {
                    TemplateName = Upgrade.ItemName;
                }
            }
        }
    }
    ItemTemplate = ItemTemplateMgr.FindItemTemplate(TemplateName);
    
    // Use the highest upgraded available version of the item
    if (bUseHighestAvailableUpgrade)
        XComHQ.UpdateItemTemplateToHighestAvailableUpgrade(ItemTemplate);

    AddUtilityItem(NewUnit, ItemTemplate, NewGameState, NewEffectState);
}

static function bool IsRocketCompatible(name RocketLauncherTech, name RocketTech)
{
    return GetTechLevel(RocketLauncherTech) >= GetTechLevel(RocketTech);
}

static function int GetTechLevel(name WeaponTech)
{
    switch (WeaponTech)
    {
        case 'conventional':
            return 1;
        case 'magnetic':
            return 2;
        case 'beam':
            return 3;
        default:
            return 0;
    }
}

defaultproperties
{
    Slot = eInvSlot_SecondaryWeapon
    bAllowUpgrades = true
    bUseHighestAvailableUpgrade = false
}