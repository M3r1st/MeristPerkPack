class X2AbilityTarget_MovingMelee_Extended extends X2AbilityTarget_MovingMelee;

var int iFixedRange;
var bool bUseFixedRange;

simulated function name GetPrimaryTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
    UpdateParameters(Ability);
    return super.GetPrimaryTargetOptions(Ability, Targets);
}

simulated function bool ValidatePrimaryTargetOption(const XComGameState_Ability Ability, XComGameState_Unit SourceUnit, XComGameState_BaseObject TargetObject)
{
    UpdateParameters(Ability);
    return super.ValidatePrimaryTargetOption(Ability, SourceUnit, TargetObject);
}

simulated function UpdateParameters(XComGameState_Ability Ability)
{
    local XComGameState_Unit		SourceUnit; 

    if (bUseFixedRange)
    {
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
        
        if (SourceUnit == none)
            return;
        MovementRangeAdjustment = SourceUnit.NumActionPointsForMoving() - iFixedRange;
        // `LOG("Adjusting MovementRangeAdjustment: " $ MovementRangeAdjustment, true, 'X2AbilityTarget_MovingMelee_Extended');
    }
}
