class X2AbilitySet_Merist extends X2Ability_Extended config(GameData_SoldierSkills) dependson(X2AbilityCooldown_Extended);

var privatewrite name SniperOverwatchActionPoint;

var config array<name> RocketLauncherTemplates;
var config array<name> BoltCasterTemplates;
var config array<name> PistolCategories;

var config array<name> AdvancedOptics_AllowedEffects;
var config array<name> ColdBlooded_AllowedAbilities;
var config array<name> ColdBlooded_AllowedEffects;
var config array<name> FutureWarfare_AllowedAbilities;
var config array<name> Malevolence_AllowedCategories;
var config array<name> PriorityFocus_AllowedEffects;
var config array<name> Relentless_AllowedAbilities;
var config array<name> Reposition_AllowedAbilities;
var config array<name> ShockGrenadier_AdditionalCharge_AllowedAbilities;
var config array<name> ShotgunWedding_AllowedCategories;
var config array<name> SniperElite_AllowedEffects;
var config array<name> Suppression_Area_AllowedCategories;
var config array<name> TrainedSniper_AllowedCategories;
var config array<name> TraverseFire_AllowedAbilities;
var config array<name> TraverseFirePlus_AllowedAbilities;
var config array<name> ShiverCrit2_AdditionalCategories;
var config array<EInventorySlot> Warbringer_AllowedSlots;

var config array<CooldownModifierInfo> EnergyShield_CooldownModifiers;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(AdvancedAidProtocol());
    Templates.AddItem(AdvancedOptics());
    Templates.AddItem(Aim());
    Templates.AddItem(AlphaStrike());
    Templates.AddItem(Assassin());
        Templates.AddItem(AssassinTrigger());
    Templates.AddItem(AssaultShot());
    Templates.AddItem(Bandit());
    Templates.AddItem(BattalionCommander());
    Templates.AddItem(BloodThirst());
    Templates.AddItem(Botnet());
    Templates.AddItem(BurstFire());
    Templates.AddItem(CallForFire());
    Templates.AddItem(ColdBlooded());
    Templates.AddItem(CombatAdvance());
    Templates.AddItem(ConcussiveGrenades());
    Templates.AddItem(ControlledDetonation());
    Templates.AddItem(CovertParkour());
    Templates.AddItem(DeathAdder());
        Templates.AddItem(DeathAdderBonus());
    Templates.AddItem(DedicatedOverwatch());
    Templates.AddItem(Dervish());
        Templates.AddItem(DervishTrigger());
    Templates.AddItem(DisarmingShot());
        Templates.AddItem(DisarmingShotSnap());
    Templates.AddItem(Duskborn());
        Templates.AddItem(DuskbornTrigger());
    Templates.AddItem(EMPBomber());
    Templates.AddItem(EnemyUnknown());
        Templates.AddItem(EnemyUnknownTrigger());
    Templates.AddItem(EnergyShield());
    Templates.AddItem(EnhancedLowProfile());
    Templates.AddItem(Entrench());
        Templates.AddItem(EntrenchTrigger());
    Templates.AddItem(EyeOnTarget());
    Templates.AddItem(Escalation());
    Templates.AddItem(Frostbane());
    Templates.AddItem(FutureWarfare());
        Templates.AddItem(FutureWarfareTrigger());
    Templates.AddItem(ImprovedSuppression());
    Templates.AddItem(LowProfileNest());
    Templates.AddItem(GenevaSuggestion());
    Templates.AddItem(Maim());
        Templates.AddItem(MaimSnap());
    Templates.AddItem(Malevolence());
        Templates.AddItem(MalevolenceAttack());
    Templates.AddItem(ManualOverride());
    Templates.AddItem(MarauderElite());
    Templates.AddItem(Meld());
    Templates.AddItem(Minelayer2());
    Templates.AddItem(NeurotoxicShot());
    Templates.AddItem(OnTheMove());
    Templates.AddItem(OverchargedBlast());
    Templates.AddItem(Overpower());
    Templates.AddItem(Overseer());
    Templates.AddItem(PerfectHandling());
    Templates.AddItem(Pinpoint());
        Templates.AddItem(PinpointBonus());
    Templates.AddItem(PipeBombs());
    Templates.AddItem(PistolDetonationShot());
    Templates.AddItem(PistolDisarmingShot());
    Templates.AddItem(PistolMaim());
    Templates.AddItem(PriorityFocus());
    Templates.AddItem(RapidDumping());
    Templates.AddItem(ReflexShot());
        Templates.AddItem(ReflexShotAttack());
    Templates.AddItem(Relentless());
    Templates.AddItem(RepositionPlus());
    Templates.AddItem(SaltInTheWound());
    Templates.AddItem(SawedOffRange());
    Templates.AddItem(SawedOffReload());
    Templates.AddItem(SawedOffSweeper());
    Templates.AddItem(ShadowstepAid());
    Templates.AddItem(ShockGrenadier());
    Templates.AddItem(ShotgunWedding());
        Templates.AddItem(ShotgunWeddingAttack());
    Templates.AddItem(Skykeeper());
    Templates.AddItem(SleightOfHand());
    Templates.AddItem(SmokeGrenadier());
    Templates.AddItem(SniperElite());
    Templates.AddItem(SniperOverwatch());
        Templates.AddItem(SniperOverwatchAttack());
    Templates.AddItem(SoldierOfFortune());
    Templates.AddItem(SolidSnake());
    Templates.AddItem(Sparkfire());
    Templates.AddItem(StaticGrenades());
    Templates.AddItem(Stiletto());
    Templates.AddItem(SuperheavyOrdnance());
    Templates.AddItem(SupplyPack());
    Templates.AddItem(SuppressingFire());
        Templates.AddItem(SuppressingFireAddActions());
        Templates.AddItem(SuppressingFireRemoveActions());
    Templates.AddItem(Suppression());
    Templates.AddItem(TargetingAid());
    Templates.AddItem(TrackingFire());
        Templates.AddItem(TrackingFireResetCooldown());
    Templates.AddItem(TrainedSniper_Squadsight());
    Templates.AddItem(TrainedSniper_LongWatch());
    Templates.AddItem(TrainedSniper_RangeFinder());
    Templates.AddItem(TraverseFire());
        Templates.AddItem(TraverseFirePlus());
    Templates.AddItem(TroubleShooter());
    Templates.AddItem(Undertaker());
    Templates.AddItem(Unload('M31_Unload', true));
        Templates.AddItem(Unload('M31_Unload_Chain'));
    Templates.AddItem(Warbringer());
    Templates.AddItem(WatchfulEye());
        Templates.AddItem(WatchfulEyeAttack());

    Templates.AddItem(AcidRoundsAttackPassive());
        Templates.AddItem(AcidRoundsAttack());
    Templates.AddItem(BleedingRoundsAttackPassive());
        Templates.AddItem(BleedingRoundsAttack());
    Templates.AddItem(Bloodlet());
        Templates.AddItem(BloodletAttack());
    Templates.AddItem(ThermalShock());
        Templates.AddItem(ThermalShockAttack());
    Templates.AddItem(ToxicNightmare());
        Templates.AddItem(ToxicNightmareAttack());
    Templates.AddItem(Shiver2());
        Templates.AddItem(Shiver2Attack());
    Templates.AddItem(HypothermiaRoundsPassive());
        Templates.AddItem(HypothermiaRoundsAttack());
    Templates.AddItem(ShiverCrit2());
        Templates.AddItem(ShiverCrit2Attack());

    Templates.AddItem(AutoGuard());

    Templates.AddItem(Chimera());

    return Templates;
}

static function X2AbilityTemplate AdvancedAidProtocol()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_AdvancedAidProtocol', "img:///UILibrary_MZChimeraIcons.Ability_ArmorSystem", false, true);
    
    return Template;
}

static function X2AbilityTemplate AdvancedOptics()
{
    local X2AbilityTemplate             Template;
    local X2Effect_AdvancedOptics       Effect;

    Template = Passive('M31_AdvancedOptics', "img:///UILibrary_MZChimeraIcons.WeaponMod_ScopeSuperior", false, true);

    Effect = new class'X2Effect_AdvancedOptics';
    Effect.bMatchSourceWeapon = false;
    Effect.bLongRange = true;
    Effect.RangeOffsetPrc = `GetConfigInt("M31_AdvancedOptics_PenaltyModifier");
    Effect.DefenseIgnorePrc = `GetConfigInt("M31_AdvancedOptics_DefenseReduction");
    Effect.AllowedEffects =  default.AdvancedOptics_AllowedEffects;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Aim()
{
    local X2AbilityTemplate                 Template;
    
    Template = Passive('M31_Aim', "img:///UILibrary_PerkIcons.UIPerk_aim", false, true);

    return Template;
}

static function X2AbilityTemplate AlphaStrike()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;

    Template = SelfTargetActivated('M31_AlphaStrike', "img:///UILibrary_MZChimeraIcons.Ability_Dash", false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    AddCooldown(Template, `GetConfigInt("M31_AlphaStrike_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_AlphaStrike_Charges"));
    AddActionPointCost(Template, eCost_DoubleConsumeAll);

    AddSuppressedCondition(Template);
    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeUnableToAct = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_AlphaStrike_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
    Template.AddMultiTargetEffect(ActionPointEffect);
    
    Template.bSkipFireAction = false;
    
    Template.CustomFireAnim = 'HL_SignalEncourage';
    Template.CinescriptCameraType = "Skirmisher_CombatPresence";
    Template.AbilityConfirmSound = "Combat_Presence_Activate";

    Template.BuildVisualizationFn = AlphaStrike_BuildVisualization;

    return Template;
}

simulated function AlphaStrike_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;

    local StateObjectReference          SourceUnitRef;
    local StateObjectReference          TargetUnitRef;
    local XComGameState_Effect          EffectState;
    local X2AbilityTemplate             AbilityTemplate;

    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   SourceTrack;
    local VisualizationActionMetadata   TargetTrack;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyoverTarget;
    local X2Action_PlayAnimation        PlayAnimationAction;

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

    SourceUnitRef = Context.InputContext.SourceObject;

    SourceTrack = EmptyTrack;
    SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(SourceUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceUnitRef.ObjectID);
    SourceTrack.VisualizeActor = History.GetVisualizer(SourceUnitRef.ObjectID);

    SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
    SoundAndFlyOver.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, 'CombatPresence', eColor_Good, AbilityTemplate.IconImage);

    class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, context, false, SourceTrack.LastActionAdded);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = AbilityTemplate.CustomFireAnim;
    PlayAnimationAction.bFinishAnimationWait = true;

    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == AbilityTemplate.DataName)
        {
            TargetUnitRef = EffectState.ApplyEffectParameters.TargetStateObjectRef;
            
            if (TargetUnitRef.ObjectID != 0 && TargetUnitRef.ObjectID != SourceUnitRef.ObjectID)
            {
                TargetTrack = EmptyTrack;
                TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
                TargetTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
                TargetTrack.VisualizeActor = History.GetVisualizer(TargetUnitRef.ObjectID);

                SoundAndFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
                SoundAndFlyoverTarget.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, 'None', eColor_Good, AbilityTemplate.IconImage);
            }
        }
    }
}

static function X2AbilityTemplate Assassin()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Assassin     Effect;
    
    Template = Passive('M31_Assassin', "img:///UILibrary_SOHunter.UIPerk_assassin", false, true);

    Effect = new class'X2Effect_Assassin';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_Assassin_Trigger');

    return Template;
}

static function X2AbilityTemplate AssassinTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_StealthCustom         StealthCondition;
    local X2Effect_RangerStealth            StealthEffect;
    local X2Effect_Spotted                  UnspottedEffect;
    local X2Effect_SetUnitValue             SetValueEffect;
    
    Template = SelfTargetTrigger('M31_Assassin_Trigger', "img:///UILibrary_SOHunter.UIPerk_assassin");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'X2Effect_Assassin'.static.AbilityTriggerEventListener_Assassin;
    Trigger.ListenerData.Priority = 20;
    Template.AbilityTriggers.AddItem(Trigger);

    StealthCondition = new class'X2Condition_StealthCustom';
    StealthCondition.bCheckConcealed = true;
    StealthCondition.bCheckFlanking = false;

    StealthEffect = new class'X2Effect_RangerStealth';
    StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
    StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    StealthEffect.TargetConditions.AddItem(StealthCondition);
    Template.AddShooterEffect(StealthEffect);

    UnspottedEffect = class'X2Effect_Spotted'.static.CreateUnspottedEffect();
    UnspottedEffect.TargetConditions.AddItem(StealthCondition);
    Template.AddShooterEffect(UnspottedEffect);

    AddUnitValueCondition(Template, class'X2Effect_Assassin'.default.CounterName, `GetConfigInt("M31_Assassin_ActivationsPerTurn"));

    SetValueEffect = new class'X2Effect_SetUnitValue';
    SetValueEffect.UnitName = class'X2Effect_Assassin'.default.ActivatedValueName;
    SetValueEffect.NewValueToSet = 1;
    SetValueEffect.CleanupType = eCleanup_BeginTurn;
    SetValueEffect.TargetConditions.AddItem(StealthCondition);
    Template.AddShooterEffect(SetValueEffect);

    AddCooldown(Template, `GetConfigInt("M31_Assassin_Cooldown"));

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate AssaultShot()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    Template = Attack('M31_AssaultShot', "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;
    
    AddActionPointCost(Template, eCost_Free);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_AssaultShot_Cooldown"));

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = `GetConfigFloat("M31_AssaultShot_Range") * class'XComWorldData'.const.WORLD_StepSize;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    return Template;
}

static function X2AbilityTemplate Bandit()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Bandit       Effect;
    
    Template = Passive('M31_Bandit', "img:///UILibrary_MZChimeraIcons.WeaponMod_ExtendedSuperior", false, true);

    Effect = new class'X2Effect_Bandit';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_Bandit_ActivationsPerTurn");
    Effect.AmmoToReload = `GetConfigInt("M31_Bandit_AmmoToReload");
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BattalionCommander()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_BattalionCommander', "img:///UILibrary_MZChimeraIcons.Ability_Resilience", false, true);

    Template.PrerequisiteAbilities.AddItem('CombatPresence');
    
    return Template;
}

static function X2AbilityTemplate BloodThirst()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_BloodThirst              Effect;
    
    Template = Passive('M31_BloodThirst', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage", false, true);

    Effect = new class'X2Effect_BloodThirst';
    Effect.iDefaultDamagePerStack = `GetConfigInt("M31_BloodThirst_DamagePerStack");
    Effect.iMaxStacks = `GetConfigInt("M31_BloodThirst_MaxStacks");
    Effect.iMaxStacksPerTurn = `GetConfigInt("M31_BloodThirst_MaxStacksPerTurn");
    Effect.iStackDuration = `GetConfigInt("M31_BloodThirst_StackDuration");
    Effect.bRefreshDuration = `GetConfigBool("M31_BloodThirst_bRefreshDuration");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_BloodThirst_bMatchSourceWeapon");
    Effect.bIncreaseOnlyOnHit = `GetConfigBool("M31_BloodThirst_bIncreaseOnlyOnHit");
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_BloodThirst_BuffText"), Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Botnet()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_Persistent               Effect;

    Template = SelfTargetActivated('M31_Botnet', "img:///UILibrary_XPerkIconPack.UIPerk_gremlin_circle", false);

    AddCooldown(Template, `GetConfigInt("M31_Botnet_Cooldown"));
    AddActionPointCost(Template, eCost_Free);

    Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_Botnet_Valid';
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Botnet_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    Effect.DuplicateResponse = eDupe_Refresh;
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Botnet_BonusText"), Template.IconImage, true,, Template.AbilitySourceName);

    Template.AddTargetEffect(Effect);
    Template.AddMultiTargetEffect(Effect);

    Template.AbilityConfirmSound = "Unreal2DSounds_TargetLock";

    return Template;
}

static function X2AbilityTemplate BurstFire()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
    local int NumExtraShots;

    Template = Attack('M31_BurstFire', "img:///UILibrary_LW_PerkPack.LW_AbilityLightEmUp", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, `GetConfigInt('M31_BurstFire_NumShots'));
    AddCooldown(Template, `GetConfigInt("M31_BurstFire_Cooldown"));

    NumExtraShots = `GetConfigInt('M31_BurstFire_NumShots') - 1;
    if (NumExtraShots > 0)
    {
        BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
        BurstFireMultiTarget.NumExtraShots = NumExtraShots;
        Template.AbilityMultiTargetStyle = BurstFireMultiTarget;
        Template.AddMultiTargetEffect(new class'X2Effect_Shredder');
    }

    SetFireAnim(Template, 'FF_IRI_BH_BurstFire');

    Template.ActivationSpeech = 'BulletShred';

    Template.AdditionalAbilities.AddItem('IRI_BH_BurstFire_Anim_Passive');

    return Template;
}

static function X2AbilityTemplate CallForFire()
{
    local X2AbilityTemplate                         Template;
    local X2AbilityMultiTarget_Radius               RadiusMultiTarget;
    local X2Condition_UnitProperty                  UnitPropertyCondition;
    local X2Effect_MeristReserveOverwatchPoints     ReserveEffect;
    local X2Effect_MeristCoveringFire               CoveringFireEffect;
    local X2Condition_TargetHasOneOfTheAbilities    CoveringFireCondition;

    Template = SelfTargetActivated('M31_CallForFire', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_circle", false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    AddCooldown(Template, `GetConfigInt("M31_CallForFire_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    AddSuppressedCondition(Template);
    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeUnableToAct = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_CallForFire_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    ReserveEffect = new class'X2Effect_MeristReserveOverwatchPoints';
    Template.AddTargetEffect(ReserveEffect);
    Template.AddMultiTargetEffect(ReserveEffect);

    CoveringFireCondition = new class'X2Condition_TargetHasOneOfTheAbilities';
    CoveringFireCondition.AbilityNames.AddItem('CoveringFire');

    CoveringFireEffect = new class'X2Effect_MeristCoveringFire';
    CoveringFireEffect.AbilitiesToActivate = class'X2Effect_MeristReserveOverwatchPoints'.default.OverwatchAbilities;
    CoveringFireEffect.bMatchSourceWeapon = false;
    CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
    Template.AddTargetEffect(CoveringFireEffect);
    Template.AddMultiTargetEffect(CoveringFireEffect);
    
    Template.bSkipFireAction = false;
    
    Template.CustomFireAnim = 'HL_SignalHalt';
    Template.CinescriptCameraType = "Overwatch";
    Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

    Template.PostActivationEvents.AddItem('OverwatchUsed');

    Template.BuildVisualizationFn = CallForFire_BuildVisualization;

    return Template;
}

simulated function CallForFire_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  Context;

    local StateObjectReference          SourceUnitRef;
    local StateObjectReference          TargetUnitRef;
    local X2AbilityTemplate             AbilityTemplate;

    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   SourceTrack;
    local VisualizationActionMetadata   TargetTrack;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyoverTarget;
    local X2Action_PlayAnimation        PlayAnimationAction;

    local int                           Index;

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

    SourceUnitRef = Context.InputContext.SourceObject;

    SourceTrack = EmptyTrack;
    SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(SourceUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceUnitRef.ObjectID);
    SourceTrack.VisualizeActor = History.GetVisualizer(SourceUnitRef.ObjectID);

    SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
    SoundAndFlyOver.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, 'Overwatch', eColor_Good, AbilityTemplate.IconImage);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = AbilityTemplate.CustomFireAnim;
    PlayAnimationAction.bFinishAnimationWait = true;

    for (Index = 0; Index < Context.InputContext.MultiTargets.Length; Index++)
    {
        TargetUnitRef = Context.InputContext.MultiTargets[Index];
        if (TargetUnitRef.ObjectID != 0 && TargetUnitRef.ObjectID != SourceUnitRef.ObjectID)
        {
            TargetTrack = EmptyTrack;
            TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
            TargetTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
            TargetTrack.VisualizeActor = History.GetVisualizer(TargetUnitRef.ObjectID);

            SoundAndFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
            SoundAndFlyoverTarget.SetSoundAndFlyOverParameters(none, AbilityTemplate.LocFlyOverText, 'None', eColor_Good, AbilityTemplate.IconImage);
        }
    }
}

static function X2AbilityTemplate ColdBlooded()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ColdBlooded              Effect;
    
    Template = Passive('M31_ColdBlooded', "img:///UILibrary_FavidsPerkPack.Perk_Ph_ColdBlooded", false, true);

    Effect = new class'X2Effect_ColdBlooded';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_ColdBlooded_ActivationsPerTurn");
    Effect.AllowedAbilities = default.ColdBlooded_AllowedAbilities;
    Effect.AllowedEffects = default.ColdBlooded_AllowedEffects;
    Effect.bMatchSourceWeapon = false;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate CombatAdvance()
{
    local X2AbilityTemplate             Template;
    local X2Effect_GrantActionPoints    ActionPointEffect;
    local array<name>                   SkipExclusions;
    
    Template = MovingMelee('M31_CombatAdvance', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Reckoning", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_CombatAdvance_Cooldown"));

    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddShooterEffect(ActionPointEffect);

    return Template;
}

static function X2AbilityTemplate ConcussiveGrenades() 
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_ConcussiveGrenades', "img:///UILibrary_MZChimeraIcons.Grenade_Plasma", false, true);
    
    return Template;
}

static function X2AbilityTemplate ControlledDetonation() 
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ControlledDetonation     Effect;

    Template = Passive('M31_ControlledDetonation', "img:///UILibrary_LWOTC.LW_AbilityCombatEngineer", false, true);
    
    Effect = new class'X2Effect_ControlledDetonation';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate CovertParkour() 
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_CovertParkour', "img:///UILibrary_LW_PerkPack.LW_AbilityCovert", false, false);
    
    Template.AdditionalAbilities.AddItem('Covert');
    Template.AdditionalAbilities.AddItem('ABB_Parkour');

    return Template;
}

static function X2AbilityTemplate DeathAdder()
{
    local X2AbilityTemplate Template;
    local X2Effect_Shredder DamageEffect;

    Template = Attack('M31_DeathAdder', "img:///UILibrary_PerkIcons.UIPerk_ruptured", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bBypassSustainEffects = true;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(DamageEffect);

    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_DeathAdder_Cooldown"));

    Template.AdditionalAbilities.AddItem('M31_DeathAdder_Bonus');

    return Template;
}

static function X2AbilityTemplate DeathAdderBonus()
{
    local X2AbilityTemplate                         Template;
    local X2Effect_DeathAdderBonus                  Effect;
    
    Template = Passive('M31_DeathAdder_Bonus', "img:///UILibrary_PerkIcons.UIPerk_ruptured", false, false);

    Effect = new class'X2Effect_DeathAdderBonus';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate DedicatedOverwatch()
{
    local X2AbilityTemplate Template;
    local X2Effect_DedicatedOverwatch Effect;

    Template = Passive('M31_DedicatedOverwatch', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_defense", false, true);

    Effect = new class'X2Effect_DedicatedOverwatch';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate Dervish()
{
    local X2AbilityTemplate                     Template;

    Template = Passive('M31_Dervish', "img:///UILibrary_MZChimeraIcons.Ability_Recharge", false, true);

    Template.AdditionalAbilities.AddItem('M31_Dervish_Trigger');

    return Template;
}

static function X2AbilityTemplate DervishTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_ReduceCooldowns          Effect;

    Template = SelfTargetTrigger('M31_Dervish_Trigger', "img:///UILibrary_MZChimeraIcons.Ability_Recharge");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'M31_Helpers'.static.KillMailListener_Self;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.Amount = `GetConfigInt("M31_Dervish_CooldownReduction");
    Effect.ReduceAll = false;
    Template.AddTargetEffect(Effect);

    AddUnitValueCondition(Template, 'M31_Dervish', `GetConfigInt("M31_Dervish_ActivationsPerTurn"));

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate DisarmingShot()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;

    Template = Attack('M31_DisarmingShot', "img:///UILibrary_MeristPerkIcons.UIPerk_DisarmingShot", false, true);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
    Template.HideIfAvailable.AddItem('M31_DisarmingShot_SnapShot');

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_DisarmingShot_AmmoCost"));

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_DisarmingShot_Cooldown");
    Cooldown.AddAdditionalCooldownInfo('M31_DisarmingShot_SnapShot',, true);
    Template.AbilityCooldown = Cooldown;

    // Template.AbilityTargetConditions.AddItem(new class'X2Condition_DisarmWeapon');
    Template.AddTargetEffect(new class'X2Effect_DisarmWeapon');
    Template.AddTargetEffect(CreateDisarmingShotEffect(Template));

    AddSuppressedCondition(Template);

    Template.AdditionalAbilities.AddItem('M31_DisarmingShot_SnapShot');

    return Template;
}

static function X2AbilityTemplate DisarmingShotSnap()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_CanAffordCost     CostCondition;

    Template = Attack('M31_DisarmingShot_SnapShot', "img:///UILibrary_MeristPerkIcons.UIPerk_DisarmingShot", false, true);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    // Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_DisarmingShot_AmmoCost"));

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_DisarmingShot_Cooldown");
    Cooldown.AddAdditionalCooldownInfo('M31_DisarmingShot',, true);
    Template.AbilityCooldown = Cooldown;

    // Template.AbilityTargetConditions.AddItem(new class'X2Condition_DisarmWeapon');
    Template.AddTargetEffect(new class'X2Effect_DisarmWeapon');
    Template.AddTargetEffect(CreateDisarmingShotEffect(Template));

    AddSuppressedCondition(Template);
    
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('SnapShot');
    Template.AbilityShooterConditions.Additem(AbilityCondition);

    CostCondition = new class'X2Condition_CanAffordCost';
    CostCondition.AbilityName = 'M31_DisarmingShot';
    CostCondition.bValidateActionPointCost = true;
    CostCondition.bFailIfCanAfford = true;
    Template.AbilityShooterConditions.Additem(CostCondition);
    
    return Template;
}

static function X2AbilityTemplate Duskborn()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Duskborn                  Effect;

    Template = Passive('M31_Duskborn', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_shot2", false, true);

    Effect = new class'X2Effect_Duskborn';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_Duskborn_Trigger');

    return Template;
}

static function X2AbilityTemplate DuskbornTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_Persistent               Effect;

    Template = SelfTargetTrigger('M31_Duskborn_Trigger', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_shot2");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 60;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = class'X2Effect_Duskborn'.default.RequiredEffect;
    Effect.DuplicateResponse = eDupe_Refresh;
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Duskborn_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Duskborn_BonusText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate EMPBomber()
{
    local X2AbilityTemplate     Template;
    local X2Effect_EMPBomber    NeedleEffect;

    Template = Passive('M31_EMPBomber', "img:///UILibrary_MeristPerkIcons.UIPerk_EMPPlus", false, true);
    
    NeedleEffect = new class'X2Effect_EMPBomber';
    NeedleEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(NeedleEffect);
    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.AddGrenadeEffect('EMPGrenade'));

    return Template;
}

static function X2AbilityTemplate EnemyUnknown()
{
    local X2AbilityTemplate                     Template;

    Template = Passive('M31_EnemyUnknown', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow", false, true);

    Template.AdditionalAbilities.AddItem('M31_EnemyUnknown_Trigger');

    return Template;
}

static function X2AbilityTemplate EnemyUnknownTrigger()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Effect_EnemyUnknown                 Effect;

    Template = SelfTargetTrigger('M31_EnemyUnknown_Trigger', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'PlayerTurnBegun';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.Priority = 50;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotVisibleToEnemies');
    Template.AddShooterEffectExclusions();

    Effect = new class'X2Effect_EnemyUnknown';
    Effect.AddPersistentStatChange(eStat_Mobility, float(`GetConfigInt("M31_EnemyUnknown_MobilityBonus")));
    Effect.AddPersistentStatChange(eStat_Dodge, float(`GetConfigInt("M31_EnemyUnknown_DodgeBonus")));
    Effect.AddPersistentStatChange(eStat_Defense, float(`GetConfigInt("M31_EnemyUnknown_DefenseBonus")));
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(Effect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate EnergyShield()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCooldown_Extended        Cooldown;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_EnhancedEnergyShield     ShieldEffect;
    local X2Effect_RemoveEffects            RemoveEffect;

    Template = SelfTargetActivated('M31_EnergyShield', "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    Template.Hostility = eHostility_Defensive;

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_EnergyShield_Cooldown");
    Cooldown.CooldownModifiers = default.EnergyShield_CooldownModifiers;
    Template.AbilityCooldown = Cooldown;

    AddCharges(Template, `GetConfigInt("M31_EnergyShield_Charges"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeCivilian = true;
    // UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_EnergyShield_Radius"));
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    RemoveEffect = new class'X2Effect_RemoveEffects';
    RemoveEffect.EffectNamesToRemove.AddItem('M31_EnergyShield');
    RemoveEffect.bDoNotVisualize = true;
    Template.AddTargetEffect(RemoveEffect);
    Template.AddMultiTargetEffect(RemoveEffect);

    ShieldEffect = new class'X2Effect_EnhancedEnergyShield';
    ShieldEffect.EffectName = 'M31_EnergyShield';
    ShieldEffect.ShieldAmount = `GetConfigArrayInt("M31_EnergyShield_ShieldAmount");
    ShieldEffect.ShieldPriority = `GetConfigInt("M31_EnergyShield_ShieldPriority");
    ShieldEffect.bGetShieldAmountFromArmor = true;
    ShieldEffect.BuildPersistentEffect(`GetConfigInt("M31_EnergyShield_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Shield_BonusText"), Template.IconImage,,, Template.AbilitySourceName);
    ShieldEffect.EffectRemovedVisualizationFn = class'X2Ability_AdventShieldBearer'.static.OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(ShieldEffect);
    Template.AddMultiTargetEffect(ShieldEffect);
    
    Template.bSkipFireAction = false;
    
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.BuildVisualizationFn = EnergyShield_BuildVisualization;

    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    return Template;
}

simulated function EnergyShield_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference InteractingUnitRef;
    local VisualizationActionMetadata EmptyTrack;
    local VisualizationActionMetadata ActionMetadata;
    local X2Action_PlayAnimation PlayAnimationAction;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = Context.InputContext.SourceObject;

    // Configure the visualization track for the shooter
    // ****************************************************************************************
    ActionMetadata = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_EnergyShield';
}

static function X2AbilityTemplate EnhancedLowProfile()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_EnhancedLowProfile       Effect;
    
    Template = Passive('M31_LowProfile', "img:///UILibrary_MeristPerkIcons.UIPerk_LowProfile", false, true);

    Effect = new class'X2Effect_EnhancedLowProfile';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Entrench()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        AbilityActionPointCost;
    local X2Condition_UnitProperty          PropertyCondition;
    local X2Effect_HunkerDown_LW            HunkerDownEffect;
    local X2Condition_UnitEffects           UnitEffectsCondition;
    local array<name>                       SkipExclusions;
    local X2Effect_SetUnitValue             UnitValueEffect;
    
    Template = SelfTargetActivated('M31_Entrench', "img:///UILibrary_PerkIcons.UIPerk_one_for_all", true);

    Template.OverrideAbilities.AddItem('HunkerDown');

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    Template.Hostility = eHostility_Defensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY;
    Template.bDisplayInUITooltip = false;

    AbilityActionPointCost = ActionPointCost(eCost_SingleConsumeAll);
    AbilityActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
    Template.AbilityCosts.AddItem(AbilityActionPointCost);
    
    PropertyCondition = new class'X2Condition_UnitProperty';
    PropertyCondition.ExcludeDead = true;                           // Can't hunkerdown while dead
    PropertyCondition.ExcludeFriendlyToSource = false;              // Self targeted
    PropertyCondition.ExcludeNoCover = true;                        // Unit must be in cover.
    Template.AbilityShooterConditions.AddItem(PropertyCondition);

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    UnitEffectsCondition = new class'X2Condition_UnitEffects';
    UnitEffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
    UnitEffectsCondition.AddExcludeEffect('Entrench', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

    HunkerDownEffect = new class'X2Effect_HunkerDown_LW';
    HunkerDownEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage);
    HunkerDownEffect.EffectAddedFn = Entrench_EffectAdded;
    Template.AddTargetEffect(HunkerDownEffect);

    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.UnitName = 'M31_EntrenchActivated';
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(UnitValueEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;

    Template.AdditionalAbilities.AddItem('M31_Entrench_Trigger');
    
    return Template;
}

static function Entrench_EffectAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;
    local XComGameState_Unit UnitState;
    local XComGameState_Effect EffectGameState;

    UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    EffectGameState = UnitState.GetUnitAffectedByEffectState(PersistentEffect.EffectName);

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EventMgr.RegisterForEvent(EffectObj, 'ObjectMoved', EffectGameState.GenerateCover_ObjectMoved, ELD_OnStateSubmitted, , UnitState);
}

static function X2AbilityTemplate EntrenchTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitEffectsOnSource   EffectCondition;
    local X2Condition_UnitValue             ValueCondition;
    local X2Effect_SetUnitValue             UnitValueEffect;

    Template = SelfTargetTrigger('M31_Entrench_Trigger', "img:///UILibrary_PerkIcons.UIPerk_one_for_all");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('HunkerDown', 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(EffectCondition);

    ValueCondition = new class'X2Condition_UnitValue';
    ValueCondition.AddCheckValue('M31_EntrenchActivated', 1, eCheck_LessThan);
    Template.AbilityTargetConditions.AddItem(ValueCondition);

    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.UnitName = 'M31_EntrenchActivated';
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(UnitValueEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate EyeOnTarget()
{
    local X2AbilityTemplate                                 Template;

    Template = Passive('M31_EyeOnTarget', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", false, false);

    Template.AdditionalAbilities.AddItem('ShadowOps_ThisOnesMine');
    Template.AdditionalAbilities.AddItem('ShadowOps_WatchfulEye');

    return Template;
}

static function X2AbilityTemplate Escalation()
{
    local X2AbilityTemplate             Template;
    local X2Effect_Escalation           Effect;

    Template = SelfTargetActivated('M31_Escalation', "img:///UILibrary_MZChimeraIcons.Ability_Supercharge", false);

    AddActionPointCost(Template, eCost_Free);
    AddCooldown(Template, `GetConfigInt("M31_Escalation_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_Escalation_Charges"));

    Effect = new class'X2Effect_Escalation';
    Effect.CritBonus = `GetConfigInt("M31_Escalation_CritBonus");
    Effect.CritDamageBonus = `GetConfigInt("M31_Escalation_CritDamageBonus");
    Effect.CritDamageBonusFactor = `GetConfigInt("M31_Escalation_CritDamageBonusFactor");
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Escalation_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_CA_Escalation_BonusText"), Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.ActivationSpeech = 'InTheZone';

    return Template;
}

static function X2AbilityTemplate Frostbane()
{
    local X2AbilityTemplate     Template;
    local X2Effect_FrostBonus   Effect;

    Template = Passive('M31_Frostbane', "img:///UILibrary_MPP.Shatter", false, true);

    Effect = new class'X2Effect_FrostBonus';
    Effect.FriendlyName = Template.LocFriendlyName;
    Effect.EffectName = 'M31_Frostbane';
    Effect.CritBase = `GetConfigInt("M31_Frostbane_CritBonus");
    Effect.CritPerTier = `GetConfigInt("M31_Frostbane_CritBonusPerTier");
    Effect.PierceBase = `GetConfigInt("M31_Frostbane_PiercingBonus");
    Effect.PiercePerTier = `GetConfigInt("M31_Frostbane_PiercingBonusPerTier");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_Frostbane_bMatchSourceWeapon");
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate FutureWarfare()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_FutureWarfare', "img:///UILibrary_MZChimeraIcons.Ability_Recharge", false, true);
    
    Template.AdditionalAbilities.AddItem('M31_FutureWarfare_Trigger');

    return Template;
}

static function X2AbilityTemplate FutureWarfareTrigger()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Effect_ReduceCooldowns              Effect;

    Template = SelfTargetTrigger('M31_FutureWarfare_Trigger', "img:///UILibrary_MZChimeraIcons.Ability_Recharge");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_FutureWarfare;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.Amount = `GetConfigInt("M31_FutureWarfare_CooldownReduction");
    Effect.AbilitiesToTick = default.FutureWarfare_AllowedAbilities;
    Effect.ReduceAll = false;
    Template.AddTargetEffect(Effect);
    
    AddUnitValueCondition(Template, 'M31_FutureWarfare_Counter', `GetConfigInt("M31_FutureWarfare_ActivationsPerTurn"));

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_FutureWarfare(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability         EventAbilityState;
    local XComGameState_Ability         AbilityState;
    local XComGameStateContext_Ability  AbilityContext;

    EventAbilityState = XComGameState_Ability(EventData);
    AbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt
        && default.FutureWarfare_AllowedAbilities.Find(EventAbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate GenevaSuggestion()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_GenevaSuggestion', "img:///KetarosPkg_Abilities.UIPerk_bomb", false, false);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.AddGrenadeEffect('AcidGrenade'));
    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.AddGrenadeEffect('GasGrenade'));
    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.AddGrenadeEffect('Firebomb'));

    return Template;
}

static function X2AbilityTemplate Maim()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;

    Template = Attack('M31_Maim', "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom", false, true);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
    Template.HideIfAvailable.AddItem('M31_Maim_SnapShot');

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_Maim_AmmoCost"));

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_Maim_Cooldown");
    Cooldown.AddAdditionalCooldownInfo('M31_Maim_SnapShot',, true);
    Template.AbilityCooldown = Cooldown;

    Template.AddTargetEffect(class'M31_Helpers'.static.CreateMaimedStatusEffect(, Template.AbilitySourceName));

    AddSuppressedCondition(Template);

    Template.AdditionalAbilities.AddItem('M31_Maim_SnapShot');

    return Template;
}

static function X2AbilityTemplate MaimSnap()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_CanAffordCost     CostCondition;

    Template = Attack('M31_Maim_SnapShot', "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom", false, true);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    // Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_Maim_AmmoCost"));

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_Maim_Cooldown");
    Cooldown.AddAdditionalCooldownInfo('M31_Maim',, true);
    Template.AbilityCooldown = Cooldown;

    Template.AddTargetEffect(class'M31_Helpers'.static.CreateMaimedStatusEffect(, Template.AbilitySourceName));

    AddSuppressedCondition(Template);
    
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('SnapShot');
    Template.AbilityShooterConditions.Additem(AbilityCondition);

    CostCondition = new class'X2Condition_CanAffordCost';
    CostCondition.AbilityName = 'M31_Maim';
    CostCondition.bValidateActionPointCost = true;
    CostCondition.bFailIfCanAfford = true;
    Template.AbilityShooterConditions.Additem(CostCondition);
    
    return Template;
}

static function X2AbilityTemplate ManualOverride()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ReduceCooldowns      Effect;

    Template = SelfTargetActivated('M31_ManualOverride', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ManualOverride");
    
    AddActionPointCost(Template, eCost_Single);
    AddCooldown(Template, `GetConfigInt("M31_ManualOverride_Cooldown"));

    AddSuppressedCondition(Template);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_ManualOverride');

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.Amount = `GetConfigInt("M31_ManualOverride_CooldownReduction");
    Effect.ReduceAll = false;
    Template.AddTargetEffect(Effect);

    Template.AbilityConfirmSound = "Manual_Override_Activate";
    Template.ActivationSpeech = 'ManualOverride';

    return Template;
}

static function X2AbilityTemplate ImprovedSuppression()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_ImprovedSuppression', "img:///UILibrary_SOInfantry.UIPerk_improvedsuppression", false, true);

    return Template;
}

static function X2AbilityTemplate LowProfileNest()
{
    local X2AbilityTemplate         Template;
    local X2Effect_LowProfileNest   Effect;
    
    Template = Passive('M31_LowProfileNest', "img:///UILibrary_PerkIcons.UIPerk_eaglesnest", false, true);

    Effect = new class'X2Effect_LowProfileNest';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Malevolence()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_MarkedBonus              Effect;
    local X2Effect_Malevolence_RuptureBonus RuptureEffect;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;
    
    Template = Passive('M31_Malevolence', "img:///UILibrary_MeristPerkIcons.UIPerk_Malevolence", false, true);

    Effect = new class'X2Effect_MarkedBonus';
    Effect.AllowedEffects.AddItem(class'X2StatusEffects'.default.AcidBurningName);
    Effect.ShredBonus = `GetConfigInt("M31_Malevolence_AcidBurning_ShredBonus");
    Effect.bMatchSourceWeapon = false;
    Effect.bApplyToRanged = true;
    Effect.bApplyToMelee = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Effect = new class'X2Effect_MarkedBonus';
    Effect.AllowedEffects.AddItem(class'X2StatusEffects'.default.BleedingName);
    Effect.AllowedEffects.AddItem('StackBleed');
    Effect.CritBonus = `GetConfigInt("M31_Malevolence_Bleeding_CritBonus");
    Effect.CritDamageBonus = `GetConfigInt("M31_Malevolence_Bleeding_CritDamageBonus");
    Effect.bMatchSourceWeapon = false;
    Effect.bApplyToRanged = true;
    Effect.bApplyToMelee = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    RuptureEffect = new class'X2Effect_Malevolence_RuptureBonus';
    RuptureEffect.AllowedEffects.AddItem('MinorRequiemCorrosion');
    RuptureEffect.AllowedEffects.AddItem('RequiemCorrosion');
    RuptureEffect.AllowedEffects.AddItem('HeavyRequiemCorrosion');
    RuptureEffect.AllowedEffects.AddItem('SevereRequiemCorrosion');
    RuptureEffect.AllowedEffects.AddItem('PsiRipple');
    RuptureEffect.bMatchSourceWeapon = false;
    RuptureEffect.bApplyToRanged = true;
    RuptureEffect.bApplyToMelee = true;
    RuptureEffect.BuildPersistentEffect(1, true, false);
    RuptureEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(RuptureEffect);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_Malevolence_Passive';
    PassiveWeaponEffect.AttackName = 'M31_Malevolence_Trigger';
    PassiveWeaponEffect.AdditionalWeaponCategories = default.Malevolence_AllowedCategories;
    PassiveWeaponEffect.EventPriority = 45;
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Malevolence_Trigger');

    return Template;
}

static function X2AbilityTemplate MalevolenceAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_TargetHasOneOfTheEffects  EffectCondition;
    local X2Effect_DamagePenalty            RadiationEffect;
    local X2Effect_VileMix                  BurningEffect;
    local X2Effect_ToHitModifier            PoisonedEffect;
    local X2Effect_PersistentStatChange     FrostEffect;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_Malevolence_Trigger',
        "img:///UILibrary_MeristPerkIcons.UIPerk_Malevolence"
    );

    // RADIATION

    EffectCondition = new class'X2Condition_TargetHasOneOfTheEffects';
    EffectCondition.EffectNames.AddItem(class'X2StatusEffects_Radiation'.default.RadDisorientedName);
    EffectCondition.EffectNames.AddItem(class'X2StatusEffects_Radiation'.default.RadBurningName);
    EffectCondition.EffectNames.AddItem(class'X2StatusEffects_Radiation'.default.RadBleedingName);
    EffectCondition.EffectNames.AddItem('EleriumPoisoning');

    RadiationEffect = new class'X2Effect_DamagePenalty';
    RadiationEffect.DamagePenaltyPrc = `GetConfigInt("M31_Malevolence_Radiation_DamageReductionPrc");
    RadiationEffect.bCeiling = true;

    RadiationEffect.EffectName = 'M31_Malevolence_RadiationEffect';
    RadiationEffect.DuplicateResponse = eDupe_Refresh;
    RadiationEffect.BuildPersistentEffect(`GetConfigInt("M31_Malevolence_Radiation_DebuffDuration"), false, false, false, eGameRule_PlayerTurnEnd);
    RadiationEffect.SetDisplayInfo(ePerkBuff_Penalty, `GetLocalizedString("M31_Malevolence_Radiation_FriendlyName"), `GetLocalizedString("M31_Malevolence_Radiation_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", true,, Template.AbilitySourceName);
    RadiationEffect.TargetConditions.AddItem(EffectCondition);
    Template.AddTargetEffect(RadiationEffect);
    
    // BURNING

    EffectCondition = new class'X2Condition_TargetHasOneOfTheEffects';
    EffectCondition.EffectNames.AddItem(class'X2StatusEffects'.default.BurningName);

    BurningEffect = new class'X2Effect_VileMix';
    BurningEffect.DOTDamageBonus = `GetConfigInt("M31_Malevolence_Burning_DOTDamageBonus");

    BurningEffect.EffectName = 'M31_Malevolence_BurningEffect';
    BurningEffect.DuplicateResponse = eDupe_Refresh;
    BurningEffect.BuildPersistentEffect(`GetConfigInt("M31_Malevolence_Burning_DebuffDuration"), false, false, false, eGameRule_PlayerTurnEnd);
    BurningEffect.SetDisplayInfo(ePerkBuff_Penalty, `GetLocalizedString("M31_Malevolence_Burning_FriendlyName"), `GetLocalizedString("M31_Malevolence_Burning_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", true,, Template.AbilitySourceName);
    BurningEffect.TargetConditions.AddItem(EffectCondition);
    Template.AddTargetEffect(BurningEffect);

    // POISONED

    EffectCondition = new class'X2Condition_TargetHasOneOfTheEffects';
    EffectCondition.EffectNames.AddItem(class'X2StatusEffects'.default.PoisonedName);
    EffectCondition.EffectNames.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
    EffectCondition.EffectNames.AddItem('EleriumPoisoning');

    PoisonedEffect = new class'X2Effect_ToHitModifier';
    PoisonedEffect.AddEffectHitModifier(eHit_Crit, -1 * `GetConfigInt("M31_Malevolence_Poisoned_CritPenalty"), Template.LocFriendlyName);
    PoisonedEffect.AddEffectHitModifier(eHit_Graze, `GetConfigInt("M31_Malevolence_Poisoned_GrazePenalty"), Template.LocFriendlyName);

    PoisonedEffect.EffectName = 'M31_Malevolence_PoisonedEffect';
    PoisonedEffect.DuplicateResponse = eDupe_Allow;
    PoisonedEffect.BuildPersistentEffect(`GetConfigInt("M31_Malevolence_Poisoned_DebuffDuration"), false, false, false, eGameRule_PlayerTurnEnd);
    PoisonedEffect.SetDisplayInfo(ePerkBuff_Penalty, `GetLocalizedString("M31_Malevolence_Poisoned_FriendlyName"), `GetLocalizedString("M31_Malevolence_Poisoned_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", true,, Template.AbilitySourceName);
    PoisonedEffect.TargetConditions.AddItem(EffectCondition);
    Template.AddTargetEffect(PoisonedEffect);

    // FROST

    EffectCondition = new class'X2Condition_TargetHasOneOfTheEffects';
    EffectCondition.EffectNames.AddItem(class'MZ_Effect_Hypothermia'.default.EffectName);
    // EffectCondition.EffectNames.AddItem('Chilled');
    // EffectCondition.EffectNames.AddItem('MZChill');
    // EffectCondition.EffectNames.AddItem('MZBitterChill');
    // EffectCondition.EffectNames.AddItem('Freeze');

    FrostEffect = new class'X2Effect_PersistentStatChange';
    FrostEffect.EffectName = 'M31_Malevolence_FrostEffect';
    FrostEffect.DuplicateResponse = eDupe_Allow;

    FrostEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_Malevolence_Frost_AimPenalty"));
    FrostEffect.AddPersistentStatChange(eStat_Defense, -1 * `GetConfigInt("M31_Malevolence_Frost_DefensePenalty"));

    FrostEffect.BuildPersistentEffect(`GetConfigInt("M31_Malevolence_Frost_DebuffDuration"), false, false, false, eGameRule_PlayerTurnEnd);
    FrostEffect.SetDisplayInfo(ePerkBuff_Penalty, `GetLocalizedString("M31_Malevolence_Frost_FriendlyName"), `GetLocalizedString("M31_Malevolence_Frost_DebuffText"), "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", true,, Template.AbilitySourceName);
    FrostEffect.TargetConditions.AddItem(EffectCondition);
    Template.AddTargetEffect(FrostEffect);
    
    return Template;
}


static function X2AbilityTemplate MarauderElite()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_MarauderElite', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_strike", false, true);

    return Template;
}

static function X2AbilityTemplate Meld()
{
    local X2AbilityTemplate         Template;
    local X2Effect_RangerStealth    StealthEffect;

    Template = SelfTargetActivated('M31_Meld', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_blaze", false);

    AddCooldown(Template, `GetConfigInt("M31_Meld_Cooldown"));
    AddActionPointCost(Template, eCost_Free);

    Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
    Template.AddShooterEffectExclusions();

    StealthEffect = new class'X2Effect_RangerStealth';
    StealthEffect.EffectName = 'M31_Meld';
    StealthEffect.EffectRemovedFn = Meld_EffectRemoved;
    StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    StealthEffect.BuildPersistentEffect(`GetConfigInt("M31_Meld_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    Template.AddTargetEffect(StealthEffect);

    Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

    Template.ActivationSpeech = 'ActivateConcealment';

    return Template;
}

static function Meld_EffectRemoved(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (UnitState != none)
        `XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', UnitState, UnitState, NewGameState);
}

static function X2AbilityTemplate Minelayer2()
{
    local X2AbilityTemplate     Template;
    local X2Effect_AddGrenade   Effect;

    Template = Passive('M31_Minelayer2', "img:///UILibrary_MZChimeraIcons.Item_TeleportDisc", false, true);

    Effect = class'X2Effect_AddGrenade'.static.AddGrenadeEffect('ProximityMine');
    Effect.BaseCharges = 2;
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate NeurotoxicShot()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Persistent               PoisonedEffect;
    local X2Effect_Persistent               DisorientedEffect;

    Template = Attack('M31_NeurotoxicShot', "img:///UILibrary_MZChimeraIcons.Ability_ToxicGreeting", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_NeurotoxicShot_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_NeurotoxicShot_Charges"));

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
    PoisonedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddTargetEffect(PoisonedEffect);

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddTargetEffect(DisorientedEffect);

    Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

    return Template;
}

static function X2AbilityTemplate OnTheMove()
{
    local X2AbilityTemplate     Template;
    local X2Effect_OnTheMove    Effect;
    
    Template = Passive('M31_OnTheMove', "img:///UILibrary_MZChimeraIcons.Ability_Dash", false, true);

    Effect = new class'X2Effect_OnTheMove';
    Effect.AddPersistentStatChange(eStat_Mobility, 1.0 - `GetConfigInt("M31_OnTheMove_MobilityPenaltyPrc") / 100.0, MODOP_PostMultiplication);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate OverchargedBlast()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Effect_Shredder                 DamageEffect;

    Template = Attack('M31_OverchargedBlast', "img:///UILibrary_MeristPerkIcons.UIPerk_Blast", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_OverchargedBlast_AmmoCost"));
    AddCooldown(Template, `GetConfigInt("M31_OverchargedBlast_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_OverchargedBlast_Charges"));

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bHitsAreCrits = `GetConfigBool("M31_OverchargedBlast_bGuaranteedCrit");
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.EffectDamageValue.Shred = `GetConfigInt("M31_OverchargedBlast_Shred");
    DamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_OverchargedBlast_Rupture");
    Template.AddTargetEffect(DamageEffect);
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

static function X2AbilityTemplate Overpower()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_ApplyWeaponDamage        ShredEffect;
    local array<name>                       SkipExclusions;
    
    Template = MovingMelee('M31_Overpower', "img:///UILibrary_SOCombatEngineer.UIPerk_fracture", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Overpower_Cooldown"));

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeLargeUnits = true;

    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_Overpower_StunDuration"), 100, false));
    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

    ShredEffect = new class'X2Effect_ApplyWeaponDamage';
    ShredEffect.bBypassShields = true;
    ShredEffect.bIgnoreBaseDamage = true;
    ShredEffect.bAllowFreeKill = false;
    ShredEffect.bAllowWeaponUpgrade = false;
    ShredEffect.bAppliesDamage = false;
    ShredEffect.EffectDamageValue.Shred = `GetConfigInt("M31_Overpower_Shred");
    ShredEffect.EffectDamageValue.DamageType = 'Melee';
    Template.AddTargetEffect(ShredEffect);

    return Template;
}

static function X2AbilityTemplate Overseer()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_Overseer', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle03", false, false);
    
    AbilitiesToAdd.AddItem('Squadsight');
    AbilitiesToAdd.AddItem('M31_SniperOverwatch');

    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.TrainedSniper_AllowedCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate PerfectHandling()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ModifyRangePenalties Effect;

    Template = Passive('M31_PerfectHandling', "img:///UILibrary_SOHunter.UIPerk_point_blank", false, true);

    Effect = new class'X2Effect_ModifyRangePenalties';
    Effect.RangeOffsetPrc = `GetConfigInt("M31_PerfectHandling_PenaltyModifier");
    Effect.BaseRange = `GetConfigInt("M31_PerfectHandling_BaseRange");
    Effect.bLongRange = true;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Pinpoint()
{
    local X2AbilityTemplate Template;

    Template = Attack('M31_Pinpoint', "img:///UILibrary_MZChimeraIcons.WeaponMod_LaserSight_Sup", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_Pinpoint_Cooldown"));

    Template.AdditionalAbilities.AddItem('M31_Pinpoint_Bonus');

    return Template;
}

static function X2AbilityTemplate PinpointBonus()
{
    local X2AbilityTemplate         Template;
    local X2Effect_PinpointBonus    Effect;

    Template = Passive('M31_Pinpoint_Bonus', "img:///UILibrary_MZChimeraIcons.WeaponMod_LaserSight_Sup", false, false);

    Effect = new class'X2Effect_PinpointBonus';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate PipeBombs()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PipeBombs', "img:///UILibrary_MZChimeraIcons.Ability_ShrapnelGrenade", false, true);
    
    return Template;
}

static function X2AbilityTemplate PriorityFocus()
{
    local X2AbilityTemplate         Template;
    local X2Effect_MarkedBonus      Effect;

    Template = Passive('M31_PriorityFocus', "img:///UILibrary_LWOTC.LW_AbilityVitalPointTargeting", false, true);
    
    Effect = new class'X2Effect_MarkedBonus';
    Effect.AllowedEffects = default.PriorityFocus_AllowedEffects;
    Effect.DamageBonus = `GetConfigInt("M31_PriorityFocus_DamageBonus");
    Effect.bApplyToRanged = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate RapidDumping()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_RapidDumping', "img:///UILibrary_PerkIcons.UIPerk_gremlincommand", false, true);
    
    return Template;
}

static function X2AbilityTemplate PistolDetonationShot()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_TriggerEvent             InsanityEvent;

    Template = Attack('M31_PistolDetonationShot', "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PistolDetonationShot_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_DetonationShot_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    Template.TargetingMethod = class'X2TargetingMethod_Fuse';
    Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
    InsanityEvent.ApplyChance = 100;
    Template.AddTargetEffect(InsanityEvent);

    AddSuppressedCondition(Template);

    Template.DamagePreviewFn = DetonationShotDamagePreview;

    return Template;
}

function bool DetonationShotDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local XComGameStateHistory History;
    local XComGameState_Ability FuseTargetAbility;
    local XComGameState_Unit TargetUnit;
    local StateObjectReference EmptyRef, FuseRef;

    AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

    History = `XCOMHISTORY;
    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
    if (TargetUnit != none)
    {
        if (class'X2Condition_FuseTarget'.static.GetAvailableFuse(TargetUnit, FuseRef))
        {
            FuseTargetAbility = XComGameState_Ability(History.GetGameStateForObjectID(FuseRef.ObjectID));
            if (FuseTargetAbility != None)
            {
                FuseTargetAbility.GetDamagePreview(EmptyRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
                return true;
            }
        }
    }
    return false;
}

static function X2AbilityTemplate PistolDisarmingShot()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCost_ActionPoints    ActionPointCost;

    Template = Attack('M31_PistolDisarmingShot', "img:///UILibrary_MeristPerkIcons.UIPerk_DisarmingShot", false, false);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PistolDisarmingShot_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_DisarmingShot_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    // Template.AbilityTargetConditions.AddItem(new class'X2Condition_DisarmWeapon');
    Template.AddTargetEffect(new class'X2Effect_DisarmWeapon');
    Template.AddTargetEffect(CreateDisarmingShotEffect(Template));

    AddSuppressedCondition(Template);

    return Template;
}

static function X2Effect_ToHitModifier CreateDisarmingShotEffect(X2AbilityTemplate Template)
{
    local X2Effect_ToHitModifier Effect;

    Effect = new class'X2Effect_ToHitModifier';
    Effect.EffectName = 'M31_DisarmingShot_Penalty';
    Effect.AddEffectHitModifier(eHit_Success, -1 * `GetConfigInt("M31_DisarmingShot_AimPenalty"), Template.LocFriendlyName);
    Effect.AddEffectHitModifier(eHit_Crit, -1 * `GetConfigInt("M31_DisarmingShot_CritPenalty"), Template.LocFriendlyName);
    Effect.BuildPersistentEffect(`GetConfigInt("M31_DisarmingShot_Duration"), false, false, true, eGameRule_PlayerTurnEnd);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_DisarmingShot_DebuffText"), Template.IconImage,,, Template.AbilitySourceName);
    Effect.DuplicateResponse = eDupe_Refresh;

    return Effect;
}

static function X2AbilityTemplate PistolMaim()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    Template = Attack('M31_PistolMaim', "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PistolMaim_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_Maim_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    Template.AddTargetEffect(class'M31_Helpers'.static.CreateMaimedStatusEffect(, Template.AbilitySourceName));

    AddSuppressedCondition(Template);

    return Template;
}

static function X2AbilityTemplate ReflexShot()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_ReflexShot', "img:///UILibrary_MeristPerkIcons.UIPerk_ReflexShot", false, true);
    
    Template.AdditionalAbilities.AddItem('M31_ReflexShot_Attack');

    return Template;
}

static function X2AbilityTemplate ReflexShotAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;

    Template = Attack('M31_ReflexShot_Attack', "img:///UILibrary_MeristPerkIcons.UIPerk_ReflexShot", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = false;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.RequireWithinRange = true;
    UnitPropertyCondition.WithinRange = `GetConfigFloat("M31_ReflexShot_Radius") * class'XComWorldData'.const.WORLD_StepSize;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    AddBladestormMark(Template, 'M31_ReflexShot_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_ReflexShot_Counter', `GetConfigInt("M31_ReflexShot_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = `GetConfigBool("M31_ReflexShot_bReactionFire");
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate Relentless()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Relentless   Effect;
    
    Template = Passive('M31_Relentless', "img:///UILibrary_SOCombatEngineer.UIPerk_skirmisher", false, true);

    Effect = new class'X2Effect_Relentless';
    Effect.AllowedAbilities = default.Relentless_AllowedAbilities;
    Effect.ActivationsPerTurn = `GetConfigInt("M31_Relentless_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate RepositionPlus()
{
    local X2AbilityTemplate     Template;
    local X2Effect_HitAndRun    Effect;
    
    Template = Passive('M31_RepositionPlus', "img:///UILibrary_SOCombatEngineer.UIPerk_skirmisher", false, true);

    Effect = new class'X2Effect_HitAndRun';
    Effect.CounterName = 'RepositionUses';
    Effect.AllowedAbilities = default.Reposition_AllowedAbilities;
    Effect.bApplyToUnflankable = `GetConfigBool("M31_RepositionPlus_bApplyToUnflankable");
    Effect.ActivationsPerTurn = `GetConfigInt("M31_RepositionPlus_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate SaltInTheWound()
{
    local X2AbilityTemplate         Template;
    local X2Effect_SaltInTheWound   Effect;
    
    Template = Passive('M31_SaltInTheWound', "img:///UILibrary_XPerkIconPack.UIPerk_poison_shot", false, true);

    Effect = new class'X2Effect_SaltInTheWound';
    Effect.DamageBonus = `GetConfigInt("M31_SaltInTheWound_DamageBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SawedOffRange()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ModifyRangeTable     Effect;
    
    Template = Passive('M31_SawedOffRange', "img:///UILibrary_SOHunter.UIPerk_point_blank", false, true);

    Effect = new class'X2Effect_ModifyRangeTable';
    Effect.IndexLast = `GetConfigInt("M31_SawedOffRange_LastIndex");
    Effect.NewIndexLast = `GetConfigInt("M31_SawedOffRange_NewLastIndex");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SawedOffReload()
{
    local X2AbilityTemplate             Template;
    local array<name>                   SkipExclusions;
    local X2Condition_SawedOffReload    SawedOffCondition;
    local X2Effect_ReloadWeapon         ReloadEffect;
    local X2AbilityCharges_Tech         Charges;
    local X2AbilityCost_Charges         ChargeCost;
    
    Template = SelfTargetActivated('M31_SawedOffReload', "img:///BstarsPerkPack_Icons.UIPerk_ReloadSawedOff", false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY + 1;

    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    AddActionPointCost(Template, eCost_Single);

    SawedOffCondition = new class'X2Condition_SawedOffReload';
    SawedOffCondition.AmmoLimitBase = `GetConfigInt("M31_SawedOffReload_BaseLimit") - `GetConfigInt("M31_SawedOffReload_AmmoPerUse") + 1;
    SawedOffCondition.PumpActionBonus = `GetConfigInt("M31_SawedOffReload_PumpAction_BonusLimit");
    Template.AbilityShooterConditions.AddItem(SawedOffCondition);

    Charges = new class'X2AbilityCharges_Tech';
    Charges.InitialChargesFromTech = `GetConfigArrayInt("M31_SawedOffReload_Charges");
    Charges.AddBonusCharge('PumpAction', `GetConfigInt("M31_SawedOffReload_PumpAction_BonusCharges"));
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    ReloadEffect = new class'X2Effect_ReloadWeapon';
    ReloadEffect.AmmoToReload = `GetConfigInt("M31_SawedOffReload_AmmoPerUse");
    ReloadEffect.bSkipClipSizeCheck = true;
    Template.AddTargetEffect(ReloadEffect);

    Template.ActivationSpeech = 'Reloading';
    Template.CinescriptCameraType = "GenericAccentCam";
    
    return Template;
}

static function X2AbilityTemplate SawedOffSweeper()
{
    local X2AbilityTemplate                             Template;
    local X2AbilityMultiTarget_Cone_SawedOffSweeper     ConeMultiTarget;
    local X2AbilityTarget_Cursor                        CursorTarget;
    local X2AbilityCost_ActionPoints                    ActionPointCost;
    local X2AbilityCost_Ammo_Extended                   AmmoCost;
    local X2Effect_Knockback                            KnockbackEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SawedOffSweeper');

    Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
    AddSuppressedCondition(Template);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
        
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_SawedOffSweeper';
    
    ConeMultiTarget.BaseConeEndDiameter = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_Width"));
    ConeMultiTarget.BaseConeLength = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_Length"));
    ConeMultiTarget.ConeEndDiameterPerAmmo = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_WidthPerAmmo"));
    ConeMultiTarget.ConeLengthPerAmmo = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_LengthPerAmmo"));

    // ConeMultiTarget.BaseConeEndDiameter = `GetConfigInt("M31_SawedOffSweeper_Width") * class'XComWorldData'.const.WORLD_StepSize;
    // ConeMultiTarget.BaseConeLength = `GetConfigInt("M31_SawedOffSweeper_Length") * class'XComWorldData'.const.WORLD_StepSize;
    // ConeMultiTarget.ConeEndDiameterPerAmmo = `GetConfigInt("M31_SawedOffSweeper_WidthPerAmmo") * class'XComWorldData'.const.WORLD_StepSize;
    // ConeMultiTarget.ConeLengthPerAmmo = `GetConfigInt("M31_SawedOffSweeper_LengthPerAmmo") * class'XComWorldData'.const.WORLD_StepSize;

    ConeMultiTarget.MinAmmo = `GetConfigInt("M31_SawedOffSweeper_MinAmmo");
    ConeMultiTarget.MaxAmmo = `GetConfigInt("M31_SawedOffSweeper_MaxAmmo");

    ConeMultiTarget.fTargetRadius = 99;
    ConeMultiTarget.bIgnoreBlockingCover = false;
    ConeMultiTarget.bUseWeaponRangeForLength = false;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Template.TargetingMethod = class'X2TargetingMethod_Cone';
    Template.bCheckCollision = true;
    // Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    if (`GetConfigBool("M31_SawedOffSweeper_bHipfire"))
    {
        ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Hipfire_LW');
    }
    Template.AbilityCosts.AddItem(ActionPointCost);

    AmmoCost = new class'X2AbilityCost_Ammo_Extended';
    AmmoCost.iAmmo = `GetConfigInt("M31_SawedOffSweeper_MinAmmo");
    AmmoCost.iAmmoMax = `GetConfigInt("M31_SawedOffSweeper_MaxAmmo");
    AmmoCost.bConsumeAllAmmo = true;
    Template.AbilityCosts.AddItem(AmmoCost);

    AddCooldown(Template, `GetConfigInt("M31_SawedOffSweeper_Cooldown"));

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

    KnockbackEffect = new class'X2Effect_Knockback';
    KnockbackEffect.KnockbackDistance = 2;
    Template.AddMultiTargetEffect(KnockbackEffect);

    Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'SaturationFire';
    Template.CinescriptCameraType = "Grenadier_SaturationFire";

    Template.bShowActivation = true;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    return Template;
}

static function X2AbilityTemplate ShadowstepAid()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_ShadowstepAid', "img:///UILibrary_MeristPerkIcons.UIPerk_ShadowstepAid", false, true);
    
    return Template;
}

static function X2AbilityTemplate ShockGrenadier()
{
    local X2AbilityTemplate     Template;

    Template = Passive('M31_ShockGrenadier', "img:///UILibrary_MeristPerkIcons.UIPerk_ShockBox", false, true);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.AddGrenadeEffect('EMPGrenade'));

    return Template;
}

static function X2AbilityTemplate ShotgunWedding()
{
    local X2AbilityTemplate             Template;
    local X2AbilityMultiTarget_Cone     ConeMultiTarget;
    local X2Effect_TriggerEvent         InsanityEvent;
    local X2Effect_SetUnitValue         UnitValueEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_ShotgunWedding');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_saturationfire";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    Template.AbilityToHitCalc = default.DeadEye;
        
    Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.ConeEndDiameter = `GetConfigInt("M31_ShotgunWedding_Width") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.ConeLength = `GetConfigInt("M31_ShotgunWedding_Length") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.fTargetRadius = 99;
    ConeMultiTarget.bIgnoreBlockingCover = true;
    ConeMultiTarget.bUseWeaponRangeForLength = false;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Template.TargetingMethod = class'X2TargetingMethod_Cone';

    AddAmmoCost(Template, `GetConfigInt("M31_ShotgunWedding_AmmoCost") + `GetConfigInt("M31_ShotgunWedding_AmmoCostPerShot"), true);
    AddAmmoCost(Template, `GetConfigInt("M31_ShotgunWedding_AmmoCost"));

    AddCooldown(Template, `GetConfigInt("M31_ShotgunWedding_Cooldown"));
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = 'M31_ShotgunWedding_Event';
    InsanityEvent.ApplyChance = 100;
    Template.AddMultiTargetEffect(InsanityEvent);

    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.UnitName = 'M31_ShotgunWedding_Counter';
    UnitValueEffect.NewValueToSet = 0;
    UnitValueEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddShooterEffect(UnitValueEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'SaturationFire';
    Template.CinescriptCameraType = "Grenadier_SaturationFire";

    Template.bSkipFireAction = true;
    Template.bShowActivation = true;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.AdditionalAbilities.AddItem('M31_ShotgunWedding_Attack');

    Template.DamagePreviewFn = ShotgunWeddingDamagePreview;

    return Template;
}

function bool ShotgunWeddingDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local XComGameState_Unit        SourceUnit;
    local StateObjectReference      AttackAbilityRef;
    local XComGameState_Ability     AttackAbility;
    local XComGameStateHistory      History;

    History = `XCOMHISTORY;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    AttackAbilityRef = SourceUnit.FindAbility('M31_ShotgunWedding_Attack');
    AttackAbility = XComGameState_Ability(History.GetGameStateForObjectID(AttackAbilityRef.ObjectID));
    if (AttackAbility != none)
    {
         AttackAbility.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
    }

    return true;
}

static function X2AbilityTemplate ShotgunWeddingAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityMultiTarget_Cone         ConeMultiTarget;
    local X2Effect_Knockback                KnockbackEffect;
    local X2Condition_ValidWeapon           ShotgunCondition;
    
    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_ShotgunWedding_Attack');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_saturationfire";
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Offensive;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_ShotgunWedding_Event';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 55;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    ShotgunCondition = new class'X2Condition_ValidWeapon';
    ShotgunCondition.AllowedWeaponCategories = default.ShotgunWedding_AllowedCategories;
    Template.AbilityShooterConditions.AddItem(ShotgunCondition);

    Template.AddShooterEffectExclusions();
    AddUnitValueCondition(Template, 'M31_ShotgunWedding_Counter', `GetConfigInt("M31_ShotgunWedding_MaxNumShots"));

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.ConeEndDiameter = `GetConfigInt("M31_ShotgunWedding_Width") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.ConeLength = `GetConfigInt("M31_ShotgunWedding_Length") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.fTargetRadius = 99;
    ConeMultiTarget.bIgnoreBlockingCover = true;
    ConeMultiTarget.bUseWeaponRangeForLength = false;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

    AddAmmoCost(Template, `GetConfigInt("M31_ShotgunWedding_AmmoCostPerShot"));

    KnockbackEffect = new class'X2Effect_Knockback';
    KnockbackEffect.KnockbackDistance = 2;
    Template.AddMultiTargetEffect(KnockbackEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
    Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
        
    Template.TargetingMethod = class'X2TargetingMethod_TopDown';

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.CinescriptCameraType = "Grenadier_SaturationFire";

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.bFragileDamageOnly = true;

    return Template;
}

static function X2AbilityTemplate Skykeeper()
{
    local X2AbilityTemplate         Template;
    local X2Effect_Skykeeper        Effect;
    
    Template = Passive('M31_Skykeeper', "img:///UILibrary_MeristPerkIcons.UIPerk_Skykeeper", false, true);

    Effect = new class'X2Effect_Skykeeper';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SleightOfHand()
{
    local X2AbilityTemplate         Template;
    local X2Effect_SleightOfHand    Effect;
    
    Template = Passive('M31_SleightOfHand', "img:///UILibrary_MeristPerkIcons.UIPerk_Gunslinger", false, true);

    Effect = new class'X2Effect_SleightOfHand';
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_SleightOfHand_bMatchSourceWeapon");
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_SleightOfHand_BuffText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SmokeGrenadier()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_SmokeGrenadier', "img:///UILibrary_XPerkIconPack.UIPerk_smoke_box", false, true);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.AddGrenadeEffect('SmokeGrenade'));

    return Template;
}

static function X2AbilityTemplate SniperElite()
{
    local X2AbilityTemplate         Template;
    local X2Effect_SniperElite      Effect;
    
    Template = Passive('M31_SniperElite', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_farsight", false, true);

    Effect = new class'X2Effect_SniperElite';
    Effect.AllowedEffects = default.SniperElite_AllowedEffects;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SniperOverwatch()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Cone             ConeMultiTarget;
    local X2Effect_ReserveActionPoints          ReservePointsEffect;
    local X2Effect_MarkValidActivationTiles     MarkTilesEffect;

    Template = SelfTargetActivated('M31_SniperOverwatch', "img:///UILibrary_MZChimeraIcons.Ability_Overwatch", false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
    Template.Hostility = eHostility_Defensive;

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = false;
    Template.AbilityTargetStyle = CursorTarget;

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.ConeEndDiameter = `GetConfigInt("M31_SniperOverwatch_Width") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.ConeLength = `GetConfigInt("M31_SniperOverwatch_Length") * class'XComWorldData'.const.WORLD_StepSize;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;
    Template.TargetingMethod = class'X2TargetingMethod_Cone';

    ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
    ReservePointsEffect.ReserveType = default.SniperOverwatchActionPoint;
    ReservePointsEffect.NumPoints = 1;
    Template.AddShooterEffect(ReservePointsEffect);

    MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
    MarkTilesEffect.AbilityToMark = 'M31_SniperOverwatch_Attack';
    Template.AddShooterEffect(MarkTilesEffect);

    AddSuppressedCondition(Template);

    AddCooldown(Template, 1);
    AddActionPointCost(Template, eCost_OverwatchWeapon);
    AddAmmoCost(Template, 1, true);

    Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

    Template.PostActivationEvents.AddItem('OverwatchUsed');

    Template.AdditionalAbilities.AddItem('M31_SniperOverwatch_Attack');

    return Template;
}

static function X2AbilityTemplate SniperOverwatchAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_AbilityProperty       AbilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;

    Template = Attack('M31_SniperOverwatch_Attack', "img:///UILibrary_MZChimeraIcons.Ability_Vigilance", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.TargetMustBeInValidTiles = true;
    Template.AbilityTargetConditions.AddItem(AbilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = `GetConfigBool("M31_SniperOverwatch_bExcludeConcealed");
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AddShooterEffectExclusions();

    AddBladestormMark(Template, 'M31_SniperOverwatch_MarkTarget');
    AddSuppressedCondition(Template);

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;
    ReserveActionPointCost.bFreeCost = false;
    ReserveActionPointCost.AllowedTypes.AddItem(default.SniperOverwatchActionPoint);
    Template.AbilityCosts.AddItem(ReserveActionPointCost);

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate SoldierOfFortune()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_SoldierOfFortune', "img:///UILibrary_MZChimeraIcons.Ability_TaskForce", false, false);
    
    return Template;
}

static function X2AbilityTemplate SolidSnake()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ModifyRangePenalties     RangeEffect;
    local X2Effect_SolidSnake               DodgeIgnoreEffect;

    Template = Passive('M31_SolidSnake', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_BloodTrail", false, true);

    RangeEffect = new class'X2Effect_ModifyRangePenalties';
    RangeEffect.EffectName = 'M31_SolidSnake_RangeEffect';
    RangeEffect.RangeOffsetPrc = `GetConfigInt("M31_SolidSnake_PenaltyModifier");
    RangeEffect.BaseRange = `GetConfigInt("M31_SolidSnake_BaseRange");
    RangeEffect.bLongRange = true;
    RangeEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(RangeEffect);

    DodgeIgnoreEffect = new class'X2Effect_SolidSnake';
    DodgeIgnoreEffect.DodgeReductionBonus = `GetConfigInt("M31_SolidSnake_DodgeIgnore");
    DodgeIgnoreEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(DodgeIgnoreEffect);
    
    return Template;
}

static function X2AbilityTemplate Sparkfire()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Effect_TriggerEvent             InsanityEvent;

    Template = Attack('M31_Sparkfire', "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;

    Template.AbilityTargetConditions.Length = 0;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    Template.TargetingMethod = class'X2TargetingMethod_Fuse_New';

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_Sparkfire_AmmoCost"));
    AddCooldown(Template, `GetConfigInt("M31_Sparkfire_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_Sparkfire_Charges"));

    Template.AddTargetEffect(CreateSparkfireBurningEffect());

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
    InsanityEvent.ApplyChance = 100;
    InsanityEvent.TargetConditions.AddItem(new class'X2Condition_FuseTarget');
    Template.AddTargetEffect(InsanityEvent);

    Template.DamagePreviewFn = SparkfireDamagePreview;

    return Template;
}

static function X2Effect_Burning CreateSparkfireBurningEffect()
{
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Burning                  BurningEffect;

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Fire');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_Sparkfire_BurnDamage"), `GetConfigInt("M31_Sparkfire_BurnDamage_Spread"));
    BurningEffect.TargetConditions.AddItem(UnitImmunityCondition);

    return BurningEffect;
}

function bool SparkfireDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local XComGameStateHistory      History;
    local XComGameState_Ability     FuseTargetAbility;
    local XComGameState_Unit        TargetUnit;
    local StateObjectReference      EmptyRef, FuseRef;

    // AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

    History = `XCOMHISTORY;
    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
    if (TargetUnit != none)
    {
        if (class'X2Condition_FuseTarget'.static.GetAvailableFuse(TargetUnit, FuseRef))
        {
            FuseTargetAbility = XComGameState_Ability(History.GetGameStateForObjectID(FuseRef.ObjectID));
            if (FuseTargetAbility != none)
            {
                //  pass an empty ref because we assume the ability will use multi target effects.
                FuseTargetAbility.GetDamagePreview(EmptyRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
                AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
                return true;
            }
        }
    }

    return false;
}

static function X2AbilityTemplate StaticGrenades()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_StaticGrenades', "img:///UILibrary_MeristPerkIcons.UIPerk_Static", false, true);
    
    return Template;
}

static function X2AbilityTemplate Stiletto()
{
    local X2AbilityTemplate             Template;
    local X2Effect_BonusFromWeaponTier  Effect;

    Template = Passive('M31_Stiletto', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Needle", false, true);

    Effect = new class'X2Effect_BonusFromWeaponTier';
    Effect.PierceBonus = `GetConfigArrayInt("M31_Stiletto_PierceBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SuperheavyOrdnance()
{
    local X2AbilityTemplate             Template;
    local X2Effect_BonusGrenadeRange    RangeEffect;

    Template = Passive('M31_SuperheavyOrdnance', "img:///UILibrary_MZChimeraIcons.Ability_Barrage", false, true);

    RangeEffect = new class'X2Effect_BonusGrenadeRange';
    RangeEffect.BonusRange = `GetConfigInt("M31_SuperheavyOrdnance_RangeBonus");
    RangeEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(RangeEffect);

    Template.GetBonusWeaponAmmoFn = SuperheavyOrdnance_BonusWeaponAmmo;

    return Template;
}

static function int SuperheavyOrdnance_BonusWeaponAmmo(XComGameState_Unit UnitState, XComGameState_Item ItemState)
{
    if (ItemState.InventorySlot == eInvSlot_GrenadePocket)
        return `GetConfigInt("M31_SuperheavyOrdnance_ChargeBonus");

    return 0;
}

static function X2AbilityTemplate SupplyPack()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_SupplyPack', "img:///IRIDenmotherUI.UIPerk_SupplyRun", false, false);

    Template.AdditionalAbilities.AddItem('IRI_ResupplyAmmo');
    Template.AdditionalAbilities.AddItem('IRI_BandageThrow');
    Template.AdditionalAbilities.AddItem('IRI_SupplyRun');

    return Template;
}

static function X2AbilityTemplate SuppressingFire()
{
    local X2AbilityTemplate Template;

    Template = Attack('M31_SuppressingFire', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_shot_2", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY - 1;

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, 3, true);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_SuppressingFire_Cooldown"));

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_SuppressingFire');

    Template.PostActivationEvents.AddItem('M31_SuppressingFire_Suppress');

    Template.AdditionalAbilities.AddItem('M31_SuppressingFire_Trigger');
    Template.AdditionalAbilities.AddItem('M31_SuppressingFire_Dummy');

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate SuppressingFireAddActions()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_GrantActionPoints        Effect;

    Template = SelfTargetTrigger('M31_SuppressingFire_Trigger', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_shot_2");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_SuppressingFire_Suppress';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 85;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_GrantActionPoints';
    Effect.NumActionPoints = 1;
    Effect.PointType = class'X2DLCInfo_MeristPerkPack'.default.SuppressingFireActionPoint;
    Template.AddTargetEffect(Effect);

    // Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate SuppressingFireRemoveActions()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    Template = SelfTargetTrigger('M31_SuppressingFire_Dummy', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_shot_2");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_SuppressingFire_Suppress';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 59;
    Template.AbilityTriggers.AddItem(Trigger);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.AllowedTypes.Length = 0;
    ActionPointCost.AllowedTypes.AddItem(class'X2DLCInfo_MeristPerkPack'.default.SuppressingFireActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    return Template;
}

static function X2AbilityTemplate Suppression()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_Suppression', "img:///UILibrary_LW_PerkPack.LW_AreaSuppression", false, false);
    
    Template.AdditionalAbilities.AddItem('Suppression_LW');
    
    AbilitiesToAdd.AddItem('AreaSuppression');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.Suppression_Area_AllowedCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate TargetingAid()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_TargetingAid', "img:///UILibrary_MZChimeraIcons.Ability_CombatProtocol", false, true);
    
    return Template;
}

static function X2AbilityTemplate TrackingFire()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;

    Template = Attack('M31_TrackingFire', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_recoil", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bFreeCost = true;
    ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_TrackingFire_Cooldown"));
    AddAmmoCost(Template, 1);

    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = `GetConfigBool("M31_TrackingFire_bIsReactionFire");
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    Template.AdditionalAbilities.AddItem('M31_TrackingFire_ResetCooldown');

    return Template;
}

static function X2AbilityTemplate TrackingFireResetCooldown()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    EventListener;
    local X2Effect_ReduceCooldowns          Effect;

    Template = SelfTargetTrigger('M31_TrackingFire_ResetCooldown', "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot");

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.EventID = 'SlashActivated';
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    if (`GetConfigBool("M31_TrackingFire_bAllowResetFromBladestorm"))
    {
        EventListener = new class'X2AbilityTrigger_EventListener';
        EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
        EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
        EventListener.ListenerData.EventID = 'BladestormActivated';
        EventListener.ListenerData.Filter = eFilter_Unit;
        Template.AbilityTriggers.AddItem(EventListener);
    }

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.ReduceAll = (`GetConfigInt("M31_TrackingFire_CooldownReduction") > 0 ? false : true);
    Effect.Amount = `GetConfigInt("M31_TrackingFire_CooldownReduction");
    Effect.AbilitiesToTick.AddItem('M31_TrackingFire');
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate TrainedSniper_Squadsight()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_TrainedSniper_Squadsight', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle01", false, false);
    
    AbilitiesToAdd.AddItem('Squadsight');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.TrainedSniper_AllowedCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate TrainedSniper_LongWatch()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_TrainedSniper_LongWatch', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle04", false, false);
        
    AbilitiesToAdd.AddItem('LongWatch');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.TrainedSniper_AllowedCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate TrainedSniper_RangeFinder()
{
    local X2AbilityTemplate Template;
    local array<name> AbilitiesToAdd;

    Template = Passive('M31_RangeFinder', "img:///UILibrary_MZChimeraIcons.WeaponMod_ScopeSuperior", false, false);
    
    AbilitiesToAdd.AddItem('Squadsight');
    AbilitiesToAdd.AddItem('LongWatch');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, default.TrainedSniper_AllowedCategories, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    return Template;
}

static function X2AbilityTemplate TraverseFire()
{
    local X2AbilityTemplate                     Template;
    local X2Effect_TraverseFire                 Effect;
    
    Template = Passive('M31_TraverseFire', "img:///UILibrary_LW_PerkPack.LW_AbilityTraverseFire", false, true);

    Effect = new class 'X2Effect_TraverseFire';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_TraverseFire_ActivationsPerTurn");
    Effect.AllowedAbilities = default.TraverseFire_AllowedAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate TraverseFirePlus()
{
    local X2AbilityTemplate         Template;
    local X2Effect_TraverseFire     Effect;
    
    Template = Passive('M31_TraverseFirePlus', "img:///UILibrary_LW_PerkPack.LW_AbilityTraverseFire", false, true);

    Effect = new class 'X2Effect_TraverseFire';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_TraverseFire_ActivationsPerTurn");
    Effect.AllowedAbilities = default.TraverseFirePlus_AllowedAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate TroubleShooter()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_TroubleShooter', "img:///UILibrary_MZChimeraIcons.Ability_Crowdsource", false, true);
    
    return Template;
}

static function X2AbilityTemplate Undertaker()
{
    local X2AbilityTemplate Template;

    Template = Attack('M31_Undertaker', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_betweentheeyes", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;
    
    AddActionPointCost(Template, eCost_Free);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_Undertaker_Cooldown"));

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_Undead');

    return Template;
}

static function X2AbilityTemplate Unload(name DataName, optional bool bFirst)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_SetUnitValue             SetValueEffect;
    local X2Condition_UnitValue             ValueCondition;
    local X2Effect_IncrementUnitValue       IncrementValueEffect;

    Template = Attack(DataName, "img:///UILibrary_XPerkIconPack.UIPerk_rifle_bullet_x3", false, true);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.BuiltInHitMod = -1 * `GetConfigInt("M31_Unload_AimPenalty");
    ToHitCalc.bAllowCrit = `GetConfigBool("M31_Unload_bAllowCrit");
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    if (bFirst)
    {
        AddActionPointCost(Template, eCost_WeaponConsumeAll);
        AddAmmoCost(Template, 2, true);
        AddAmmoCost(Template, 1);
        AddCooldown(Template, `GetConfigInt("M31_Unload_Cooldown"));

        SetValueEffect = new class'X2Effect_SetUnitValue';
        SetValueEffect.UnitName = 'M31_Unload_Counter';
        SetValueEffect.NewValueToSet = 0;
        SetValueEffect.CleanupType = eCleanup_BeginTurn;
        SetValueEffect.bApplyOnMiss = true;
        Template.AddShooterEffect(SetValueEffect);

        IncrementValueEffect = new class'X2Effect_IncrementUnitValue';
        IncrementValueEffect.UnitName = 'M31_Unload_Counter';
        IncrementValueEffect.NewValueToSet = 1;
        IncrementValueEffect.CleanupType = eCleanup_BeginTurn;
        IncrementValueEffect.bApplyOnMiss = !`GetConfigBool("M31_Unload_bOnlyOnHit");
        Template.AddShooterEffect(IncrementValueEffect);

        Template.AdditionalAbilities.AddItem('M31_Unload_Chain');
        
        Template.bShowActivation = true;
    }
    else
    {
        Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

        Template.AbilityTriggers.Length = 0;

        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.EventID = DataName;
        Trigger.ListenerData.Filter = eFilter_Unit;
        Trigger.ListenerData.Priority = 80;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
        Template.AbilityTriggers.AddItem(Trigger);

        AddAmmoCost(Template, 1);

        ValueCondition = new class'X2Condition_UnitValue';
        ValueCondition.AddCheckValue('M31_Unload_Counter', `GetConfigInt("M31_Unload_MaxShots"), eCheck_LessThan);
        Template.AbilityShooterConditions.AddItem(ValueCondition);

        IncrementValueEffect = new class'X2Effect_IncrementUnitValue';
        IncrementValueEffect.UnitName = 'M31_Unload_Counter';
        IncrementValueEffect.NewValueToSet = 1;
        IncrementValueEffect.CleanupType = eCleanup_BeginTurn;
        IncrementValueEffect.bApplyOnMiss = !`GetConfigBool("M31_Unload_bOnlyOnHit");
        Template.AddShooterEffect(IncrementValueEffect);

        Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
        Template.BuildInterruptGameStateFn = none;
    }

    Template.PostActivationEvents.AddItem('M31_Unload_Chain');

    return Template;
}

static function X2AbilityTemplate Warbringer()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_Warbringer', "img:///UILibrary_MZChimeraIcons.Ability_HeavyOrdinance", false, false);

    Template.GetBonusWeaponAmmoFn = Warbringer_BonusWeaponAmmo;

    return Template;
}

static function int Warbringer_BonusWeaponAmmo(XComGameState_Unit UnitState, XComGameState_Item ItemState)
{
    if (X2GrenadeTemplate(ItemState.GetMyTemplate()) != none && default.Warbringer_AllowedSlots.Find(ItemState.InventorySlot) != INDEX_NONE)
        return `GetConfigInt("M31_Warbringer_ChargeBonus");

    return 0;
}

static function X2AbilityTemplate WatchfulEye()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_WatchfulEye', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", false, true);

    Template.AdditionalAbilities.AddItem('M31_WatchfulEye_Attack');

    return Template;
}

static function AddWatchfulEyeEffect(out X2AbilityTemplate Template)
{
    local X2Effect_WatchfulEye          Effect;
    local X2Condition_SoldierAbilities  AbilityCondition;
    local X2Condition_SoldierAbilities  NoAbilityCondition;

    NoAbilityCondition = new class'X2Condition_SoldierAbilities';
    NoAbilityCondition.ExcludedAbilities.AddItem('IndependentTracking');

    AbilityCondition = new class'X2Condition_SoldierAbilities';
    AbilityCondition.RequiredAbilities.AddItem('IndependentTracking');

    Effect = new class'X2Effect_WatchfulEye';
    Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.bRemoveWhenTargetDies = true;
    Effect.bUseSourcePlayerState = true;
    Effect.EffectName = 'M31_WatchfulEye_Mark';
    Effect.TargetConditions.AddItem(NoAbilityCondition);
    Template.AddTargetEffect(Effect);

    Effect = new class'X2Effect_WatchfulEye';
    Effect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnBegin);
    Effect.bRemoveWhenTargetDies = true;
    Effect.bUseSourcePlayerState = true;
    Effect.EffectName = 'M31_WatchfulEye_Mark';
    Effect.TargetConditions.AddItem(AbilityCondition);
    Template.AddTargetEffect(Effect);
}

static function X2AbilityTemplate WatchfulEyeAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;
    local X2Condition_UnitEffectsWithAbilitySource  TargetEffectCondition;

    Template = Attack('M31_WatchfulEye_Attack', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTrigger(Template);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AddShooterEffectExclusions();

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect('M31_WatchfulEye_Mark', 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

    AddBladestormMark(Template, 'M31_WatchfulEye_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_WatchfulEye_Counter', `GetConfigInt("M31_WatchfulEye_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate AcidRoundsAttackPassive()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;
    local X2Effect_AcidRoundsShred          ShredEffect;

    Template = Passive('M31_AcidRoundsPassive', "img:///UILibrary_MZChimeraIcons.Grenade_Acid", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_AcidRounds_Passive';
    PassiveWeaponEffect.AttackName = 'M31_AcidRounds_Attack';
    PassiveWeaponEffect.AdditionalWeaponCategories = default.PistolCategories;
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    ShredEffect = new class'X2Effect_AcidRoundsShred';
    ShredEffect.ShredBonus = `GetConfigInt("M31_AcidRounds_ShredBonus");
    ShredEffect.AdditionalWeaponCategories = default.PistolCategories;
    ShredEffect.BuildPersistentEffect(1, true, false);
    ShredEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(ShredEffect);

    Template.AdditionalAbilities.AddItem('M31_AcidRounds_Attack');

    return Template;
}

static function X2AbilityTemplate AcidRoundsAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_AcidRounds_Attack',
        "img:///UILibrary_MZChimeraIcons.Grenade_Acid",
        CreateAcidRoundsBurningEffect()
    );

    return Template;
}

static function X2Effect_Burning CreateAcidRoundsBurningEffect()
{
    local X2Effect_Burning Effect;

    Effect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(`GetConfigInt("M31_AcidRounds_BurnDamage"), `GetConfigInt("M31_AcidRounds_BurnDamage_Spread"));
    Effect.iNumTurns = `GetConfigInt("M31_AcidRounds_BurnDuration");

    return Effect;
}

static function X2AbilityTemplate BleedingRoundsAttackPassive()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_BleedingRoundsPassive', "img:///UILibrary_MZChimeraIcons.Ability_RendingSlash", false, true);
        
    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_BleedingRounds_Passive';
    PassiveWeaponEffect.AttackName = 'M31_BleedingRounds_Attack';
    PassiveWeaponEffect.AdditionalWeaponCategories = default.PistolCategories;
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_BleedingRounds_Attack');

    return Template;
}

static function X2AbilityTemplate BleedingRoundsAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_BleedingRounds_Attack',
        "img:///UILibrary_MZChimeraIcons.Ability_RendingSlash",
        CreateBleedingRoundsBleedingEffect()
    );

    return Template;
}

static function X2Effect_Persistent CreateBleedingRoundsBleedingEffect()
{

    local X2Effect_Persistent BleedingEffect;
    
    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_BleedingRounds_BleedDuration"),
        `GetConfigInt("M31_BleedingRounds_BleedDamage"),
        `GetConfigInt("M31_BleedingRounds_BleedDamage_Spread"),
        `GetConfigFloat("M31_BleedingRounds_BleedDamage_Prc"));
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_BleedingRoundsBleeding_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding"); 

    return BleedingEffect;
}

static function X2AbilityTemplate Bloodlet()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_Bloodlet', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Bloodlet", false, true);
        
    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_Bloodlet';
    PassiveWeaponEffect.AttackName = 'M31_Bloodlet_Attack';
    PassiveWeaponEffect.AdditionalWeaponCategories = default.PistolCategories;
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Bloodlet_Attack');

    return Template;
}

static function X2AbilityTemplate BloodletAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_Bloodlet_Attack',
        "img:///UILibrary_FavidsPerkPack.Perk_Ph_Bloodlet",
        CreateBloodletBleedingEffect()
    );

    return Template;
}

static function X2Effect_Persistent CreateBloodletBleedingEffect()
{
    local X2Effect_Persistent BleedingEffect;
    
    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_Bloodlet_BleedDuration"),
        `GetConfigInt("M31_Bloodlet_BleedDamage"),
        `GetConfigInt("M31_Bloodlet_BleedDamage_Spread"),
        `GetConfigFloat("M31_Bloodlet_BleedDamage_Prc"));
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_BloodletBleeding_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding"); 

    return BleedingEffect;
}

static function X2Effect_Persistent CreatePipeBombsBleedingEffect()
{
    local X2Effect_Persistent           BleedingEffect;
    local X2Condition_AbilityProperty   AbilityCondition;

    BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PipeBombs_BleedDuration"), `GetConfigInt("M31_PipeBombs_BleedDamage"));
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PipeBombs');
    BleedingEffect.TargetConditions.AddItem(AbilityCondition);

    return BleedingEffect;
}

static function X2AbilityTemplate ThermalShock()
{
    local X2AbilityTemplate Template;
    local X2Effect_PassiveWeaponEffect PassiveWeaponEffect;

    Template = Passive('M31_ThermalShock', "img:///KetarosPkg_Abilities.UIPerk_surprise", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_ThermalShock';
    PassiveWeaponEffect.AttackName = 'M31_ThermalShock_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ThermalShock_Attack');

    return Template;
}

static function X2AbilityTemplate ThermalShockAttack()
{
    local X2AbilityTemplate         Template;
    local X2Effect_ThermalShock     Effect;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_ThermalShock_Attack',
        "img:///KetarosPkg_Abilities.UIPerk_surprise"
    );

    Effect = new class'X2Effect_ThermalShock';
    Effect.EffectName = 'M31_ThermalShock_Debuff';

    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ThermalShock_AimPenalty_Immune"), true);
    Effect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ThermalShock_DefensePenalty_Immune"), true);
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ThermalShock_AimPenalty"));
    Effect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ThermalShock_DefensePenalty"));

    Effect.BuildPersistentEffect(`GetConfigInt("M31_ThermalShock_Duration"), false, false, true, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_ThermalShock_DebuffText"), Template.IconImage,,, Template.AbilitySourceName);
    Effect.DuplicateResponse = eDupe_Refresh;

    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ToxicNightmare()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_ToxicNightmare', "img:///UILibrary_MeristPerkIcons.UIPerk_ToxicNightmare", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_ToxicNightmare';
    PassiveWeaponEffect.AttackName = 'M31_ToxicNightmare_Attack';
    PassiveWeaponEffect.AdditionalWeaponCategories = default.PistolCategories;
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ToxicNightmare_Attack');

    return Template;
}

static function X2AbilityTemplate ToxicNightmareAttack()
{
    local X2AbilityTemplate                 Template;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_ToxicNightmare_Attack',
        "img:///UILibrary_MeristPerkIcons.UIPerk_ToxicNightmare",
        class'X2StatusEffects'.static.CreatePoisonedStatusEffect()
    );

    return Template;
}

static function X2AbilityTemplate Shiver2()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_Shiver2', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_Shiver2';
    PassiveWeaponEffect.AttackName = 'M31_Shiver2_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Shiver2_Attack');

    return Template;
}

static function X2AbilityTemplate Shiver2Attack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_PercentChanceWithRank ToHitCalc;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_Shiver2_Attack',
        "img:///UILibrary_DLC2Images.UIPerk_freezingbreath"
    );

    class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

    ToHitCalc = new class'X2AbilityToHitCalc_PercentChanceWithRank';
    ToHitCalc.PercentToHit = `GetConfigInt("M31_Shiver2_PrcChance");
    ToHitCalc.PercentToHitPerRank = `GetConfigFloat("M31_Shiver2_PrcChancePerRank");
    Template.AbilityToHitCalc = ToHitCalc;

    return Template;
}

static function X2AbilityTemplate HypothermiaRoundsPassive()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_HypothermiaRounds', "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverShot", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_HypothermiaRounds';
    PassiveWeaponEffect.AttackName = 'M31_HypothermiaRounds_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_HypothermiaRounds_Attack');

    return Template;
}

static function X2AbilityTemplate HypothermiaRoundsAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_PercentChanceWithRank ToHitCalc;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_HypothermiaRounds_Attack',
        "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverShot",
        class'MZ_Effect_Hypothermia'.static.CreateHypothermiaEffect(`GetConfigInt("M31_HypothermiaRounds_Duration"))
    );

    ToHitCalc = new class'X2AbilityToHitCalc_PercentChanceWithRank';
    ToHitCalc.PercentToHit = `GetConfigInt("M31_HypothermiaRounds_PrcChance");
    ToHitCalc.PercentToHitPerRank = `GetConfigFloat("M31_HypothermiaRounds_PrcChancePerRank");
    Template.AbilityToHitCalc = ToHitCalc;

    return Template;
}

static function X2AbilityTemplate ShiverCrit2()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_ShiverCrit2', "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverCrit", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_ShiverCrit2';
    PassiveWeaponEffect.AttackName = 'M31_ShiverCrit2_Attack';
    PassiveWeaponEffect.AdditionalWeaponCategories = default.ShiverCrit2_AdditionalCategories;
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ShiverCrit2_Attack');

    return Template;
}

static function X2AbilityTemplate ShiverCrit2Attack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_PercentChanceWithRank ToHitCalc;
    local X2Effect                          FreezeCleanseEffect;
    local X2Effect_DLC_Day60Freeze          FreezeEffect;
    local X2Effect_PersistentStatChange     BitterChillEffect;
    local X2Effect_Persistent               ChillEffect;

    Template = class'M31_Helpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_ShiverCrit2_Attack',
        "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverCrit"
    );

    FreezeCleanseEffect = class'BitterfrostHelper'.static.FreezeCleanse();
    FreezeEffect = class'BitterfrostHelper'.static.FreezeEffect();
    BitterChillEffect = class'BitterfrostHelper'.static.BitterChillEffect();
    ChillEffect = class'BitterfrostHelper'.static.ChillEffect();
    FreezeCleanseEffect.ApplyChanceFn = ApplyChance_ApplyOnCrit;
    FreezeEffect.ApplyChanceFn = ApplyChance_ApplyOnCrit;
    BitterChillEffect.ApplyChanceFn = ApplyChance_ApplyOnCrit;
    ChillEffect.ApplyChanceFn = ApplyChance_ApplyOnCrit;

    Template.AddTargetEffect(FreezeCleanseEffect);
    Template.AddTargetEffect(FreezeEffect);
    Template.AddTargetEffect(BitterChillEffect);
    Template.AddTargetEffect(ChillEffect);

    ToHitCalc = new class'X2AbilityToHitCalc_PercentChanceWithRank';
    ToHitCalc.PercentToHit = `GetConfigInt("M31_ShiverCrit2_PrcChance");
    ToHitCalc.PercentToHitPerRank = `GetConfigFloat("M31_ShiverCrit2_PrcChancePerRank");
    Template.AbilityToHitCalc = ToHitCalc;

    return Template;
}

function name ApplyChance_ApplyOnCrit(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local int Index;

    if (kNewTargetState.ObjectID == ApplyEffectParameters.AbilityInputContext.PrimaryTarget.ObjectID
        && ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
    {
        return 'AA_Success';
    }
    else
    {
        for (Index = 0; Index < ApplyEffectParameters.AbilityInputContext.MultiTargets.Length; Index++)
        {
            if (kNewTargetState.ObjectID == ApplyEffectParameters.AbilityInputContext.MultiTargets[Index].ObjectID
                && ApplyEffectParameters.AbilityResultContext.MultiTargetHitResults[Index] == eHit_Crit)
            {
                return 'AA_Success';
            }
        }
    }

    return 'AA_EffectChanceFailed';
}

static function X2AbilityTemplate AutoGuard()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_Rider_AutoGuard', "img:///UILibrary_MeristPerkIcons.UIPerk_Rider_AutoGuard", false, true);

    Template.PrerequisiteAbilities.AddItem('IRI_Rider_Guard');

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_AutoGuard(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory      History;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        SourceUnit;
    local XComGameState             NewGameState;

    History = `XCOMHISTORY;

    AbilityState = XComGameState_Ability(CallbackData);
    if (AbilityState != none)
    {
        SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

        if (SourceUnit != none && SourceUnit.HasSoldierAbility('M31_Rider_AutoGuard', true) && !SourceUnit.IsPanicked() && !SourceUnit.IsMindControlled())
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
            SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
            SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
            
            if (AbilityState.CanActivateAbility(SourceUnit) == 'AA_Success')
            {
                `GAMERULES.SubmitGameState(NewGameState);
                AbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false);
            }
            else
            {
                History.CleanupPendingGameState(NewGameState);
            }
        }
    }
    return ELR_NoInterrupt;
}

static function X2AbilityTemplate Chimera()
{
    local X2AbilityTemplate         Template;
    local X2Condition_ValidWeapon   Condition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget Effect;
    local array<name>               WeaponCats;
    local array<name>               AbilitiesToAdd;

    Template = Passive('M31_Chimera', "img:///UILibrary_MeristPerkIcons.UIPerk_Chimera", false, false);

    // SMG
    WeaponCats.Length = 0;
    WeaponCats.AddItem('smg');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('ShadowOps_Airstrike');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    // Rifle (excluding Bolt Caster)
    WeaponCats.Length = 0;
    WeaponCats.AddItem('rifle');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('CyclicFire');

    Condition = new class'X2Condition_ValidWeapon';
    Condition.AllowedWeaponCategories = WeaponCats;
    Condition.ExcludedWeaponTemplates = default.BoltCasterTemplates;
    Condition.bCheckSpecificSlot = true;
    Condition.SpecificSlot = eInvSlot_PrimaryWeapon;

    Effect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    Effect.AddAbilities = AbilitiesToAdd;
    Effect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    Effect.TargetConditions.AddItem(Condition);

    Template.AddTargetEffect(Effect);

    // Bolt Caster

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('M31_Pinpoint');

    Condition = new class'X2Condition_ValidWeapon';
    Condition.AllowedWeaponTemplates = default.BoltCasterTemplates;
    Condition.bCheckSpecificSlot = true;
    Condition.SpecificSlot = eInvSlot_PrimaryWeapon;

    Effect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    Effect.AddAbilities = AbilitiesToAdd;
    Effect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    Effect.TargetConditions.AddItem(Condition);

    Template.AddTargetEffect(Effect);

    // Shotgun
    WeaponCats.Length = 0;
    WeaponCats.AddItem('shotgun');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('M31_AssaultShot');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    // Cannon
    WeaponCats.Length = 0;
    WeaponCats.AddItem('cannon');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('SaturationFire');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    // Sniper Rifle
    WeaponCats.Length = 0;
    WeaponCats.AddItem('sniper_rifle');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('Squadsight');
    AbilitiesToAdd.AddItem('DoubleTap2');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    // Vektor Rifle
    WeaponCats.Length = 0;
    WeaponCats.AddItem('vektor_rifle');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('Squadsight');
    AbilitiesToAdd.AddItem('M31_BurstFire');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    // Bullpup
    WeaponCats.Length = 0;
    WeaponCats.AddItem('bullpup');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('Battlelord');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_PrimaryWeapon);

    // Sword
    WeaponCats.Length = 0;
    WeaponCats.AddItem('sword');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('M31_Overpower');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_SecondaryWeapon);

    // Combat Knife
    WeaponCats.Length = 0;
    WeaponCats.AddItem('combatknife');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('M31_PA_CripplingBlow');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_SecondaryWeapon);

    // Ripjack
    WeaponCats.Length = 0;
    WeaponCats.AddItem('wristblade');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('M31_CombatAdvance');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_SecondaryWeapon);

    // Pistol
    WeaponCats.Length = 0;
    WeaponCats.AddItem('pistol');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('MZFranticFire');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_Pistol);

    // Autopistol
    WeaponCats.Length = 0;
    WeaponCats.AddItem('sidearm');

    AbilitiesToAdd.Length = 0;
    AbilitiesToAdd.AddItem('MZPistolRave');
    class'M31_Helpers'.static.AddConditionalAbilityEffect(Template, WeaponCats, AbilitiesToAdd, eInvSlot_Pistol);

    return Template;
}

defaultproperties
{
    SniperOverwatchActionPoint = M31_SniperOverwatch
}