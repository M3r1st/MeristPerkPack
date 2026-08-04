class X2Effect_DisarmWeapon extends X2Effect_DisableWeapon;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
    local bool bBadEffect;

    if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none )
    {
        if (default.HideVisualizationOfResults.Find(EffectApplyResult) != INDEX_NONE)
            return;

        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));

        bBadEffect = XComGameState_Unit(ActionMetadata.StateObject_NewState).GetTeam() == eTeam_XCom;

        if (EffectApplyResult == 'AA_Success')
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.DisabledWeapon, '', bBadEffect ? eColor_Alien : eColor_Good);
        else
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.FailedDisable, '', bBadEffect ? eColor_Good : eColor_Alien);
    }
}

function name CheckWeaponImmunities(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;
    local XComGameState_Item WeaponState;

    TargetUnit = XComGameState_Unit(kNewTargetState);
    if (TargetUnit != none)
    {
        WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
        if (WeaponState == none)
        {
            return 'AA_UnitIsImmune';
        }
        else
        {
            if (WeaponState.HasInfiniteAmmo()
                || default.WeaponsImmuneToDisable.Find(WeaponState.GetMyTemplateName()) != INDEX_NONE)
            {
                return 'AA_UnitIsImmune';
            }
        }
    }

    return 'AA_Success';
}

defaultproperties
{
    ApplyChanceFn = CheckWeaponImmunities
}