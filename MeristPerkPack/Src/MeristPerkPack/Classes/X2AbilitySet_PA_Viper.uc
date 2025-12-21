class X2AbilitySet_PA_Viper extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> ViperSpit_Abilities;
var config array<name> GetOverHere_Abilities;
var config array<name> Bind_Abilities;
var config array<name> BindSustained_Abilities;
var config array<name> ViperBite_Abilities;
var config array<name> FrostbiteSpit_AllowedAbilities;
var config array<name> Salamander_AllowedGrenades;
var config array<name> Serpentine_AllowedAbilities;

var privatewrite name EnhancedPoisonAbilityName;

var localized string MemeBite_BuffText;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Ambush());
    /*>>*/Templates.AddItem(AmbushPassive());
    Templates.AddItem(Coil('M31_PA_Coil'));
    /*>>*/Templates.AddItem(Coil('M31_PA_Coil_Hunker'));
    Templates.AddItem(Entwine());
    Templates.AddItem(Lockjaw());
    /*>>*/Templates.AddItem(LockjawPassive());
    Templates.AddItem(Rattle());
    /*>>*/Templates.AddItem(RattlePassive());
    Templates.AddItem(Salamander());
    Templates.AddItem(Sidewinder());
    /*>>*/Templates.AddItem(SidewinderMove());
    /*>>*/Templates.AddItem(SidewinderAddMovementAction());
    Templates.AddItem(Slither());
    Templates.AddItem(ViperBite());
    Templates.AddItem(IronskinBite());
    Templates.AddItem(RegenBite());
    Templates.AddItem(WrongAcidBite());
    /*>>*/Templates.AddItem(WrongAcidBitePanic());
    Templates.AddItem(AngryBite());
    /*>>*/Templates.AddItem(AngryBitePassive());
    Templates.AddItem(Serpentine());

    Templates.AddItem(PoisonSpit());
    /*>>*/Templates.AddItem(EnhancedPoison());
    /*>>*/Templates.AddItem(BlindingPoison());
    /*>>*/Templates.AddItem(NeuroPoison());
    Templates.AddItem(FrostSpit());
    Templates.AddItem(FrostbiteSpit());
    Templates.AddItem(FrostBreath());

    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PA_FrostSpit_Anims', "M31_PA_Vipers.Anims.AS_ViperKing"));
    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PA_ViperBite_Anims', "M31_PA_Vipers.Anims.AS_ViperBite"));
    Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PA_ViperBash_Anims', "Viper_FireAndMeleeAnims.Anims.AS_Viper"));

    return Templates;
}

static function X2AbilityTemplate Ambush()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;

    Template = SelfTargetTrigger('M31_PA_Ambush', "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 60;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);

    Template.AddTargetEffect(new class'X2Effect_MeristReserveOverwatchPoints');
    Template.AddTargetEffect(class'X2Effect_MeristCoveringFire'.static.CreateCoveringFireEffect());

    Template.BuildVisualizationFn = Ambush_BuildVisualization;

    Template.AdditionalAbilities.AddItem('M31_PA_Ambush_Passive');

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

static function X2AbilityTemplate AmbushPassive()
{
    return Passive('M31_PA_Ambush_Passive', "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction", false, true);
}

static function X2AbilityTemplate Coil(name DataName, optional bool bHunkerDown)
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitEffects       EffectsCondition;
    local array<name>                   SkipExclusions;
    local X2AbilityCost_ActionPoints    ActionPointCost;
    local X2Effect_PA_Coil              CoilEffect;
    local X2Effect_PA_CoilDefense       HunkerDownEffect;
    
    Template = SelfTargetActivated('M31_PA_Coil', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");

    Template.Hostility = eHostility_Defensive;
    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    EffectsCondition = new class'X2Condition_UnitEffects';
    EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(EffectsCondition);

    HunkerDownEffect =  new class'X2Effect_PA_CoilDefense';
    HunkerDownEffect.DefenseBonus = `GetConfigInt("M31_PA_Coil_DefenseBonus");
    HunkerDownEffect.DodgeBonus = `GetConfigInt("M31_PA_Coil_DodgeBonus");
    HunkerDownEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, class'X2Effect_PA_CoilDefense'.default.strFriendlyName, class'X2Effect_PA_CoilDefense'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(HunkerDownEffect);

    if (bHunkerDown)
    {
        Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY;
        Template.AbilitySourceName = 'eAbilitySource_Standard';

        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
        Template.AddShooterEffectExclusions(SkipExclusions);

        ActionPointCost = new class'X2AbilityCost_ActionPoints';
        ActionPointCost.bConsumeAllPoints = true;
        ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
        Template.AbilityCosts.AddItem(ActionPointCost);
    }
    else
    {
        Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY + 1;

        Template.AddShooterEffectExclusions();

        AddCooldown(Template, `GetConfigInt("M31_PA_Coil_Cooldown"));
        AddActionPointCost(Template, eCost_SingleConsumeAll);

        CoilEffect = new class'X2Effect_PA_Coil';
        CoilEffect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
        CoilEffect.SetDisplayInfo(ePerkBuff_Bonus, class'X2Effect_PA_Coil'.default.strFriendlyName, class'X2Effect_PA_Coil'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
        Template.AddTargetEffect(CoilEffect);

        Template.AdditionalAbilities.AddItem('M31_PA_Coil_Hunker');
    }

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;

    Template.bSkipFireAction = false;

    return Template;
}

static function X2AbilityTemplate Entwine()
{
    local X2AbilityTemplate     Template;
    local X2Effect_PA_Entwine   Effect;

    Template = Passive('M31_PA_Entwine', "img:///UILibrary_PerkIcons.UIPerk_viper_bind", false, true);
    
    Effect = new class'X2Effect_PA_Entwine';
    Effect.BindDefenseBonus = `GetConfigInt("M31_PA_Entwine_DefenseBonus");
    Effect.BindDodgeBonus = `GetConfigInt("M31_PA_Entwine_DefenseBonus");
    Effect.GrabAimBonus = `GetConfigInt("M31_PA_Entwine_AimBonus");
    Effect.BindDamageBonus = `GetConfigInt("M31_PA_Entwine_BindDamageBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Lockjaw()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityCooldown_Extended        Cooldown;

    Template = StandardMelee('M31_PA_Lockjaw', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("MM31_PA_Lockjaw_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_Lockjaw_CritBonus");
    ToHitCalc.bAllowCrit = `GetConfigBool("M31_PA_Lockjaw_bAllowCrit");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;

    Template.AbilityTriggers.Length = 0;
    AddOverwatchTriggers(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BladestormConcealment;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 180;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    AddBladestormMark(Template, 'M31_PA_Lockjaw_MarkTarget');

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_Lockjaw_Cooldown");
    Cooldown.bApplyOnlyOnHit = true;
    Template.AbilityCooldown = Cooldown;

    Template.AddTargetEffect(CreateLockjawStunEffect());
    Template.AddTargetEffect(CreateLockjawDamageEffect());
    AddViperPoisonEffects(Template);

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.AdditionalAbilities.AddItem('M31_PA_Lockjaw_Passive');
    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2Effect_Stunned CreateLockjawStunEffect()
{
    local X2Effect_Stunned StunnedEffect;

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_Lockjaw_StunDuration"), 100, false);
    StunnedEffect.DamageTypes.AddItem('Poison');

    return StunnedEffect;
}

static function X2Effect_ApplyScalingDamage CreateLockjawDamageEffect()
{
    local X2Effect_ApplyScalingDamage DamageEffect;

    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_Lockjaw_Damage");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_Lockjaw_DamagePerRank");
    DamageEffect.CritDamagePerRank = `GetConfigFloat("M31_PA_Lockjaw_CritDamagePerRank");

    return DamageEffect;
}

static function X2AbilityTemplate LockjawPassive()
{
    return Passive('M31_PA_Lockjaw_Passive', "img:///UILibrary_MZChimeraIcons.Ability_QuickBite", false, true);
}

static function X2AbilityTemplate Rattle()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_PercentChance  PercentChanceToHit;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_TargetCanSeeSource    VisibilityCondition;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Panicked                 PanickedEffect;

    Template = SelfTargetTrigger('M31_PA_Rattle', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_harborwave");

    PercentChanceToHit = new class'X2AbilityToHitCalc_PercentChance';
    PercentChanceToHit.PercentToHit = `GetConfigInt("M31_PA_Rattle_PanicChance");
    Template.AbilityToHitCalc = PercentChanceToHit;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `GetConfigFloat("M31_PA_Rattle_PanicRange");
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_UnitSeesUnit;
    Template.AbilityTriggers.AddItem(Trigger);

    AddUnitValueCondition(Template, 'M31_PA_Rattle_Counter', `GetConfigInt("M31_PA_Rattle_ActivationsPerTurn"));

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    VisibilityCondition = new class'X2Condition_TargetCanSeeSource';
    VisibilityCondition.bRequireLOS = true;
    VisibilityCondition.bRequireGameplayVisible = true;
    Template.AbilityMultiTargetConditions.AddItem(VisibilityCondition);

    PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.ExcludeDamageTypes = PanickedEffect.DamageTypes;
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    Template.AddMultiTargetEffect(PanickedEffect);

    Template.bShowActivation = true;

    Template.ModifyNewContextFn = Rattle_ModifyActivatedAbilityContext;

    Template.AdditionalAbilities.AddItem('M31_PA_Rattle_Passive');

    return Template;
}

static function Rattle_ModifyActivatedAbilityContext(XComGameStateContext Context)
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

static function X2AbilityTemplate RattlePassive()
{
    return Passive('M31_PA_Rattle_Passive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_harborwave", false, true);
}

static function X2AbilityTemplate Salamander()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_DamageImmunityByTypes    ImmunityEffect;
    local XMBEffect_BonusRadius             RadiusEffect;

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

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('Firebomb'));
    
    return Template;
}

static function X2AbilityTemplate Sidewinder()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_Sidewinder    Effect;

    Template = Passive('M31_PA_Sidewinder', "img:///UILibrary_MeristPerkIcons.UIPerk_Sidewinder", false, true);
    
    Effect = new class'X2Effect_PA_Sidewinder';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_Sidewinder_Move');
    if (!`GetConfigBool("M31_PA_Sidewinder_bOnlyOnEnemyTurn"))
    {
        Template.AdditionalAbilities.AddItem('M31_PA_Sidewinder_AddMovementAction');
    }

    return Template;
}

static function X2AbilityTemplate SidewinderMove()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local array<name>                       SkipExclusions;
    local X2Effect_PA_Sidewinder_Move       InterruptTurnEffect;
    
    Template = SelfTargetTrigger('M31_PA_Sidewinder_Move', "img:///UILibrary_MeristPerkIcons.UIPerk_Sidewinder");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = class'X2Effect_PA_Sidewinder'.default.EventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 50;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_SidewinderMove;
    Template.AbilityTriggers.AddItem(Trigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeStunned = true;
    UnitPropertyCondition.ExcludePanicked = true;
    UnitPropertyCondition.ExcludeUnableToAct = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');

    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    InterruptTurnEffect = new class'X2Effect_PA_Sidewinder_Move';
    InterruptTurnEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(InterruptTurnEffect);

    class'X2Effect_PA_Sidewinder'.static.AddSidewinderCooldown(Template, `GetConfigInt("M31_PA_Sidewinder_Cooldown"));

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_SidewinderMove(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability CallbackAbilityState;
    local XComGameState_Unit    SourceUnit;
    local XComGameState         NewGameState;

    CallbackAbilityState = XComGameState_Ability(CallbackData);
    SourceUnit = XComGameState_Unit(EventSource);

    `assert(SourceUnit != none);

    if (`TACTICALRULES.GetUnitActionTeam() == SourceUnit.GetTeam())
        return ELR_NoInterrupt;

    if (CallbackAbilityState.CanActivateAbilityForObserverEvent(SourceUnit) == 'AA_Success')
    {
        if (CallbackAbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false))
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.ObjectID));
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
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
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local array<name>                       SkipExclusions;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    
    Template = SelfTargetTrigger('M31_PA_Sidewinder_AddMovementAction', "img:///UILibrary_MeristPerkIcons.UIPerk_Sidewinder");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = class'X2Effect_PA_Sidewinder'.default.EventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 55;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeStunned = true;
    UnitPropertyCondition.ExcludePanicked = true;
    UnitPropertyCondition.ExcludeUnableToAct = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_ItsOwnTurn');

    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileDisoriented"))
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    if (`GetConfigBool("M31_PA_Sidewinder_bAllowWhileBurning"))
        SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddTargetEffect(ActionPointEffect);

    class'X2Effect_PA_Sidewinder'.static.AddSidewinderCooldown(Template, `GetConfigInt("M31_PA_Sidewinder_Cooldown"));

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate Slither()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PersistentStatChange SlitherEffect;
    
    Template = SelfTargetActivated('M31_PA_Slither', "img:///UILibrary_PlayableAdvent.Viper_Slither", false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    Template.AddShooterEffectExclusions();

    AddCooldown(Template, `GetConfigInt("M31_PA_Slither_Cooldown"));
    AddActionPointCost(Template, eCost_Free);

    SlitherEffect = new class'X2Effect_PersistentStatChange';
    SlitherEffect.AddPersistentStatChange(eStat_Mobility, `GetConfigInt("M31_PA_Slither_MobilityBonus"));
    SlitherEffect.AddPersistentStatChange(eStat_Defense, `GetConfigInt("M31_PA_Slither_DefenseBonus"));
    SlitherEffect.AddPersistentStatChange(eStat_Dodge, `GetConfigInt("M31_PA_Slither_DodgeBonus"));
    SlitherEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Slither_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    SlitherEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(SlitherEffect);

    return Template;
}

static function X2AbilityTemplate ViperBite()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_ApplyScalingDamage       DamageEffect;

    Template = MovingMelee('M31_PA_ViperBite', "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_ViperBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_ViperBite_CritBonus");
    ToHitCalc.bAllowCrit = `GetConfigBool("M31_PA_ViperBite_bAllowCrit");
    Template.AbilityToHitCalc = ToHitCalc;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    AddCooldown(Template, `GetConfigInt("M31_PA_ViperBite_Cooldown"));
    AddActionPointCost(Template, eCost_Single);

    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_ViperBite_Damage");
    DamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_PA_ViperBite_Rupture");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_ViperBite_DamagePerRank");
    DamageEffect.CritDamagePerRank = `GetConfigFloat("M31_PA_ViperBite_CritDamagePerRank");
    Template.AddTargetEffect(DamageEffect);
    AddViperPoisonEffects(Template);

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2AbilityTemplate CreateFriendlyViperBiteAbility(name DataName, string IconImage, bool bAddUnitPropertyCondition = true)
{
    local X2AbilityTemplate         Template;
    local X2Condition_UnitProperty  UnitPropertyCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Defensive;
    Template.DisplayTargetHitChance = false;
    Template.bLimitTargetIcons = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    if (!`GetConfigBool("M31_PA_ViperBite_bCanTargetVipers"))
        Template.AbilityTargetConditions.AddItem(class'X2Condition_Viper'.static.NotViperCondition());

    if (bAddUnitPropertyCondition)
    {
        UnitPropertyCondition = new class'X2Condition_UnitProperty';
        UnitPropertyCondition.ExcludeHostileToSource = true;
        UnitPropertyCondition.ExcludeFriendlyToSource = false;
        UnitPropertyCondition.ExcludeRobotic = true;
        UnitPropertyCondition.FailOnNonUnits = true;
        UnitPropertyCondition.RequireWithinRange = true;
        UnitPropertyCondition.WithinRange = 180;
        Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    }

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bShowActivation = true;

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}


static function X2AbilityTemplate IronskinBite()
{
    local X2AbilityTemplate         Template;
    local X2Effect_RemoveEffects    RemoveEffect;
    local X2Effect_PersonalShield   Effect;

    Template = CreateFriendlyViperBiteAbility('M31_PA_IronskinBite', "img:///UILibrary_MeristPerkIcons.UIPerk_ShieldBite");

    AddCooldown(Template, `GetConfigInt("M31_PA_IronskinBite_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_IronskinBite_Charges"));
    AddActionPointCost(Template, eCost_Single);

    RemoveEffect = new class'X2Effect_RemoveEffects';
    RemoveEffect.EffectNamesToRemove.AddItem('M31_PA_IronskinBite_Buff');
    RemoveEffect.bDoNotVisualize = true;
    Template.AddTargetEffect(RemoveEffect);

    Effect = new class'X2Effect_PersonalShield';
    Effect.EffectName = 'M31_PA_IronskinBite_Buff';
    Effect.ShieldAmountBase = `GetConfigInt("M31_PA_IronskinBite_ShieldAmount");
    Effect.ShieldPriority = `GetConfigInt("M31_PA_IronskinBite_ShieldPriority");
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_IronskinBite_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_PersonalShield'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Effect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate RegenBite()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitStatCheck         UnitStatCheckCondition;
    local X2Effect_PA_ViperRegeneration     RegenerationEffect;
    local X2Condition_UnitProperty          BleedingOutCondition;
    local X2Effect_RemoveEffects            RemoveBleedOut;
    local X2Effect_Persistent               UnconsciousEffect;
    local X2Condition_UnitEffects           UnitEffectsCondition;

    Template = CreateFriendlyViperBiteAbility('M31_PA_RegenBite', "img:///UILibrary_MeristPerkIcons.UIPerk_RegenBite", false);

    AddCooldown(Template, `GetConfigInt("M31_PA_RegenBite_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_RegenBite_Charges"));
    AddActionPointCost(Template, eCost_Single);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 180;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
    UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
    Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

    RegenerationEffect = new class'X2Effect_PA_ViperRegeneration';
    RegenerationEffect.HealAmount = `GetConfigInt("M31_PA_RegenBite_HealPerTurn");
    if (`GetConfigInt("M31_PA_RegenBite_EnhHealPerTurn") - `GetConfigInt("M31_PA_RegenBite_HealPerTurn") > 0)
        RegenerationEffect.BonusHealAmount = `GetConfigInt("M31_PA_RegenBite_EnhHealPerTurn") - `GetConfigInt("M31_PA_RegenBite_HealPerTurn");
    if (`GetConfigInt("M31_PA_RegenBite_EnhDuration") - `GetConfigInt("M31_PA_RegenBite_Duration") > 0)
        RegenerationEffect.BonusDuration = `GetConfigInt("M31_PA_RegenBite_EnhDuration") - `GetConfigInt("M31_PA_RegenBite_Duration");
    if (`GetConfigBool("M31_PA_RegenBite_bRemovePoison"))
        RegenerationEffect.DamageTypesToRemove.AddItem('Poison');
    if (`GetConfigBool("M31_PA_RegenBite_bProvidesPoisonImmunity"))
        RegenerationEffect.ImmuneTypes.AddItem('Poison');
    RegenerationEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_RegenBite_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    RegenerationEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_PA_ViperRegeneration'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    RegenerationEffect.bRemoveWhenTargetDies = false;
    Template.AddTargetEffect(RegenerationEffect);

    if (`GetConfigBool("M31_PA_RegenBite_bStabilize"))
    {
        BleedingOutCondition = new class'X2Condition_UnitProperty';
        BleedingOutCondition.ExcludeDead = false;
        BleedingOutCondition.IsBleedingOut = true;

        RemoveBleedOut = new class'X2Effect_RemoveEffects';
        RemoveBleedOut.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
        RemoveBleedOut.TargetConditions.AddItem(BleedingOutCondition);
        Template.AddTargetEffect(RemoveBleedOut);

        UnconsciousEffect = class'X2StatusEffects'.static.CreateUnconsciousStatusEffect(, true);
        UnconsciousEffect.TargetConditions.AddItem(BleedingOutCondition);
        Template.AddTargetEffect(UnconsciousEffect);
    }
    else
    {
        UnitEffectsCondition = new class'X2Condition_UnitEffects';
        UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsBleedingOut');
        Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);
    }

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

    Template = CreateFriendlyViperBiteAbility('M31_PA_MemeBite', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false);

    Template.Hostility = eHostility_Offensive;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 180;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_PA_MemeBite_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_MemeBite_Charges"));

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
    PoisonedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_Poisoned_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PoisonedEffect.TargetConditions.AddItem(HostileCondition);
    Template.AddTargetEffect(PoisonedEffect);

    BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(`GetConfigInt("M31_PA_MemeBite_H"), 3);
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_Bleeding_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding");
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
    StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.MemeBite_BuffText, Template.IconImage,,, Template.AbilitySourceName);
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
    SetFireAnim(Template, 'HL_M31_ViciousBite');

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
    Template.MergeVisualizationFn = class'X2Effect_PassiveWeaponEffect'.static.FollowUpShot_MergeVisualization;
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
    local X2AbilityTemplate                         Template;
    local X2AbilityToHitCalc_StandardMelee          ToHitCalc;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Condition_Visibility                    VisibilityCondition;
    local X2Condition_UnitProperty                  UnitPropertyCondition;
    local X2AbilityCooldown_Extended                Cooldown;

    Template = StandardMelee('M31_PA_AngryBite', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bFrameEvenWhenUnitIsHidden = true;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_AngryBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_AngryBite_CritBonus");
    ToHitCalc.bAllowCrit = `GetConfigBool("M31_PA_AngryBite_bAllowCrit");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;

    Template.AbilityTriggers.Length = 0;
    AddOverwatchTriggers(Template);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BladestormConcealment;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();
    AddSuppressedCondition(Template);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = 180;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    AddBladestormMark(Template, 'M31_PA_AngryBite_MarkTarget');

    if (`GetConfigBool("M31_PA_AngryBite_bHasCooldown"))
    {
        Cooldown = new class'X2AbilityCooldown_Extended';
        Cooldown.iNumTurns = `GetConfigInt("M31_PA_AngryBite_Cooldown");
        Cooldown.bApplyOnlyOnHit = `GetConfigBool("M31_PA_AngryBite_bCooldownOnlyOnHit");
        Template.AbilityCooldown = Cooldown;
    }

    Template.AddTargetEffect(CreateAngryBiteDamageEffect());

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.AdditionalAbilities.AddItem('M31_PA_AngryBite_Passive');
    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');
 
    return Template;
}

static function X2AbilityTemplate AngryBitePassive()
{
    return Passive('M31_PA_AngryBite_Passive', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, true);
}

static function X2Effect_ApplyScalingDamage CreateAngryBiteDamageEffect()
{
    local X2Effect_ApplyScalingDamage DamageEffect;

    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_AngryBite_Damage");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_AngryBite_DamagePerRank");
    DamageEffect.CritDamagePerRank = `GetConfigFloat("M31_PA_AngryBite_CritDamagePerRank");

    return DamageEffect;
}

static function X2AbilityTemplate Serpentine()
{
    local X2AbilityTemplate             Template;
    local X2Effect_RefundActionPoints   Effect;
    
    Template = Passive('M31_PA_Serpentine', "img:///UILibrary_MZChimeraIcons.Ability_BindRelease", false, true);

    Effect = new class'X2Effect_RefundActionPoints';
    Effect.EffectName = 'M31_PA_Serpentine';
    Effect.bRefundAll = true;
    Effect.AllowedAbilities = default.Serpentine_AllowedAbilities;
    Effect.ActivationsPerTurn = `GetConfigInt("M31_PA_Serpentine_ActivationsPerTurn");
    Effect.CountValueName = 'M31_PA_Serpentine_Activations';
    Effect.bShowFlyover = true;
    Effect.FlyoverEventName = 'M31_PA_Serpentine_Flyover';
    Effect.bAllowCBACOverride = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate PoisonSpit()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Effect_ApplyScalingDamage   DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_PoisonSpit', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit", `GetConfigFloat("M31_PA_PoisonSpit_Radius"));

    AddActionPointCost(Template, eCost_Single);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_PoisonSpit_Cooldown");
    Cooldown.AddCooldownModifier('M31_PA_NeuroPoison', -1 * `GetConfigInt("M31_PA_NeuroPoison_CooldownReduction"));
    Template.AbilityCooldown = Cooldown;

    if (`GetConfigBool("M31_PA_PoisonSpit_bDealsDamage"))
    {
        DamageEffect = new class'X2Effect_ApplyScalingDamage';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_PoisonSpit_Damage");
        DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_PoisonSpit_DamagePerRank");
        DamageEffect.DamageTypes.AddItem('Poison');
        Template.AddMultiTargetEffect(DamageEffect);
    }

    AddViperPoisonEffects(Template);

    if (`GetConfigBool("M31_PA_PoisonSpit_bAppliesPoisonToWorld"))
    {
        Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');
    }

    Template.CustomFireAnim = 'HL_PoisonSpit';

    return Template;
}

static function X2AbilityTemplate EnhancedPoison()
{
    return Passive(default.EnhancedPoisonAbilityName, "img:///UILibrary_XPerkIconPack.UIPerk_poison_plus", false, true);
}

static function X2AbilityTemplate BlindingPoison()
{
    return Passive('M31_PA_BlindingPoison', "UILibrary_XPACK_Common.PerkIcons.UIPerk_mountainmist", false, false);
}

static function X2AbilityTemplate NeuroPoison()
{
    return Passive('M31_PA_NeuroPoison', "img:///UILibrary_PerkIcons.UIPerk_insanity", false, true);
}

static function X2AbilityTemplate FrostSpit()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyScalingDamage   DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_FrostSpit', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit", `GetConfigFloat("M31_PA_FrostSpit_Radius"));

    AddCooldown(Template, `GetConfigInt("M31_PA_FrostSpit_Cooldown"));
    AddActionPointCost(Template, eCost_Single);

    class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_FrostSpit_Damage");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_FrostSpit_DamagePerRank");
    DamageEffect.DamageTypes.AddItem('Frost');
    Template.AddMultiTargetEffect(DamageEffect);

    Template.CustomFireAnim = 'HL_M31_FrostBite';

    Template.AdditionalAbilities.AddItem('M31_PA_FrostSpit_Anims');
    
    return Template;
}

static function X2AbilityTemplate FrostbiteSpit()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PA_FrostbiteSpit Effect;

    Template = Passive('M31_PA_FrostbiteSpit', "img:///UILibrary_SODragoon.UIPerk_overkill", false, true);
    
    Effect = new class'X2Effect_PA_FrostbiteSpit';
    Effect.EffectName = 'M31_PA_FrostbiteSpit';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_PA_FrostSpit');

    return Template;
}

static function X2AbilityTemplate FrostBreath()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyScalingDamage   DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_FrostBreath', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", `GetConfigFloat("M31_PA_FrostBreath_Radius"));

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 1;

    AddCooldown(Template, `GetConfigInt("M31_PA_FrostBreath_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_PA_FrostBreath_Charges"));
    AddActionPointCost(Template, eCost_Single);

    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeEffect(false));
    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeCleanse(false));

    if (`GetConfigBool("M31_PA_FrostBreath_bDealsDamage"))
    {
        DamageEffect = new class'X2Effect_ApplyScalingDamage';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_FrostBreath_Damage");
        DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_FrostBreath_DamagePerRank");
        DamageEffect.DamageTypes.AddItem('Frost');
        Template.AddMultiTargetEffect(DamageEffect);
    }

    Template.CustomFireAnim = 'HL_M31_FrostBite';

    Template.AdditionalAbilities.AddItem('M31_PA_FrostSpit_Anims');

    return Template;
}

static function X2AbilityTemplate CreateViperSpitAbility(name DataName, string IconImage, int fTargetRadius = 2.5)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_Cylinder     CylinderMultiTarget;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Offensive;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    CylinderMultiTarget = new class'X2AbilityMultiTarget_Cylinder';
    CylinderMultiTarget.bUseWeaponRadius = false;
    CylinderMultiTarget.fTargetRadius = fTargetRadius;
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

static function AddViperPoisonEffects(out X2AbilityTemplate Template)
{
    local X2Effect_PersistentStatChange EnhancedPoisonedEffect;
    local X2Effect_PersistentStatChange PoisonedEffect;
    local X2Effect_Persistent   NeuroPoisonEffect;
    local X2Effect_Persistent   BlindingPoisonEffect;

    EnhancedPoisonedEffect = CreateEnhancedPoisonedEffect();
    PoisonedEffect = CreatePoisonedEffect();
    NeuroPoisonEffect = CreateNeuroPoisonEffect();
    BlindingPoisonEffect = CreateBlindingPoisonEffect();

    if (Template.AbilityTargetEffects.Length > 0)
    {
        Template.AddTargetEffect(EnhancedPoisonedEffect);
        Template.AddTargetEffect(PoisonedEffect);
        Template.AddTargetEffect(NeuroPoisonEffect);
        Template.AddTargetEffect(BlindingPoisonEffect);
    }
    if (Template.AbilityMultiTargetEffects.Length > 0)
    {
        Template.AddMultiTargetEffect(EnhancedPoisonedEffect);
        Template.AddMultiTargetEffect(PoisonedEffect);
        Template.AddMultiTargetEffect(NeuroPoisonEffect);
        Template.AddMultiTargetEffect(BlindingPoisonEffect);
    }
}

static function X2Effect_PersistentStatChange CreatePoisonedEffect()
{
    local X2Effect_PersistentStatChange PoisonedEffect;
    local X2Effect_ApplyScalingDamage   DamageEffect;
    local X2Condition_SoldierAbilities  AbilityCondition;

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();

    PoisonedEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Poison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PoisonedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_Poisoned_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");

    PoisonedEffect.m_aStatChanges.Length = 0;
    PoisonedEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_Poison_MobilityPenalty"));
    PoisonedEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_Poison_AimPenalty"));

    PoisonedEffect.ApplyOnTick.Length = 0;
    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_Poison_Damage");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_Poison_DamagePerRank");
    DamageEffect.DamageFromHP = `GetConfigFloat("M31_PA_Poison_DamageFromHP");
    DamageEffect.EffectDamageValue.DamageType = 'Poison';
    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS;
    PoisonedEffect.ApplyOnTick.AddItem(DamageEffect);

    AbilityCondition = new class'X2Condition_SoldierAbilities';
    AbilityCondition.ExcludedAbilities.AddItem(default.EnhancedPoisonAbilityName);
    PoisonedEffect.TargetConditions.AddItem(AbilityCondition);

    PoisonedEffect.EffectRank = 1;

    return PoisonedEffect;
}

static function X2Effect_PersistentStatChange CreateEnhancedPoisonedEffect()
{
    local X2Effect_PersistentStatChange PoisonedEffect;
    local X2Effect_ApplyScalingDamage   DamageEffect;
    local X2Condition_SoldierAbilities  AbilityCondition;

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();

    PoisonedEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PoisonedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, `GetLocalizedString("M31_Poisoned_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_poisoned");

    PoisonedEffect.m_aStatChanges.Length = 0;
    PoisonedEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_EnhancedPoison_MobilityPenalty"));
    PoisonedEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_EnhancedPoison_AimPenalty"));

    PoisonedEffect.ApplyOnTick.Length = 0;
    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_EnhancedPoison_Damage");
    DamageEffect.DamagePerRank = `GetConfigFloat("M31_PA_EnhancedPoison_DamagePerRank");
    DamageEffect.DamageFromHP = `GetConfigFloat("M31_PA_EnhancedPoison_DamageFromHP");
    DamageEffect.EffectDamageValue.DamageType = 'Poison';
    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS;
    PoisonedEffect.ApplyOnTick.AddItem(DamageEffect);

    AbilityCondition = new class'X2Condition_SoldierAbilities';
    AbilityCondition.RequiredAbilities.AddItem(default.EnhancedPoisonAbilityName);
    PoisonedEffect.TargetConditions.AddItem(AbilityCondition);

    PoisonedEffect.EffectRank = 2;

    return PoisonedEffect;
}

static function X2Effect_Persistent CreateNeuroPoisonEffect()
{
    local X2Effect_Persistent           DisorientedEffect;
    local X2Condition_AbilityProperty   AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_NeuroPoison');

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.DamageTypes.AddItem('Poison');
    DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

    return DisorientedEffect;
}

static function X2Effect_Persistent CreateBlindingPoisonEffect()
{
    local X2Effect_PA_ViperBlind        BlindedEffect;
    local X2Condition_AbilityProperty   AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_BlindingPoison');

    BlindedEffect = class'X2Effect_PA_ViperBlind'.static.CreateViperBlindEffect(
        `GetConfigInt("M31_PA_Poison_Duration"), `GetConfigFloat("M31_PA_BlindingPoison_SightMult"), `GetConfigInt("M31_PA_BlindingPoison_ApplyChance"));
    BlindedEffect.BonusDuration = `GetConfigInt("M31_PA_EnhancedPoison_Duration") - `GetConfigInt("M31_PA_Poison_Duration");
    BlindedEffect.TargetConditions.AddItem(AbilityCondition);

    return BlindedEffect;
}

defaultproperties
{
    EnhancedPoisonAbilityName = M31_PA_EnhancedPoison
}