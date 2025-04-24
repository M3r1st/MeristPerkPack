class X2Effect_AddGrenade extends XMBEffect_AddUtilityItem config(GameData_SoldierSkills);

struct UpgradeInfo
{
	var name ResearchName;
	var name BaseItemName;
	var name ItemName;
};

var config array<UpgradeInfo> Upgrades;

var bool bAllowUpgrades;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2ItemTemplate ItemTemplate;
	local X2ItemTemplateManager ItemTemplateMgr;
	local XComGameState_Unit NewUnit;
	local name TemplateName;
	local UpgradeInfo Upgrade;
	local XComGameState_HeadquartersXCom XComHQ;

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
		foreach Upgrades(Upgrade)
		{
			if (Upgrade.BaseItemName == TemplateName)
			{
				if (XComHQ.IsTechResearched(Upgrade.ResearchName))
				{
					TemplateName = Upgrade.ItemName;
					break;
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

defaultproperties
{
	bAllowUpgrades = true;
}