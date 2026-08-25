class X2AbilitySet_Merist extends X2Ability_Extended config(GameData_SoldierSkills);

var privatewrite name SniperOverwatchActionPoint;

var config array<name> AdvancedOptics_AllowedEffects;
var config array<name> Aim_AllowedAbilities;
var config array<name> Blademaster_AdditionalAbilities;
var config array<name> BombAndRun_AllowedAbilities;
var config array<name> ColdBlooded_AllowedAbilities;
var config array<name> ColdBlooded_AllowedEffects;
var config array<name> ImprovedSuppression_AllowedAbilities;
var config array<name> KeenEdge_AdditionalAbilities;
var config array<name> Malevolence_AllowedCategories;
var config array<name> MarauderElite_AllowedAbilities;
var config array<name> PriorityFocus_AllowedEffects;
var config array<name> Relentless_AllowedAbilities;
var config array<name> Reposition_AllowedAbilities;
var config array<name> ShiverCrit2_AdditionalCategories;
var config array<name> ShotgunWedding_AllowedCategories;
var config array<name> SniperElite_AllowedEffects;
var config array<name> SuppressingFire_AllowedAbilities;
var config array<name> Suppression_Area_AllowedCategories;
var config array<name> TrainedSniper_AllowedCategories;
var config array<name> TraverseFire_AllowedAbilities;
var config array<name> TraverseFirePlus_AllowedAbilities;
var config array<name> TroubleShooter_AllowedAbilities;
var config array<EInventorySlot> Warbringer_AllowedSlots;
var config array<name> WatchfulEye_AllowedAbilities;

var privatewrite name SuppressingFireActionPoint;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(AdvancedOptics());
    Templates.AddItem(Aim());
    Templates.AddItem(AlphaStrike());
        Templates.AddItem(AlphaStrikeLmao());
    Templates.AddItem(Assassin());
    Templates.AddItem(AssaultShot());
    Templates.AddItem(Bandit());
    Templates.AddItem(BattalionCommander());
    Templates.AddItem(Blademaster());
    Templates.AddItem(BloodThirst());
    Templates.AddItem(BombAndRun());
        Templates.AddItem(BombAndRunPassive());
    Templates.AddItem(BurstFire());
    Templates.AddItem(CallForFire());
    Templates.AddItem(ChasingCoveringFire());
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
        Templates.AddItem(EnemyUnknownPassive());
    Templates.AddItem(EnhancedLowProfile());
    Templates.AddItem(Entrench());
        Templates.AddItem(EntrenchTrigger());
    Templates.AddItem(EyeOnTarget());
    Templates.AddItem(Escalation());
    Templates.AddItem(Frostbane());
    Templates.AddItem(ImprovedSuppression());
    Templates.AddItem(KeenEdge());
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
    Templates.AddItem(PriorityFocus());
    Templates.AddItem(Relentless());
    Templates.AddItem(RepositionPlus());
    Templates.AddItem(SaltInTheWound());
    Templates.AddItem(SawedOffRange());
    Templates.AddItem(SawedOffReload());
    Templates.AddItem(SawedOffSweeper());
    Templates.AddItem(Shadowstrike());
    Templates.AddItem(ShockGrenadier());
    Templates.AddItem(ShotgunWedding());
        Templates.AddItem(ShotgunWeddingAttack());
    Templates.AddItem(SiegeWarheads());
    Templates.AddItem(Skykeeper());
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
    Templates.AddItem(TacticalAdvance());
        Templates.AddItem(TacticalAdvanceTrigger());
    Templates.AddItem(TacticalAdvance2());
        Templates.AddItem(TacticalAdvance2Trigger());
    Templates.AddItem(TrackingFire());
        Templates.AddItem(TrackingFireResetCooldown());
    Templates.AddItem(TrainedSniper_Squadsight());
    Templates.AddItem(TrainedSniper_LongWatch());
    Templates.AddItem(TrainedSniper_RangeFinder());
    Templates.AddItem(TraverseFire());
        Templates.AddItem(TraverseFirePlus());
    Templates.AddItem(TroubleShooter());
    Templates.AddItem(Unload('M31_Unload', true));
        Templates.AddItem(Unload('M31_Unload_Chain'));
    Templates.AddItem(Warbringer());
    Templates.AddItem(WatchfulEye());
        Templates.AddItem(WatchfulEyeAttack());
    Templates.AddItem(ZoneOfControl());
        Templates.AddItem(ZoneOfControlPassive());

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
    local X2AbilityTemplate Template;
    
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

    SetAbilityShotHUDPriority(Template, ePriorityType_None, eCost_DoubleConsumeAll, eHostility_Neutral);

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

    Template.AdditionalAbilities.AddItem('M31_AlphaStrike_Lmao');

    return Template;
}

static function X2AbilityTemplate AlphaStrikeLmao()
{
    local X2AbilityTemplate     Template;
    local X2Effect_ChargesLmao  Effect;

    Template = Passive('M31_AlphaStrike_Lmao', "img:///UILibrary_MZChimeraIcons.Ability_Dash", false, false);

    Effect = new class'X2Effect_ChargesLmao';
    Effect.AbilitiesToTick.AddItem('M31_AlphaStrike');
    Effect.AllowedAbilities.AddItem('ABBActivatePsiInducer');
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

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
    local X2AbilityTemplate Template;
    local X2Effect_Assassin Effect;
    
    Template = Passive('M31_Assassin', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_assassin", false, true);

    Effect = new class'X2Effect_Assassin';
    Effect.bAllowMultiTarget = `GetConfigBool("M31_Assassin_bAllowMultiTarget");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_Assassin_bMatchSourceWeapon");
    Effect.ActivationsPerTurn = `GetConfigInt("M31_Assassin_ActivationsPerTurn");
    Effect.bShowFlyover = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate AssaultShot()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    Template = Attack('M31_AssaultShot', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilitySnapShot", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_Free, eHostility_Offensive);
    
    AddCooldown(Template, `GetConfigInt("M31_AssaultShot_Cooldown"));
    AddActionPointCost(Template, eCost_Free);
    AddAmmoCost(Template, 1);

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

static function X2AbilityTemplate Blademaster()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Blademaster  Effect;

    Template = Passive('M31_Blademaster', "img:///UILibrary_PerkIcons.UIPerk_momentum", false, false);

    Effect = new class'X2Effect_Blademaster';
    Effect.EffectName = 'M31_Blademaster';
    Effect.AimBonus = `GetConfigInt("M31_Blademaster_AimBonus");
    Effect.DamageBonus = `GetConfigInt("M31_Blademaster_DamageBonus");
    Effect.AdditionalAbilities = default.Blademaster_AdditionalAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BloodThirst()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_BloodThirst              Effect;
    
    Template = Passive('M31_BloodThirst', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage", false, true);

    Effect = new class'X2Effect_BloodThirst';
    Effect.DamagePerStack = `GetConfigInt("M31_BloodThirst_DamagePerStack");
    Effect.MaxStacks = `GetConfigInt("M31_BloodThirst_MaxStacks");
    Effect.MaxStacksPerTurn = `GetConfigInt("M31_BloodThirst_MaxStacksPerTurn");
    Effect.StackDuration = `GetConfigInt("M31_BloodThirst_StackDuration");
    Effect.bRefreshDuration = `GetConfigBool("M31_BloodThirst_bRefreshDuration");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_BloodThirst_bMatchSourceWeapon");
    Effect.bIncreaseOnlyOnHit = `GetConfigBool("M31_BloodThirst_bIncreaseOnlyOnHit");
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Effect_BloodThirst'.default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BombAndRun()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_GrantActionPoints        Effect;
    local X2Condition_UnitEffects           EffectCondition;

    Template = SelfTargetTrigger('M31_BombAndRun', "img:///UILibrary_XPerkIconPack.UIPerk_move_grenade");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BombAndRun;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    EffectCondition = new class'X2Condition_UnitEffects';
    EffectCondition.AddExcludeEffect(class'X2Effect_SkirmisherInterrupt'.default.EffectName, 'AA_AbilityUnavailable');
    Template.AbilityShooterConditions.AddItem(EffectCondition);

    Effect = new class'X2Effect_GrantActionPoints';
    Effect.NumActionPoints = 1;
    Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddTargetEffect(Effect);
    
    AddUnitValueCondition(Template, 'M31_BombAndRun_Counter', `GetConfigInt("M31_BombAndRun_ActivationsPerTurn"));

    Template.bShowActivation = true;

    Template.AdditionalAbilities.AddItem('M31_BombAndRun_Passive');

    return Template;
}

static function X2AbilityTemplate BombAndRunPassive()
{
    return Passive('M31_BombAndRun_Passive', "img:///UILibrary_XPerkIconPack.UIPerk_move_grenade", false, true);
}

static function EventListenerReturn AbilityTriggerEventListener_BombAndRun(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         EventAbilityState;
    local XComGameState_Ability         AbilityState;
    local XComGameStateContext_Ability  AbilityContext;

    SourceUnit = XComGameState_Unit(EventSource);

    if (class'M31_Helpers'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
    {
        return ELR_NoInterrupt;
    }

    EventAbilityState = XComGameState_Ability(EventData);
    AbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        if (default.BombAndRun_AllowedAbilities.Find(EventAbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate BurstFire()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
    local int NumExtraShots;

    Template = Attack('M31_BurstFire', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilityLightEmUp", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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
    local X2AbilityPassiveAOE_WeaponRadius          PassiveRadius;
    local X2Condition_UnitProperty                  UnitPropertyCondition;
    local X2Effect_MeristReserveOverwatchPoints     ReserveEffect;
    local X2Effect_MeristCoveringFire               CoveringFireEffect;
    local X2Condition_TargetHasOneOfTheAbilities    CoveringFireCondition;

    Template = SelfTargetActivated('M31_CallForFire', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_circle", false);

    SetAbilityShotHUDPriority(Template, ePriorityType_None, eCost_SingleConsumeAll, eHostility_Defensive);
    Template.Hostility = eHostility_Defensive;

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

    PassiveRadius = new class'X2AbilityPassiveAOE_WeaponRadius';
    PassiveRadius.fTargetRadius = `TILESTOMETERS(`GetConfigInt("M31_CallForFire_Radius"));
    Template.AbilityPassiveAOEStyle = PassiveRadius;
    
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
    Template.bShowActivation = false;
    
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
    SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, 'Overwatch', eColor_Good, AbilityTemplate.IconImage);

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

            SoundAndFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, Context, false, TargetTrack.LastActionAdded));
            SoundAndFlyoverTarget.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, 'None', eColor_Good, AbilityTemplate.IconImage);
        }
    }
}

static function X2AbilityTemplate ChasingCoveringFire()
{
    local X2AbilityTemplate     Template;
    local X2Effect_ChasingFire  Effect;

    Template = Passive('M31_ChasingCoveringFire', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_zeroin", false, true);

    Effect = new class'X2Effect_ChasingFire';
    Effect.EffectName = 'M31_ChasingCoveringFire';
    Effect.bMatchSourceWeapon = false;
    Effect.AbilitiesToActivate = class'X2Effect_MeristReserveOverwatchPoints'.default.OverwatchAbilities;
    Effect.ActivationsPerTargetPerTurn = `GetConfigInt("M31_ChasingCoveringFire_ActivationsPerTargetPerTurn");
    Effect.TargetCountValueNamePrefix = "M31_ChasingCoveringFire_";
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ColdBlooded()
{
    local X2AbilityTemplate     Template;
    local X2Effect_ColdBlooded  Effect;
    
    Template = Passive('M31_ColdBlooded', "img:///UILibrary_MeristOtherPerkIcons.Perk_Ph_ColdBlooded", false, true);

    Effect = new class'X2Effect_ColdBlooded';
    Effect.AllowedAbilities = default.ColdBlooded_AllowedAbilities;
    Effect.AllowedEffects = default.ColdBlooded_AllowedEffects;
    Effect.ActivationsPerTurn = `GetConfigInt("M31_ColdBlooded_ActivationsPerTurn");
    Effect.bMatchSourceWeapon = false;
    Effect.bShowFlyover = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate CombatAdvance()
{
    local X2AbilityTemplate             Template;
    local X2Effect_GrantActionPoints    ActionPointEffect;
    local array<name>                   SkipExclusions;

    Template = MovingMelee('M31_CombatAdvance', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Reckoning", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Melee, eCost_Single, eHostility_Offensive);

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

    Template = Passive('M31_ControlledDetonation', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilityCombatEngineer", false, true);
    
    Effect = new class'X2Effect_ControlledDetonation';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate CovertParkour()
{
    local X2AbilityTemplate                     Template;
    local X2Effect_PersistentTraversalChange    ClimbEffect;
    local X2Effect_PersistentStatChange         CovertEffect;

    Template = Passive('M31_CovertParkour', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilityCovert", false, false);

    CovertEffect = new class'X2Effect_PersistentStatChange';
    CovertEffect.EffectName = 'M31_CovertParkour';
    CovertEffect.DuplicateResponse = eDupe_Ignore;
    CovertEffect.AddPersistentStatChange(eStat_DetectionModifier, `GetConfigInt("M31_CovertParkour_DetectionReduction") / 100.0f);
    CovertEffect.BuildPersistentEffect(1, true, false);
    CovertEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(CovertEffect);

    ClimbEffect = new class'X2Effect_PersistentTraversalChange';
    ClimbEffect.EffectName = 'M31_WallClimb';
    ClimbEffect.DuplicateResponse = eDupe_Ignore;
    ClimbEffect.AddTraversalChange(eTraversal_WallClimb, true);
    ClimbEffect.BuildPersistentEffect(1, true, false);
    ClimbEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(ClimbEffect);

    return Template;
}

static function X2AbilityTemplate DeathAdder()
{
    local X2AbilityTemplate Template;
    local X2Effect_Shredder DamageEffect;

    Template = Attack('M31_DeathAdder', "img:///UILibrary_PerkIcons.UIPerk_ruptured", false, false);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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
    local X2AbilityTemplate         Template;
    local X2Effect_DeathAdderBonus  Effect;
    
    Template = Passive('M31_DeathAdder_Bonus', "img:///UILibrary_PerkIcons.UIPerk_ruptured", false, false);

    Effect = new class'X2Effect_DeathAdderBonus';
    Effect.AllowedAbilities.AddItem('M31_DeathAdder');
    Effect.DamageFromHP = `GetConfigInt("M31_DeathAdder_HPToDamage");
    Effect.MaxDamageBonus = `GetConfigInt("M31_DeathAdder_MaxDamageBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate DedicatedOverwatch()
{
    local X2AbilityTemplate             Template;
    local X2Effect_DedicatedOverwatch   Effect;

    Template = Passive('M31_DedicatedOverwatch', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_defense", false, true);

    Effect = new class'X2Effect_DedicatedOverwatch';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate Dervish()
{
    local X2AbilityTemplate Template;

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
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_NonInterruptSelf;
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

    Template = Attack('M31_DisarmingShot', "img:///UILibrary_MZChimeraIcons.Ability_DisablingShot", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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

static function X2AbilityTemplate DisarmingShotSnap()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_CanAffordCost     CostCondition;

    Template = Attack('M31_DisarmingShot_SnapShot', "img:///UILibrary_MZChimeraIcons.Ability_DisablingShot", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_SingleConsumeAll, eHostility_Offensive);

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
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
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
    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('EMPGrenade'));

    return Template;
}

static function X2AbilityTemplate EnemyUnknown()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_EnemyUnknown             Effect;

    Template = SelfTargetTrigger('M31_EnemyUnknown', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow");

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

    Template.AdditionalAbilities.AddItem('M31_EnemyUnknown_Passive');

    return Template;
}

static function X2AbilityTemplate EnemyUnknownPassive()
{
    return Passive('M31_EnemyUnknown_Passive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_shadow", false, true);
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
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Condition_UnitProperty          PropertyCondition;
    local X2Effect_HunkerDown_LW            HunkerDownEffect;
    local X2Condition_UnitEffects           UnitEffectsCondition;
    local array<name>                       SkipExclusions;
    local X2Effect_SetUnitValue             UnitValueEffect;
    local X2Effect_RemoveEffects            RemoveEffects;
    
    Template = SelfTargetActivated('M31_Entrench', "img:///UILibrary_PerkIcons.UIPerk_one_for_all", true);

    Template.OverrideAbilities.AddItem('HunkerDown');

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    Template.Hostility = eHostility_Defensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY;
    Template.bDisplayInUITooltip = false;
 
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);
    
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

    if (`GetConfigBool("M31_Entrench_bRemovesBurning"))
    {
        RemoveEffects = new class'X2Effect_RemoveEffects';
        RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BurningName);
        Template.AddTargetEffect(RemoveEffects);
    }

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
    EventMgr.RegisterForEvent(EffectObj, 'ObjectMoved', EffectGameState.GenerateCover_ObjectMoved, ELD_OnStateSubmitted,, UnitState);
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

    Template = Passive('M31_EyeOnTarget', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_watchfuleye", false, false);

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
    Effect.CritDamageBonusMinCrit = `GetConfigInt("M31_Escalation_CritDamageBonusMinCrit");
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Escalation_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_CA_Escalation_BonusText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.ActivationSpeech = 'InTheZone';

    return Template;
}

static function X2AbilityTemplate Frostbane()
{
    local X2AbilityTemplate     Template;
    local X2Effect_FrostBonus   Effect;

    Template = Passive('M31_Frostbane', "img:///UILibrary_XPerkIconPack.UIPerk_crit_plus", false, true);

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

static function X2AbilityTemplate GenevaSuggestion()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_GenevaSuggestion', "img:///KetarosPkg_Abilities.UIPerk_bomb", false, false);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('AcidGrenade'));
    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('GasGrenade'));
    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('Firebomb'));

    return Template;
}

static function X2AbilityTemplate Maim()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;

    Template = Attack('M31_Maim', "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
    Template.HideIfAvailable.AddItem('M31_Maim_SnapShot');

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_Maim_AmmoCost"));

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_Maim_Cooldown");
    Cooldown.AddAdditionalCooldownInfo('M31_Maim_SnapShot',, true);
    Template.AbilityCooldown = Cooldown;

    Template.AddTargetEffect(class'X2Effect_Immobilize'.static.CreateMaimedStatusEffect(, Template));

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

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_SingleConsumeAll, eHostility_Offensive);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
    // Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddAmmoCost(Template, `GetConfigInt("M31_Maim_AmmoCost"));

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_Maim_Cooldown");
    Cooldown.AddAdditionalCooldownInfo('M31_Maim',, true);
    Template.AbilityCooldown = Cooldown;

    Template.AddTargetEffect(class'X2Effect_Immobilize'.static.CreateMaimedStatusEffect(, Template));

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
    
    Template = Passive('M31_ImprovedSuppression', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_improvedsuppression", false, true);

    return Template;
}

static function X2AbilityTemplate KeenEdge()
{
    local X2AbilityTemplate Template;
    local X2Effect_KeenEdge Effect;

    Template = Passive('M31_KeenEdge', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_keenedge", false, false);

    Effect = new class'X2Effect_KeenEdge';
    Effect.DamageBonus = `GetConfigArrayInt("M31_KeenEdge_DamageBonus");
    Effect.PierceBonus = `GetConfigArrayInt("M31_KeenEdge_PierceBonus");
    Effect.AdditionalAbilities = default.KeenEdge_AdditionalAbilities;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

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
    local X2AbilityTemplate     Template;
    local X2Effect_MarkedBonus  Effect;
    local X2Effect_Malevolence_RuptureBonus RuptureEffect;
    local X2Effect_WeaponEffect WeaponEffect;
    
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

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_Malevolence_Passive';
    WeaponEffect.AttackName = 'M31_Malevolence_Trigger';
    WeaponEffect.AdditionalWeaponCategories = default.Malevolence_AllowedCategories;
    WeaponEffect.EventPriority = 45;
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Malevolence_Trigger');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

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

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
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
    StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
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

    Effect = class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('ProximityMine');
    Effect.BaseCharges = 2;
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate NeurotoxicShot()
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitImmunities    UnitImmunityCondition;
    local X2Effect_Persistent           PoisonedEffect;
    local X2Effect_Persistent           DisorientedEffect;

    Template = Attack('M31_NeurotoxicShot', "img:///UILibrary_MZChimeraIcons.Ability_ToxicGreeting", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate Overpower()
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Effect_ApplyWeaponDamage    ShredEffect;

    Template = MovingMelee('M31_Overpower', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_fracture", false, false);

    SetAbilityShotHUDPriority(Template, ePriorityType_Melee, eCost_SingleConsumeAll, eHostility_Offensive);

    Template.AddShooterEffectExclusions();

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.FailOnNonUnits = true;
    UnitPropertyCondition.ExcludeLargeUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_Overpower_Cooldown"));

    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_Overpower_StunDuration"), 100, false));
    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

    // Empty damage effect that ignores shields and only applies shred.
    // If the target has any amount of shields and the attack doesn't ignore them, armor pierced cannot be shredded.
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
    local X2AbilityTemplate         Template;
    local X2Condition_ValidWeapon   WeaponCondition;

    Template = Passive('M31_Overseer', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle03", false, false);

    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    Template.AbilityShooterConditions.AddItem(WeaponCondition);

    Template.AdditionalAbilities.AddItem('Squadsight');
    Template.AdditionalAbilities.AddItem('M31_SniperOverwatch');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate PerfectHandling()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ModifyRangePenalties Effect;

    Template = Passive('M31_PerfectHandling', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_point_blank", false, true);

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

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

    AddCooldown(Template, `GetConfigInt("M31_Pinpoint_Cooldown"));
    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, 1);

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
    return Passive('M31_PipeBombs', "img:///UILibrary_MZChimeraIcons.Ability_ShrapnelGrenade", false, true);
}

static function X2AbilityTemplate PriorityFocus()
{
    local X2AbilityTemplate     Template;
    local X2Effect_MarkedBonus  Effect;

    Template = Passive('M31_PriorityFocus', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilityVitalPointTargeting", false, true);
    
    Effect = new class'X2Effect_MarkedBonus';
    Effect.AllowedEffects = default.PriorityFocus_AllowedEffects;
    Effect.DamageBonus = `GetConfigInt("M31_PriorityFocus_DamageBonus");
    Effect.bApplyToRanged = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Relentless()
{
    local X2AbilityTemplate             Template;
    local X2Effect_RefundActionPoints   Effect;

    Template = Passive('M31_Relentless', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_skirmisher", false, true);

    Effect = new class'X2Effect_RefundActionPoints';
    Effect.EffectName = 'M31_Relentless';
    Effect.bRefundAll = false;
    Effect.ActionPointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Effect.AllowedAbilities = default.Relentless_AllowedAbilities;
    Effect.ActivationsPerTurn = `GetConfigInt("M31_Relentless_ActivationsPerTurn");
    Effect.CountValueName = 'M31_Relentless_Activations';
    Effect.bShowFlyover = true;
    Effect.FlyoverEventName = 'M31_Relentless_Flyover';
    Effect.bAllowCBACOverride = false;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate RepositionPlus()
{
    local X2AbilityTemplate     Template;
    local X2Effect_HitAndRun    Effect;
    
    Template = Passive('M31_RepositionPlus', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_skirmisher", false, true);

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
    
    Template = Passive('M31_SawedOffRange', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_point_blank", false, true);

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

    SetAbilityShotHUDPriority(Template, ePriorityType_Secondary, eCost_SingleConsumeAll, eHostility_Offensive);

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;
    Template.TargetingMethod = class'X2TargetingMethod_Cone';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_SawedOffSweeper';
    ConeMultiTarget.BaseConeEndDiameter = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_Width"));
    ConeMultiTarget.BaseConeLength = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_Length"));
    ConeMultiTarget.ConeEndDiameterPerAmmo = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_WidthPerAmmo"));
    ConeMultiTarget.ConeLengthPerAmmo = `METERSTOUNITS(`GetConfigFloat("M31_SawedOffSweeper_LengthPerAmmo"));
    ConeMultiTarget.MinAmmo = `GetConfigInt("M31_SawedOffSweeper_MinAmmo");
    ConeMultiTarget.MaxAmmo = `GetConfigInt("M31_SawedOffSweeper_MaxAmmo");
    ConeMultiTarget.fTargetRadius = 99;
    ConeMultiTarget.bIgnoreBlockingCover = false;
    ConeMultiTarget.bUseWeaponRangeForLength = false;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Template.bCheckCollision = true;
    // Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = false;

    Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
    AddSuppressedCondition(Template);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    if (`GetConfigBool("M31_SawedOffSweeper_bHipfire"))
    {
        ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Hipfire_LW');
    }
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_SawedOffSweeper_Cooldown"));

    AmmoCost = new class'X2AbilityCost_Ammo_Extended';
    AmmoCost.iAmmo = `GetConfigInt("M31_SawedOffSweeper_MinAmmo");
    AmmoCost.iAmmoMax = `GetConfigInt("M31_SawedOffSweeper_MaxAmmo");
    AmmoCost.bConsumeAllAmmo = true;
    Template.AbilityCosts.AddItem(AmmoCost);

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

static function X2AbilityTemplate Shadowstrike()
{
    local X2AbilityTemplate         Template;
    local X2Effect_ToHitModifier    Effect;
    local X2Condition_Visibility    VisibilityCondition;

    Template = Passive('M31_Shadowstrike', "img:///UILibrary_PerkIcons.UIPerk_shadowstrike", false, true);

    Effect = new class'X2Effect_ToHitModifier';
    Effect.EffectName = 'M31_Shadowstrike';
    Effect.DuplicateResponse = eDupe_Ignore;
    Effect.AddEffectHitModifier(eHit_Success, `GetConfigInt("M31_Shadowstrike_AimBonus"), Template.LocFriendlyName);
    Effect.AddEffectHitModifier(eHit_Crit, `GetConfigInt("M31_Shadowstrike_CritBonus"), Template.LocFriendlyName);
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bExcludeGameplayVisible = true;
    Effect.ToHitConditions.AddItem(VisibilityCondition);

    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ShockGrenadier()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_ShockGrenadier', "img:///UILibrary_MeristPerkIcons.UIPerk_ShockBox", false, true);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('EMPGrenade'));

    return Template;
}

static function X2AbilityTemplate ShotgunWedding()
{
    local X2AbilityTemplate             Template;
    local X2AbilityMultiTarget_Cone     ConeMultiTarget;
    local X2Effect_TriggerEvent         InsanityEvent;
    local X2Effect_SetUnitValue         UnitValueEffect;
    local X2Condition_ValidWeapon       ShotgunCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_ShotgunWedding');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_saturationfire";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
    Template.TargetingMethod = class'X2TargetingMethod_Cone';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    ShotgunCondition = new class'X2Condition_ValidWeapon';
    ShotgunCondition.AllowedWeaponCategories = default.ShotgunWedding_AllowedCategories;
    Template.AbilityShooterConditions.AddItem(ShotgunCondition);

    Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.ConeEndDiameter = `GetConfigInt("M31_ShotgunWedding_Width") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.ConeLength = `GetConfigInt("M31_ShotgunWedding_Length") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.fTargetRadius = 99;
    ConeMultiTarget.bIgnoreBlockingCover = true;
    ConeMultiTarget.bUseWeaponRangeForLength = false;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_ShotgunWedding_Cooldown"));

    AddAmmoCost(Template, `GetConfigInt("M31_ShotgunWedding_AmmoCost") + `GetConfigInt("M31_ShotgunWedding_AmmoCostPerShot"), true);
    AddAmmoCost(Template, `GetConfigInt("M31_ShotgunWedding_AmmoCost"));

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = 'M31_ShotgunWedding_Event';
    InsanityEvent.ApplyChance = 100;
    Template.AddMultiTargetEffect(InsanityEvent);

    UnitValueEffect = new class'X2Effect_SetUnitValue';
    UnitValueEffect.UnitName = 'M31_ShotgunWedding_Counter';
    UnitValueEffect.NewValueToSet = 0;
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
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

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.ConeEndDiameter = `GetConfigInt("M31_ShotgunWedding_Width") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.ConeLength = `GetConfigInt("M31_ShotgunWedding_Length") * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.fTargetRadius = 99;
    ConeMultiTarget.bIgnoreBlockingCover = true;
    ConeMultiTarget.bUseWeaponRangeForLength = false;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_ShotgunWedding_Event';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 55;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    ShotgunCondition = new class'X2Condition_ValidWeapon';
    ShotgunCondition.AllowedWeaponCategories = default.ShotgunWedding_AllowedCategories;
    Template.AbilityShooterConditions.AddItem(ShotgunCondition);

    Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

    AddUnitValueCondition(Template, 'M31_ShotgunWedding_Counter', `GetConfigInt("M31_ShotgunWedding_MaxNumShots"));

    AddAmmoCost(Template, `GetConfigInt("M31_ShotgunWedding_AmmoCostPerShot"));

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;
    KnockbackEffect = new class'X2Effect_Knockback';
    KnockbackEffect.KnockbackDistance = 2;
    Template.AddMultiTargetEffect(KnockbackEffect);

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
    Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

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

static function X2AbilityTemplate SiegeWarheads()
{
    return Passive('M31_SiegeWarheads', "img:///UILibrary_LWOTC.LW_AbilityTandemWarheads", false, true);
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

static function X2AbilityTemplate SmokeGrenadier()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_SmokeGrenadier', "img:///UILibrary_XPerkIconPack.UIPerk_smoke_box", false, true);

    Template.AddTargetEffect(class'X2Effect_AddGrenade'.static.CreateAddGrenadeEffect('SmokeGrenade'));

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

    Template.AddShooterEffectExclusions();
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

    AddOverwatchTriggers(Template);

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

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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
    local X2AbilityTemplate Template;

    Template = Passive('M31_StaticGrenades', "img:///UILibrary_MeristPerkIcons.UIPerk_Static", false, true);
    
    return Template;
}

static function X2AbilityTemplate Stiletto()
{
    local X2AbilityTemplate Template;
    local X2Effect_Stiletto Effect;

    Template = Passive('M31_Stiletto', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Needle", false, false);

    Effect = new class'X2Effect_Stiletto';
    Effect.PierceBonus = `GetConfigArrayInt("M31_Stiletto_PierceBonus");
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
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

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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
    Effect.PointType = default.SuppressingFireActionPoint;
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
    ActionPointCost.AllowedTypes.AddItem(default.SuppressingFireActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    return Template;
}

static function X2AbilityTemplate Suppression()
{
    local X2AbilityTemplate         Template;
    local X2Condition_ValidWeapon   WeaponCondition;

    Template = Passive('M31_Suppression', "img:///UILibrary_MeristOtherPerkIcons.LW_AreaSuppression", false, false);

    Template.AdditionalAbilities.AddItem('Suppression_LW');

    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories = default.Suppression_Area_AllowedCategories;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'AreaSuppression', eInvSlot_PrimaryWeapon, WeaponCondition);

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate TacticalAdvance()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_HunkerMove', "img:///IRIPerkPackUI.UIPerk_TacticalAdvance", false, true);

    Template.AdditionalAbilities.AddItem('M31_HunkerMove_Trigger');
    Template.PrerequisiteAbilities.AddItem('NOT_M31_HunkerRunAndGun');

    return Template;
}

static function X2AbilityTemplate TacticalAdvanceTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_TacticalAdvance          Effect;
    
    Template = SelfTargetTrigger('M31_HunkerMove_Trigger', "img:///IRIPerkPackUI.UIPerk_TacticalAdvance");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_TacticalAdvance;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AddShooterEffectExclusions();

    Effect = new class'X2Effect_TacticalAdvance';
    Effect.ActionPointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Effect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_TacticalAdvance(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit, OldSourceUnit;
    local XComGameState_Ability         CallbackAbilityState;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        CallbackAbilityState = XComGameState_Ability(CallbackData);
        SourceUnit = XComGameState_Unit(EventSource);
        OldSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.ObjectID,, GameState.HistoryIndex - 1));
        if (!OldSourceUnit.IsHunkeredDown() && SourceUnit.IsHunkeredDown())
        {
            return CallbackAbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate TacticalAdvance2()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_HunkerRunAndGun', "img:///IRIPerkPackUI.UIPerk_TacticalAdvance", false, true);

    Template.AdditionalAbilities.AddItem('M31_HunkerRunAndGun_Trigger');
    Template.PrerequisiteAbilities.AddItem('NOT_M31_HunkerMove');

    return Template;
}

static function X2AbilityTemplate TacticalAdvance2Trigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_TacticalAdvance          Effect;
    
    Template = SelfTargetTrigger('M31_HunkerRunAndGun_Trigger', "img:///IRIPerkPackUI.UIPerk_TacticalAdvance");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_TacticalAdvance;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AddShooterEffectExclusions();

    Effect = new class'X2Effect_TacticalAdvance';
    Effect.ActionPointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
    Effect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate TrackingFire()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;

    Template = Attack('M31_TrackingFire', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_recoil", false, true);

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_Free, eHostility_Offensive);

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
    local X2AbilityTemplate         Template;
    local X2Condition_ValidWeapon   WeaponCondition;

    Template = Passive('M31_TrainedSniper_Squadsight', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle01", false, false);

    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    Template.AbilityShooterConditions.AddItem(WeaponCondition);

    Template.AdditionalAbilities.AddItem('Squadsight');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate TrainedSniper_LongWatch()
{
    local X2AbilityTemplate         Template;
    local X2Condition_ValidWeapon   WeaponCondition;

    Template = Passive('M31_TrainedSniper_LongWatch', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle04", false, false);
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    Template.AbilityShooterConditions.AddItem(WeaponCondition);

    Template.AdditionalAbilities.AddItem('LongWatch');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate TrainedSniper_RangeFinder()
{
    local X2AbilityTemplate         Template;
    local X2Condition_ValidWeapon   WeaponCondition;

    Template = Passive('M31_RangeFinder', "img:///UILibrary_MZChimeraIcons.WeaponMod_ScopeSuperior", false, false);

    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    Template.AbilityShooterConditions.AddItem(WeaponCondition);

    Template.AdditionalAbilities.AddItem('Squadsight');
    Template.AdditionalAbilities.AddItem('LongWatch');

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate TraverseFire()
{
    local X2AbilityTemplate     Template;
    local X2Effect_TraverseFire Effect;
    
    Template = Passive('M31_TraverseFire', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilityTraverseFire", false, true);

    Effect = new class 'X2Effect_TraverseFire';
    Effect.bRefundAll = false;
    Effect.ActionPointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
    Effect.AllowedAbilities = default.TraverseFire_AllowedAbilities;
    Effect.ActivationsPerTurn = `GetConfigInt("M31_TraverseFire_ActivationsPerTurn");
    Effect.bMatchSourceWeapon = true;
    Effect.bShowFlyover = true;
    Effect.bAllowCBACOverride = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate TraverseFirePlus()
{
    local X2AbilityTemplate     Template;
    local X2Effect_TraverseFire Effect;
    
    Template = Passive('M31_TraverseFirePlus', "img:///UILibrary_MeristOtherPerkIcons.LW_AbilityTraverseFire", false, true);

    Effect = new class 'X2Effect_TraverseFire';
    Effect.bRefundAll = false;
    Effect.ActionPointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
    Effect.AllowedAbilities = default.TraverseFirePlus_AllowedAbilities;
    Effect.ActivationsPerTurn = `GetConfigInt("M31_TraverseFire_ActivationsPerTurn");
    Effect.bMatchSourceWeapon = true;
    Effect.bShowFlyover = true;
    Effect.bAllowCBACOverride = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.OverrideAbilities.AddItem('M31_TraverseFire');

    return Template;
}

static function X2AbilityTemplate TroubleShooter()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_TroubleShooter', "img:///UILibrary_MZChimeraIcons.Ability_Crowdsource", false, true);
    
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

    SetAbilityShotHUDPriority(Template, ePriorityType_Primary, eCost_WeaponConsumeAll, eHostility_Offensive);

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

    Template = Passive('M31_WatchfulEye', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_watchfuleye", false, true);

    Template.AdditionalAbilities.AddItem('M31_WatchfulEye_Attack');

    return Template;
}

static function AddWatchfulEyeEffect(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffectsWithAbilitySource EffectCondition;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_UnitValueOnSource ValueCondition;
    local X2Effect_RemoveEffects        RemoveEffects;
    local X2Effect_WatchfulEye          Effect;

    // Remove existing Watchful Eye effect if the target is not affected by Holo from the same source
    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddExcludeEffect(class'X2Effect_WatchfulEye'.default.HoloEffectName, 'AA_UnitIsImmune');

    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove.AddItem(class'X2Effect_WatchfulEye'.default.EffectName);
    RemoveEffects.TargetConditions.AddItem(EffectCondition);
    Template.AddTargetEffect(RemoveEffects);
    if (Template.AbilityMultiTargetStyle != none)
    {
        Template.AddMultiTargetEffect(RemoveEffects);
    }

    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddExcludeEffect(class'X2Effect_WatchfulEye'.default.EffectName, 'AA_DuplicateEffectIgnored');

    // Infinite duration, hide if there is no Holo from the same source
    Effect = new class'X2Effect_WatchfulEye';
    Effect.BuildPersistentEffect(1, true, true);
    Effect.bRemoveWhenTargetDies = true;
    Effect.bUseSourcePlayerState = true;
    Effect.bUniqueTarget = `GetConfigBool("M31_WatchfulEye_bUniqueTarget");
    Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_WatchfulEye'.default.strFriendlyName, class'X2Effect_WatchfulEye'.default.strFriendlyDesc, "img:///UILibrary_MeristOtherPerkIcons.UIPerk_watchfuleye",,, Template.AbilitySourceName);
    Effect.TargetConditions.AddItem(EffectCondition);

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_WatchfulEye');
    Effect.TargetConditions.AddItem(AbilityCondition);

    if (`GetConfigInt("M31_WatchfulEye_ActivationsPerTurn") > 0)
    {
        ValueCondition = new class'X2Condition_UnitValueOnSource';
        ValueCondition.AddCheckValue(class'X2Effect_WatchfulEye'.default.CountValueName, `GetConfigInt("M31_WatchfulEye_ActivationsPerTurn"), eCheck_LessThan);
        Effect.TargetConditions.AddItem(ValueCondition);
    }

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

    Template = Attack('M31_WatchfulEye_Attack', "img:///UILibrary_MeristOtherPerkIcons.UIPerk_watchfuleye", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    AddOverwatchTriggers(Template);

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
    TargetEffectCondition.AddRequireEffect(class'X2Effect_WatchfulEye'.default.HoloEffectName, 'AA_MissingRequiredEffect');
    TargetEffectCondition.AddRequireEffect(class'X2Effect_WatchfulEye'.default.EffectName, 'AA_MissingRequiredEffect');
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

    AddBladestormMark(Template, 'M31_WatchfulEye_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_WatchfulEye_Counter', `GetConfigInt("M31_WatchfulEye_AttacksPerTurn"));

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

static function X2AbilityTemplate ZoneOfControl()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsWithAbilitySource EffectCondition;
    local X2Effect_ZoneOfControl            Effect;

    Template = SelfTargetTrigger('M31_ZoneOfControl', "img:///UILibrary_WOTC_APA_Class_Pack_LW.perk_ZoneOfControl");

    Template.BuildVisualizationFn = none;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'M31_BuffMe';
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_BuffMe;
    Trigger.ListenerData.Priority = 50;
    Template.AbilityTriggers.AddItem(Trigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeInStasis = false;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    EffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    EffectCondition.AddExcludeEffect(class'X2Effect_ZoneOfControl'.default.EffectName, 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(EffectCondition);

    Effect = new class'X2Effect_ZoneOfControl';
    Effect.bIsUnique = !`GetConfigBool("M31_ZoneOfControl_bAllowStack");
    Effect.bAllowWhileImpaired = `GetConfigBool("M31_ZoneOfControl_bAllowWhileImpaired");
    Effect.Radius = `GetConfigFloat("M31_ZoneOfControl_Radius");
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ZoneOfControl_AimPenalty"));
    Effect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_ZoneOfControl_MobilityPenalty"));
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_ZoneOfControl_Passive');

    return Template;
}

static function X2AbilityTemplate ZoneOfControlPassive()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ZoneOfControl_Source Effect;

    // TODO: Import icon
    Template = Passive('M31_ZoneOfControl_Passive', "img:///UILibrary_WOTC_APA_Class_Pack_LW.perk_ZoneOfControl", false, false);
    Template.bIsPassive = false;

    Effect = new class'X2Effect_ZoneOfControl_Source';
    Effect.UpdateEventName = class'X2Effect_ZoneOfControl'.default.UpdateEventName;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    // TODO: Does this need a sync?
    // Template.BuildAppliedVisualizationSyncFn = ZoneOfControl_BuildVisualizationSync;

    return Template;
}

static function ZoneOfControl_BuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
    local XComGameStateContext_Ability  AbilityContext;
    local X2AbilityTemplate             AbilityTemplate;
    local int                           i;

    if (!`XENGINE.IsMultiplayerGame() && EffectName == class'X2Effect_ZoneOfControl_Source'.default.EffectName)
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

static function X2AbilityTemplate AcidRoundsAttackPassive()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WeaponEffect     WeaponEffect;
    local X2Effect_AcidRoundsShred  ShredEffect;

    Template = Passive('M31_AcidRoundsPassive', "img:///UILibrary_MZChimeraIcons.Grenade_Acid", false, true);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_AcidRounds_Passive';
    WeaponEffect.AttackName = 'M31_AcidRounds_Attack';
    WeaponEffect.AdditionalWeaponCategories = class'X2DLCInfo_MeristPerkPack'.default.PistolCategories;
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    ShredEffect = new class'X2Effect_AcidRoundsShred';
    ShredEffect.ShredBonus = `GetConfigInt("M31_AcidRounds_ShredBonus");
    ShredEffect.AdditionalWeaponCategories = class'X2DLCInfo_MeristPerkPack'.default.PistolCategories;
    ShredEffect.BuildPersistentEffect(1, true, false);
    ShredEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(ShredEffect);

    Template.AdditionalAbilities.AddItem('M31_AcidRounds_Attack');

    return Template;
}

static function X2AbilityTemplate AcidRoundsAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
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
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_BleedingRoundsPassive', "img:///UILibrary_MZChimeraIcons.Ability_RendingSlash", false, true);
        
    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_BleedingRounds_Passive';
    WeaponEffect.AttackName = 'M31_BleedingRounds_Attack';
    WeaponEffect.AdditionalWeaponCategories = class'X2DLCInfo_MeristPerkPack'.default.PistolCategories;
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_BleedingRounds_Attack');

    return Template;
}

static function X2AbilityTemplate BleedingRoundsAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
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
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_Bleeding_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding"); 

    return BleedingEffect;
}

static function X2AbilityTemplate Bloodlet()
{
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_Bloodlet', "img:///UILibrary_MeristOtherPerkIcons.Perk_Ph_Bloodlet", false, true);
        
    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_Bloodlet';
    WeaponEffect.AttackName = 'M31_Bloodlet_Attack';
    WeaponEffect.AdditionalWeaponCategories = class'X2DLCInfo_MeristPerkPack'.default.PistolCategories;
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Bloodlet_Attack');

    return Template;
}

static function X2AbilityTemplate BloodletAttack()
{
    local X2AbilityTemplate Template;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
        'M31_Bloodlet_Attack',
        "img:///UILibrary_MeristOtherPerkIcons.Perk_Ph_Bloodlet",
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
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_Bleeding_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding"); 

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
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_ThermalShock', "img:///KetarosPkg_Abilities.UIPerk_surprise", false, true);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_ThermalShock';
    WeaponEffect.AttackName = 'M31_ThermalShock_Attack';
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ThermalShock_Attack');

    return Template;
}

static function X2AbilityTemplate ThermalShockAttack()
{
    local X2AbilityTemplate         Template;
    local X2Effect_ThermalShock     Effect;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
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
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_ToxicNightmare', "img:///UILibrary_MeristPerkIcons.UIPerk_ToxicNightmare", false, true);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_ToxicNightmare';
    WeaponEffect.AttackName = 'M31_ToxicNightmare_Attack';
    // WeaponEffect.AdditionalWeaponCategories = default.PistolCategories;
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ToxicNightmare_Attack');

    return Template;
}

static function X2AbilityTemplate ToxicNightmareAttack()
{
    local X2AbilityTemplate                 Template;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
        'M31_ToxicNightmare_Attack',
        "img:///UILibrary_MeristPerkIcons.UIPerk_ToxicNightmare",
        class'X2StatusEffects'.static.CreatePoisonedStatusEffect()
    );

    return Template;
}

static function X2AbilityTemplate Shiver2()
{
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_Shiver2', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", false, false);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_Shiver2';
    WeaponEffect.AttackName = 'M31_Shiver2_Attack';
    WeaponEffect.BuildPersistentEffect(1, true, false);
    WeaponEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Shiver2_Attack');

    return Template;
}

static function X2AbilityTemplate Shiver2Attack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_PercentChanceWithRank ToHitCalc;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
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
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_HypothermiaRounds', "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverShot", false, false);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_HypothermiaRounds';
    WeaponEffect.AttackName = 'M31_HypothermiaRounds_Attack';
    WeaponEffect.BuildPersistentEffect(1, true, false);
    WeaponEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_HypothermiaRounds_Attack');

    return Template;
}

static function X2AbilityTemplate HypothermiaRoundsAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_PercentChanceWithRank ToHitCalc;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
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
    local X2AbilityTemplate     Template;
    local X2Effect_WeaponEffect WeaponEffect;

    Template = Passive('M31_ShiverCrit2', "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverCrit", false, false);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_ShiverCrit2';
    WeaponEffect.AttackName = 'M31_ShiverCrit2_Attack';
    WeaponEffect.AdditionalWeaponCategories = default.ShiverCrit2_AdditionalCategories;
    WeaponEffect.AllowedHitResults.AddItem(eHit_Crit);
    WeaponEffect.BuildPersistentEffect(1, true, false);
    WeaponEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(WeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ShiverCrit2_Attack');

    return Template;
}

static function X2AbilityTemplate ShiverCrit2Attack()
{
    local X2AbilityTemplate Template;
    local X2AbilityToHitCalc_PercentChanceWithRank ToHitCalc;

    Template = class'M31_Helpers'.static.CreateWeaponEffectAttack(
        'M31_ShiverCrit2_Attack',
        "img:///UILibrary_MeristPerkIcons.UIPerk_ShiverCrit"
    );

    class'BitterfrostHelper'.static.AddBitterfrostToTarget(Template);

    ToHitCalc = new class'X2AbilityToHitCalc_PercentChanceWithRank';
    ToHitCalc.PercentToHit = `GetConfigInt("M31_ShiverCrit2_PrcChance");
    ToHitCalc.PercentToHitPerRank = `GetConfigFloat("M31_ShiverCrit2_PrcChancePerRank");
    Template.AbilityToHitCalc = ToHitCalc;

    return Template;
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
    local X2Condition_ValidWeapon   WeaponCondition;

    Template = Passive('M31_Chimera', "img:///UILibrary_MeristPerkIcons.UIPerk_Chimera", false, false);

    // SMG
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('smg');
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'ShadowOps_Airstrike', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Rifle (excluding Bolt Caster)
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('rifle');
    WeaponCondition.ExcludedWeaponTemplates = class'X2DLCInfo_MeristPerkPack'.default.BoltCasterTemplates;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'CyclicFire', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Bolt Caster
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponTemplates = class'X2DLCInfo_MeristPerkPack'.default.BoltCasterTemplates;
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_Pinpoint', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Shotgun
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('shotgun');
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_AssaultShot', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Cannon
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('cannon');
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'SaturationFire', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Sniper Rifle
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('sniper_rifle');
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'Squadsight', eInvSlot_PrimaryWeapon, WeaponCondition);
    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'DoubleTap2', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Vektor Rifle
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('vektor_rifle');
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'Squadsight', eInvSlot_PrimaryWeapon, WeaponCondition);
    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_BurstFire', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Bullpup
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('bullpup');
    WeaponCondition.Slot = eInvSlot_PrimaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'Battlelord', eInvSlot_PrimaryWeapon, WeaponCondition);

    // Sword
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('sword');
    WeaponCondition.Slot = eInvSlot_SecondaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_Overpower', eInvSlot_SecondaryWeapon, WeaponCondition);

    // Combat Knife
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('combatknife');
    WeaponCondition.Slot = eInvSlot_SecondaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_PA_CripplingBlow', eInvSlot_SecondaryWeapon, WeaponCondition);

    // Ripjack
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('wristblade');
    WeaponCondition.Slot = eInvSlot_SecondaryWeapon;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_CombatAdvance', eInvSlot_SecondaryWeapon, WeaponCondition);

    // Pistol
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('pistol');
    WeaponCondition.Slot = eInvSlot_Pistol;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'MZFranticFire', eInvSlot_Pistol, WeaponCondition);

    // Autopistol
    WeaponCondition = new class'X2Condition_ValidWeapon';
    WeaponCondition.AllowedWeaponCategories.AddItem('sidearm');
    WeaponCondition.Slot = eInvSlot_Pistol;

    class'X2DLCInfo_MeristPerkPack'.static.AddConditionalEarnedAbility(Template.DataName, 'M31_PistolRouletteShot', eInvSlot_Pistol, WeaponCondition);

    return Template;
}

defaultproperties
{
    SniperOverwatchActionPoint = M31_SniperOverwatch
    SuppressingFireActionPoint = M31_SuppressingFire
}