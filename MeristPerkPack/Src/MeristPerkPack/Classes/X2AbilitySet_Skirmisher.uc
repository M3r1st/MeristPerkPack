class X2AbilitySet_Skirmisher extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name PinionsEventName;
var privatewrite name PinionsDelayEffectName;
var privatewrite name PinionsShooterEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(ForwardOperator());
    Templates.AddItem(FullKit());
    // Templates.AddItem(Pinions());
    // /*>>*/Templates.AddItem(PinionsAttack());

    return Templates;
}

static function X2AbilityTemplate ForwardOperator()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_MeristForwardOperator    Effect;

    Template = Passive('M31_ForwardOperator', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ForwardOperator", false, true);

    Effect = new class'X2Effect_MeristForwardOperator';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_ForwardOperator_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_MeristForwardOperator'.default.strFriendlyDesc, Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate FullKit()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_SK_FullKit', "img:///UILibrary_XPerkIconPack.UIPerk_grenade_plus", false, true);

    return Template;
}

static function X2AbilityTemplate Pinions()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityMultiTarget_MeristPinions    PinionsMultiTarget;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2Effect_DelayedAbilityActivation     DelayAbilityEffect;
    local X2Effect_Persistent                   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SK_Pinions');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_blazingpinions";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.TwoTurnAttackAbility = 'M31_SK_Pinions_Attack';

    SetAbilityShotHUDPriority(Template, ePriorityType_Secondary, eCost_SingleConsumeAll, eHostility_Offensive);

    Template.AbilityToHitCalc = default.DeadEye;
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToSquadsightRange = true;
    CursorTarget.FixedAbilityRange = class'X2Ability_Archon'.default.BLAZING_PINIONS_SELECTION_RANGE;
    Template.AbilityTargetStyle = CursorTarget;

    Template.TargetingMethod = class'X2TargetingMethod_MeristPinions';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    PinionsMultiTarget = new class'X2AbilityMultiTarget_MeristPinions';
    PinionsMultiTarget.fTargetRadius = class'X2Ability_Archon'.default.BLAZING_PINIONS_IMPACT_RADIUS_METERS;
    PinionsMultiTarget.NumTargets = class'X2Ability_Archon'.default.BLAZING_PINIONS_NUM_TARGETS;
    PinionsMultiTarget.fAreaTargetRadius = class'X2Ability_Archon'.default.BLAZING_PINIONS_TARGETING_AREA_RADIUS;
    PinionsMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = PinionsMultiTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    AddSuppressedCondition(Template);
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.HasClearanceToMaxZ = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, 3);

    // Delayed Effect to cause the second Blazing Pinions stage to occur
    DelayAbilityEffect = new class 'X2Effect_DelayedAbilityActivation';
    DelayAbilityEffect.EffectName = default.PinionsDelayEffectName;
    DelayAbilityEffect.TriggerEventName = default.PinionsEventName;
    DelayAbilityEffect.BuildPersistentEffect(1, false, false,, eGameRule_PlayerTurnBegin);
    DelayAbilityEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddShooterEffect(DelayAbilityEffect);

    // An effect to attach Perk FX to
    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = default.PinionsShooterEffectName;
    PersistentEffect.BuildPersistentEffect(1, true, false, true);
    Template.AddShooterEffect(PersistentEffect);

    Template.AddShooterEffect(new class'X2Effect_ApplyBlazingPinionsTargetToWorld');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildAppliedVisualizationSyncFn = Pinions_BuildVisualizationSync;
    // Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.DamagePreviewFn = Pinions_DamagePreview;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.CustomFireAnim = 'HL_SignalPoint';
    Template.CinescriptCameraType = "Archon_BlazingPinions_Stage1";

    Template.bShowActivation = true;

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.AdditionalAbilities.AddItem('M31_SK_Pinions_Attack');

    return Template;
}

static function Pinions_BuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
    local XComGameStateContext_Ability  AbilityContext;
    local X2AbilityTemplate             AbilityTemplate;
    local int                           i;

    if (!`XENGINE.IsMultiplayerGame() && EffectName == default.PinionsDelayEffectName)
    {
        AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
        AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
        
        // The references to the shooter effect instances in the input context don't restore to be the references to the ability
        // template that they should.  Which is okay, we'll just use the effects directly.
        for (i = 0; i < AbilityTemplate.AbilityShooterEffects.Length; i++)
        {
            AbilityTemplate.AbilityShooterEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 
                AbilityContext.ResultContext.ShooterEffectResults.ApplyResults[i]);
        }
    }
}

function bool Pinions_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        AbilityOwner;
    local StateObjectReference      PreviewAbilityRef;
    local XComGameState_Ability     PreviewAbilityState;

    History = `XCOMHISTORY;

    AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    PreviewAbilityRef = AbilityOwner.FindAbility('M31_SK_Pinions_Attack');
    PreviewAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(PreviewAbilityRef.ObjectID));
    if (PreviewAbilityState != none)
    {
        PreviewAbilityState.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
    }

    return true;
}

static function X2AbilityTemplate PinionsAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    EventListener;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_RemoveEffects            RemoveEffects;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SK_Pinions_Attack');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_blazingpinions";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Offensive;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventFn = AbilityTriggerEventListener_PinionsAttack;
    EventListener.ListenerData.EventID = default.PinionsEventName;
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = class'X2Ability_Archon'.default.BLAZING_PINIONS_IMPACT_RADIUS_METERS;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove.AddItem(default.PinionsShooterEffectName);
    RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_ApplyBlazingPinionsTargetToWorld'.default.EffectName);
    Template.AddShooterEffect(RemoveEffects);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    // DamageEffect.EffectDamageValue = `GetConfigDamage("M31_ENEMY_ViperBite2_Damage");
    DamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.ARCHON_BLAZINGPINIONS_BASEDAMAGE;
    DamageEffect.EnvironmentalDamageAmount = class'X2Item_DefaultWeapons'.default.ARCHON_BLAZINGPINIONS_ENVDAMAGE;
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bApplyWorldEffectsForEachTargetLocation = true;
    Template.AddMultiTargetEffect(DamageEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = PinionsAttack_BuildVisualization;
    Template.ModifyNewContextFn = PinionsAttack_ModifyActivatedAbilityContext;

    Template.ActionFireClass = class'X2Action_MeristPinionsAttack';

    Template.CinescriptCameraType = "Archon_BlazingPinions_Stage2";

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function PinionsAttack_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local X2AbilityMultiTargetStyle     RadiusMultiTarget;
    local AvailableTarget               MultiTargets;
    local int                           i;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(Context);

    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
    RadiusMultiTarget = AbilityState.GetMyTemplate().AbilityMultiTargetStyle;// new class'X2AbilityMultiTarget_Radius';

    AbilityContext.ResultContext.ProjectileHitLocations.Length = 0;
    for (i = 0; i < AbilityContext.InputContext.TargetLocations.Length; i++)
    {
        RadiusMultiTarget.GetMultiTargetsForLocation(AbilityState, AbilityContext.InputContext.TargetLocations[i], MultiTargets);

        // Add the TargetLocations as ProjectileHitLocations
        AbilityContext.ResultContext.ProjectileHitLocations.AddItem(AbilityContext.InputContext.TargetLocations[i]);
    }

    AbilityContext.InputContext.MultiTargets = MultiTargets.AdditionalTargets;
}

static function EventListenerReturn AbilityTriggerEventListener_PinionsAttack(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory      History;
    local XComGameState_Ability     CallbackAbilityState;
    local XComGameState_Unit        SourceUnit;
    local XComGameState_Effect      EffectState;
    local AvailableAction           CurrentAvailableAction;
    local AbilityInputContext       InputContext;
    local AvailableTarget           Targets;
    local array<vector>             TargetLocations;

    History = `XCOMHISTORY;

    CallbackAbilityState = XComGameState_Ability(CallbackData);
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(CallbackAbilityState.OwnerStateObject.ObjectID));
    EffectState = SourceUnit.GetUnitAffectedByEffectState(default.PinionsShooterEffectName);
    if (EffectState != none)
    {
        CurrentAvailableAction.AvailableCode = CallbackAbilityState.CanActivateAbility(SourceUnit);
        InputContext = EffectState.ApplyEffectParameters.AbilityInputContext;
        if ((CurrentAvailableAction.AvailableCode == 'AA_Success') && (InputContext.TargetLocations.Length > 1))
        {
            // Set up the available action
            CurrentAvailableAction.AvailableTargets.AddItem(Targets);
            CurrentAvailableAction.AbilityObjectRef = CallbackAbilityState.GetReference();

            InputContext.TargetLocations.Remove(0, 1);
            TargetLocations = InputContext.TargetLocations;
            class'XComGameStateContext_Ability'.static.ActivateAbility(CurrentAvailableAction, 0, TargetLocations);
        }
    }

    return ELR_NoInterrupt;
}

simulated function PinionsAttack_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      AbilityContext;
    local StateObjectReference              InteractingUnitRef;
    local X2AbilityTemplate                 AbilityTemplate;
    local VisualizationActionMetadata       EmptyTrack;
    local VisualizationActionMetadata       ActionMetadata;
    // local X2Action_PlaySoundAndFlyOver      SoundAndFlyover;
    // local X2Action_PersistentEffect	        PersistentEffectAction;
    local int i, j;
    local X2VisualizerInterface             TargetVisualizerInterface;

    local XComGameState_EnvironmentDamage   EnvironmentDamageEvent;
    local XComGameState_WorldEffectTileData WorldDataUpdate;
    local XComGameState_InteractiveObject   InteractiveObject;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = AbilityContext.InputContext.SourceObject;

    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);

    // ****************************************************************************************
    // Configure the visualization track for the source
    // ****************************************************************************************
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    // SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
    // SoundAndFlyOver.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, '', eColor_Bad);

    // Remove the override idle animation
    // PersistentEffectAction = X2Action_PersistentEffect(class'X2Action_PersistentEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
    // PersistentEffectAction.IdleAnimName = '';

    // Play the firing action
    // class'X2Action_MeristPinionsAttack'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
    AbilityTemplate.ActionFireClass.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

    for (i = 0; i < AbilityContext.ResultContext.ShooterEffectResults.Effects.Length; ++i)
    {
        AbilityContext.ResultContext.ShooterEffectResults.Effects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 
            AbilityContext.ResultContext.ShooterEffectResults.ApplyResults[i]);
    }

    if (AbilityContext.InputContext.MovementPaths.Length > 0)
    {
        class'X2VisualizerHelpers'.static.ParsePath(AbilityContext, ActionMetadata);
    }
    // ****************************************************************************************

    // ****************************************************************************************
    // Configure the visualization track for the targets
    // ****************************************************************************************
    for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; ++i)
    {
        InteractingUnitRef = AbilityContext.InputContext.MultiTargets[i];
        ActionMetadata = EmptyTrack;
        ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
        ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
        ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

        class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
        for (j = 0; j < AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j)
        {
            AbilityContext.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, AbilityContext.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
        }

        TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
        if (TargetVisualizerInterface != none)
        {
            // Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
            TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
        }
    }

    // ****************************************************************************************
    // Configure the visualization tracks for the environment
    // ****************************************************************************************
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
    {
        ActionMetadata = EmptyTrack;
        ActionMetadata.VisualizeActor = none;
        ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
        ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

        //Wait until signaled by the shooter that the projectiles are hitting
        class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

        for (i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
        {
            AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
        }
    }

    foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
    {
        ActionMetadata = EmptyTrack;
        ActionMetadata.VisualizeActor = none;
        ActionMetadata.StateObject_NewState = WorldDataUpdate;
        ActionMetadata.StateObject_OldState = WorldDataUpdate;

        // Wait until signaled by the shooter that the projectiles are hitting
        class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);

        for(i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i)
        {
            AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
        }

    }
    // ****************************************************************************************

    // Process any interactions with interactive objects
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
    {
        // Add any doors that need to listen for notification
        if (InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim() && InteractiveObject.InteractionCount % 2 != 0) // Is this a closed door?
        {
            ActionMetadata = EmptyTrack;
            // Don't necessarily have a previous state, so just use the one we know about
            ActionMetadata.StateObject_OldState = InteractiveObject;
            ActionMetadata.StateObject_NewState = InteractiveObject;
            ActionMetadata.VisualizeActor = History.GetVisualizer(InteractiveObject.ObjectID);
            class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
            class'X2Action_BreakInteractActor'.static.AddToVisualizationTree(ActionMetadata, AbilityContext);
        }
    }
}

defaultproperties
{
    PinionsEventName = M31_SK_Pinions_Attack
    PinionsDelayEffectName = M31_SK_Pinions_Delay
    PinionsShooterEffectName = M31_SK_Pinions_FX
}