class X2AbilitySet_PlayableAliens extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> ViperSpit_Abilities;
var config array<name> GetOverHere_Abilities;
var config array<name> Bind_Abilities;
var config array<name> BindSustained_Abilities;
var config array<name> ViperBite_Abilities;
var config array<name> FrostbiteSpit_AllowedAbilities;
var config array<name> Salamander_AllowedGrenades;
var config array<name> Serpentine_AllowedAbilities;

var privatewrite name SidewinderCooldownEffectName;
var privatewrite name SidewinderEventName;
var privatewrite name SidewinderOriginalGroupValueName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(ViperBash());
    Templates.AddItem(Ambush());
        Templates.AddItem(AmbushTrigger());
    Templates.AddItem(Coil());
        Templates.AddItem(CoilTrigger());
        Templates.AddItem(CoilCleanse());
        Templates.AddItem(CoilHunker());
    Templates.AddItem(Entwine());
    Templates.AddItem(Lockjaw());
        Templates.AddItem(LockjawAttack());
    Templates.AddItem(Rattle());
        Templates.AddItem(RattleTrigger());
    Templates.AddItem(Salamander());
    Templates.AddItem(Sidewinder());
        Templates.AddItem(SidewinderMove());
        Templates.AddItem(SidewinderAddMovementAction());
    Templates.AddItem(Slither());
    Templates.AddItem(ViperBite());
    Templates.AddItem(IronskinBite());
    Templates.AddItem(RegenBite());
    Templates.AddItem(WrongAcidBite());
        Templates.AddItem(WrongAcidBitePanic());
    Templates.AddItem(AngryBite());
        Templates.AddItem(AngryBiteAttack());
    Templates.AddItem(Serpentine());

    Templates.AddItem(PoisonSpit());
        Templates.AddItem(EnhancedPoison());
        Templates.AddItem(BlindingPoison());
        Templates.AddItem(NeuroPoison());
    Templates.AddItem(FrostSpit());
    Templates.AddItem(FrostbiteSpit());
    Templates.AddItem(FrostBreath());

    Templates.AddItem(class'M31_AbilityHelpers'.static.CreateAnimSetPassive('M31_PA_FrostSpit_Anims', "M31_PA_Vipers.Anims.AS_ViperKing"));
    Templates.AddItem(class'M31_AbilityHelpers'.static.CreateAnimSetPassive('M31_PA_ViperBite_Anims', "M31_PA_Vipers.Anims.AS_ViperBite"));
    Templates.AddItem(class'M31_AbilityHelpers'.static.CreateAnimSetPassive('M31_PA_ViperBash_Anims', "Viper_FireAndMeleeAnims.Anims.AS_Viper"));

    return Templates;
}

static function X2AbilityTemplate ViperBash()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_ViperBash');

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
    Template.bHideOnClassUnlock = false;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.bCrossClassEligible = false;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
    Template.bShowActivation = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_ViperBash_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_ViperBash_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.bLimitTargetIcons = true;

    AddAdjacencyCondition(Template);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName); // okay when burning
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); // okay when disoriented
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_ViperBash_Damage");
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bOverrideMeleeDeath = true;

    Template.Hostility = eHostility_Offensive;

    Template.CustomFireAnim = 'FF_MeleeA';
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBash_Anims');

    return Template;
}

static function X2AbilityTemplate Ambush()
{
    local X2AbilityTemplate         Template;

    Template = Passive('M31_PA_Ambush', "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_Ambush_Trigger');

    return Template;
}

static function X2AbilityTemplate AmbushTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_CoveringFire             CoveringFireEffect;
    local X2Condition_AbilityProperty       CoveringFireCondition;

    Template = SelfTargetTrigger('M31_PA_Ambush_Trigger', "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 60;
    Template.AbilityTriggers.AddItem(Trigger);

    AddSuppressedCondition(Template);
    Template.AddShooterEffectExclusions();

    Template.AddTargetEffect(new class'X2Effect_MeristReserveOverwatchPoints');
    CoveringFireEffect = new class'X2Effect_CoveringFire';
    CoveringFireEffect.AbilityToActivate = 'OverwatchShot';
    CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    CoveringFireCondition = new class'X2Condition_AbilityProperty';
    CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
    CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
    Template.AddTargetEffect(CoveringFireEffect);

    Template.BuildVisualizationFn = Ambush_BuildVisualization;
    
    return Template;
}

static simulated function Ambush_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;

    local VisualizationActionMetadata        EmptyTrack;
    local VisualizationActionMetadata        ActionMetadata;

    local XComGameState_Unit            UnitState;
    local X2Action_CameraFrameAbility   FrameAction;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
    local X2Action_CameraRemove         RemoveCameraAction;
    local X2AbilityTemplate             AbilityTemplate;
    local string                        FlyOverText, FlyOverImage;

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
    if (UnitState != none)
    {
        AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);
        FlyOverImage = AbilityTemplate.IconImage;
        FlyOverText = AbilityTemplate.LocFlyOverText;
        if (UnitState.HasSoldierAbility('CoveringFire', true))
        {
            FlyOverText = FlyOverText $ `GetLocalizedString("M31_CoveringFire_FlyoverText");
        }

        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(none, FlyOverText, 'Overwatch', eColor_Good, FlyOverImage);
    }

    if (FrameAction != none)
    {
        RemoveCameraAction = X2Action_CameraRemove(class'X2Action_CameraRemove'.static.AddToVisualizationTree(ActionMetaData, Context));
        RemoveCameraAction.CameraTagToRemove = 'OverwatchCamera';
    }
}

static function X2AbilityTemplate Coil()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitEffects           EffectsCondition;
    // local array<name>                       SkipExclusions;
    local X2Effect_CoilHunker               HunkerDownEffect;
    
    Template = SelfTargetActivated('M31_PA_Coil', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY;

    Template.Hostility = eHostility_Defensive;
    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;
    Template.bSkipFireAction = false;

    AddCooldown(Template, `GetConfigInt("M31_PA_Coil_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    EffectsCondition = new class'X2Condition_UnitEffects';
    EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(EffectsCondition);
    
    // SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    // SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    // Template.AddShooterEffectExclusions(SkipExclusions);

    HunkerDownEffect = new class'X2Effect_CoilHunker';
    HunkerDownEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
    HunkerDownEffect.EffectRemovedFn = Coil_EffectRemoved;
    Template.AddTargetEffect(HunkerDownEffect);

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_Coil_Trigger');
    Template.AdditionalAbilities.AddItem('M31_PA_Coil_Cleanse');
    Template.AdditionalAbilities.AddItem('M31_PA_Coil_Hunker');

    return Template;
}

static function Coil_EffectRemoved(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (UnitState != none)
    {
        `XEVENTMGR.TriggerEvent('M31_PA_Coil_EffectRemoved', UnitState, UnitState, NewGameState);
    }
}

static function X2AbilityTemplate CoilTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_Coil                     CoilEffect;
    
    Template = SelfTargetTrigger('M31_PA_Coil_Trigger', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_PA_Coil_EffectRemoved';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    // This is a hack. Overdrive effect's name is patched into most abilities as non-turn ending by Firaxis.
    CoilEffect = new class'X2Effect_Coil';
    CoilEffect.EffectName = 'DLC_3Overdrive'; 
    CoilEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
    CoilEffect.SetDisplayInfo(ePerkBuff_Bonus, `GetLocalizedString("M31_PA_Coil_FriendlyName"), `GetLocalizedString("M31_PA_Coil_BonusText"), Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(CoilEffect);

    return Template;
}

static function X2AbilityTemplate CoilCleanse()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_RemoveEffects            RemoveEffects;

    Template = SelfTargetTrigger('M31_PA_Coil_Cleanse', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = CoilCleanseListener;
    Template.AbilityTriggers.AddItem(Trigger);

    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove.AddItem('DLC_3Overdrive');
    Template.AddTargetEffect(RemoveEffects);

    return Template;
}

static function EventListenerReturn CoilCleanseListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Ability             CoilCleanseAbilityState;
    local XComGameState_Ability             AbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local XComGameStateContext_Ability      AbilityContext;
    local X2AbilityCost                     AbilityCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local bool                              bHasActionPointCost;

    SourceUnit = XComGameState_Unit(EventSource);
    CoilCleanseAbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    AbilityState = XComGameState_Ability(EventData);
    AbilityTemplate = AbilityState.GetMyTemplate();

    if (SourceUnit == none || CoilCleanseAbilityState == none || AbilityState == none || AbilityTemplate == none)
        return ELR_NoInterrupt;

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        if (CoilCleanseAbilityState.OwnerStateObject.ObjectID == SourceUnit.ObjectID)
        {
            if (AbilityState.IsAbilityInputTriggered())
            {
                foreach AbilityTemplate.AbilityCosts(AbilityCost)
                {
                    ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
                    if (ActionPointCost != none)
                    {
                        if ((ActionPointCost.iNumPoints > 0 || ActionPointCost.bAddWeaponTypicalCost) && !ActionPointCost.bFreeCost)
                        {
                            bHasActionPointCost = true;
                            break;
                        }
                    }
                }
                if (bHasActionPointCost)
                {
                    return CoilCleanseAbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate CoilHunker()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitEffects           EffectsCondition;
    local array<name>                       SkipExclusions;
    local X2AbilityCost_ActionPoints        ActionPointsCost;
    local X2Effect_CoilHunker               HunkerDownEffect;
    local X2Effect_RemoveEffects            RemoveEffects;
    
    Template = SelfTargetActivated('M31_PA_Coil_Hunker', "img:///UILibrary_PerkIcons.UIPerk_takecover");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY + 1;

    Template.Hostility = eHostility_Defensive;
    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;
    Template.bSkipFireAction = false;

    ActionPointsCost = ActionPointCost(eCost_SingleConsumeAll);
    if (`GetConfigBool("M31_PA_Coil_Hunker_bAllowDeepCover"))
        ActionPointsCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
    Template.AbilityCosts.AddItem(ActionPointsCost);

    EffectsCondition = new class'X2Condition_UnitEffects';
    EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(EffectsCondition);
    
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove.AddItem('DLC_3Overdrive');
    Template.AddTargetEffect(RemoveEffects);

    HunkerDownEffect = new class'X2Effect_CoilHunker';
    HunkerDownEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
    Template.AddTargetEffect(HunkerDownEffect);

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate Entwine()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Entwine      Effect;

    Template = Passive('M31_PA_Entwine', "img:///UILibrary_PerkIcons.UIPerk_viper_bind", false, false);
    
    Effect = new class'X2Effect_Entwine';
    Effect.EffectName = 'M31_PA_Entwine';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Lockjaw()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_PA_Lockjaw', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_Lockjaw_Attack');

    return Template;
}

static function X2AbilityTemplate LockjawAttack()
{
    local X2AbilityTemplate                         Template;
    local X2AbilityToHitCalc_StandardMelee          ToHitCalc;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_Visibility                    VisibilityCondition;
    local X2Condition_UnitProperty                  UnitPropertyCondition;
    local X2AbilityCooldown_Extended                Cooldown;

    Template = StandardMelee('M31_PA_Lockjaw_Attack', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_Lockjaw;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    AddAdjacencyCondition(Template);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_Lockjaw_Cooldown");
    Cooldown.bApplyOnlyOnHit = true;
    Template.AbilityCooldown = Cooldown;

    AddBladestormMark(Template, 'M31_PA_Lockjaw_MarkTarget');
    AddSuppressedCondition(Template);

    class'M31_AbilityHelpers'.static.AddEnhancedPoisonEffectToTarget(Template);
    class'M31_AbilityHelpers'.static.AddBlindingPoisonEffectToTarget(Template);

    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false));
    Template.AddTargetEffect(CreateLockjawDamageEffect());

    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2Effect_ApplyDamageWithRank CreateLockjawDamageEffect()
{
    local X2Effect_ApplyDamageWithRank PhysicalDamageEffect;

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_Lockjaw_Damage");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_Lockjaw_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_Lockjaw_CritDamagePerRank");

    return PhysicalDamageEffect;
}

static function EventListenerReturn AbilityTriggerEventListener_Lockjaw(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameState_Unit SourceUnit;
    local XComGameState_Ability AbilityState;
    local XComGameStateContext_Ability AbilityContext;

    SourceUnit = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(CallbackData);

    if (SourceUnit != none && AbilityState != none)
    {
        AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
        if (AbilityContext != none && AbilityContext.InputContext.SourceObject == SourceUnit.ConcealmentBrokenByUnitRef)
        {
            AbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.ConcealmentBrokenByUnitRef, false);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate Rattle()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_Rattle', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_harborwave", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_Rattle_Trigger');

    return Template;
}

static function X2AbilityTemplate RattleTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityToHitCalc_PercentChance  PercentChanceToHit;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_TargetCanSeeSource    VisibilityCondition;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Panicked                 PanickedEffect;

    Template = SelfTargetTrigger('M31_PA_Rattle_Trigger', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_harborwave");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_UnitSeesUnit;
    Template.AbilityTriggers.AddItem(Trigger);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `GetConfigFloat("M31_PA_Rattle_PanicRange");
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    VisibilityCondition = new class'X2Condition_TargetCanSeeSource';
    VisibilityCondition.bRequireLOS = true;
    VisibilityCondition.bRequireGameplayVisible = true;
    Template.AbilityMultiTargetConditions.AddItem(VisibilityCondition);

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Mental');
    UnitImmunityCondition.AddExcludeDamageType('Panic');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    PercentChanceToHit = new class'X2AbilityToHitCalc_PercentChance';
    PercentChanceToHit.PercentToHit = `GetConfigInt("M31_PA_Rattle_PanicChance");
    Template.AbilityToHitCalc = PercentChanceToHit;

    PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
    Template.AddMultiTargetEffect(PanickedEffect);

    AddUnitValueCondition(Template, 'M31_PA_Rattle_Counter', `GetConfigInt("M31_PA_Rattle_ActivationsPerTurn"));

    Template.bShowActivation = true;

    Template.ModifyNewContextFn = Rattle_ModifyActivatedAbilityContext;

    return Template;
}

static private function Rattle_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
    local XComGameStateContext_Ability AbilityContext;
    local int Counter, MaxCount;
    local int Index;

    AbilityContext = XComGameStateContext_Ability(Context);

    MaxCount = `GetConfigInt("M31_PA_Rattle_MaxTargets");

    for (Index = 0; Index < AbilityContext.ResultContext.MultiTargetHitResults.Length; Index++)
    {
        if (AbilityContext.ResultContext.MultiTargetHitResults[Index] == eHit_Success)
        {
            if (Counter < MaxCount)
            {
                Counter++;
            }
            else
            {
                AbilityContext.ResultContext.MultiTargetHitResults[Index] = eHit_Miss;
            }
        }
    }
}

static function X2AbilityTemplate Salamander()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_DamageImmunityByTypes    ImmunityEffect;
    local XMBEffect_BonusRadius             RadiusEffect;
    local X2Effect_AddGrenade               FreeGrenadeEffect;

    Template = Passive('M31_PA_Salamander', "img:///UILibrary_MPP.fireshield", false, true);

    ImmunityEffect = new class'X2Effect_DamageImmunityByTypes';
    ImmunityEffect.EffectName = 'M31_PA_Salamander_Immunity';
    ImmunityEffect.DamageImmunities.AddItem('Fire');
    ImmunityEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(ImmunityEffect);

    RadiusEffect = new class'XMBEffect_BonusRadius';
    RadiusEffect.EffectName = 'M31_PA_Salamander_Radius';
    RadiusEffect.fBonusRadius = `GetConfigInt("M31_PA_Salamander_RadiusBonus");
    RadiusEffect.IncludeItemNames = default.Salamander_AllowedGrenades;
    RadiusEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(RadiusEffect);

    FreeGrenadeEffect = new class'X2Effect_AddGrenade';
    FreeGrenadeEffect.bAllowUpgrades = true;
    FreeGrenadeEffect.DataName = 'Firebomb';
    FreeGrenadeEffect.SkipAbilities.AddItem('SmallItemWeight');
    FreeGrenadeEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(FreeGrenadeEffect);
    
    return Template;
}

static function X2AbilityTemplate Sidewinder()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Sidewinder               Effect;

    Template = Passive('M31_PA_Sidewinder', "img:///UILibrary_PerkIcons.UIPerk_Shadowstrike", false, true);
    
    Effect = new class'X2Effect_Sidewinder';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_Sidewinder_Move');
    if (!`GetConfigBool("M31_PA_Sidewinder_bOnlyOnEnemyTurn"))
        Template.AdditionalAbilities.AddItem('M31_PA_Sidewinder_AddMovementAction');

    return Template;
}

static function X2AbilityTemplate SidewinderMove()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local array<name>                       SkipExclusions;
    local X2Effect_Sidewinder_Move          InterruptTurnEffect;
    local X2Effect_Persistent               CooldownEffect;
    
    Template = SelfTargetTrigger('M31_PA_Sidewinder_Move', "img:///UILibrary_PerkIcons.UIPerk_Shadowstrike");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.SidewinderEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 50;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_SidewinderMove;
    Template.AbilityTriggers.AddItem(Trigger);

    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    InterruptTurnEffect = new class'X2Effect_Sidewinder_Move';
    InterruptTurnEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(InterruptTurnEffect);

    CooldownEffect = new class'X2Effect_Persistent';
    CooldownEffect.EffectName = default.SidewinderCooldownEffectName;
    CooldownEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Sidewinder_Cooldown"), false, true, false, eGameRule_PlayerTurnBegin);
    CooldownEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_PA_Sidewinder_CooldownText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(CooldownEffect);

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_SidewinderMove(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit            SourceUnit;
    local XComGameState                 NewGameState;
    local XComGameState_Ability         AbilityState;

    AbilityState = XComGameState_Ability(CallbackData);
    SourceUnit = XComGameState_Unit(EventSource);

    `assert(SourceUnit != none);

    if (`TACTICALRULES.GetUnitActionTeam() == SourceUnit.GetTeam())
        return ELR_NoInterrupt;

    if (AbilityState.CanActivateAbilityForObserverEvent(SourceUnit) == 'AA_Success')
    {
        if (AbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false))
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.ObjectID));
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Viper Interrupt Initiative");
            `TACTICALRULES.InterruptInitiativeTurn(NewGameState, SourceUnit.GetGroupMembership().GetReference());
            `TACTICALRULES.SubmitGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate SidewinderAddMovementAction()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local array<name>                       SkipExclusions;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Effect_Persistent               CooldownEffect;
    
    Template = SelfTargetTrigger('M31_PA_Sidewinder_AddMovementAction', "img:///UILibrary_PerkIcons.UIPerk_Shadowstrike");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.SidewinderEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 55;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(new class'X2Condition_ItsOwnTurn');

    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeStunned = true;
    UnitPropertyCondition.ExcludePanicked = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddTargetEffect(ActionPointEffect);

    CooldownEffect = new class'X2Effect_Persistent';
    CooldownEffect.EffectName = default.SidewinderCooldownEffectName;
    CooldownEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Sidewinder_Cooldown"), false, true, false, eGameRule_PlayerTurnBegin);
    CooldownEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_PA_Sidewinder_CooldownText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(CooldownEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate Slither()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCooldown                 Cooldown;
    local X2Effect_PersistentStatChange     SlitherEffect;
    
    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_Slither');

    Template.AbilitySourceName = 'eAbilitySource_Perk';

    Template.IconImage = "img:///UILibrary_PlayableAdvent.Viper_Slither";
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    SlitherEffect = new class'X2Effect_PersistentStatChange';
    SlitherEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Slither_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    SlitherEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, , , Template.AbilitySourceName);
    SlitherEffect.AddPersistentStatChange(eStat_Mobility, `GetConfigInt("M31_PA_Slither_MobilityBonus"));
    SlitherEffect.AddPersistentStatChange(eStat_Defense, `GetConfigInt("M31_PA_Slither_DefenseBonus"));
    SlitherEffect.AddPersistentStatChange(eStat_Dodge, `GetConfigInt("M31_PA_Slither_DodgeBonus"));
    Template.AddTargetEffect(SlitherEffect);

    Template.AbilityCosts.AddItem(default.FreeActionCost);
    
    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_Slither_Cooldown");
    Template.AbilityCooldown = Cooldown;

    Template.bCrossClassEligible = false;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.bShowActivation = true;
    Template.bSkipFireAction = true;

    // Template.CustomFireAnim = 'HR_FlinchA';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

static function X2AbilityTemplate ViperBite()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Effect_ApplyDamageWithRank      PhysicalDamageEffect;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_ViperBite');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    Template.bCrossClassEligible = false;

    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PA_ViperBite_Cooldown"));

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_ViperBite_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_ViperBite_CritBonus");
    StandardMelee.bAllowCrit = `GetConfigBool("M31_PA_ViperBite_bAllowCrit");
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    // Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeRobotic = true;
    Template.AbilityTargetConditions.AddItem(UnitPropCondition);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    
    class'M31_AbilityHelpers'.static.AddEnhancedPoisonEffectToTarget(Template);
    class'M31_AbilityHelpers'.static.AddBlindingPoisonEffectToTarget(Template);

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_ViperBite_Damage");
    PhysicalDamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_PA_ViperBite_Rupture");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_ViperBite_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_ViperBite_CritDamagePerRank");
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.bSkipMoveStop = true;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bOverrideMeleeDeath = false;

    Template.CustomFireAnim = 'HL_M31_ViciousBite';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2AbilityTemplate IronskinBite()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_RemoveEffects            RemoveEffect;
    local X2Effect_PersonalShield           Effect;

    Template = SelfTargetActivated('M31_PA_IronskinBite', "img:///UILibrary_MeristPerkIcons.UIPerk_ShieldBite", false);

    Template.Hostility = eHostility_Defensive;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.bLimitTargetIcons = true;

    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_PA_IronskinBite_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_IronskinBite_Charges"));

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 144;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    if (!`GetConfigBool("M31_PA_ViperBite_bCanTargetVipers"))
        Template.AbilityTargetConditions.AddItem(class'X2Condition_Viper'.static.NotViperCondition());

    RemoveEffect = new class'X2Effect_RemoveEffects';
    RemoveEffect.EffectNamesToRemove.AddItem('M31_PA_IronskinBite_Buff');
    RemoveEffect.bDoNotVisualize = true;
    Template.AddTargetEffect(RemoveEffect);

    Effect = new class'X2Effect_PersonalShield';
    Effect.EffectName = 'M31_PA_IronskinBite_Buff';
    Effect.ShieldAmountBase = `GetConfigInt("M31_PA_IronskinBite_ShieldAmount");
    Effect.ShieldPriority = `GetConfigInt("M31_PA_IronskinBite_ShieldPriority");
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_IronskinBite_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Shield_BonusText"), Template.IconImage,, , Template.AbilitySourceName);
    Effect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(Effect);

    Template.bSkipFireAction = false;
    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');
    
    return Template;
}

static function X2AbilityTemplate RegenBite()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitStatCheck         UnitStatCheckCondition;
    local X2Effect_Regeneration             RegenerationEffect;
    local X2Effect_DamageImmunity           DamageImmunity;
    local X2Condition_UnitEffectsOnSource   EffectCondition;
    local X2Condition_UnitEffectsOnSource   EnhEffectCondition;
    local X2Effect_RemoveEffects            RemoveEffects;
    local X2Effect_Persistent               UnconsciousEffect;

    Template = SelfTargetActivated('M31_PA_RegenBite', "img:///UILibrary_MeristPerkIcons.UIPerk_RegenBite", false);

    Template.Hostility = eHostility_Defensive;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.bLimitTargetIcons = true;

    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_PA_RegenBite_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_RegenBite_Charges"));

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeDead = !`GetConfigBool("M31_PA_RegenBite_bStabilize");
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 144;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    if (!`GetConfigBool("M31_PA_ViperBite_bCanTargetVipers"))
        Template.AbilityTargetConditions.AddItem(class'X2Condition_Viper'.static.NotViperCondition());

    UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
    UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
    Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');

    RegenerationEffect = new class'X2Effect_Regeneration';
    RegenerationEffect.HealAmount = `GetConfigInt("M31_PA_RegenBite_HealPerTurn");
    RegenerationEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_RegenBite_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    RegenerationEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_PA_RegenBite_BuffText"), Template.IconImage, true, , Template.AbilitySourceName);
    RegenerationEffect.TargetConditions.AddItem(EffectCondition);
    RegenerationEffect.bRemoveWhenTargetDies = true;
    RegenerationEffect.bTickWhenApplied = true;
    Template.AddTargetEffect(RegenerationEffect);

    EnhEffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EnhEffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');

    RegenerationEffect = new class'X2Effect_Regeneration';
    RegenerationEffect.HealAmount = `GetConfigInt("M31_PA_RegenBite_EnhHealPerTurn");
    RegenerationEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_RegenBite_EnhDuration"), false, false, false, eGameRule_PlayerTurnBegin);
    RegenerationEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_PA_RegenBite_EnhBuffText"), Template.IconImage, true, , Template.AbilitySourceName);
    RegenerationEffect.TargetConditions.AddItem(EnhEffectCondition);
    RegenerationEffect.bRemoveWhenTargetDies = true;
    RegenerationEffect.bTickWhenApplied = true;
    Template.AddTargetEffect(RegenerationEffect);

    if (`GetConfigBool("M31_PA_RegenBite_bRemovePoison"))
    {
        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.PoisonedName);
        Template.AddTargetEffect(RemoveEffects);

        if (`GetConfigBool("M31_PA_RegenBite_bProvidesPoisonImmunity"))
        {
            DamageImmunity = new class'X2Effect_DamageImmunity';
            DamageImmunity.ImmuneTypes.AddItem('Poison');
            DamageImmunity.BuildPersistentEffect(`GetConfigInt("M31_PA_RegenBite_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
            DamageImmunity.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_PA_RegenBite_ImmunityBuffText"), Template.IconImage, true, , Template.AbilitySourceName);
            DamageImmunity.TargetConditions.AddItem(EffectCondition);
            Template.AddTargetEffect(DamageImmunity);

            DamageImmunity = new class'X2Effect_DamageImmunity';
            DamageImmunity.ImmuneTypes.AddItem('Poison');
            DamageImmunity.BuildPersistentEffect(`GetConfigInt("M31_PA_RegenBite_EnhDuration"), false, false, false, eGameRule_PlayerTurnBegin);
            DamageImmunity.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_PA_RegenBite_ImmunityBuffText"), Template.IconImage, true, , Template.AbilitySourceName);
            DamageImmunity.TargetConditions.AddItem(EnhEffectCondition);
            Template.AddTargetEffect(DamageImmunity);

        }
    }

    if (`GetConfigBool("M31_PA_RegenBite_bStabilize"))
    {
        UnitPropertyCondition = new class'X2Condition_UnitProperty';
        UnitPropertyCondition.ExcludeAlive = true;
        UnitPropertyCondition.ExcludeDead = false;
        UnitPropertyCondition.ExcludeHostileToSource = true;
        UnitPropertyCondition.ExcludeFriendlyToSource = false;
        UnitPropertyCondition.FailOnNonUnits = true;

        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
        RemoveEffects.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddTargetEffect(RemoveEffects);

        UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
        UnconsciousEffect.TargetConditions.AddItem(UnitPropertyCondition);
        Template.AddTargetEffect(UnconsciousEffect);
    }

    Template.bSkipFireAction = false;
    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');
    
    return Template;
}

static function X2AbilityTemplate WrongAcidBite()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitProperty          FriendlyCondition;
    local X2Condition_UnitProperty          HostileCondition;
    local X2Effect_DamageImmunity           SteadfastEffect;
    local X2Effect_Persistent               DisorientedEffect;
    local X2Effect_ImmediateAbilityActivation PanicAbilityEffect;
    local X2Effect_Persistent               BleedingEffect;
    local X2Effect_Persistent               PoisonedEffect;
    local X2Effect_Burning                  AcidBurningEffect;
    local X2Effect_Radiation                RadiationEffect;
    local X2Effect_PersistentStatChange     StatChangeEffect;
    local X2Effect_ApplyWeaponDamage        DamageEffect;

    Template = SelfTargetActivated('M31_PA_MemeBite', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false);

    Template.Hostility = eHostility_Neutral;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.bLimitTargetIcons = true;

    Template.AddShooterEffectExclusions();

    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_PA_MemeBite_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_MemeBite_Charges"));

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 144;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    FriendlyCondition = new class'X2Condition_UnitProperty';
    FriendlyCondition.ExcludeHostileToSource = true;
    FriendlyCondition.ExcludeFriendlyToSource = false;
    FriendlyCondition.FailOnNonUnits = true;

    HostileCondition = new class'X2Condition_UnitProperty';
    HostileCondition.ExcludeHostileToSource = false;
    HostileCondition.ExcludeFriendlyToSource = true;
    HostileCondition.FailOnNonUnits = true;

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_MemeBite_Dam");
    DamageEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(DamageEffect);

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
    DisorientedEffect.iNumTurns = `GetConfigInt("M31_PA_MemeBite_H");
    DisorientedEffect.bRemoveWhenSourceDies = false;
    DisorientedEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(DisorientedEffect);

    AcidBurningEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(3, 1);
    AcidBurningEffect.iNumTurns = `GetConfigInt("M31_PA_MemeBite_H");
    AcidBurningEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(AcidBurningEffect);

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
    PoisonedEffect.iNumTurns = `GetConfigInt("M31_PA_MemeBite_H");
    PoisonedEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(PoisonedEffect);

    BleedingEffect = class'M31_AbilityHelpers'.static.CreateBleedingStatusEffect(`GetConfigInt("M31_PA_MemeBite_H"), 3, 0);
    BleedingEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(BleedingEffect);
    
    RadiationEffect = class'X2StatusEffects_Radiation'.static.CreateRadBleedingStatusEffect(100, 3, 2);
    RadiationEffect.iNumTurns = `GetConfigInt("M31_PA_MemeBite_H");
    RadiationEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(RadiationEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_PA_MemeBite_G");
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = true;

    StatChangeEffect = new class'X2Effect_PersistentStatChange';
    StatChangeEffect.AddPersistentStatChange(eStat_Offense, `GetConfigInt("M31_PA_MemeBite_A"));
    StatChangeEffect.AddPersistentStatChange(eStat_CritChance, `GetConfigInt("M31_PA_MemeBite_I"));
    StatChangeEffect.AddPersistentStatChange(eStat_Mobility, `GetConfigInt("M31_PA_MemeBite_B"));
    StatChangeEffect.AddPersistentStatChange(eStat_Will, `GetConfigInt("M31_PA_MemeBite_C"));
    StatChangeEffect.AddPersistentStatChange(eStat_Dodge, `GetConfigInt("M31_PA_MemeBite_D"));
    StatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_MemeBite_E"), false, false, false, eGameRule_PlayerTurnEnd);
    StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_PA_MemeBite_BuffText"), Template.IconImage, true, , Template.AbilitySourceName);
    StatChangeEffect.ApplyOnTick.AddItem(DamageEffect);
    StatChangeEffect.TargetConditions.AddItem(FriendlyCondition);
    StatChangeEffect.bRemoveWhenTargetDies = true;
    Template.AddTargetEffect(StatChangeEffect);

    AcidBurningEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(0, 0);
    AcidBurningEffect.DamageTypes.Length = 0;
    AcidBurningEffect.iNumTurns = `GetConfigInt("M31_PA_MemeBite_E");
    AcidBurningEffect.TargetConditions.AddItem(FriendlyCondition);
    Template.AddTargetEffect(AcidBurningEffect);

    PanicAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
    PanicAbilityEffect.ApplyChance = `GetConfigInt("M31_PA_MemeBite_F");
    PanicAbilityEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    PanicAbilityEffect.EffectName = 'M31_PA_MemeBite_ImmediatePanic';
    PanicAbilityEffect.AbilityName = 'M31_PA_MemeBite_Panic';
    PanicAbilityEffect.TargetConditions.AddItem(FriendlyCondition);
    Template.AddTargetEffect(PanicAbilityEffect);

    SteadfastEffect = new class'X2Effect_DamageImmunity';
    SteadfastEffect.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.DisorientDamageType);
    SteadfastEffect.ImmuneTypes.AddItem('Stun');
    SteadfastEffect.ImmuneTypes.AddItem('Unconscious');
    SteadfastEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_MemeBite_E"), false, false, false, eGameRule_PlayerTurnEnd);
    SteadfastEffect.bRemoveWhenTargetDies = true;
    SteadfastEffect.TargetConditions.AddItem(FriendlyCondition);
    Template.AddTargetEffect(SteadfastEffect);

    Template.bSkipFireAction = false;
    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
    
    Template.AdditionalAbilities.AddItem('M31_PA_MemeBite_Panic');
    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2AbilityTemplate WrongAcidBitePanic()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_IRI_Berserk              PanickedEffect;
    local X2Effect_IRI_Berserk_ActionPoints	ActionPointsEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_MemeBite_Panic');

    Template.IconImage = "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite";
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityToHitCalc = default.DeadEye;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Template.bAllowAmmoEffects = false;
    Template.bAllowBonusWeaponEffects = false;
    Template.bAllowFreeFireWeaponUpgrade = false;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    Template.FrameAbilityCameraType = eCameraFraming_Never; 
    Template.bSkipExitCoverWhenFiring = true;
    Template.bSkipFireAction = true;
    Template.bShowActivation = false;
    Template.bUsesFiringCamera = false;

    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.MergeVisualizationFn = class'M31_AbilityHelpers'.static.FollowUpShot_MergeVisualization;
    Template.BuildInterruptGameStateFn = none;
    Template.bCrossClassEligible = false;

    ActionPointsEffect = new class'X2Effect_IRI_Berserk_ActionPoints';
    ActionPointsEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(ActionPointsEffect);

    PanickedEffect = new class'X2Effect_IRI_Berserk';
    PanickedEffect.EffectName = 'IRI_Berserk_Effect';
    PanickedEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    PanickedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.PANICKED_HIERARCHY_VALUE;
    PanickedEffect.EffectAppliedEventName = 'PanickedEffectApplied';
    Template.AddTargetEffect(PanickedEffect);

    return Template;
}

static function X2AbilityTemplate AngryBite()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_PA_AngryBite', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_AngryBite_Attack');

    return Template;
}

static function X2AbilityTemplate AngryBiteAttack()
{
    local X2AbilityTemplate                         Template;
    local X2AbilityToHitCalc_StandardMelee          ToHitCalc;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_Visibility                    VisibilityCondition;
    local X2Condition_UnitProperty                  UnitPropertyCondition;
    local X2AbilityCooldown_Extended                Cooldown;

    Template = StandardMelee('M31_PA_AngryBite_Attack', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_AngryBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_AngryBite_CritBonus");
    ToHitCalc.bAllowCrit = `GetConfigBool("M31_PA_AngryBite_bAllowCrit");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_Lockjaw;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    AddAdjacencyCondition(Template);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    if (`GetConfigBool("M31_PA_AngryBite_bHasCooldown"))
    {
        Cooldown = new class'X2AbilityCooldown_Extended';
        Cooldown.iNumTurns = `GetConfigInt("M31_PA_AngryBite_Cooldown");
        Cooldown.bApplyOnlyOnHit = `GetConfigBool("M31_PA_AngryBite_bCooldownOnlyOnHit");
        Template.AbilityCooldown = Cooldown;
    }

    AddBladestormMark(Template, 'M31_PA_AngryBite_MarkTarget');
    AddSuppressedCondition(Template);

    Template.AddTargetEffect(CreateAngryBiteDamageEffect());

    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');
 
    return Template;
}

static function X2Effect_ApplyDamageWithRank CreateAngryBiteDamageEffect()
{
    local X2Effect_ApplyDamageWithRank PhysicalDamageEffect;

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_AngryBite_Damage");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_AngryBite_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_AngryBite_CritDamagePerRank");

    return PhysicalDamageEffect;
}

static function X2AbilityTemplate Serpentine()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_RefundActionCost         Effect;
    
    Template = Passive('M31_PA_Serpentine', "img:///UILibrary_MZChimeraIcons.Ability_BindRelease", false, true);

    Effect = new class'X2Effect_RefundActionCost';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_PA_Serpentine_ActivationsPerTurn");
    Effect.AllowedAbilities = default.Serpentine_AllowedAbilities;
    Effect.CounterName = 'M31_PA_Serpentine';;
    Effect.EventName = 'M31_PA_Serpentine';
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Effect.BuildPersistentEffect(1, true, false);
    
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate PoisonSpit()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCooldown_Extended        Cooldown;
    local X2Effect_ApplyDamageWithRank      DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_PoisonSpit', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit");

    X2AbilityMultiTarget_Cylinder(Template.AbilityMultiTargetStyle).fTargetRadius = `GetConfigFloat("M31_PA_PoisonSpit_Radius");

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    AddActionPointCost(Template, eCost_Single);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_PoisonSpit_Cooldown");
    Cooldown.AddCooldownModifier('M31_PA_NeuroPoison', -1 * `GetConfigInt("M31_PA_NeuroPoison_CooldownReduction"));
    Template.AbilityCooldown = Cooldown;

    class'M31_AbilityHelpers'.static.AddEnhancedPoisonEffectToMultiTarget(Template);
    class'M31_AbilityHelpers'.static.AddBlindingPoisonEffectToMultiTarget(Template);

    if (`GetConfigBool("M31_PA_PoisonSpit_bDealsDamage"))
    {
        DamageEffect = new class'X2Effect_ApplyDamageWithRank';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_PoisonSpit_Damage");
        DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_PoisonSpit_DamagePerRank");
        Template.AddMultiTargetEffect(DamageEffect);
    }

    if (`GetConfigBool("M31_PA_PoisonSpit_bAppliesPoisonToWorld"))
    {
        Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');
    }

    Template.CustomFireAnim = 'HL_PoisonSpit';

    return Template;
}

static function X2AbilityTemplate EnhancedPoison()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   Effect;

    Template = Passive('M31_PA_EnhancedPoison', "img:///UILibrary_XPerkIconPack.UIPerk_poison_plus", false, false);
    
    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_PA_EnhancedPoison_Valid';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BlindingPoison()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   Effect;

    Template = Passive('M31_PA_BlindingPoison', "UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist", false, false);
    
    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_PA_BlindingPoison_Valid';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate NeuroPoison()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_NeuroPoison', "img:///UILibrary_PerkIcons.UIPerk_insanity", false, true);

    return Template;
}

static function X2AbilityTemplate FrostSpit()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCooldown                 Cooldown;
    local X2Effect_ApplyDamageWithRank      DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_FrostSpit', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit");

    X2AbilityMultiTarget_Cylinder(Template.AbilityMultiTargetStyle).fTargetRadius = `GetConfigFloat("M31_PA_FrostSpit_Radius");

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Frost');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    AddActionPointCost(Template, eCost_Single);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_FrostSpit_Cooldown");
    Template.AbilityCooldown = Cooldown;

    class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

    DamageEffect = new class'X2Effect_ApplyDamageWithRank';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_FrostSpit_Damage");
    DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_FrostSpit_DamagePerRank");
    Template.AddMultiTargetEffect(DamageEffect);

    Template.CustomFireAnim = 'HL_M31_FrostBite';

    Template.AdditionalAbilities.AddItem('M31_PA_FrostSpit_Anims');
    
    return Template;
}

static function X2AbilityTemplate FrostbiteSpit()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_FrostbiteSpit     Effect;

    Template = Passive('M31_PA_FrostbiteSpit', "img:///UILibrary_SODragoon.UIPerk_overkill", false, true);
    
    Effect = new class'X2Effect_PA_FrostbiteSpit';
    Effect.EffectName = 'M31_PA_FrostbiteSpit';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_PA_FrostSpit');

    return Template;
}

static function X2AbilityTemplate FrostBreath()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCooldown                 Cooldown;
    local X2Effect_ApplyDamageWithRank      DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_FrostBreath', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 1;

    X2AbilityMultiTarget_Cylinder(Template.AbilityMultiTargetStyle).fTargetRadius = `GetConfigFloat("M31_PA_FrostBreath_Radius");

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Frost');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    AddActionPointCost(Template, eCost_Single);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_FrostBreath_Cooldown");
    Template.AbilityCooldown = Cooldown;

    AddCharges(Template, `GetConfigInt("M31_PA_FrostBreath_Charges"));

    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeEffect(false));
    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeCleanse(false));

    if (`GetConfigBool("M31_PA_FrostBreath_bDealsDamage"))
    {
        DamageEffect = new class'X2Effect_ApplyDamageWithRank';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_FrostBreath_Damage");
        DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_FrostBreath_DamagePerRank");
        Template.AddMultiTargetEffect(DamageEffect);
    }

    Template.CustomFireAnim = 'HL_M31_FrostBite';

    Template.AdditionalAbilities.AddItem('M31_PA_FrostSpit_Anims');

    return Template;
}

static function X2AbilityTemplate CreateViperSpitAbility(
    name DataName,
    string IconImage)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_Cylinder     CylinderMultiTarget;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.AbilitySourceName = 'eAbilitySource_Standard'; 
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    CylinderMultiTarget = new class'X2AbilityMultiTarget_Cylinder';
    CylinderMultiTarget.bUseWeaponRadius = false;
    CylinderMultiTarget.fTargetRadius = 2.5;
    CylinderMultiTarget.fTargetHeight = `GetConfigFloat("M31_PA_ViperSpit_Height");
    CylinderMultiTarget.bUseOnlyGroundTiles = true;
    Template.AbilityMultiTargetStyle = CylinderMultiTarget;

    Template.TargetingMethod = class'X2TargetingMethod_ViperSpit';

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    CursorTarget = new class'X2AbilityTarget_Cursor';
    // CursorTarget.bRestrictToWeaponRange = true;
    CursorTarget.bRestrictToSquadsightRange = `GetConfigBool("M31_PA_Spit_bRequireVisibility");
    CursorTarget.FixedAbilityRange = `TILESTOMETERS(`GetConfigInt("M31_PA_ViperSpit_Range"));
    Template.AbilityTargetStyle = CursorTarget;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    Template.CinescriptCameraType = "_PoisonSpit";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = false;
    Template.bUseAmmoAsChargesForHUD = false;

    Template.bCrossClassEligible = false;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

defaultproperties
{
    SidewinderCooldownEffectName = M31_PA_Sidewinder_Cooldown
    SidewinderEventName = M31_PA_Sidewinder_Trigger
    SidewinderOriginalGroupValueName = M31_Sidewinder_OriginalGroupValueName
}