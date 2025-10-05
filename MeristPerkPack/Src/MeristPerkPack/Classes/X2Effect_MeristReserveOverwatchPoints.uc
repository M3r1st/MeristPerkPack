class X2Effect_MeristReserveOverwatchPoints extends X2Effect_ReserveOverwatchPoints config(GameData_SoldierSkills);

var bool bRemoveActionPoints;
var bool bMatchSourceWeapon;

struct OverwatchAbilityInfo
{
    var name AbilityName;
    var int Priority;
};

var config array<OverwatchAbilityInfo> OverwatchAbilities;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnitState;
    local name ReservePoint;
    local int i, Points;

    TargetUnitState = XComGameState_Unit(kNewTargetState);
    if (TargetUnitState != none)
    {
        ReservePoint = GetReserveType(ApplyEffectParameters, NewGameState);

        if (ReservePoint == '')
            return;

        Points = GetNumPoints(TargetUnitState);

        for (i = 0; i < Points; ++i)
        {
            TargetUnitState.ReserveActionPoints.AddItem(ReservePoint);
        }

        if (bRemoveActionPoints)
            TargetUnitState.ActionPoints.Length = 0;
    }
}

simulated function name GetReserveType(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
    local XComGameStateHistory          History;
    local XComGameState_Unit            TargetUnit;

    local StateObjectReference          OverwatchRef;
    local XComGameState_Ability         OverwatchState;
    local OverwatchAbilityInfo          OverwatchAbility;
    local array<OverwatchAbilityInfo>   OverwatchAbilitiesSorted;
    local name                          OverwatchAbilityName;
    local bool                          bCanUseOverwatch;
    local X2AbilityCost                 Cost;

    local name                          ActionPointType;
    local int                           iNumPoints;

    History = `XCOMHISTORY;

    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (TargetUnit == none)
        TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    foreach default.OverwatchAbilities(OverwatchAbility)
    {
        OverwatchAbilitiesSorted.AddItem(OverwatchAbility);
    }
    OverwatchAbilitiesSorted.Sort(SortOverwatchAbilities);

    foreach OverwatchAbilitiesSorted(OverwatchAbility)
    {
        OverwatchAbilityName = OverwatchAbility.AbilityName;
        if (bMatchSourceWeapon && ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
            OverwatchRef = TargetUnit.FindAbility(OverwatchAbilityName, ApplyEffectParameters.ItemStateObjectRef);
        else
            OverwatchRef = TargetUnit.FindAbility(OverwatchAbilityName);

        if (OverwatchRef.ObjectID != 0)
        {
            OverwatchState = XComGameState_Ability(History.GetGameStateForObjectID(OverwatchRef.ObjectID));
            if (OverwatchState != none)
            {
                if (OverwatchState.CanActivateAbility(TargetUnit,, true) == 'AA_Success')
                {
                    bCanUseOverwatch = true;
                    foreach OverwatchState.GetMyTemplate().AbilityCosts(Cost)
                    {
                        if (X2AbilityCost_ReserveActionPoints(Cost) == none)
                        {
                            if (Cost.CanAfford(OverwatchState, TargetUnit) != 'AA_Success')
                            {
                                bCanUseOverwatch = false;
                                break;
                            }
                        }
                    }
                    if (bCanUseOverwatch && GetAllowedActionPointType(OverwatchState, TargetUnit, ActionPointType, iNumPoints, true))
                    {
                        if (ActionPointType != '')
                        {
                            return ActionPointType;
                        }
                    }
                }
            }
        }
    }

    return super.GetReserveType(ApplyEffectParameters, NewGameState);
}

static function bool GetAllowedActionPointType(XComGameState_Ability AbilityState, XComGameState_Unit UnitState, out name ActionPointType, out int iNumPoints, optional bool bReserve)
{
    local X2AbilityTemplate                     AbilityTemplate;
    local X2AbilityCost                         AbilityCost;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityCost_ReserveActionPoints     ReserveActionPointCost;

    AbilityTemplate = AbilityState.GetMyTemplate();

    if (AbilityTemplate.AbilityCosts.Length > 0)
    {
        if (bReserve)
        {
            foreach AbilityTemplate.AbilityCosts(AbilityCost)
            {
                ReserveActionPointCost = X2AbilityCost_ReserveActionPoints(AbilityCost);
                if (ReserveActionPointCost != none)
                {
                    if (ActionPointType == '')
                        ActionPointType = ReserveActionPointCost.AllowedTypes[0];

                    iNumPoints = Max(iNumPoints, ReserveActionPointCost.iNumPoints);
                }
            }
        }
        else
        {
            foreach AbilityTemplate.AbilityCosts(AbilityCost)
            {
                ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
                if (ActionPointCost != none)
                {
                    if (ActionPointType == '')
                        ActionPointType = ActionPointCost.AllowedTypes[0];

                    iNumPoints = Max(iNumPoints, ActionPointCost.GetPointCost(AbilityState, UnitState));
                }
            }
        }
    }

    if (ActionPointType != '')
        return true;

    return false;
}

delegate int SortOverwatchAbilities(OverwatchAbilityInfo A, OverwatchAbilityInfo B)
{
    if (A.Priority < B.Priority)
        return -1;
    else if (A.Priority > B.Priority)
        return 1;
    else
        return 0;
}

defaultproperties
{
    bRemoveActionPoints = false
    bMatchSourceWeapon = false
}