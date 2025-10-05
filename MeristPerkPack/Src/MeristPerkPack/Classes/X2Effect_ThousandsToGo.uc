class X2Effect_ThousandsToGo extends X2Effect_Persistent;

var bool bMatchSourceWeapon;
var name PointType;
var int ActivationsPerTurn;

var name CounterName;
var name EventName;

var array<name> ExcludeCharacterTemplates;
var array<name> ExcludeCharacterGroups;

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
    local XComGameStateHistory      History;
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

    if (ActivationsPerTurn > 0 && iCounter >= ActivationsPerTurn)
        return false;

    History = `XCOMHISTORY;

    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    if (AbilityState != none)
    {
        if (!bMatchSourceWeapon || kAbility.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        {
            TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

            if (TargetUnit != none && TargetUnit.IsDead()
                && ExcludeCharacterGroups.Find(TargetUnit.GetMyTemplate().CharacterGroupName) == INDEX_NONE
                && ExcludeCharacterTemplates.Find(TargetUnit.GetMyTemplateName()) == INDEX_NONE)
            {
                if (kAbility.IsAbilityInputTriggered() && ValidateAbilityCost(kAbility, SourceUnit))
                {
                    SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
                    if (PointType != '')
                        SourceUnit.ActionPoints.AddItem(PointType);
                    else
                        SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);
                    
                    `XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
                }
            }
        }
    }
    return false;
}

// Helper function that returns false if the ability is free
static function bool ValidateAbilityCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
    local X2AbilityTemplate Template;
    local X2AbilityCost Cost;
    local X2AbilityCost_ActionPoints ActionPointCost;

    Template = AbilityState.GetMyTemplate();

    foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none && !ActionPointCost.bFreeCost && ActionPointCost.GetPointCost(AbilityState, AbilityOwner) > 0)
            return true;
    }
    return false;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = M31_ThousandsToGo
    CounterName = M31_ThousandsToGo
    EventName = M31_ThousandsToGo
    bMatchSourceWeapon = true
}
