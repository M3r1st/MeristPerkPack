class X2AbilitySet_Skirmisher extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name PinionsEventName;
var privatewrite name PinionsDelayEffectName;
var privatewrite name PinionsShooterEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(ForwardOperator());
    Templates.AddItem(DeepPockets());
    Templates.AddItem(ZeroIn());
    Templates.AddItem(BloodThirst());
    Templates.AddItem(Pinions());
    /*>>*/Templates.AddItem(PinionsAttack());

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

static function X2AbilityTemplate DeepPockets()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_SK_DeepPockets', "img:///UILibrary_XPerkIconPack.UIPerk_grenade_plus", false, false);

    return Template;
}

static function X2AbilityTemplate BloodThirst()
{
    local X2AbilityTemplate     Template;
    local X2Effect_BloodThirst  Effect;
    
    Template = Passive('M31_SK_BloodThirst', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage", false, true);

    Effect = new class'X2Effect_BloodThirst';
    Effect.DamagePerStack = `GetConfigInt("M31_SK_BloodThirst_DamagePerStack");
    Effect.MaxStacks = `GetConfigInt("M31_SK_BloodThirst_MaxStacks");
    Effect.MaxStacksPerTurn = `GetConfigInt("M31_SK_BloodThirst_MaxStacksPerTurn");
    Effect.StackDuration = `GetConfigInt("M31_SK_BloodThirst_StackDuration");
    Effect.bRefreshDuration = `GetConfigBool("M31_SK_BloodThirst_bRefreshDuration");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_SK_BloodThirst_bMatchSourceWeapon");
    Effect.bIncreaseOnlyOnHit = `GetConfigBool("M31_SK_BloodThirst_bIncreaseOnlyOnHit");
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_BloodThirst'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ZeroIn()
{
    local X2AbilityTemplate     Template;
    local X2Effect_SK_ZeroIn    Effect;
    
    Template = Passive('M31_SK_ZeroIn', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_zeroin", false, true);

    Effect = new class'X2Effect_SK_ZeroIn';
    Effect.CritPerShot = `GetConfigInt("M31_SK_ZeroIn_CritPerShot");
    Effect.LockedInAimPerShot = `GetConfigInt("M31_SK_ZeroIn_LockedInAimPerShot");
    Effect.bDontResetOnMovement = `GetConfigBool("M31_SK_ZeroIn_bDontResetOnMovement");
    Effect.bAllowIncrementWithoutInput = `GetConfigBool("M31_SK_ZeroIn_bAllowIncrementWithoutInput");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_SK_ZeroIn'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Pinions()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_MeristPinions    PinionsMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2Condition_UnitEffects               ExcludeEffects;
    local X2Effect_DelayedAbilityActivation     DelayAbilityEffect;
    local X2Effect_Persistent                   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SK_Pinions');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_blazingpinions";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.TwoTurnAttackAbility = 'M31_SK_Pinions_Attack';

    SetAbilityShotHUDPriority(Template, ePriorityType_None, eCost_SingleConsumeAll, eHostility_Offensive);

    Template.bCrossClassEligible = false;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.AbilityToHitCalc = default.DeadEye;

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToSquadsightRange = true;
    CursorTarget.FixedAbilityRange = `TILESTOMETERS(`GetConfigInt("M31_SK_Pinions_Range"));
    Template.AbilityTargetStyle = CursorTarget;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    PinionsMultiTarget = new class'X2AbilityMultiTarget_MeristPinions';
    PinionsMultiTarget.fTargetRadius = `GetConfigFloat("M31_SK_Pinions_Radius");
    PinionsMultiTarget.NumTargets = `GetConfigInt("M31_SK_Pinions_NumTargets");
    PinionsMultiTarget.fAreaTargetRadius = `GetConfigFloat("M31_SK_Pinions_AreaRadius");
    PinionsMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = PinionsMultiTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeristPinions';

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);

    ExcludeEffects = new class'X2Condition_UnitEffects';
    ExcludeEffects.AddExcludeEffect(default.PinionsShooterEffectName, 'AA_DuplicateEffectIgnored');
    Template.AbilityShooterConditions.AddItem(ExcludeEffects);

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_SK_Pinions_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_SK_Pinions_Charges"));

    // Delayed effect to cause the second stage to occur
    DelayAbilityEffect = new class 'X2Effect_DelayedAbilityActivation';
    DelayAbilityEffect.EffectName = default.PinionsDelayEffectName;
    DelayAbilityEffect.TriggerEventName = default.PinionsEventName;
    DelayAbilityEffect.BuildPersistentEffect(1, false, false,, eGameRule_PlayerTurnBegin);
    DelayAbilityEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddShooterEffect(DelayAbilityEffect);

    // Callback effect for the second stage
    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = default.PinionsShooterEffectName;
    PersistentEffect.BuildPersistentEffect(1, true, false);
    Template.AddShooterEffect(PersistentEffect);

    Template.AddShooterEffect(new class'X2Effect_ApplyBlazingPinionsTargetToWorld');

    Template.CustomFireAnim = 'HL_SignalPoint';

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    // Template.CinescriptCameraType = "Archon_BlazingPinions_Stage1";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.bSkipFireAction = false;
    Template.bShowActivation = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildAppliedVisualizationSyncFn = Pinions_BuildVisualizationSync;

    Template.DamagePreviewFn = Pinions_DamagePreview;

    Template.ConcealmentRule = eConceal_Never;
    Template.SuperConcealmentLoss = 100;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    // Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

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
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2AbilityTrigger_EventListener    EventListener;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_RemoveEffects            RemoveEffects;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Effect_Burning                  BurningEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SK_Pinions_Attack');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_blazingpinions";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Offensive;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    Template.AbilityTargetStyle = default.SelfTarget;

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventFn = AbilityTriggerEventListener_PinionsAttack;
    EventListener.ListenerData.EventID = default.PinionsEventName;
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `GetConfigFloat("M31_SK_Pinions_Radius");
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove.AddItem(default.PinionsShooterEffectName);
    RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_ApplyBlazingPinionsTargetToWorld'.default.EffectName);
    Template.AddShooterEffect(RemoveEffects);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_SK_Pinions_Damage");
    DamageEffect.EnvironmentalDamageAmount = `GetConfigInt("M31_SK_Pinions_EnvDamage");
    DamageEffect.bExplosiveDamage = `GetConfigBool("M31_SK_Pinions_bExplosiveDamage");
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bApplyWorldEffectsForEachTargetLocation = true;
    Template.AddMultiTargetEffect(DamageEffect);

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_SK_Pinions_BurnDamage"), `GetConfigInt("M31_SK_Pinions_BurnDamage_Spread"));
    Template.AddMultiTargetEffect(BurningEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = PinionsAttack_BuildVisualization;
    Template.ModifyNewContextFn = PinionsAttack_ModifyActivatedAbilityContext;

    Template.ActionFireClass = class'X2Action_MeristPinionsAttack';

    // Template.CinescriptCameraType = "Archon_BlazingPinions_Stage2";
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;
    // Template.SuperConcealmentLoss = 100;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

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
    RadiusMultiTarget = AbilityState.GetMyTemplate().AbilityMultiTargetStyle;

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

static function PinionsAttack_BuildVisualization(XComGameState VisualizeGameState)
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
    PinionsShooterEffectName = M31_SK_Pinions_Callback
}