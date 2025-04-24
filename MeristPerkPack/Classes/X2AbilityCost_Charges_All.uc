class X2AbilityCost_Charges_All extends X2AbilityCost_Charges;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local name SharedAbilityName;
	local StateObjectReference SharedAbilityRef;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameState_Ability SharedAbilityState;
	local StateObjectReference BondmateRef;

	if (bOnlyOnHit && AbilityContext.IsResultContextMiss())
	{
		return;
	}
	kAbility.iCharges = 0;

	if( SharedAbilityCharges.Length > 0 || bAlsoExpendChargesOnSharedBondmateAbility )
	{
		History = `XCOMHISTORY;
		UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
		if (UnitState == None)
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

		foreach SharedAbilityCharges(SharedAbilityName)
		{
			if (SharedAbilityName != kAbility.GetMyTemplateName())
			{
				SharedAbilityRef = UnitState.FindAbility(SharedAbilityName);
				if (SharedAbilityRef.ObjectID > 0)
				{
					SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
					SharedAbilityState.iCharges = 0;
				}
			}
		}

		if( bAlsoExpendChargesOnSharedBondmateAbility && UnitState.HasSoldierBond(BondmateRef) )
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(BondmateRef.ObjectID));
			SharedAbilityRef = UnitState.FindAbility(kAbility.GetMyTemplateName());
			if( SharedAbilityRef.ObjectID > 0 )
			{
				SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
				SharedAbilityState.iCharges = 0;
			}

			foreach SharedAbilityCharges(SharedAbilityName)
			{
				if( SharedAbilityName != kAbility.GetMyTemplateName() )
				{
					SharedAbilityRef = UnitState.FindAbility(SharedAbilityName);
					if( SharedAbilityRef.ObjectID > 0 )
					{
						SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
						SharedAbilityState.iCharges = 0;
					}
				}
			}
		}
	}
}

DefaultProperties
{
	NumCharges = 1
}