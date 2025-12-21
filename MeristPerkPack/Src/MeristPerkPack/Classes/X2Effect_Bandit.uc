class X2Effect_Bandit extends X2Effect_Persistent;

var int ActivationsPerTurn;
var int AmmoToReload;
var name CounterName;
var name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local XComGameState_Unit        UnitState;
    local Object                    EffectObj;

    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    `XEVENTMGR.RegisterForEvent(EffectObj, EventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, 40, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Item        WeaponState;
    local XComGameState_Ability     AbilityState;
    local UnitValue                 UnitValue;
    local int                       iCounter;

    SourceUnit.GetUnitValue(CounterName, UnitValue);
    iCounter = int(UnitValue.fValue);

    if (ActivationsPerTurn > 0 && iCounter >= ActivationsPerTurn)
        return false;

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    if (AbilityState != none)
    {
        if (kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
            return false;

        if (kAbility.iAmmoConsumed > 0)
        {
            WeaponState = XComGameState_Item(NewGameState.GetGameStateForObjectID(kAbility.SourceWeapon.ObjectID));
            if (WeaponState == none)
            {
                WeaponState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', kAbility.SourceWeapon.ObjectID));
            }

            if (WeaponState != none && WeaponState.Ammo < WeaponState.GetClipSize())
            {
                WeaponState.Ammo = Min(WeaponState.Ammo + AmmoToReload, WeaponState.GetClipSize());
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
}
