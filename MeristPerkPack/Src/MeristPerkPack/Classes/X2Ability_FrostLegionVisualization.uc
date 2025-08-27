class X2Ability_FrostLegionVisualization extends X2Ability;

simulated function Bind_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local X2AbilityTemplate             AbilityTemplate;
    local StateObjectReference          InteractingUnitRef;
    local X2Action_PlaySoundAndFlyOver  FlyOver;

    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   ActionMetadata;

    local int                           EffectIndex;
    local int                           SearchHistoryIndex;

    local XComGameStateContext          TestContext;
    local XComGameStateContext_TacticalGameRule TestGameRuleContext;
    local XComGameStateContext_Ability  GetOverHereAbilityContext;
    local bool                          bGetOverHereWasHit;
    local bool                          bDisplayAnimations;
    local X2VisualizerInterface         TargetVisualizerInterface;
    local bool                          bIsContextHit;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

    if( Context.InterruptionStatus == eInterruptionStatus_Interrupt )
    {
        // Only visualize InterruptionStatus eInterruptionStatus_None or eInterruptionStatus_Resume,
        // if eInterruptionStatus_Interrupt then the Viper was killed (or removed)
        return;
    }

    bIsContextHit = Context.IsResultContextHit();   // If this missed, there is no need to display animations

    bDisplayAnimations = Context.IsResultContextHit();

    // If this missed, there is no need to display animations
    if( bDisplayAnimations &&
        Context.InterruptionStatus == eInterruptionStatus_None )
    {
        // Look backwards for a turn begin, Bind, or GetOverHere
        for( SearchHistoryIndex = VisualizeGameState.HistoryIndex - 1; SearchHistoryIndex >= 0; --SearchHistoryIndex )
        {
            TestContext = History.GetGameStateFromHistory(SearchHistoryIndex).GetContext();
            TestGameRuleContext = XComGameStateContext_TacticalGameRule(TestContext);
            if( (TestGameRuleContext != none) && ( TestGameRuleContext.GameRuleType == eGameRule_PlayerTurnBegin ) )
            {
                // Found a begin turn, so no need to keep lookig for GetOverHere
                break;
            }

            GetOverHereAbilityContext = XComGameStateContext_Ability(TestContext);
            bGetOverHereWasHit = GetOverHereAbilityContext != none && class'XComGameStateContext_Ability'.static.IsHitResultHit(GetOverHereAbilityContext.ResultContext.HitResult);

            if( bGetOverHereWasHit &&
                class'X2Ability_Viper'.default.BIND_ABILITY_ALIASES.Find(GetOverHereAbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE &&
                GetOverHereAbilityContext.InputContext.SourceObject.ObjectID == Context.InputContext.SourceObject.ObjectID )
            {
                // A Bind with the same source was found, so this can't be a Bind due to GetOverHere
                break;
            }
            else if( bGetOverHereWasHit &&
                    class'X2Ability_Viper'.default.GET_OVER_HERE_ABILITY_ALIASES.Find(GetOverHereAbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE &&
                    GetOverHereAbilityContext.InputContext.SourceObject.ObjectID == Context.InputContext.SourceObject.ObjectID )
            {
                // An associated GetOverHere Ability was found, so we won't need to show the animations
                bDisplayAnimations = false;
                break;
            }
        }
    }

    //Configure the visualization track for the shooter
    //****************************************************************************************
    InteractingUnitRef = Context.InputContext.SourceObject;
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    //If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
    //done during the move.
    if (Context.InterruptionStatus != eInterruptionStatus_None)
    {
        //Insert markers for the subsequent interrupt to insert into
        class'X2Action'.static.AddInterruptMarkerPair(ActionMetadata, Context, `XCOMVISUALIZATIONMGR.BuildVisTree);
    }

    if( bDisplayAnimations && bIsContextHit )
    {
        class'X2Ability_Viper'.static.BindSourceAnimationVisualization(ActionMetadata, Context);
    }
    
    if( !bIsContextHit && (AbilityTemplate.LocMissMessage != "") )
    {
        FlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
        FlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, '', eColor_Bad);
    }

        //****************************************************************************************

    //Configure the visualization track for the target
    //****************************************************************************************
    if( bIsContextHit )
    {
        InteractingUnitRef = Context.InputContext.PrimaryTarget;
        ActionMetadata = EmptyTrack;
        ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
        ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
        ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

        if( bDisplayAnimations )
        {
            class'X2Ability_Viper'.static.BindTargetAnimationVisualization(ActionMetadata, Context);
        }

        for(EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
        {
            AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
        }

        TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
        if( TargetVisualizerInterface != none )
        {
            //Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
            TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
        }

    }
    //****************************************************************************************

    //****************************************************************************************
    //Configure the visualization tracks for the environment
    //****************************************************************************************

    if( bIsContextHit && bDisplayAnimations )
    {
        class'X2Ability_Viper'.static.BindEnvironmentDamageVisualization(Context, Context, AbilityTemplate);
    }
}
simulated function BindEndSource_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameStateHistory          History;
    local XComGameState_Effect          BindSustainedEffectState;
    local XComGameState_Unit            OldUnitState, BindTarget;
    local X2Action_ViperBindEnd         BindEnd;
    local XComGameStateContext          Context;

    History = `XCOMHISTORY;

    if (ActionMetadata.VisualizeActor != None)
    {
        Context = VisualizeGameState.GetContext( );

        OldUnitState = XComGameState_Unit(ActionMetadata.StateObject_OldState);
        BindSustainedEffectState = OldUnitState.GetUnitApplyingEffectState(class'X2Ability_Viper'.default.BindSustainedEffectName);
        `assert(BindSustainedEffectState != none);
        BindTarget = XComGameState_Unit(History.GetGameStateForObjectID(BindSustainedEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        `assert(BindTarget != none);

        if( BindTarget.IsDead() ||
            BindTarget.IsBleedingOut() ||
            BindTarget.IsUnconscious() )
        {
            // The target is dead, wait for it to die and inform the source
            class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
        }
        else
        {

            BindEnd = X2Action_ViperBindEnd(class'X2Action_ViperBindEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
            BindEnd.PartnerUnitRef = BindSustainedEffectState.ApplyEffectParameters.TargetStateObjectRef;
        }
    }
}
simulated function BindEndTarget_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Effect          BindSustainedEffectState;
    local XComGameState_Unit            OldUnitState;
    local X2Action_ViperBindEnd         BindEnd;
    local XComGameStateContext          Context;

    if(ActionMetadata.VisualizeActor != None)
    {
        Context = VisualizeGameState.GetContext();

        if( XComGameState_Unit(ActionMetadata.StateObject_NewState).IsDead() ||
        XComGameState_Unit(ActionMetadata.StateObject_NewState).IsBleedingOut() ||
        XComGameState_Unit(ActionMetadata.StateObject_NewState).IsUnconscious() )
        {
            OldUnitState = XComGameState_Unit(ActionMetadata.StateObject_OldState);
            BindSustainedEffectState = OldUnitState.GetUnitAffectedByEffectState(class'X2Ability_Viper'.default.BindSustainedEffectName);
            `assert(BindSustainedEffectState != none);

            BindEnd = X2Action_ViperBindEnd(class'X2Action_ViperBindEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
            BindEnd.PartnerUnitRef = BindSustainedEffectState.ApplyEffectParameters.SourceStateObjectRef;
        }
    }
}
simulated function BindEnd_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;
    

    local VisualizationActionMetadata        EmptyTrack;
    local VisualizationActionMetadata        ActionMetadata;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    //Configure the visualization track for the shooter
    //****************************************************************************************
    ActionMetadata = EmptyTrack;
    InteractingUnitRef = Context.InputContext.SourceObject;
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);

    BindEndSource_BuildVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
        //****************************************************************************************

    //Configure the visualization track for the target
    //****************************************************************************************
    ActionMetadata = EmptyTrack;
    InteractingUnitRef = Context.InputContext.PrimaryTarget;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    BindEndTarget_BuildVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
        //****************************************************************************************
}
simulated function BindSustained_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;
    local bool                          bTargetIsDead;
    local int                           i;

    local VisualizationActionMetadata        EmptyTrack;
    local VisualizationActionMetadata        ActionMetadata;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    //Configure the visualization track for the target
    //****************************************************************************************
    ActionMetadata = EmptyTrack;
    InteractingUnitRef = Context.InputContext.PrimaryTarget;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    bTargetIsDead = XComGameState_Unit(ActionMetadata.StateObject_NewState).IsDead() ||
                    XComGameState_Unit(ActionMetadata.StateObject_NewState).bBleedingOut;

    if( bTargetIsDead )
    {
        class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
    }

    for( i = 0; i < Context.ResultContext.TargetEffectResults.Effects.Length; ++i )
    {
        Context.ResultContext.TargetEffectResults.Effects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.TargetEffectResults.ApplyResults[i]);
    }

    if( bTargetIsDead )
    {
        class'X2Action_Death'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
    }

    //****************************************************************************************
}