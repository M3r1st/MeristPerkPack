class X2Effect_ColdBlooded extends X2Effect_Persistent;

var int ActivationsPerTurn;
var array<name> AllowedAbilities;
var array<name> AllowedEffects;
var bool bIncludeDefaultEffects;
var bool bCheckSourceWeapon;
var name CounterName;
var name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local XComGameState_Unit        UnitState;
    local Object                    EffectObj;

    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    `XEVENTMGR.RegisterForEvent(EffectObj, EventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, 45, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        TargetUnit;
    local UnitValue                 UnitValue;
    local int                       iCounter;

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
        if (bCheckSourceWeapon && kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
            return false;

        if (AllowedAbilities.Find(kAbility.GetMyTemplateName()) != -1)
        {
            TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
            // TargetUnit = XComGameState_Unit(
            //     `XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID,, AbilityContext.AssociatedState.HistoryIndex - 1));
            if (TargetUnit != none && ValidateEffects(TargetUnit))
            {
                SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
                SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
                `XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
            }
        }
    }
    return false;
}

private function bool ValidateEffects(XComGameState_Unit UnitState)
{
    local name Effect;

    if (UnitState == none)
        return false;

    if (bIncludeDefaultEffects)
    {
        if (UnitState.IsBurning() || UnitState.IsPoisoned() || UnitState.IsAcidBurning() ||
            UnitState.AffectedByEffectNames.Find(class'X2StatusEffects'.default.BleedingName) != INDEX_NONE)
        {
            return true;
        }
    }

    foreach AllowedEffects(Effect)
    {
        if (UnitState.AffectedByEffectNames.Find(Effect) != INDEX_NONE)
        {
            return true;
        }
    }
    
    return false;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = M31_ColdBlooded
    CounterName = M31_ColdBlooded
    EventName = M31_ColdBlooded
    bIncludeDefaultEffects = true
    bCheckSourceWeapon = true
}
