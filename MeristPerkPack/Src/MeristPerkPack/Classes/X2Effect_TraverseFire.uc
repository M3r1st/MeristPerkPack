class X2Effect_TraverseFire extends X2Effect_Persistent;

var int ActivationsPerTurn;
var array<name> AllowedAbilities;
var bool bCheckSourceWeapon;
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
    local XComGameState_Ability                 AbilityState;
    local int                                   iCounter;
    local UnitValue                             UnitValue;

    if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
        return false;

    if (class'M31_AbilityHelpers'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
        return false;

    SourceUnit.GetUnitValue(CounterName, UnitValue);
    iCounter = int(UnitValue.fValue);

    if (iCounter >= ActivationsPerTurn)
        return false;

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    if (AbilityState != none)
    {
        if (!(bCheckSourceWeapon && kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef) &&
            AllowedAbilities.Find(kAbility.GetMyTemplateName()) != -1)
        {
            SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
            SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);
            `XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
        }
        else
        {
            if (kAbility.IsAbilityInputTriggered()) {
                if (kAbility.GetMyTemplate().Hostility == eHostility_Offensive || PreCostActionPoints.Length - SourceUnit.ActionPoints.Length > 0) {
                    SourceUnit.SetUnitFloatValue(CounterName, ActivationsPerTurn, eCleanup_BeginTurn);
                }
            }
        }
    }
    return false;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = M31_TraverseFire
    CounterName = M31_TraverseFire
    EventName = M31_TraverseFire
    bCheckSourceWeapon = true
}
