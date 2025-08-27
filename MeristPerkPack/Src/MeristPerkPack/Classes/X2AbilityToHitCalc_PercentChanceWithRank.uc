class X2AbilityToHitCalc_PercentChanceWithRank extends X2AbilityToHitCalc_PercentChance;

var() float PercentToHitPerRank;

protected function int GetPercentToHit(XComGameState_Ability kAbility, AvailableTarget kTarget)
{
    local XComGameStateHistory History;
    local XComGameState_Unit SourceUnit;
    local int RetVal;

    History = `XCOMHISTORY;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
    RetVal = super.GetPercentToHit(kAbility, kTarget) + int(SourceUnit.GetSoldierRank() * PercentToHitPerRank);
    return RetVal;
}

function int GetShotBreakdown(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog = false)
{
    m_ShotBreakdown.FinalHitChance = GetPercentToHit(kAbility, kTarget);
    return m_ShotBreakdown.FinalHitChance;
}