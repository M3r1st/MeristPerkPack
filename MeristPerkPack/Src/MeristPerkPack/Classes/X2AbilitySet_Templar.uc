class X2AbilitySet_Templar extends X2Ability_Extended config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(ReadyForAnything());
    Templates.AddItem(ReadyForAnythingTrigger());

    return Templates;
}

static function X2AbilityTemplate ReadyForAnything()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_ReadyForAnything');

    Template.IconImage = "img:///UILibrary_LWAlienPack.LW_AbilityReadyForAnything";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = 'ReadyForAnything_Passive';
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    Template.bCrossClassEligible = true;

    Template.AdditionalAbilities.AddItem('M31_ReadyForAnythingTrigger');

    return Template;
}

static function X2AbilityTemplate ReadyForAnythingTrigger()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Condition_UnitEffects               SuppressedCondition;
    local X2Effect_MeristReserveOverwatchPoints ReserveEffect;
    local X2Effect_MeristCoveringFire           CoveringFireEffect;
    local X2Condition_AbilityProperty           CoveringFireCondition;
    local X2Condition_UnitValue                 ValueCondition;
    local X2Effect_IncrementUnitValue           UnitValueEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_ReadyForAnythingTrigger');

    Template.IconImage = "img:///UILibrary_LWAlienPack.LW_AbilityReadyForAnything";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.bCrossClassEligible = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'X2Effect_ReadyForAnything'.static.AbilityTriggerEventListener_ReadyForAnything;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    // SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);

    ReserveEffect = new class'X2Effect_MeristReserveOverwatchPoints';
    ReserveEffect.bMatchSourceWeapon = class'X2Effect_ReadyForAnything'.default.bMatchSourceWeapon;
    Template.AddTargetEffect(ReserveEffect);
    
    CoveringFireEffect = new class'X2Effect_MeristCoveringFire';
    CoveringFireEffect.AbilitiesToActivate = class'X2Effect_MeristReserveOverwatchPoints'.default.OverwatchAbilities;
    CoveringFireEffect.bMatchSourceWeapon = class'X2Effect_ReadyForAnything'.default.bMatchSourceWeapon;
    CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    CoveringFireCondition = new class'X2Condition_AbilityProperty';
    CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
    CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
    Template.AddTargetEffect(CoveringFireEffect);

    if (class'X2Effect_ReadyForAnything'.default.RFA_ACTIVATIONS_PER_TURN > 0)
    {
        ValueCondition = new class'X2Condition_UnitValue';
        ValueCondition.AddCheckValue(class'X2Effect_ReadyForAnything'.default.CounterName, class'X2Effect_ReadyForAnything'.default.RFA_ACTIVATIONS_PER_TURN, eCheck_LessThan);
        Template.AbilityShooterConditions.AddItem(ValueCondition);

        UnitValueEffect = new class'X2Effect_IncrementUnitValue';
        UnitValueEffect.UnitName = class'X2Effect_ReadyForAnything'.default.CounterName;
        UnitValueEffect.NewValueToSet = 1;
        UnitValueEffect.CleanupType = eCleanup_BeginTurn;
        UnitValueEffect.bApplyOnMiss = true;
        Template.AddShooterEffect(UnitValueEffect);
    }

    Template.bSkipFireAction = true;

    Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
    Template.CinescriptCameraType = "Overwatch";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = ReadyForAnything_BuildVisualization;

    return Template;
}

static simulated function ReadyForAnything_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      Context;
    local StateObjectReference              InteractingUnitRef;

    local VisualizationActionMetadata       EmptyTrack;
    local VisualizationActionMetadata       ActionMetadata;

    local X2Action_CameraFrameAbility       FrameAction;
    local X2Action_PlaySoundAndFlyOver      SoundAndFlyOver;
    local X2Action_CameraRemove             RemoveCameraAction;
    local XComGameState_Unit                UnitState;
    local X2AbilityTemplate                 AbilityTemplate;
    local string                            FlyOverText, FlyOverImage;
    local XGUnit                            UnitVisualizer;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = Context.InputContext.SourceObject;

    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    FrameAction = X2Action_CameraFrameAbility(class'X2Action_CameraFrameAbility'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
    FrameAction.AbilitiesToFrame.AddItem(Context);
    FrameAction.CameraTag = 'OverwatchCamera';

    AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);
    FlyOverText = AbilityTemplate.LocFlyOverText;
    FlyOverImage = AbilityTemplate.IconImage;
    if (UnitState != none && UnitState.HasSoldierAbility('CoveringFire'))
    {
        AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('CoveringFire');
        FlyOverText = FlyOverText $ ": " $ AbilityTemplate.LocFriendlyName;
    }
    SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));

    if (UnitState != none)
    {
        UnitVisualizer = XGUnit(UnitState.GetVisualizer());
        if ((UnitVisualizer != none) && !UnitVisualizer.IsMine())
        {
            SoundAndFlyOver.SetSoundAndFlyOverParameters(SoundCue'SoundUI.OverwatchCue', FlyOverText, '', eColor_Bad, FlyOverImage);
        }
        else
        {
            SoundAndFlyOver.SetSoundAndFlyOverParameters(none, FlyOverText, '', eColor_Good, FlyOverImage);
        }
    }

    if (FrameAction != none)
    {
        RemoveCameraAction = X2Action_CameraRemove(class'X2Action_CameraRemove'.static.AddToVisualizationTree(ActionMetaData, Context));
        RemoveCameraAction.CameraTagToRemove = 'OverwatchCamera';
    }
}