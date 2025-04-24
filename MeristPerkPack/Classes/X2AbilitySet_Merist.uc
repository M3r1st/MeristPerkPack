class X2AbilitySet_Merist extends X2Ability_Extended config(GameData_SoldierSkills);

var config bool bFrostbane_CheckSourceWeapon;

var config array<name> ColdBlooded_AllowedAbilities;
var config array<name> ColdBlooded_AllowedEffects;
var config array<name> Relentless_AllowedAbilities;
var config array<name> Suppression_Area_AllowedCategories;
var config array<name> TrainedSniper_AllowedCategories;
var config array<name> TraverseFire_AllowedAbilities;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;
    
    // Templates.AddItem(Adrenaline());
    //     Templates.AddItem(AdrenalineTrigger());
    Templates.AddItem(Aim());
    Templates.AddItem(AlphaStrike());
    Templates.AddItem(Bandit());
    Templates.AddItem(BattalionCommander());
    Templates.AddItem(Botnet());
    Templates.AddItem(ColdBlooded());
    Templates.AddItem(ConcussiveGrenades());
    Templates.AddItem(DeathAdder());
        Templates.AddItem(DeathAdderBonus());
    Templates.AddItem(Dervish());
        Templates.AddItem(DervishTrigger());
    Templates.AddItem(Duskborn());
        Templates.AddItem(DuskbornTrigger());
    Templates.AddItem(Entrench());
        Templates.AddItem(EntrenchTrigger());
    Templates.AddItem(EyeOnTarget());
    Templates.AddItem(Escalation());
    Templates.AddItem(Frostbane());
    Templates.AddItem(GenevaSuggestion());
    Templates.AddItem(Meld());
    Templates.AddItem(NeurotoxicShot());
    Templates.AddItem(Overseer());
    Templates.AddItem(PerfectHandling());
    Templates.AddItem(Pinpoint());
        Templates.AddItem(PinpointBonus());
    Templates.AddItem(PipeBombs());
    Templates.AddItem(Relentless());
    Templates.AddItem(SnipersOverwatch());
        Templates.AddItem(SnipersOverwatchShot());
    Templates.AddItem(SolidSnake());
    Templates.AddItem(Sparkfire());
    Templates.AddItem(SuperheavyOrdnance());
    Templates.AddItem(SupplyPack());
    Templates.AddItem(SuppressingFire());
        Templates.AddItem(SuppressingFireAddActions());
    Templates.AddItem(Suppression());
    Templates.AddItem(TrainedSniper_Squadsight());
    Templates.AddItem(TrainedSniper_LongWatch());
    Templates.AddItem(TrainedSniper_RangeFinder());
    Templates.AddItem(TraverseFire());
    Templates.AddItem(Warbringer());

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
    return Templates;
}

static function X2AbilityTemplate Adrenaline()
{
    local X2AbilityTemplate                     Template;

    Template = Passive('M31_Adrenaline', "img:///UILibrary_XPerkIconPack.UIPerk_shield_plus", false, true);

    Template.AdditionalAbilities.AddItem('M31_Adrenaline_Trigger');

    return Template;
}

static function X2AbilityTemplate AdrenalineTrigger()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Effect_PersonalShield               Effect;
    local X2Condition_UnitValue                 ValueCondition;
    local X2Effect_IncrementUnitValue           UnitValueEffect;

    Template = SelfTargetTrigger('M31_Adrenaline_Trigger', "img:///UILibrary_XPerkIconPack.UIPerk_shield_plus");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'M31_AbilityHelpers'.static.KillMailListener_Self;
    Trigger.ListenerData.Priority = 41;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_PersonalShield';
    Effect.EffectName = 'M31_Adrenaline';
    Effect.ShieldAmountBase = `GetConfigInt("M31_Adrenaline_ShieldAmount");
    Effect.DuplicateResponse = eDupe_Allow;
    Effect.BuildPersistentEffect(1, true, true);
    Template.AddTargetEffect(Effect);
    
    ValueCondition = new class'X2Condition_UnitValue';
    ValueCondition.AddCheckValue('M31_Adrenaline', `GetConfigInt("M31_Adrenaline_ActivationsPerMission"), eCheck_LessThan);
    Template.AbilityTargetConditions.AddItem(ValueCondition);

    UnitValueEffect = new class'X2Effect_IncrementUnitValue';
    UnitValueEffect.UnitName = 'M31_Adrenaline';
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddTargetEffect(UnitValueEffect);

    Template.bShowActivation = true;

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
    local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

    Template = SelfTargetActivated('M31_AlphaStrike', "img:///UILibrary_MZChimeraIcons.Ability_Dash", false);

    AddCooldown(Template, `GetConfigInt("M31_AlphaStrike_Cooldown"));
    AddCharges(Template, `GetConfigInt("M31_AlphaStrike_Charges"));
    AddActionPointCost(Template, eCost_DoubleConsumeAll);

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
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
    Template.AddMultiTargetEffect(ActionPointEffect);
    
    Template.bShowActivation = true;
    Template.bSkipFireAction = false;
    Template.bSkipExitCoverWhenFiring = true;
    
    Template.CustomFireAnim = 'HL_SignalPositiveA';
    Template.CinescriptCameraType = "Skirmisher_CombatPresence";

    Template.AbilityConfirmSound = "Combat_Presence_Activate";
    Template.ActivationSpeech = 'CombatPresence';

    return Template;
}

static function X2AbilityTemplate Bandit()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Bandit                   Effect;
    
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
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_Botnet_Valid';
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Botnet_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    Effect.DuplicateResponse = eDupe_Refresh;
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);

    Template.AddTargetEffect(Effect);
    Template.AddMultiTargetEffect(Effect);

    Template.bShowActivation = true;

    Template.AbilityConfirmSound = "Unreal2DSounds_TargetLock";

    return Template;
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
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ConcussiveGrenades() 
{
    local X2AbilityTemplate                         Template;

    Template = Passive('M31_ConcussiveGrenades', "img:///UILibrary_MZChimeraIcons.Grenade_Plasma", false, true);
    
    return Template;
}

static function X2AbilityTemplate DeathAdder()
{
    local X2AbilityTemplate                         Template;

    Template = Attack('M31_DeathAdder', "img:///UILibrary_PerkIcons.UIPerk_ruptured", false, true);

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
    Template.AddTargetEffect(Effect);

    return Template;
}

function EventListenerReturn DeepCoverListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory              History;
    local XComGameState                     NewGameState;
    local XComGameState_Unit                UnitState;
    local XComGameState_Ability             AbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local StateObjectReference              HunkerDownRef;
    local XComGameState_Ability             HunkerDownState;
    local X2AbilityCost                     AbilityCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local UnitValue                         AttacksThisTurn;
    local bool                              bFoundDeepCoverCost;

    History = `XCOMHISTORY;
    AbilityState = XComGameState_Ability(CallbackData);
    UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    if (UnitState == none)
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

    if (UnitState != none && !UnitState.IsHunkeredDown())
    {
        if (!UnitState.GetUnitValue('AttacksThisTurn', AttacksThisTurn) || AttacksThisTurn.fValue == 0)
        {
            foreach UnitState.Abilities(HunkerDownRef)
            {
                HunkerDownState = XComGameState_Ability(History.GetGameStateForObjectID(HunkerDownRef.ObjectID));
                AbilityTemplate = HunkerDownState.GetMyTemplate();
                bFoundDeepCoverCost = false;
                foreach AbilityTemplate.AbilityCosts(AbilityCost)
                {
                    ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
                    if (ActionPointCost != none &&
                        ActionPointCost.AllowedTypes.Find(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint) != INDEX_NONE)
                    {
                        bFoundDeepCoverCost = true;
                        break;
                    }
                }
                if (bFoundDeepCoverCost && HunkerDownState.CanActivateAbility(UnitState, , true) == 'AA_Success')
                {
                    if (UnitState.NumActionPoints() == 0)
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
                        UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }

                    return HunkerDownState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
                }   
            }
        }
    }

    return ELR_NoInterrupt;
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
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Effect_ReduceCooldowns              Effect;
    local X2Condition_UnitValue                 ValueCondition;
    local X2Effect_IncrementUnitValue           UnitValueEffect;

    Template = SelfTargetTrigger('M31_Dervish_Trigger', "img:///UILibrary_MZChimeraIcons.Ability_Recharge");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'M31_AbilityHelpers'.static.KillMailListener_Self;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.Amount = `GetConfigInt("M31_Dervish_CooldownReduction");
    Effect.ReduceAll = false;
    Template.AddTargetEffect(Effect);
    
    ValueCondition = new class'X2Condition_UnitValue';
    ValueCondition.AddCheckValue('M31_Dervish', `GetConfigInt("M31_Dervish_ActivationsPerTurn"), eCheck_LessThan);
    Template.AbilityTargetConditions.AddItem(ValueCondition);

    UnitValueEffect = new class'X2Effect_IncrementUnitValue';
    UnitValueEffect.UnitName = 'M31_Dervish';
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(UnitValueEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate Duskborn()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ToHitModifier            Effect;
    local X2Condition_UnitProperty          StealthCondition;
    local X2Condition_UnitProperty          NoStealthCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    Template = Passive('M31_Duskborn', "img:///UILibrary_PerkIcons.UIPerk_Stealth", false, true);

    Effect = new class'X2Effect_ToHitModifier';
    Effect.EffectName = 'M31_Duskborn';
    Effect.DuplicateResponse = eDupe_Ignore;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.AddEffectHitModifier(eHit_Success, `GetConfigInt("M31_Duskborn_AimBonus"), Template.LocFriendlyName);
    Effect.AddEffectHitModifier(eHit_Crit, `GetConfigInt("M31_Duskborn_CritBonus"), Template.LocFriendlyName);

    StealthCondition = new class 'X2Condition_UnitProperty';
    StealthCondition.IsConcealed = true;
    Effect.ToHitConditions.AddItem(StealthCondition);

    Effect = new class'X2Effect_ToHitModifier';
    Effect.EffectName = 'M31_Duskborn_Lasting';
    Effect.DuplicateResponse = eDupe_Ignore;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.AddEffectHitModifier(eHit_Success, `GetConfigInt("M31_Duskborn_AimBonus"), Template.LocFriendlyName);
    Effect.AddEffectHitModifier(eHit_Crit, `GetConfigInt("M31_Duskborn_CritBonus"), Template.LocFriendlyName);

    NoStealthCondition = new class 'X2Condition_UnitProperty';
    NoStealthCondition.ExcludeConcealed = true;
    Effect.ToHitConditions.AddItem(NoStealthCondition);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_Duskborn_Valid', 'AA_MissingRequiredEffect');
    Effect.ToHitConditions.AddItem(EffectCondition);

    Template.AdditionalAbilities.AddItem('M31_Duskborn_Trigger');

    return Template;
}

static function X2AbilityTemplate DuskbornTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_Persistent               Effect;

    Template = SelfTargetTrigger('M31_Duskborn_Trigger', "img:///UILibrary_PerkIcons.UIPerk_Stealth");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 56;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_Duskborn_Valid';
    Effect.DuplicateResponse = eDupe_Refresh;
    Effect.BuildPersistentEffect(`GetConfigInt("M31_Duskborn_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_Duskborn_BonusText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}
static function X2AbilityTemplate Entrench()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        AbilityActionPointCost;
    local X2Condition_UnitProperty          PropertyCondition;
    local X2Effect_HunkerDown_LW	        HunkerDownEffect;
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

    return Template;
}

static function X2AbilityTemplate EyeOnTarget()
{
    local X2AbilityTemplate										Template;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget			Effect;

    Template = Passive('M31_EyeOnTarget', "img:///UILibrary_SOHunter.UIPerk_watchfuleye", false, false);

    Effect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    Effect.AddAbilities.AddItem('ShadowOps_ThisOnesMine');
    Effect.AddAbilities.AddItem('ShadowOps_WatchfulEye');
    Effect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Escalation()
{
    local X2AbilityTemplate				Template;
    local X2Effect_Escalation			Effect;

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
    local X2AbilityTemplate             Template;
    local X2Effect_FrostBonus           Effect;

    Template = Passive('M31_Frostbane', "img:///UILibrary_MPP.Shatter", false, true);

    Effect = new class'X2Effect_FrostBonus';
    Effect.FriendlyName = Template.LocFriendlyName;
    Effect.EffectName = 'M31_Frostbane';
    Effect.CritBase = `GetConfigInt("M31_Frostbane_CritBonus");
    Effect.CritPerTier = `GetConfigInt("M31_Frostbane_CritBonusPerTier");
    Effect.PierceBase = `GetConfigInt("M31_Frostbane_PiercingBonus");
    Effect.PiercePerTier = `GetConfigInt("M31_Frostbane_PiercingBonusPerTier");
    Effect.bCheckSourceWeapon = default.bFrostbane_CheckSourceWeapon;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate GenevaSuggestion()
{
    local X2AbilityTemplate                                 Template;
    local X2Effect_AddGrenade                               Effect;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory    GrenadeLauncherCondition;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory    RocketLauncherCondition;

    Template = Passive('M31_GenevaSuggestion', "img:///KetarosPkg_Abilities.UIPerk_bomb", false, false);

    GrenadeLauncherCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    GrenadeLauncherCondition.AllowedWeaponCategories.AddItem('grenade_launcher');
    GrenadeLauncherCondition.bCheckSpecificSlot = true;
    GrenadeLauncherCondition.SpecificSlot = eInvSlot_SecondaryWeapon;

    RocketLauncherCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    RocketLauncherCondition.AllowedWeaponCategories.AddItem('iri_rocket_launcher');
    RocketLauncherCondition.bCheckSpecificSlot = true;
    RocketLauncherCondition.SpecificSlot = eInvSlot_SecondaryWeapon;

    Effect = new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = true;
    Effect.DataName = 'AcidGrenade';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.TargetConditions.AddItem(GrenadeLauncherCondition);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Effect = new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = true;
    Effect.DataName = 'GasGrenade';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.TargetConditions.AddItem(GrenadeLauncherCondition);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Effect = new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = true;
    Effect.DataName = 'Firebomb';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.TargetConditions.AddItem(GrenadeLauncherCondition);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Effect= new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = false;
    Effect.DataName = 'IRI_X2Rocket_Napalm';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.TargetConditions.AddItem(RocketLauncherCondition);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Effect = new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = false;
    Effect.DataName = 'IRI_X2Rocket_WhitePh';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.TargetConditions.AddItem(RocketLauncherCondition);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);
    
    return Template;
}

static function X2AbilityTemplate ImprovedSuppression()
{
    local X2AbilityTemplate                 Template;
    
    Template = Passive('M31_ImprovedSuppression', "img:///UILibrary_SOInfantry.UIPerk_improvedsuppression", false, true);

    return Template;
}

static function X2AbilityTemplate Meld()
{
    local X2AbilityTemplate                     Template;
    local X2Effect_RangerStealth                StealthEffect;

    Template = SelfTargetActivated('M31_Meld', "img:///UILibrary_PerkIcons.UIPerk_stealth", false);

    AddCooldown(Template, `GetConfigInt("M31_Meld_Cooldown"));
    AddActionPointCost(Template, eCost_Free);

    Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
    Template.AddShooterEffectExclusions();

    StealthEffect = new class'X2Effect_RangerStealth';
    StealthEffect.EffectName = 'M31_Meld';
    StealthEffect.EffectRemovedFn = Meld_EffectRemoved;
    StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    StealthEffect.BuildPersistentEffect(`GetConfigInt("M31_Meld_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
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

static function X2AbilityTemplate NeurotoxicShot()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Persistent               PoisonedEffect;
    local X2Effect_Persistent               DisorientedEffect;

    Template = Attack('M31_NeurotoxicShot', "img:///UILibrary_MZChimeraIcons.Ability_ToxicGreeting", false, true);

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

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddTargetEffect(DisorientedEffect);

    Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

    return Template;
}

static function X2AbilityTemplate Overseer()
{
    local X2AbilityTemplate										Template;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory		SniperRifleCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget			SniperRifleAbilityEffect;

    Template = Passive('M31_Overseer', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle05", false, false);
    
    SniperRifleCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    SniperRifleCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    SniperRifleCondition.bCheckSpecificSlot = true;
    SniperRifleCondition.SpecificSlot = eInvSlot_PrimaryWeapon;

    SniperRifleAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    SniperRifleAbilityEffect.AddAbilities.AddItem('Squadsight');
    SniperRifleAbilityEffect.AddAbilities.AddItem('M31_SnipersOverwatch');
    SniperRifleAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    SniperRifleAbilityEffect.TargetConditions.AddItem(SniperRifleCondition);
    Template.AddTargetEffect(SniperRifleAbilityEffect);

    return Template;
}

static function X2AbilityTemplate PerfectHandling()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ModifyRangePenalties Effect;

    Template = Passive('M31_PerfectHandling', "img:///UILibrary_SOHunter.UIPerk_point_blank", false, true);

    Effect = new class'X2Effect_ModifyRangePenalties';
    Effect.RangePenaltyMultiplier = `GetConfigFloat("M31_PerfectHandling_PenaltyModifier");
    Effect.BaseRange = `GetConfigInt("M31_PerfectHandling_BaseRange");
    Effect.bLongRange = true;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Pinpoint()
{
    local X2AbilityTemplate					Template;

    Template = Attack('M31_Pinpoint', "img:///UILibrary_MZChimeraIcons.WeaponMod_LaserSight_Sup", false, true);

    AddActionPointCost(Template, eCost_WeaponConsumeAll);
    AddAmmoCost(Template, 1);
    AddCooldown(Template, `GetConfigInt("M31_Pinpoint_Cooldown"));

    Template.AdditionalAbilities.AddItem('M31_Pinpoint_Bonus');

    return Template;
}

static function X2AbilityTemplate PinpointBonus()
{
    local X2AbilityTemplate					Template;
    local X2Effect_PinpointBonus			Effect;

    Template = Passive('M31_Pinpoint_Bonus', "img:///UILibrary_MZChimeraIcons.WeaponMod_LaserSight_Sup", false, false);

    Effect = new class'X2Effect_PinpointBonus';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate PipeBombs()
{
    local X2AbilityTemplate	Template;

    Template = Passive('M31_PipeBombs', "img:///UILibrary_MZChimeraIcons.Ability_ShrapnelGrenade", false, true);
    
    return Template;
}

static function X2AbilityTemplate Relentless()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Relentless               Effect;
    
    Template = Passive('M31_Relentless', "img:///UILibrary_SOCombatEngineer.UIPerk_skirmisher", false, true);

    Effect = new class'X2Effect_Relentless';
    Effect.ActivationsPerTurn = `GetConfigInt("M31_Relentless_ActivationsPerTurn");
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.bShowActivation = true;

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}

static function X2AbilityTemplate SnipersOverwatch()
{
    local X2AbilityTemplate							Template;
    local X2AbilityCooldown							Cooldown;
    local X2AbilityCost_Ammo						AmmoCost;
    local X2AbilityCost_ActionPoints				ActionPointCost;
    local X2AbilityTarget_Cursor					CursorTarget;
    local X2AbilityMultiTarget_Cone					ConeMultiTarget;
    local X2Effect_ReserveActionPoints				ReservePointsEffect;
    local X2Effect_MarkValidActivationTiles			MarkTilesEffect;
    local X2Condition_UnitEffects					SuppressedCondition;
    
    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SnipersOverwatch');

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    AmmoCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(AmmoCost);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.bAddWeaponTypicalCost = true;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = 1;
    Template.AbilityCooldown = Cooldown;

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = false;
    Template.AbilityTargetStyle = CursorTarget;

    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.ConeEndDiameter = 16 * class'XComWorldData'.const.WORLD_StepSize;
    ConeMultiTarget.ConeLength = 60 * class'XComWorldData'.const.WORLD_StepSize;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
    ReservePointsEffect.ReserveType = 'M31_SnipersOverwatch';
    ReservePointsEffect.NumPoints = 1;
    Template.AddShooterEffect(ReservePointsEffect);

    MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
    MarkTilesEffect.AbilityToMark = 'M31_SnipersOverwatchShot';
    Template.AddShooterEffect(MarkTilesEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.TargetingMethod = class'X2TargetingMethod_Cone';
    Template.bSkipFireAction = true;
    Template.bShowActivation = true;

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Vigilance";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.Hostility = eHostility_Defensive;
    Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

    Template.ActivationSpeech = 'KillZone';
    
    Template.bCrossClassEligible = false;
        
    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    Template.PostActivationEvents.AddItem('OverwatchUsed');

    Template.AdditionalAbilities.AddItem('M31_SnipersOverwatchShot');

    return Template;
}

static function X2AbilityTemplate SnipersOverwatchShot()
{
    local X2AbilityTemplate                         Template;
    local X2AbilityCost_Ammo                        AmmoCost;
    local X2AbilityCost_ReserveActionPoints         ReserveActionPointCost;
    local X2AbilityToHitCalc_StandardAim            StandardAim;
    local X2Condition_AbilityProperty               AbilityCondition;
    local X2AbilityTarget_Single                    SingleTarget;
    local X2AbilityTrigger_EventListener            Trigger;
    local X2Effect_Persistent                       KillZoneEffect;
    local X2Condition_UnitEffectsWithAbilitySource  KillZoneCondition;
    local X2Condition_Visibility                    TargetVisibilityCondition;
    local X2Condition_UnitProperty                  ShooterCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_SnipersOverwatchShot');

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);

    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;
    ReserveActionPointCost.bFreeCost = false;
    ReserveActionPointCost.AllowedTypes.AddItem('M31_SnipersOverwatch');
    Template.AbilityCosts.AddItem(ReserveActionPointCost);

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bReactionFire = true;
    Template.AbilityToHitCalc = StandardAim;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bDisablePeeksOnMovement = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.TargetMustBeInValidTiles = true;
    Template.AbilityTargetConditions.AddItem(AbilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    KillZoneCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    KillZoneCondition.AddExcludeEffect('KillZoneTarget', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(KillZoneCondition);

    KillZoneEffect = new class'X2Effect_Persistent';
    KillZoneEffect.EffectName = 'KillZoneTarget';
    KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    KillZoneEffect.SetupEffectOnShotContextResult(true, true);
    Template.AddTargetEffect(KillZoneEffect);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    ShooterCondition = new class'X2Condition_UnitProperty';
    ShooterCondition.ExcludeConcealed = false;
    Template.AbilityShooterConditions.AddItem(ShooterCondition);
    Template.AddShooterEffectExclusions();

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'ObjectMoved';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Vigilance";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
    return Template;
}

static function X2AbilityTemplate SolidSnake()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ModifyRangePenalties     RangeEffect;
    local X2Effect_SolidSnake               DodgeIgnoreEffect;

    Template = Passive('M31_SolidSnake', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_BloodTrail", false, true);

    RangeEffect = new class'X2Effect_ModifyRangePenalties';
    RangeEffect.RangePenaltyMultiplier = `GetConfigFloat("M31_SolidSnake_PenaltyModifier");
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
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2Effect_Burning                  BurningEffect;
    local X2Effect_TriggerEvent             InsanityEvent;

    Template = Attack('M31_Sparkfire', "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade", false, true);

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

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Fire');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        `GetConfigInt("M31_Sparkfire_BurnDamage"), `GetConfigInt("M31_Sparkfire_BurnDamage_Spread"));
    BurningEffect.TargetConditions.AddItem(UnitImmunityCondition);
    Template.AddTargetEffect(BurningEffect);

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
    InsanityEvent.ApplyChance = 100;
    InsanityEvent.TargetConditions.AddItem(new class'X2Condition_FuseTarget');
    Template.AddTargetEffect(InsanityEvent);

    Template.DamagePreviewFn = SparkfireDamagePreview;

    return Template;
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

static function X2AbilityTemplate SuperheavyOrdnance()
{
    local X2AbilityTemplate							Template;
    local X2Effect_SuperheavyOrdnanceRange			RangeEffect;
    local XMBEffect_AddItemCharges					ChargesEffect;

    Template = Passive('M31_SuperheavyOrdnance', "img:///UILibrary_MZChimeraIcons.Ability_Barrage", false, true);

    RangeEffect = new class'X2Effect_SuperheavyOrdnanceRange';
    RangeEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(RangeEffect);

    ChargesEffect = new class'XMBEffect_AddItemCharges';
    ChargesEffect.ApplyToSlots.AddItem(eInvSlot_GrenadePocket);
    ChargesEffect.PerItemBonus = `GetConfigInt("M31_SuperheavyOrdnance_ChargeBonus");
    Template.AddTargetEffect(ChargesEffect);

    return Template;
}

static function X2AbilityTemplate SupplyPack()
{
    local X2AbilityTemplate										Template;

    Template = Passive('M31_SupplyPack', "img:///IRIDenmotherUI.UIPerk_SupplyRun", false, false);

    Template.AdditionalAbilities.AddItem('IRI_ResupplyAmmo');
    Template.AdditionalAbilities.AddItem('IRI_BandageThrow');
    Template.AdditionalAbilities.AddItem('IRI_SupplyRun');

    return Template;
}

static function X2AbilityTemplate SuppressingFire()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_Ammo                AmmoCost;

    Template = Attack('M31_SuppressingFire', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_shot_2", false, true);

    AddActionPointCost(Template, eCost_WeaponConsumeAll);

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 3;
    AmmoCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(AmmoCost);

    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);

    AddCooldown(Template, `GetConfigInt("M31_SuppressingFire_Cooldown"));

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_SuppressingFire');

    Template.PostActivationEvents.AddItem('M31_SuppressingFire_Suppress');

    Template.AdditionalAbilities.AddItem('M31_SuppressingFire_Trigger');

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
    Trigger.ListenerData.Priority = 75;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_GrantActionPoints';
    Effect.NumActionPoints = 1;
    Effect.PointType = class'X2DLCInfo_MeristPerkPack'.default.SuppressingFireActionPoint;
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Suppression()
{
    local X2AbilityTemplate                                     Template;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory        CannonCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget          CannonAbilityEffect;

    Template = Passive('M31_Suppression', "img:///UILibrary_LW_PerkPack.LW_AreaSuppression", false, false);
    
    Template.AdditionalAbilities.AddItem('Suppression_LW');

    CannonCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    CannonCondition.AllowedWeaponCategories = default.Suppression_Area_AllowedCategories;
    CannonCondition.bCheckSpecificSlot = true;
    CannonCondition.SpecificSlot = eInvSlot_PrimaryWeapon;

    CannonAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    CannonAbilityEffect.AddAbilities.AddItem('AreaSuppression');
    CannonAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    CannonAbilityEffect.TargetConditions.AddItem(CannonCondition);
    Template.AddTargetEffect(CannonAbilityEffect);

    return Template;
}

static function X2AbilityTemplate TrainedSniper_Squadsight()
{
    local X2AbilityTemplate                                     Template;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory        SniperRifleCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget          SniperRifleAbilityEffect;

    Template = Passive('M31_TrainedSniper_Squadsight', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle01", false, false);
    
    SniperRifleCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    SniperRifleCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    SniperRifleCondition.bCheckSpecificSlot = true;
    SniperRifleCondition.SpecificSlot = eInvSlot_PrimaryWeapon;

    SniperRifleAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    SniperRifleAbilityEffect.AddAbilities.AddItem('Squadsight');
    SniperRifleAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    SniperRifleAbilityEffect.TargetConditions.AddItem(SniperRifleCondition);
    Template.AddTargetEffect(SniperRifleAbilityEffect);

    return Template;
}

static function X2AbilityTemplate TrainedSniper_LongWatch()
{
    local X2AbilityTemplate                                     Template;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory        SniperRifleCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget          SniperRifleAbilityEffect;

    Template = Passive('M31_TrainedSniper_LongWatch', "img:///KetarosPkg_Abilities.UIPerk_SniperRifle04", false, false);
    
    SniperRifleCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    SniperRifleCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    SniperRifleCondition.bCheckSpecificSlot = true;
    SniperRifleCondition.SpecificSlot = eInvSlot_PrimaryWeapon;

    SniperRifleAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    SniperRifleAbilityEffect.AddAbilities.AddItem('LongWatch');
    SniperRifleAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    SniperRifleAbilityEffect.TargetConditions.AddItem(SniperRifleCondition);
    Template.AddTargetEffect(SniperRifleAbilityEffect);

    return Template;
}

static function X2AbilityTemplate TrainedSniper_RangeFinder()
{
    local X2AbilityTemplate                                     Template;
    local X2Condition_WOTC_APA_Class_ValidWeaponCategory        SniperRifleCondition;
    local X2Effect_WOTC_APA_Class_AddAbilitiesToTarget          SniperRifleAbilityEffect;

    Template = Passive('M31_RangeFinder', "img:///UILibrary_MZChimeraIcons.WeaponMod_ScopeSuperior", false, false);
    
    SniperRifleCondition = new class'X2Condition_WOTC_APA_Class_ValidWeaponCategory';
    SniperRifleCondition.AllowedWeaponCategories = default.TrainedSniper_AllowedCategories;
    SniperRifleCondition.bCheckSpecificSlot = true;
    SniperRifleCondition.SpecificSlot = eInvSlot_PrimaryWeapon;

    SniperRifleAbilityEffect = new class'X2Effect_WOTC_APA_Class_AddAbilitiesToTarget';
    SniperRifleAbilityEffect.AddAbilities.AddItem('Squadsight');
    SniperRifleAbilityEffect.AddAbilities.AddItem('LongWatch');
    SniperRifleAbilityEffect.ApplyToWeaponSlot = eInvSlot_PrimaryWeapon;
    SniperRifleAbilityEffect.TargetConditions.AddItem(SniperRifleCondition);
    Template.AddTargetEffect(SniperRifleAbilityEffect);

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

static function X2AbilityTemplate Warbringer()
{
    local X2AbilityTemplate                 Template;
    local XMBEffect_BonusRadius             RadiusEffect;
    local X2Effect_AddGrenadeCharges        ChargesEffect;

    Template = Passive('M31_Warbringer', "img:///UILibrary_MZChimeraIcons.Ability_HeavyOrdinance", false, false);

    RadiusEffect = new class'XMBEffect_BonusRadius';
    RadiusEffect.EffectName = 'M31_Warbringer';
    RadiusEffect.fBonusRadius = `GetConfigInt("M31_Warbringer_RadiusBonus");
    RadiusEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(RadiusEffect);

    ChargesEffect = new class'X2Effect_AddGrenadeCharges';
    ChargesEffect.ApplyToSlots.AddItem(eInvSlot_Utility);
    ChargesEffect.ApplyToSlots.AddItem(eInvSlot_GrenadePocket);
    ChargesEffect.PerItemBonus = `GetConfigInt("M31_Warbringer_ChargeBonus");
    Template.AddTargetEffect(ChargesEffect);

    return Template;
}

static function X2AbilityTemplate AcidRoundsAttackPassive()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;
    local X2Effect_PersistentAttackModifier ShredEffect;

    Template = Passive('M31_AcidRoundsPassive', "img:///UILibrary_MZChimeraIcons.Grenade_Acid", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_AcidRounds_Passive';
    PassiveWeaponEffect.AttackName = 'M31_AcidRounds_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    ShredEffect = new class'X2Effect_PersistentAttackModifier';
    ShredEffect.EffectName = 'M31_AcidRounds_ShredBonus';
    ShredEffect.ShredBonus = `GetConfigInt("M31_AcidRounds_ShredBonus");
    ShredEffect.bCheckSourceWeapon = true;
    ShredEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(ShredEffect);

    Template.AdditionalAbilities.AddItem('M31_AcidRounds_Attack');

    return Template;
}

static function X2AbilityTemplate AcidRoundsAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Burning                  AcidBurningEffect;

    AcidBurningEffect = class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(
        `GetConfigInt("M31_AcidRounds_BurnDamage"), `GetConfigInt("M31_AcidRounds_BurnSpread"));

    Template = class'M31_AbilityHelpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_AcidRounds_Attack',
        "img:///UILibrary_MZChimeraIcons.Grenade_Acid",
        AcidBurningEffect
    );

    return Template;
}

static function X2AbilityTemplate BleedingRoundsAttackPassive()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_BleedingRoundsPassive', "img:///UILibrary_MZChimeraIcons.Ability_RendingSlash", false, true);
        
    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_BleedingRounds_Passive';
    PassiveWeaponEffect.AttackName = 'M31_BleedingRounds_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_BleedingRounds_Attack');

    return Template;
}

static function X2AbilityTemplate BleedingRoundsAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Persistent               BleedingEffect;

    BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_BleedingRounds_BleedDuration"), `GetConfigInt("M31_BleedingRounds_BleedDamage"));

    Template = class'M31_AbilityHelpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_BleedingRounds_Attack',
        "img:///UILibrary_MZChimeraIcons.Ability_RendingSlash",
        BleedingEffect
    );

    return Template;
}

static function X2AbilityTemplate Bloodlet()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_Bloodlet', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Bloodlet", false, true);
        
    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_Bloodlet';
    PassiveWeaponEffect.AttackName = 'M31_Bloodlet_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_Bloodlet_Attack');

    return Template;
}

static function X2AbilityTemplate BloodletAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Persistent               BleedingEffect;

    BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_Bloodlet_BleedDuration"), `GetConfigInt("M31_Bloodlet_BleedDamage"));

    Template = class'M31_AbilityHelpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_Bloodlet_Attack',
        "img:///UILibrary_FavidsPerkPack.Perk_Ph_Bloodlet",
        BleedingEffect
    );

    return Template;
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
    local X2AbilityTemplate                 Template;
    local X2Effect_PersistentStatChange     Effect;
    local X2Condition_UnitImmunities        UnitImmunityCondition;


    Template = class'M31_AbilityHelpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_ThermalShock_Attack',
        "img:///KetarosPkg_Abilities.UIPerk_surprise"
    );

    Effect = new class'X2Effect_PersistentStatChange';
    Effect.EffectName = 'M31_ThermalShock_Debuff';
    Effect.BuildPersistentEffect(`GetConfigInt("M31_ThermalShock_Duration"), false, false, true, eGameRule_PlayerTurnBegin);
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ThermalShock_AimPenalty"));
    Effect.AddPersistentStatChange(eStat_Defense, -1 * `GetConfigInt("M31_ThermalShock_DefensePenalty"));
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_ThermalShock_DebuffText"), Template.IconImage,,, Template.AbilitySourceName);
    Effect.DuplicateResponse = eDupe_Refresh;

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Frost');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Effect.TargetConditions.AddItem(UnitImmunityCondition);

    Template.AddTargetEffect(Effect);

    Effect = new class'X2Effect_PersistentStatChange';
    Effect.EffectName = 'M31_ThermalShock_Debuff';
    Effect.BuildPersistentEffect(`GetConfigInt("M31_ThermalShock_Duration"), false, false, true, eGameRule_PlayerTurnBegin);
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_ThermalShock_AimPenalty_Immune"));
    Effect.AddPersistentStatChange(eStat_Defense, -1 * `GetConfigInt("M31_ThermalShock_DefensePenalty_Immune"));
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_ThermalShock_DebuffText"), Template.IconImage,,, Template.AbilitySourceName);
    Effect.DuplicateResponse = eDupe_Refresh;

    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate ToxicNightmare()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PassiveWeaponEffect      PassiveWeaponEffect;

    Template = Passive('M31_ToxicNightmare', "img:///UILibrary_MeristPerkIcons.UIPerk_venomrounds", false, true);

    PassiveWeaponEffect = new class'X2Effect_PassiveWeaponEffect';
    PassiveWeaponEffect.EffectName = 'M31_ToxicNightmare';
    PassiveWeaponEffect.AttackName = 'M31_ToxicNightmare_Attack';
    PassiveWeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(PassiveWeaponEffect);

    Template.AdditionalAbilities.AddItem('M31_ToxicNightmare_Attack');

    return Template;
}

static function X2AbilityTemplate ToxicNightmareAttack()
{
    local X2AbilityTemplate                 Template;

    Template = class'M31_AbilityHelpers'.static.CreatePassiveWeaponEffectAttack(
        'M31_ToxicNightmare_Attack',
        "img:///UILibrary_MeristPerkIcons.UIPerk_venomrounds",
        class'X2StatusEffects'.static.CreatePoisonedStatusEffect()
    );

    return Template;
}