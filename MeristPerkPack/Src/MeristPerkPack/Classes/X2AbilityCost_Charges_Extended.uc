class X2AbilityCost_Charges_Extended extends X2AbilityCost_Charges;

var bool bConsumeAllCharges;
var bool bOnlyOnMiss;

simulated function name CanAfford(XComGameState_Ability kAbility, XComGameState_Unit ActivatingUnit)
{
    if (kAbility.GetCharges() >= GetChargeCost(kAbility, ActivatingUnit))
    {
        return 'AA_Success';
    }

    return 'AA_CannotAfford_Charges';
}

simulated function int GetChargeCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
    local int Charges;

    if (ConsumeAllCharges(AbilityState, AbilityOwner))
    {
        Charges = AbilityState.GetCharges();
        if (Charges > 0)
        {
            return Charges;
        }

        return 1;
    }

    return NumCharges;
}

simulated function bool ConsumeAllCharges(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
    return bConsumeAllCharges;
}

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        AbilityOwner, BondmateState;
    local name                      SharedAbilityName;
    local StateObjectReference      SharedAbilityRef;
    local XComGameState_Ability     SharedAbilityState;
    local StateObjectReference      BondmateRef;
    local int                       Cost;

    AbilityOwner = XComGameState_Unit(AffectState);

    if (bFreeCost)
    {
        return;
    }

    if (bOnlyOnMiss && AbilityContext.IsResultContextHit())
    {
        return;
    }
    if (bOnlyOnHit && AbilityContext.IsResultContextMiss())
    {
        return;
    }

    Cost = GetChargeCost(kAbility, AbilityOwner);
    kAbility.iCharges -= Cost;

    if (SharedAbilityCharges.Length > 0 || bAlsoExpendChargesOnSharedBondmateAbility)
    {
        History = `XCOMHISTORY;

        foreach SharedAbilityCharges(SharedAbilityName)
        {
            if (SharedAbilityName != kAbility.GetMyTemplateName())
            {
                SharedAbilityRef = AbilityOwner.FindAbility(SharedAbilityName);
                if (SharedAbilityRef.ObjectID > 0)
                {
                    SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
                    if (SharedAbilityState.iCharges > 0)
                    {
                        SharedAbilityState.iCharges -= Min(Cost, SharedAbilityState.iCharges);
                    }
                }
            }
        }

        if (bAlsoExpendChargesOnSharedBondmateAbility && AbilityOwner.HasSoldierBond(BondmateRef))
        {
            BondmateState = XComGameState_Unit(History.GetGameStateForObjectID(BondmateRef.ObjectID));
            SharedAbilityRef = BondmateState.FindAbility(kAbility.GetMyTemplateName());
            if (SharedAbilityRef.ObjectID > 0)
            {
                SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
                if (SharedAbilityState.iCharges > 0)
                {
                    SharedAbilityState.iCharges -= Min(Cost, SharedAbilityState.iCharges);
                }
            }

            foreach SharedAbilityCharges(SharedAbilityName)
            {
                if (SharedAbilityName != kAbility.GetMyTemplateName())
                {
                    SharedAbilityRef = BondmateState.FindAbility(SharedAbilityName);
                    if (SharedAbilityRef.ObjectID > 0)
                    {
                        SharedAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', SharedAbilityRef.ObjectID));
                        if (SharedAbilityState.iCharges > 0)
                        {
                            SharedAbilityState.iCharges -= Min(Cost, SharedAbilityState.iCharges);
                        }
                    }
                }
            }
        }
    }
}