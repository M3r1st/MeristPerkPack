class X2Effect_Heal extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit        TargetUnit;
    local int                       HealAmount;

    TargetUnit = XComGameState_Unit(kNewTargetState);

    if (TargetUnit != none)
    {
        HealAmount = GetHealAmount(ApplyEffectParameters);
        TargetUnit.ModifyCurrentStat(eStat_HP, HealAmount);
    }
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit OldUnit, NewUnit;
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
    local int Healed;
    local string Msg;

    OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
    NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    if (OldUnit != none && NewUnit != None)
    {
        Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
    
        if (Healed != 0)
        {
            SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
            Msg = Repl(class'X2Effect_ApplyMedikitHeal'.default.HealedMessage, "<Heal/>", Healed);
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
        }
    }
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
    AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}

simulated function int GetHealAmount(const out EffectAppliedData ApplyEffectParameters)
{
    return 0;
}