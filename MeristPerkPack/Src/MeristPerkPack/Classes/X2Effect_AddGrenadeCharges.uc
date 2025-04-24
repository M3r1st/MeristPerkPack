class X2Effect_AddGrenadeCharges extends XMBEffect_AddItemCharges;

simulated function int GetItemChargeModifier(XComGameState NewGameState, XComGameState_Unit NewUnit, XComGameState_Item ItemIter)
{
	if (X2GrenadeTemplate(X2WeaponTemplate(ItemIter.GetMyTemplate())) != none)
	{
		if (ItemIter.Quantity == 0)
			return 0;

		if (ApplyToNames.Length > 0 && ApplyToNames.Find(ItemIter.GetMyTemplateName()) == INDEX_NONE)
			return 0;

		if (ApplyToSlots.Length > 0 && ApplyToSlots.Find(ItemIter.InventorySlot) == INDEX_NONE)
			return 0;

		return PerItemBonus;
	}
	return 0;
}