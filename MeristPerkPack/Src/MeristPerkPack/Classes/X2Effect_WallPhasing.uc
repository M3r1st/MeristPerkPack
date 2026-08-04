class X2Effect_WallPhasing extends X2Effect_PersistentTraversalChange;

function OnUnitChangedTile(const out TTile NewTileLocation, XComGameState_Effect EffectState, XComGameState_Unit TargetUnit)
{
    local XGUnit                Unit;
    local XComUnitPawn          UnitPawn;
    local XComPerkContentInst   PerkContent;
    local PerkActivationData    ActivationData;

    Unit = XGUnit(TargetUnit.GetVisualizer());
    UnitPawn = Unit.GetPawn();

    PerkContent = UnitPawn.GetPerkContent(string(EffectState.ApplyEffectParameters.AbilityInputContext.AbilityTemplateName));

    if (PerkContent != none)
    {
        if (UnitPawn.m_bIsPhasing && PerkContent.IsInState('Idle'))
        {
            PerkContent.OnPerkActivation(ActivationData);
        }
        else if (!UnitPawn.m_bIsPhasing && PerkContent.IsInState('ActionActive'))
        {
            PerkContent.OnPerkDeactivation();
        }
    }
}

defaultproperties
{
    EffectName = "M31_WallPhasing"
    DuplicateResponse = eDupe_Ignore
}
