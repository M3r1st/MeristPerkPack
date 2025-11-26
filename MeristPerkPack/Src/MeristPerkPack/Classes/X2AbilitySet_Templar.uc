class X2AbilitySet_Templar extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> Loophole_AllowedAbilities;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Loophole());
        Templates.AddItem(LoopholeTrigger());
    Templates.AddItem(TeleportSlash());
    return Templates;
}

static function X2AbilityTemplate Loophole()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_TM_Loophole', "", false, true);

    Template.AdditionalAbilities.AddItem('M31_TM_Loophole_Trigger');

    return Template;
}

static function X2AbilityTemplate LoopholeTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_ModifyTemplarFocus       FocusEffect;

    Template = SelfTargetTrigger('M31_TM_Loophole_Trigger', "");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_Loophole;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    FocusEffect = new class'X2Effect_ModifyTemplarFocus';
    FocusEffect.TargetConditions.AddItem(new class'X2Condition_GhostShooter');
    Template.AddShooterEffect(FocusEffect);

    AddUnitValueCondition(Template, 'M31_TM_Loophole', `GetConfigInt("M31_TM_Loophole_ActivationsPerTurn"));

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_Loophole(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability             AbilityState;
    local XComGameState_Ability             KillingAbilityState;
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(CallbackData);
        KillingAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

        if (SourceUnit != none && AbilityState != none && KillingAbilityState != none)
        {
            if (default.Loophole_AllowedAbilities.Find(KillingAbilityState.GetMyTemplateName()) != INDEX_NONE)
            {
                return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
            }
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate TeleportSlash()
{
    local X2AbilityTemplate Template;

    Template = MovingMelee('M31_TM_TeleportSlash', "", false, true);

    AddActionPointCost(Template, eCost_Single);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_Wrath');
    Template.TargetingMethod = class'X2TargetingMethod_NXWrath';
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.BuildNewGameStateFn = TeleportSlash_BuildGameState;
    Template.BuildVisualizationFn = TeleportSlash_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    return Template;
}

static function XComGameState TeleportSlash_BuildGameState(XComGameStateContext Context)
{
    local XComGameState                 NewGameState;
    local XComGameState_Unit            UnitState;
    local XComGameStateContext_Ability  AbilityContext;
    local vector                        NewLocation;
    local TTile                         NewTileLocation;
    local XComWorldData                 World;
    local X2EventManager                EventManager;
    local int                           LastIndex;

    World = `XWORLD;
    EventManager = `XEVENTMGR;

    NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);

    AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());	
    UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));

    LastIndex = AbilityContext.InputContext.MovementPaths[0].MovementData.Length - 1;

    `assert(LastIndex > 0);
    NewLocation = AbilityContext.InputContext.MovementPaths[0].MovementData[LastIndex].Position;
    NewTileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
    UnitState.SetVisibilityLocation(NewTileLocation);

    AbilityContext.ResultContext.bPathCausesDestruction = MoveAbility_StepCausesDestruction(UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);
    MoveAbility_AddTileStateObjects(NewGameState, UnitState, AbilityContext.InputContext, 0, AbilityContext.InputContext.MovementPaths[0].MovementTiles.Length - 1);

    EventManager.TriggerEvent('ObjectMoved', UnitState, UnitState, NewGameState);
    EventManager.TriggerEvent('UnitMoveFinished', UnitState, UnitState, NewGameState);

    TypicalAbility_FillOutGameState(NewGameState);

    return NewGameState;
}

static function TeleportSlash_BuildVisualization(XComGameState VisualizeGameState)
{	
    //general
    local XComGameStateHistory              History;
    local XComGameStateVisualizationMgr     VisualizationMgr;

    //visualizers
    local Actor	TargetVisualizer, ShooterVisualizer;

    //actions
    local X2Action                          AddedAction;
    local X2Action                          FireAction;
    local X2Action_MoveTurn                 MoveTurnAction;
    local X2Action_PlaySoundAndFlyOver      SoundAndFlyover;
    local X2Action_ExitCover                ExitCoverAction;
    // local X2Action_MoveTeleport             TeleportMoveAction;
    local X2Action_Delay                    MoveDelay;
    // local X2Action_MoveEnd                  MoveEnd;
    local X2Action_MarkerNamed              JoinActions;
    local array<X2Action>                   LeafNodes;
    local X2Action_WaitForAnotherAction     WaitForFireAction;

    local X2Action_MoveVisibleTeleport      CasterTeleport;
    // local X2Action_MoveBegin                CasterMoveBegin;
    // local X2Action_MoveEnd                  CasterMoveEnd;

    //state objects
    local XComGameState_Ability             AbilityState;
    local XComGameState_EnvironmentDamage   EnvironmentDamageEvent;
    local XComGameState_WorldEffectTileData WorldDataUpdate;
    local XComGameState_InteractiveObject   InteractiveObject;
    local XComGameState_BaseObject          TargetStateObject;
    local XComGameState_Item                SourceWeapon;
    local StateObjectReference              ShootingUnitRef;

    //interfaces
    local X2VisualizerInterface             TargetVisualizerInterface, ShooterVisualizerInterface;

    //contexts
    local XComGameStateContext_Ability      Context;
    local AbilityInputContext               AbilityContext;

    //templates
    local X2AbilityTemplate                 AbilityTemplate;
    local X2AmmoTemplate                    AmmoTemplate;
    local X2WeaponTemplate                  WeaponTemplate;
    local array<X2Effect>                   MultiTargetEffects;

    //Tree metadata
    local VisualizationActionMetadata       InitData;
    local VisualizationActionMetadata       BuildData;
    local VisualizationActionMetadata       SourceData, InterruptTrack;

    local XComGameState_Unit TargetUnitState;
    local name         ApplyResult;

    //indices
    local int   EffectIndex, TargetIndex;
    local int   TrackIndex;
    local int   WindowBreakTouchIndex;

    //flags
    local bool  bSourceIsAlsoTarget;
    local bool  bMultiSourceIsAlsoTarget;
    local bool  bPlayedAttackResultNarrative;

    // good/bad determination
    local bool bGoodAbility;

    History = `XCOMHISTORY;
    VisualizationMgr = `XCOMVISUALIZATIONMGR;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    AbilityContext = Context.InputContext;
    /// HL-Docs: ref:Bugfixes; issue:879
    /// Use HistoryIndex to access the AbilityState as it was when the ability was activated rather than getting the most recent version.
    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID,, VisualizeGameState.HistoryIndex));
    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
    ShootingUnitRef = Context.InputContext.SourceObject;

    //Configure the visualization track for the shooter, part I. We split this into two parts since
    //in some situations the shooter can also be a target
    //****************************************************************************************
    ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);
    ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

    SourceData = InitData;
    SourceData.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    SourceData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
    if (SourceData.StateObject_NewState == none)
        SourceData.StateObject_NewState = SourceData.StateObject_OldState;
    SourceData.VisualizeActor = ShooterVisualizer;	

    /// HL-Docs: ref:Bugfixes; issue:879
    /// Use HistoryIndex to access the WeaponState as it was when the ability was activated rather than getting the most recent version.
    SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID,, VisualizeGameState.HistoryIndex));
    if (SourceWeapon != None)
    {
        WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
        AmmoTemplate = X2AmmoTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
    }

    bGoodAbility = XComGameState_Unit(SourceData.StateObject_NewState).IsFriendlyToLocalPlayer();

    if( Context.IsResultContextMiss() && AbilityTemplate.SourceMissSpeech != '' )
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceMissSpeech, bGoodAbility ? eColor_Bad : eColor_Good);
    }
    else if( Context.IsResultContextHit() && AbilityTemplate.SourceHitSpeech != '' )
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.SourceHitSpeech, bGoodAbility ? eColor_Good : eColor_Bad);
    }

    if( !AbilityTemplate.bSkipFireAction || Context.InputContext.MovementPaths.Length > 0 )
    {
        ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceData, Context));
        ExitCoverAction.bSkipExitCoverVisualization = AbilityTemplate.bSkipExitCoverWhenFiring;

        // if this ability has a built in move, do it right before we do the fire action
        if(Context.InputContext.MovementPaths.Length > 0)
        {
            // note that we skip the stop animation since we'll be doing our own stop with the end of move attack
            class'X2VisualizerHelpers'.static.ParsePath(Context, SourceData, AbilityTemplate.bSkipMoveStop);

            //  add paths for other units moving with us (e.g. gremlins moving with a move+attack ability)
            if (Context.InputContext.MovementPaths.Length > 1)
            {
                for (TrackIndex = 1; TrackIndex < Context.InputContext.MovementPaths.Length; ++TrackIndex)
                {
                    BuildData = InitData;
                    BuildData.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.MovementPaths[TrackIndex].MovingUnitRef.ObjectID);
                    BuildData.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.MovementPaths[TrackIndex].MovingUnitRef.ObjectID);
                    MoveDelay = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(BuildData, Context));
                    MoveDelay.Duration = class'X2Ability_DefaultAbilitySet'.default.TypicalMoveDelay;
                    class'X2VisualizerHelpers'.static.ParsePath(Context, BuildData, AbilityTemplate.bSkipMoveStop);	
                }
            }

            if (!AbilityTemplate.bSkipFireAction)
            {
                CasterTeleport = X2Action_MoveVisibleTeleport(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveVisibleTeleport', SourceData.VisualizeActor));
                CasterTeleport.ParamsStart.AnimName = 'HL_ExchangeStart';
                CasterTeleport.ParamsStop.AnimName = 'HL_ExchangeEnd';
                CasterTeleport.bLookAtEndPos = true;
                // CasterMoveBegin = X2Action_MoveBegin(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveBegin', SourceData.VisualizeActor));
                // CasterMoveEnd = X2Action_MoveEnd(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveEnd', SourceData.VisualizeActor));

                ExitCoverAction.bSkipFOWReveal = true;
                AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, SourceData.LastActionAdded);
                // MoveEnd = X2Action_MoveEnd(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveEnd', SourceData.VisualizeActor));

                // if (MoveEnd != none)
                // {
                //     // add the fire action as a child of the node immediately prior to the move end
                //     AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, none, MoveEnd.ParentActions);

                //     // reconnect the move end action as a child of the fire action, as a special end of move animation will be performed for this move + attack ability
                //     VisualizationMgr.DisconnectAction(MoveEnd);
                //     VisualizationMgr.ConnectAction(MoveEnd, VisualizationMgr.BuildVisTree, false, AddedAction);
                // }
                // else
                // {
                //     //See if this is a teleport. If so, don't perform exit cover visuals
                //     TeleportMoveAction = X2Action_MoveTeleport(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_MoveTeleport', SourceData.VisualizeActor));
                //     if (TeleportMoveAction != none)
                //     {
                //         //Skip the FOW Reveal ( at the start of the path ). Let the fire take care of it ( end of the path )
                //         ExitCoverAction.bSkipFOWReveal = true;
                //     }

                //     AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, SourceData.LastActionAdded);
                // }
            }
        }
        else
        {
            //If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
            //done during the move.
            if (Context.InterruptionStatus != eInterruptionStatus_None)
            {
                //Insert markers for the subsequent interrupt to insert into
                class'X2Action'.static.AddInterruptMarkerPair(SourceData, Context, ExitCoverAction);
            }

            if (!AbilityTemplate.bSkipFireAction)
            {
                // no move, just add the fire action. Parent is exit cover action if we have one
                AddedAction = AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(SourceData, Context, false, SourceData.LastActionAdded);
            }			
        }

        if( !AbilityTemplate.bSkipFireAction )
        {
            FireAction = AddedAction;

            class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'AttackBegin', FireAction.ParentActions[0]);

            if( AbilityTemplate.AbilityToHitCalc != None )
            {
                X2Action_Fire(AddedAction).SetFireParameters(Context.IsResultContextHit());
            }
        }
    }

    //If there are effects added to the shooter, add the visualizer actions for them
    for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
    {
        AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, SourceData, Context.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));		
    }
    //****************************************************************************************

    //Configure the visualization track for the target(s). This functionality uses the context primarily
    //since the game state may not include state objects for misses.
    //****************************************************************************************	
    bSourceIsAlsoTarget = AbilityContext.PrimaryTarget.ObjectID == AbilityContext.SourceObject.ObjectID; //The shooter is the primary target
    if (AbilityTemplate.AbilityTargetEffects.Length > 0 &&			//There are effects to apply
        AbilityContext.PrimaryTarget.ObjectID > 0)				//There is a primary target
    {
        TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
        TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

        if( bSourceIsAlsoTarget )
        {
            BuildData = SourceData;
        }
        else
        {
            BuildData = InterruptTrack;        //  interrupt track will either be empty or filled out correctly
        }

        BuildData.VisualizeActor = TargetVisualizer;

        TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
        if( TargetStateObject != none )
        {
            History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID, 
                                                            BuildData.StateObject_OldState, BuildData.StateObject_NewState,
                                                            eReturnType_Reference,
                                                            VisualizeGameState.HistoryIndex);
            `assert(BuildData.StateObject_NewState == TargetStateObject);
        }
        else
        {
            //If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
            //and show no change.
            BuildData.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
            BuildData.StateObject_NewState = BuildData.StateObject_OldState;
        }

        // if this is a melee attack, make sure the target is facing the location he will be melee'd from
        if(!AbilityTemplate.bSkipFireAction 
            && !bSourceIsAlsoTarget 
            && AbilityContext.MovementPaths.Length > 0
            && AbilityContext.MovementPaths[0].MovementData.Length > 0
            && XGUnit(TargetVisualizer) != none)
        {
            MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(BuildData, Context, false, ExitCoverAction));
            MoveTurnAction.m_vFacePoint = AbilityContext.MovementPaths[0].MovementData[AbilityContext.MovementPaths[0].MovementData.Length - 1].Position;
            MoveTurnAction.m_vFacePoint.Z = TargetVisualizerInterface.GetTargetingFocusLocation().Z;
            MoveTurnAction.UpdateAimTarget = true;

            // Jwats: Add a wait for ability effect so the idle state machine doesn't process!
            WaitForFireAction = X2Action_WaitForAnotherAction(class'X2Action_WaitForAnotherAction'.static.AddToVisualizationTree(BuildData, Context, false, MoveTurnAction));
            WaitForFireAction.ActionToWaitFor = FireAction;
        }

        //Pass in AddedAction (Fire Action) as the LastActionAdded if we have one. Important! As this is automatically used as the parent in the effect application sub functions below.
        if (AddedAction != none && AddedAction.IsA('X2Action_Fire'))
        {
            BuildData.LastActionAdded = AddedAction;
        }
        
        //Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
        //playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
        //track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
        for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
        {
            ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

            // Target effect visualization
            if( !Context.bSkipAdditionalVisualizationSteps )
            {
                AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
            }

            // Source effect visualization
            AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
        }

        //the following is used to handle Rupture flyover text
        TargetUnitState = XComGameState_Unit(BuildData.StateObject_OldState);
        if (TargetUnitState != none &&
            XComGameState_Unit(BuildData.StateObject_OldState).GetRupturedValue() == 0 &&
            XComGameState_Unit(BuildData.StateObject_NewState).GetRupturedValue() > 0)
        {
            //this is the frame that we realized we've been ruptured!
            class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildData);
        }

        if (AbilityTemplate.bAllowAmmoEffects && AmmoTemplate != None)
        {
            for (EffectIndex = 0; EffectIndex < AmmoTemplate.TargetEffects.Length; ++EffectIndex)
            {
                ApplyResult = Context.FindTargetEffectApplyResult(AmmoTemplate.TargetEffects[EffectIndex]);
                AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
                AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
            }
        }
        if (AbilityTemplate.bAllowBonusWeaponEffects && WeaponTemplate != none)
        {
            for (EffectIndex = 0; EffectIndex < WeaponTemplate.BonusWeaponEffects.Length; ++EffectIndex)
            {
                ApplyResult = Context.FindTargetEffectApplyResult(WeaponTemplate.BonusWeaponEffects[EffectIndex]);
                WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
                WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
            }
        }

        if (Context.IsResultContextMiss() && (AbilityTemplate.LocMissMessage != "" || AbilityTemplate.TargetMissSpeech != ''))
        {
            SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context, false, BuildData.LastActionAdded));
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocMissMessage, AbilityTemplate.TargetMissSpeech, bGoodAbility ? eColor_Bad : eColor_Good);
        }
        else if( Context.IsResultContextHit() && (AbilityTemplate.LocHitMessage != "" || AbilityTemplate.TargetHitSpeech != '') )
        {
            SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(BuildData, Context, false, BuildData.LastActionAdded));
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocHitMessage, AbilityTemplate.TargetHitSpeech, bGoodAbility ? eColor_Good : eColor_Bad);
        }

        if (!bPlayedAttackResultNarrative)
        {
            class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'AttackResult');
            bPlayedAttackResultNarrative = true;
        }

        if( TargetVisualizerInterface != none )
        {
            //Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
            TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildData);
        }

        if( bSourceIsAlsoTarget )
        {
            SourceData = BuildData;
        }
    }

    if (AbilityTemplate.bUseLaunchedGrenadeEffects)
    {
        MultiTargetEffects = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState)).LaunchedGrenadeEffects;
    }
    else if (AbilityTemplate.bUseThrownGrenadeEffects)
    {
        MultiTargetEffects = X2GrenadeTemplate(SourceWeapon.GetMyTemplate()).ThrownGrenadeEffects;
    }
    else
    {
        MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
    }

    //  Apply effects to multi targets - don't show multi effects for burst fire as we just want the first time to visualize
    if( MultiTargetEffects.Length > 0 && AbilityContext.MultiTargets.Length > 0 && X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle) == none)
    {
        for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
        {	
            bMultiSourceIsAlsoTarget = false;
            if( AbilityContext.MultiTargets[TargetIndex].ObjectID == AbilityContext.SourceObject.ObjectID )
            {
                bMultiSourceIsAlsoTarget = true;
                bSourceIsAlsoTarget = bMultiSourceIsAlsoTarget;				
            }

            TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
            TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

            if( bMultiSourceIsAlsoTarget )
            {
                BuildData = SourceData;
            }
            else
            {
                BuildData = InitData;
            }
            BuildData.VisualizeActor = TargetVisualizer;

            // if the ability involved a fire action and we don't have already have a potential parent,
            // all the target visualizations should probably be parented to the fire action and not rely on the auto placement.
            if( (BuildData.LastActionAdded == none) && (FireAction != none) )
                BuildData.LastActionAdded = FireAction;

            TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
            if( TargetStateObject != none )
            {
                History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID, 
                                                                    BuildData.StateObject_OldState, BuildData.StateObject_NewState,
                                                                    eReturnType_Reference,
                                                                    VisualizeGameState.HistoryIndex);
                `assert(BuildData.StateObject_NewState == TargetStateObject);
            }			
            else
            {
                //If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
                //and show no change.
                BuildData.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
                BuildData.StateObject_NewState = BuildData.StateObject_OldState;
            }
        
            //Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
            //playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
            //track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
            for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
            {
                ApplyResult = Context.FindMultiTargetEffectApplyResult(MultiTargetEffects[EffectIndex], TargetIndex);

                // Target effect visualization
                MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);

                // Source effect visualization
                MultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
            }			

            //the following is used to handle Rupture flyover text
            TargetUnitState = XComGameState_Unit(BuildData.StateObject_OldState);
            if (TargetUnitState != none && 
                XComGameState_Unit(BuildData.StateObject_OldState).GetRupturedValue() == 0 &&
                XComGameState_Unit(BuildData.StateObject_NewState).GetRupturedValue() > 0)
            {
                //this is the frame that we realized we've been ruptured!
                class 'X2StatusEffects'.static.RuptureVisualization(VisualizeGameState, BuildData);
            }

            // Start Issue #1329
            /// HL-Docs: ref:Bugfixes; issue:1329
            /// Visualize bonus weapon effects and ammo effects being applied to multi targets.
            if (AbilityTemplate.bAllowAmmoEffects && AmmoTemplate != None)
            {
                for (EffectIndex = 0; EffectIndex < AmmoTemplate.TargetEffects.Length; ++EffectIndex)
                {
                    ApplyResult = Context.FindMultiTargetEffectApplyResult(AmmoTemplate.TargetEffects[EffectIndex], TargetIndex);
                    AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
                    AmmoTemplate.TargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
                }
            }
            if (AbilityTemplate.bAllowBonusWeaponEffects && WeaponTemplate != none)
            {
                for (EffectIndex = 0; EffectIndex < WeaponTemplate.BonusWeaponEffects.Length; ++EffectIndex)
                {
                    ApplyResult = Context.FindMultiTargetEffectApplyResult(WeaponTemplate.BonusWeaponEffects[EffectIndex], TargetIndex);
                    WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, ApplyResult);
                    WeaponTemplate.BonusWeaponEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceData, ApplyResult);
                }
            }
            // End Issue #1329
            
            if (!bPlayedAttackResultNarrative)
            {
                class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'AttackResult');
                bPlayedAttackResultNarrative = true;
            }

            if( TargetVisualizerInterface != none )
            {
                //Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
                TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildData);
            }

            if( bMultiSourceIsAlsoTarget )
            {
                SourceData = BuildData;
            }			
        }
    }
    //****************************************************************************************

    //Finish adding the shooter's track
    //****************************************************************************************
    if( !bSourceIsAlsoTarget && ShooterVisualizerInterface != none)
    {
        ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, SourceData);				
    }	

    //  Handle redirect visualization
    TypicalAbility_AddEffectRedirects(VisualizeGameState, SourceData);

    //****************************************************************************************

    //Configure the visualization tracks for the environment
    //****************************************************************************************

    if (ExitCoverAction != none)
    {
        ExitCoverAction.ShouldBreakWindowBeforeFiring( Context, WindowBreakTouchIndex );
    }

    foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
    {
        BuildData = InitData;
        BuildData.VisualizeActor = none;
        BuildData.StateObject_NewState = EnvironmentDamageEvent;
        BuildData.StateObject_OldState = EnvironmentDamageEvent;

        // if this is the damage associated with the exit cover action, we need to force the parenting within the tree
        // otherwise LastActionAdded with be 'none' and actions will auto-parent.
        if ((ExitCoverAction != none) && (WindowBreakTouchIndex > -1))
        {
            if (EnvironmentDamageEvent.HitLocation == AbilityContext.ProjectileEvents[WindowBreakTouchIndex].HitLocation)
            {
                BuildData.LastActionAdded = ExitCoverAction;
            }
        }

        for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
        {
            AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');		
        }

        for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
        {
            AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');
        }

        for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
        {
            MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');	
        }
    }

    foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
    {
        BuildData = InitData;
        BuildData.VisualizeActor = none;
        BuildData.StateObject_NewState = WorldDataUpdate;
        BuildData.StateObject_OldState = WorldDataUpdate;

        for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
        {
            AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');		
        }

        for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
        {
            AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');
        }

        for (EffectIndex = 0; EffectIndex < MultiTargetEffects.Length; ++EffectIndex)
        {
            MultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildData, 'AA_Success');	
        }
    }
    //****************************************************************************************

    //Process any interactions with interactive objects
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
    {
        // Add any doors that need to listen for notification. 
        // Move logic is taken from MoveAbility_BuildVisualization, which only has special case handling for AI patrol movement ( which wouldn't happen here )
        if ( Context.InputContext.MovementPaths.Length > 0 || (InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim()) ) //Is this a closed door?
        {
            BuildData = InitData;
            //Don't necessarily have a previous state, so just use the one we know about
            BuildData.StateObject_OldState = InteractiveObject;
            BuildData.StateObject_NewState = InteractiveObject;
            BuildData.VisualizeActor = History.GetVisualizer(InteractiveObject.ObjectID);

            class'X2Action_BreakInteractActor'.static.AddToVisualizationTree(BuildData, Context);
        }
    }
    
    //Add a join so that all hit reactions and other actions will complete before the visualization sequence moves on. In the case
    // of fire but no enter cover then we need to make sure to wait for the fire since it isn't a leaf node
    VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, LeafNodes);

    if (!AbilityTemplate.bSkipFireAction)
    {
        if (!AbilityTemplate.bSkipExitCoverWhenFiring)
        {			
            LeafNodes.AddItem(class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceData, Context, false, FireAction));
        }
        else
        {
            LeafNodes.AddItem(FireAction);
        }
    }
    
    if (VisualizationMgr.BuildVisTree.ChildActions.Length > 0)
    {
        JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SourceData, Context, false, none, LeafNodes));
        JoinActions.SetName("Join");
    }
}