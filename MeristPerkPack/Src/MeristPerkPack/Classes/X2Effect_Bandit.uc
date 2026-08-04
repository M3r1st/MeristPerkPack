class X2Effect_Bandit extends X2Effect_Persistent;

var int ActivationsPerTurn;
var int AmmoToReload;
var name CountValueName;
var name AmmoValueName;
var name FlyoverEventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetUnit;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    EventMgr.RegisterForEvent(EffectObj, FlyoverEventName, class'M31_Helpers'.static.TriggerAbilityFlyover_Static, ELD_OnStateSubmitted, 40, TargetUnit,, EffectObj);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Ability AbilityState;
    local XComGameState_Item    WeaponState;
    local UnitValue             UnitValue;
    local int                   AmmoReloaded;

    SourceUnit.GetUnitValue(CountValueName, UnitValue);

    if (ActivationsPerTurn > 0 && UnitValue.fValue >= ActivationsPerTurn)
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

            if (WeaponState != none)
            {
                if (WeaponState.Ammo < WeaponState.GetClipSize())
                {
                    AmmoReloaded = Min(WeaponState.GetClipSize() - WeaponState.Ammo, AmmoToReload);
                    WeaponState.Ammo += AmmoReloaded;
                    SourceUnit.SetUnitFloatValue(CountValueName, UnitValue.fValue + 1.0, eCleanup_BeginTurn);
                    SourceUnit.SetUnitFloatValue(AmmoValueName, AmmoReloaded, eCleanup_BeginTurn);
                    `XEVENTMGR.TriggerEvent(FlyoverEventName, AbilityState, SourceUnit, NewGameState);
                }
            }
        }
    }

    return false;
}

static function string GetFlyoverOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameStateHistory  History;
    local XComGameState_Effect  EffectState;
    local XComGameState_Unit    UnitState;
    local X2Effect_Bandit       Effect;
    local UnitValue             UnitValue;

    if (StrategyParseObj == none)
    {
        History = `XCOMHISTORY;

        EffectState = XComGameState_Effect(ParseObj);
        if (EffectState != none)
        {
            Effect = X2Effect_Bandit(EffectState.GetX2Effect());
            if (Effect != none)
            {
                UnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
                if (UnitState != none)
                {
                    if (UnitState.GetUnitValue(Effect.AmmoValueName, UnitValue) && UnitValue.fValue > 0)
                    {
                        return string(int(UnitValue.fValue));
                    }
                    else
                    {
                        return string(Effect.AmmoToReload);
                    }
                }
            }
        }
    }

    return "?";
}

defaultproperties
{
    EffectName = M31_Bandit
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_Bandit
    AmmoValueName = M31_Bandit_LastReloaded

    FlyoverEventName = M31_Bandit
}
