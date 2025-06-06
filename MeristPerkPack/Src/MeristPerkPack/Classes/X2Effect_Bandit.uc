class X2Effect_Bandit extends X2Effect_Persistent;

var int ActivationsPerTurn;
var int AmmoToReload;
var EInventorySlot Slot;
var name CounterName;
var name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local XComGameState_Unit        UnitState;
    local Object                    EffectObj;

    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    `XEVENTMGR.RegisterForEvent(EffectObj, EventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, 51, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Item                    WeaponState, NewWeaponState;
    local XComGameState_Ability                 AbilityState;
    local X2AbilityTemplate                     AbilityTemplate;
    local X2AbilityCost                         AbilityCost;
    local X2AbilityCost_Ammo                    AmmoCost;
    local UnitValue                             UnitValue;
    local int                                   iCounter;
    local bool                                  bHasAmmoCost;

    SourceUnit.GetUnitValue(CounterName, UnitValue);
    iCounter = int(UnitValue.fValue);

    if (iCounter >= ActivationsPerTurn)
        return false;

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    if (AbilityState != none)
    {
        if (kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
            return false;

        AbilityTemplate = kAbility.GetMyTemplate();
        
        foreach AbilityTemplate.AbilityCosts(AbilityCost)
        {
            AmmoCost = X2AbilityCost_Ammo(AbilityCost);
            if (AmmoCost != none)
            {
                if (AmmoCost.iAmmo > 0 && !AmmoCost.bFreeCost)
                {
                    bHasAmmoCost = true;
                    break;
                }
            }
        }

        if (bHasAmmoCost)
        {
            WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(kAbility.SourceWeapon.ObjectID));
            if (WeaponState != none)
            {
                NewWeaponState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', WeaponState.ObjectID));
                if (NewWeaponState.Ammo < WeaponState.GetClipSize())
                {
                    NewWeaponState.Ammo = Min(NewWeaponState.Ammo + AmmoToReload, WeaponState.GetClipSize());
                }
                SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
                `XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
            }
        }
    }
    return false;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = M31_Bandit
    CounterName = M31_Bandit
    EventName = M31_Bandit
    Slot = eInvSlot_PrimaryWeapon
}
