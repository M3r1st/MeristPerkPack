class X2Condition_CanAffordCost extends X2Condition;

var name AbilityName;

var bool bValidateAmmoCost;
var bool bValidateActionPointCost;

var bool bFailIfNotFound;
var bool bFailIfCanAfford;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        SourceUnit;
    local XComGameState_Ability     AbilityState;
    local X2AbilityTemplate         AbilityTemplate;
    local X2AbilityCost             Cost;
    local name                      AvailableCode;

    History = `XCOMHISTORY;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
    if (SourceUnit == none)
        return 'AA_NotAUnit';

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.FindAbility(AbilityName).ObjectID));

    if (AbilityState == none)
        return (bFailIfNotFound ? 'AA_AbilityUnavailable' : 'AA_Success');

    AbilityTemplate = AbilityState.GetMyTemplate();

    foreach AbilityTemplate.AbilityCosts(Cost)
    {
        if (bValidateAmmoCost && X2AbilityCost_Ammo(Cost) != none
            || bValidateActionPointCost && X2AbilityCost_ActionPoints(Cost) != none)
        {
            AvailableCode = Cost.CanAfford(AbilityState, SourceUnit);
            if (AvailableCode != 'AA_Success')
            {
                `LOG("Can't afford " $ AbilityName, true, 'X2Condition_CanAffordCost');
                `LOG("Returning " $ (bFailIfCanAfford ? 'AA_Success' : AvailableCode), true, 'X2Condition_CanAffordCost');
                return (bFailIfCanAfford ? 'AA_Success' : AvailableCode);
            }
        }
    }

    return (bFailIfCanAfford ? 'AA_AbilityUnavailable' : 'AA_Success');
}

defaultproperties
{
    bFailIfNotFound = true
}