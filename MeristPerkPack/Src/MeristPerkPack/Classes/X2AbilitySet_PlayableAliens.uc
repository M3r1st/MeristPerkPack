class X2AbilitySet_PlayableAliens extends X2Ability_Extended config(GameData_SoldierSkills);

var config bool bCoil_AllowDeepCover;
var config bool bLockjaw_AllowCrit;
var config bool bViperBite_AllowCrit;
var config bool bSpit_RequireVisibility;
var config bool bPoisonSpit_DealsDamage;
var config bool bPoisonSpit_AppliesPoisonToWorld;
var config bool bFrostBreath_DealsDamage;
var config bool bPersonalShield_AllowWhileDisoriented;
var config bool bBayonetCharge_AllowWhileDisoriented;
var config bool bCounterattack_OnlyOnEnemyTurn;
var config bool bViperScaling_ApplyToSpit;
var config bool bViperScaling_ApplyToBind;
var config bool bViperScaling_ApplyToBindSustained;
var config bool bViperScaling_ApplyToBite;
var config bool bCripplingBlow_InfiniteDuration;
var config bool bCripplingBlow_AllowStack;

var config array<name> ViperSpit_Abilities;
var config array<name> GetOverHere_Abilities;
var config array<name> Bind_Abilities;
var config array<name> BindSustained_Abilities;
var config array<name> ViperBite_Abilities;
var config array<name> FrostbiteSpit_AllowedAbilities;
var config array<name> Salamander_AllowedGrenades;

var privatewrite name Counterattack_CounterName;
var privatewrite name SidewinderCooldownEffectName;
var privatewrite name SidewinderEventName;
var privatewrite name SidewinderOriginalGroupValueName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(MutonPunch());
    Templates.AddItem(ViperBash());

    Templates.AddItem(Ambush());
        Templates.AddItem(AmbushTrigger());
    Templates.AddItem(Coil());
        Templates.AddItem(CoilTrigger());
        Templates.AddItem(CoilCleanse());
    Templates.AddItem(Entwine());
    Templates.AddItem(Lockjaw());
        Templates.AddItem(LockjawAttack());
    Templates.AddItem(Rattle());
        Templates.AddItem(RattleTrigger());
    Templates.AddItem(Salamander());
    Templates.AddItem(Sidewinder());
        Templates.AddItem(SidewinderMove());
    Templates.AddItem(Slither());
    Templates.AddItem(ViperBite());

    Templates.AddItem(PoisonSpit());
        Templates.AddItem(EnhancedPoison());
        Templates.AddItem(BlindingPoison());
    Templates.AddItem(FrostSpit());
    Templates.AddItem(FrostbiteSpit());
    Templates.AddItem(FrostBreath());
    // Templates.AddItem(ViperDamageScaling());

    Templates.AddItem(PersonalShield());
    Templates.AddItem(Aegis());
    Templates.AddItem(HardenedShield());
    Templates.AddItem(CreateBayonetAbility('M31_PA_Bayonet', false));
    Templates.AddItem(CreateBayonetChargeAbility('M31_PA_BayonetCharge'));
    Templates.AddItem(Counterattack());
        Templates.AddItem(CreateBayonetAbility('M31_PA_Counterattack_Attack', true));
        Templates.AddItem(CounterattackDodge());
        Templates.AddItem(CounterattackTrigger());
    Templates.AddItem(CripplingBlow());
    Templates.AddItem(Bladestorm());

    Templates.AddItem(class'M31_AbilityHelpers'.static.CreateAnimSetPassive('M31_PA_FrostSpit_Anims', "PA_ViperKing_ANIM.Anims.AS_ViperKing"));
    Templates.AddItem(class'M31_AbilityHelpers'.static.CreateAnimSetPassive('M31_PA_ViperBash_Anims', "Viper_FireAndMeleeAnims.Anims.AS_Viper"));

    return Templates;
}

static function X2AbilityTemplate MutonPunch()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_MutonPunch');

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
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_MutonPunch_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_MutonPunch_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.bLimitTargetIcons = true;

    class'M31_AbilityHelpers'.static.AddAdjacencyCondition(Template);

    Template.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName); // okay when burning
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); // okay when disoriented
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_MutonPunch_Damage");
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bOverrideMeleeDeath = true;

    Template.Hostility = eHostility_Offensive;

    Template.CustomFireAnim = 'FF_MutonPunch';
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.AdditionalAbilities.AddItem('MutonPunch_Animation');

    return Template;
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

    class'M31_AbilityHelpers'.static.AddAdjacencyCondition(Template);

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

    Template = Passive('M31_PA_Ambush', "img:///UILibrary_PerkIcons.UIPerk_rapidreaction", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_Ambush_Trigger');

    return Template;
}

static function X2AbilityTemplate AmbushTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_ThreatAssessment         CoveringFireEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_Ambush_Trigger');

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.Priority = 51;
    Template.AbilityTriggers.AddItem(Trigger);

    CoveringFireEffect = new class'X2Effect_ThreatAssessment';
    CoveringFireEffect.EffectName = 'M31_PA_Ambush_Overwatch';
    CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
    CoveringFireEffect.AbilityToActivate = 'OverwatchShot';
    CoveringFireEffect.ImmediateActionPoint = class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint;
    Template.AddTargetEffect(CoveringFireEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.bShowActivation = true;
    Template.bSkipPerkActivationActions = true;
    Template.bSkipFireAction = true;
    
    return Template;
}

static function X2AbilityTemplate Coil()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCooldown                 Cooldown;
    local X2Condition_UnitProperty          PropertyCondition;
    local X2Condition_UnitEffects           EffectsCondition;
    local X2AbilityTrigger_PlayerInput      InputTrigger;
    local array<name>                       SkipExclusions;
    local X2Effect_HunkerDown_LW            HunkerDownEffect;
    
    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_Coil');
    // img:///UILibrary_PerkIcons.UIPerk_takecover
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_one_for_all";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.HUNKER_DOWN_PRIORITY;

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.HunkerDownAbility_BuildVisualization;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    if (default.bCoil_AllowDeepCover)
    {
        ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
    }
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    PropertyCondition = new class'X2Condition_UnitProperty';	
    PropertyCondition.ExcludeDead = true;                           // Can't hunkerdown while dead
    PropertyCondition.ExcludeFriendlyToSource = false;              // Self targeted
    // PropertyCondition.ExcludeNoCover = true;                        // Unit must be in cover.
    Template.AbilityShooterConditions.AddItem(PropertyCondition);

    EffectsCondition = new class'X2Condition_UnitEffects';
    EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
    EffectsCondition.AddExcludeEffect('M31_PA_Coil', 'AA_UnitIsImmune');
    Template.AbilityTargetConditions.AddItem(EffectsCondition);
    
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.AbilityToHitCalc = default.DeadEye;
    
    Template.AbilityTargetStyle = default.SelfTarget;

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_Coil_Cooldown");
    Template.AbilityCooldown = Cooldown;

    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);

    HunkerDownEffect = class'X2Effect_HunkerDown_LW'.static.HunkerDownEffect();
    HunkerDownEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
    HunkerDownEffect.EffectRemovedFn = Coil_EffectRemoved;
    Template.AddTargetEffect(HunkerDownEffect);

    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

    Template.Hostility = eHostility_Defensive;
    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    Template.bDontDisplayInAbilitySummary = false;

    Template.AdditionalAbilities.AddItem('M31_PA_Coil_Trigger');
    Template.AdditionalAbilities.AddItem('M31_PA_Coil_Cleanse');
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
    RemoveEffects.bApplyOnHit = true;
    RemoveEffects.bApplyOnMiss = true;
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
    local X2Effect_ApplyDamageWithRank              PhysicalDamageEffect;
    local X2Effect_Persistent                       BladestormTargetEffect;
    local X2Condition_UnitEffectsWithAbilitySource	BladestormTargetCondition;
    local X2Condition_UnitProperty                  SourceNotConcealedCondition;
    local X2Condition_Visibility                    TargetVisibilityCondition;
    local X2Condition_UnitProperty                  ExcludeSquadmatesCondition;
    local X2Condition_NotItsOwnTurn                 NotItsOwnTurnCondition;
    local X2AbilityCooldown_Extended                Cooldown;
    local X2Effect_Persistent                       StunnedEffect;
    local X2Condition_UnitProperty                  UnitPropertyCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_Lockjaw_Attack');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_QuickBite";

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.bReactionFire = true;
    ToHitCalc.bAllowCrit = default.bLockjaw_AllowCrit;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = 1;
    Cooldown.bApplyOnlyOnHit = true;
    Template.AbilityCooldown = Cooldown;

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

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = LockjawConcealmentListener;
    Trigger.ListenerData.Priority = 55;
    Template.AbilityTriggers.AddItem(Trigger);
    
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bRequireBasicVisibility = true;
    TargetVisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    ExcludeSquadmatesCondition = new class'X2Condition_UnitProperty';
    ExcludeSquadmatesCondition.ExcludeSquadmates = true;
    Template.AbilityTargetConditions.AddItem(ExcludeSquadmatesCondition);

    class'M31_AbilityHelpers'.static.AddAdjacencyCondition(Template);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
    Template.AddShooterEffectExclusions();

    SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
    SourceNotConcealedCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

    class'M31_AbilityHelpers'.static.AddEnhancedPoisonEffectToTarget(Template);
    class'M31_AbilityHelpers'.static.AddBlindingPoisonEffectToTarget(Template);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
    Template.AddTargetEffect(StunnedEffect);

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_Lockjaw_Damage");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_Lockjaw_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_Lockjaw_CritDamagePerRank");
    PhysicalDamageEffect.HideVisualizationOfResultsAdditional.AddItem('AA_HitResultFailure');
    Template.AddTargetEffect(PhysicalDamageEffect);
    
    BladestormTargetEffect = new class'X2Effect_Persistent';
    BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
    BladestormTargetEffect.EffectName = 'M31_PA_Lockjaw_MarkTarget';
    BladestormTargetEffect.bApplyOnMiss = true;
    Template.AddTargetEffect(BladestormTargetEffect);
    
    BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    BladestormTargetCondition.AddExcludeEffect('M31_PA_Lockjaw_MarkTarget', 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

    Template.CustomFireAnim = 'HL_ViciousBite';

    NotItsOwnTurnCondition = new class'X2Condition_NotItsOwnTurn';
    Template.AbilityShooterConditions.AddItem(NotItsOwnTurnCondition);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.bShowActivation = true;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    Template.bFrameEvenWhenUnitIsHidden = true;
    Template.DefaultSourceItemSlot = eInvSlot_Unknown;

    // Template.AdditionalAbilities.AddItem('M31_PA_ViperDamagePerRank');

    return Template;
}

static function EventListenerReturn LockjawConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateContext_Ability AbilityContext;
    local XComGameState_Unit ConcealmentBrokenUnit;
    local XComGameState_Ability BladestormState;

    ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
    if (ConcealmentBrokenUnit == None)
        return ELR_NoInterrupt;

    // Do not trigger if the Bladestorm Ranger himself moved to cause the concealment break - only when an enemy moved and caused it.
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
    if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
        return ELR_NoInterrupt;

    BladestormState = XComGameState_Ability(CallbackData);
    if (BladestormState == None)
        return ELR_NoInterrupt;
    
    BladestormState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
    return ELR_NoInterrupt;
}

static function X2AbilityTemplate Rattle()
{
    local X2AbilityTemplate         Template;

    Template = PurePassive('M31_PA_Rattle', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_harborwave", false, 'eAbilitySource_Perk', true);

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
    local X2Effect_Panicked                 PanickedEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_Rattle_Trigger');
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityTargetStyle = default.SelfTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'UnitConcealmentBroken';
    Trigger.ListenerData.Filter = eFilter_Unit;
    // Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_UnitSeesUnit;
    // Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AddShooterEffectExclusions();
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

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
    Template.AbilityMultiTargetConditions.AddItem(default.GameplayVisibilityCondition);

    PercentChanceToHit = new class'X2AbilityToHitCalc_PercentChance';
    PercentChanceToHit.PercentToHit = `GetConfigInt("M31_PA_Rattle_PanicChance");
    Template.AbilityToHitCalc = PercentChanceToHit;

    PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
    PanickedEffect.VisualizationFn = class'X2Ability_DLC_Day60ItemGrantedAbilitySet'.static.ArmorPanickedVisualization;
    Template.AddMultiTargetEffect(PanickedEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.bShowActivation = false;
    Template.bSkipPerkActivationActions = true;
    Template.bSkipFireAction = true;

    return Template;
}

static function X2AbilityTemplate Salamander()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_DamageImmunityByTypes    ImmunityEffect;
    local XMBEffect_BonusRadius             RadiusEffect;
    local X2Effect_AddGrenade               FreeGrenadeEffect;

    Template = Passive('M31_PA_Salamander', "img:///UILibrary_MPP.fireshield", false, true);

    ImmunityEffect = new class'X2Effect_DamageImmunityByTypes';
    ImmunityEffect.EffectName = 'M31_PA_Salamander_Radius';
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

    return Template;
}

static function X2AbilityTemplate SidewinderMove()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_Sidewinder_Move          InterruptTurnEffect;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Effect_Persistent               CooldownEffect;
    
    Template = SelfTargetTrigger('M31_PA_Sidewinder_Move', "img:///UILibrary_PerkIcons.UIPerk_Shadowstrike");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.SidewinderEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    InterruptTurnEffect = new class'X2Effect_Sidewinder_Move';
    InterruptTurnEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    InterruptTurnEffect.TargetConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddTargetEffect(InterruptTurnEffect);

    ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    ActionPointEffect.TargetConditions.AddItem(new class'X2Condition_ItsOwnTurn');
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
    local X2AbilityTarget_MovingMelee_Extended MeleeTarget;
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
    StandardMelee.bAllowCrit = default.bViperBite_AllowCrit;
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_Extended';
    MeleeTarget.iFixedRange = 1;
    MeleeTarget.bUseFixedRange = true;
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

    Template.CustomFireAnim = 'HL_ViciousBite';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    // Template.AdditionalAbilities.AddItem('M31_PA_ViperDamagePerRank');

    return Template;
}

static function X2AbilityTemplate PoisonSpit()
{
    local X2AbilityTemplate                 Template;	
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCooldown                 Cooldown;
    local X2Effect_ApplyDamageWithRank      DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_PoisonSpit', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit");

    X2AbilityMultiTarget_Cylinder(Template.AbilityMultiTargetStyle).fTargetRadius = `GetConfigFloat("M31_PA_PoisonSpit_Radius");

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Poison');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_PoisonSpit_Cooldown");
    Template.AbilityCooldown = Cooldown;

    class'M31_AbilityHelpers'.static.AddEnhancedPoisonEffectToMultiTarget(Template);
    class'M31_AbilityHelpers'.static.AddBlindingPoisonEffectToMultiTarget(Template);

    if (default.bPoisonSpit_DealsDamage)
    {
        DamageEffect = new class'X2Effect_ApplyDamageWithRank';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_PoisonSpit_Damage");
        DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_PoisonSpit_DamagePerRank");
        Template.AddMultiTargetEffect(DamageEffect);
    }

    if (default.bPoisonSpit_AppliesPoisonToWorld)
    {
        Template.AddMultiTargetEffect(new class'X2Effect_ApplyPoisonToWorld');
    }

    // Template.AdditionalAbilities.AddItem('M31_PA_ViperDamagePerRank');

    Template.CustomFireAnim = 'HL_PoisonSpit';

    return Template;
}

static function X2AbilityTemplate EnhancedPoison()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   Effect;

    Template = Passive('M31_PA_EnhancedPoison', "img:///UILibrary_PerkIcons.UIPerk_poisoned", false, false);
    
    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_PA_EnhancedPoison_Valid';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BlindingPoison()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   Effect;

    Template = Passive('M31_PA_BlindingPoison', "img:///UILibrary_PerkIcons.UIPerk_insanity", false, false);
    
    Effect = new class'X2Effect_Persistent';
    Effect.EffectName = 'M31_PA_BlindingPoison_Valid';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate FrostSpit()
{
    local X2AbilityTemplate                 Template;	
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCooldown                 Cooldown;
    local X2Effect_ApplyDamageWithRank      DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_FrostSpit', "img:///UILibrary_PerkIcons.UIPerk_viper_poisonspit");

    X2AbilityMultiTarget_Cylinder(Template.AbilityMultiTargetStyle).fTargetRadius = `GetConfigFloat("M31_PA_FrostSpit_Radius");

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Frost');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_FrostSpit_Cooldown");
    Template.AbilityCooldown = Cooldown;

    class'BitterfrostHelper'.static.AddBitterfrostToMultiTarget(Template);

    DamageEffect = new class'X2Effect_ApplyDamageWithRank';
    DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_FrostSpit_Damage");
    DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_FrostSpit_DamagePerRank");
    Template.AddMultiTargetEffect(DamageEffect);

    Template.CustomFireAnim = 'HL_FrostBite';

    // Template.AdditionalAbilities.AddItem('M31_PA_ViperDamagePerRank');
    
    return Template;
}

static function X2AbilityTemplate FrostbiteSpit()
{
    local X2AbilityTemplate         Template;
    local X2Effect_FrostbiteSpit    Effect;

    Template = Passive('M31_PA_FrostbiteSpit', "img:///UILibrary_SODragoon.UIPerk_overkill", false, true);
    
    Effect = new class'X2Effect_FrostbiteSpit';
    Effect.EffectName = 'M31_PA_FrostbiteSpit';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate FrostBreath()
{
    local X2AbilityTemplate                 Template;	
    local X2Condition_UnitImmunities        UnitImmunityCondition;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCooldown                 Cooldown;
    local X2Effect_ApplyDamageWithRank      DamageEffect;

    Template = CreateViperSpitAbility('M31_PA_FrostBreath', "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 1;

    X2AbilityMultiTarget_Cylinder(Template.AbilityMultiTargetStyle).fTargetRadius = `GetConfigFloat("M31_PA_FrostBreath_Radius");

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Frost');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_FrostBreath_Cooldown");
    Template.AbilityCooldown = Cooldown;

    AddCharges(Template, `GetConfigInt("M31_PA_FrostBreath_Charges"));

    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeEffect(false));
    Template.AddMultiTargetEffect(class'BitterfrostHelper'.static.FreezeCleanse(false));

    if (default.bFrostBreath_DealsDamage)
    {
        DamageEffect = new class'X2Effect_ApplyDamageWithRank';
        DamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_FrostBreath_Damage");
        DamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_FrostBreath_DamagePerRank");
        Template.AddMultiTargetEffect(DamageEffect);
    }

    Template.CustomFireAnim = 'HL_FrostBite';

    // Template.AdditionalAbilities.AddItem('M31_PA_ViperDamagePerRank');
    Template.AdditionalAbilities.AddItem('M31_PA_FrostSpit_Anims');

    return Template;
}

static function X2AbilityTemplate ViperDamageScaling()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ViperDamageScaling   Effect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_ViperDamagePerRank');

    Template = Passive('M31_PA_ViperDamagePerRank', "img:///UILibrary_PerkIcons.UIPerk_standard", false, false);

    Effect = new class'X2Effect_ViperDamageScaling';
    Effect.EffectName = 'M31_PA_ViperDamagePerRank';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

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
    CylinderMultiTarget.bIgnoreBlockingCover = default.bSpit_RequireVisibility;
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
    CursorTarget.bRestrictToSquadsightRange = default.bSpit_RequireVisibility;
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


static function X2DataTemplate PersonalShield()
{
    local X2AbilityTemplate                         Template;
    local X2AbilityCooldown                         Cooldown;
    local X2AbilityCost_ActionPoints                ActionPointCost;
    local array<name>                               SkipExclusions;
    local X2Effect_RemoveEffects                    RemoveEffect;
    local X2Effect_PersonalShield                   Effect;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'M31_PA_PersonalShield');

    Template.AbilitySourceName = 'eAbilitySource_Perk';

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_Phalanx";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY - 1;

    Template.Hostility = eHostility_Defensive;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    if (default.bPersonalShield_AllowWhileDisoriented)
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);

    RemoveEffect = new class'X2Effect_RemoveEffects';
    RemoveEffect.EffectNamesToRemove.AddItem('M31_PA_PersonalShield');
    RemoveEffect.bDoNotVisualize = true;
    Template.AddTargetEffect(RemoveEffect);

    Effect = new class'X2Effect_PersonalShield';
    Effect.EffectName = 'M31_PA_PersonalShield';
    Effect.ShieldAmount = `GetConfigArrayInt("M31_PA_PersonalShield_ShieldAmount");
    Effect.ShieldPriority = 20;
    Effect.bGetShieldAmountFromArmor = true;
    Effect.AddAdditionalShieldAmount('M31_PA_HardenedShield', `GetConfigInt("M31_PA_HardenedShield_ShieldAmount"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_PersonalShield_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage,, , Template.AbilitySourceName);
    Effect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;
    Template.AddTargetEffect(Effect);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_PersonalShield_Cooldown");
    Template.AbilityCooldown = Cooldown;

    Template.bCrossClassEligible = false;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.bShowActivation = true;
    // Template.bSkipFireAction = true;

    Template.CustomFireAnim = 'HL_SignalPositive';
    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

final static function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if (XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
	}
}

static function X2AbilityTemplate Aegis()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_Aegis                 Effect;

    Template = Passive('M31_PA_Aegis', "img:///UILibrary_SODragoon.UIPerk_aegis", false, true);

    Effect = new class'X2Effect_PA_Aegis';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate HardenedShield()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_HardenedShield        Effect;

    Template = Passive('M31_PA_HardenedShield', "img:///UILibrary_PerkIcons.UIPerk_extrapadding", false, true);

    Effect = new class'X2Effect_PA_HardenedShield';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate CreateBayonetAbility(name TemplateName, bool bCounterattack)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_muton_bayonet";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

    Template.bCrossClassEligible = false;
    if (bCounterattack)
    {
        Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
        Template.bDisplayInUITooltip = false;
        Template.bDisplayInUITacticalText = false;
        Template.bShowActivation = false;
        Template.bDontDisplayInAbilitySummary = true;
    }
    else
    {
        Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
        Template.bDisplayInUITooltip = true;
        Template.bDisplayInUITacticalText = true;
        Template.bShowActivation = true;
    }
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    if (bCounterattack)
    {
        ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
    }
    else
    {
        ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_PA_Bladestorm');
    }
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.bLimitTargetIcons = true;

    // class'M31_AbilityHelpers'.static.AddAdjacencyCondition(Template);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    if (!bCounterattack)
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.bAllowBonusWeaponEffects = true;

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    Template.AddTargetEffect(PhysicalDamageEffect);

    // Impairing effects need to come after the damage. This is needed for proper visualization ordering.
    // Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
    Template.AddTargetEffect(class'M31_AbilityHelpers'.static.CreateImpairingEffect());

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    if (bCounterattack)
        Template.MergeVisualizationFn = class'X2Ability_Muton'.static.CounterAttack_MergeVisualization;	

    if (!bCounterattack)
        Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bFrameEvenWhenUnitIsHidden = true;	

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    // Template.AdditionalAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    return Template;
}

static function X2AbilityTemplate CreateBayonetChargeAbility(name TemplateName)
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee       MeleeTarget;
    local X2Effect_ApplyWeaponDamage        PhysicalDamageEffect;
    local array<name>                       SkipExclusions;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.Hostility = eHostility_Offensive;
    Template.IconImage = "img:///UILibrary_LWAlienPack.LWCenturion_AbilityBayonetCharge32";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

    Template.bCrossClassEligible = false;
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.bShowActivation = true;
    Template.DisplayTargetHitChance = true;
    Template.bSkipFireAction = false;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee';
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    Template.bLimitTargetIcons = true;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    if (default.bBayonetCharge_AllowWhileDisoriented)
    {
        SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    }
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.bAllowBonusWeaponEffects = true;

    PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    Template.AddTargetEffect(PhysicalDamageEffect);

    // Impairing effects need to come after the damage. This is needed for proper visualization ordering.
    // Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
    Template.AddTargetEffect(class'M31_AbilityHelpers'.static.CreateImpairingEffect());

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.bFrameEvenWhenUnitIsHidden = true;	

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    // Template.AdditionalAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    return Template;
}

static function X2AbilityTemplate Counterattack()
{
    local X2AbilityTemplate     Template;

    Template = Passive('M31_PA_Counterattack', "img:///UILibrary_PerkIcons.UIPerk_muton_counterattack", false, true);
    Template.AbilitySourceName = 'eAbilitySource_Standard';

    Template.AdditionalAbilities.AddItem('M31_PA_Counterattack_Attack');
    Template.AdditionalAbilities.AddItem('M31_PA_Counterattack_Dodge');
    Template.AdditionalAbilities.AddItem('M31_PA_Counterattack_Trigger');

    return Template;
}

static function X2AbilityTemplate CounterattackDodge()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_CounterattackDodge       DodgeEffect;
    local X2Effect_SetUnitValue             SetUnitValEffect;

    Template = Passive('M31_PA_Counterattack_Dodge', "img:///UILibrary_PerkIcons.UIPerk_muton_counterattack", false, false);
    Template.AbilitySourceName = 'eAbilitySource_Standard';

    Template.bDontDisplayInAbilitySummary = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

    DodgeEffect = new class'X2Effect_CounterattackDodge';
    DodgeEffect.EffectName = class'X2Ability'.default.CounterattackDodgeEffectName;
    DodgeEffect.DodgeBase = `GetConfigInt("M31_PA_Counterattack_Dodge");
    DodgeEffect.DodgeReductionPerHit = `GetConfigInt("M31_PA_Counterattack_Dodge_ReductionPerHit");
    DodgeEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
    Template.AddShooterEffect(DodgeEffect);

    SetUnitValEffect = new class'X2Effect_SetUnitValue';
    SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
    SetUnitValEffect.NewValueToSet = class'X2Ability'.default.CounterattackDodgeUnitValue;
    SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(SetUnitValEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    
    return Template;
}

static function X2AbilityTemplate CounterattackTrigger()
{
    local X2AbilityTemplate Template;
    local X2AbilityTrigger_EventListener EventListener;
    
    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_Counterattack_Trigger');
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_muton_counterattack";

    Template.bDontDisplayInAbilitySummary = true;
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventID = 'AbilityActivated';
    EventListener.ListenerData.EventFn = MeleeCounterattackListener;
    Template.AbilityTriggers.AddItem(EventListener);

    Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityTargetStyle = default.SelfTarget;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.CinescriptCameraType = "Muton_Counterattack";

    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

function EventListenerReturn MeleeCounterattackListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local X2TacticalGameRuleset         TacticalRules;
    local XComGameStateContext_Ability  AbilityContext;
    local StateObjectReference          OwnerStateObject;
    local XComGameState_Unit            OwnerState;
    local XComGameState_Unit            UnitState;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local X2AbilityCost_ActionPoints    ActionPointCost;
    local XComGameState                 NewGameState;
    local GameRulesCache_Unit           UnitCache;
    local StateObjectReference          UseMeleeAbilityRef;
    local UnitValue     CounterattackUnitValue;
    local int           iCounterMax;
    local int           iCounter;
    local int           i, j;
    local bool          bFoundUsableMeleeAbility;

    History = `XCOMHISTORY;
    TacticalRules = `TACTICALRULES;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    OwnerStateObject = XComGameState_Ability(CallbackData).OwnerStateObject;
    OwnerState = XComGameState_Unit(History.GetGameStateForObjectID(XComGameState_Ability(CallbackData).OwnerStateObject.ObjectID));

    if ((OwnerState != none) &&
        (AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt) &&
        (AbilityContext.InputContext.PrimaryTarget == OwnerStateObject) &&
        (AbilityContext.ResultContext.HitResult == eHit_CounterAttack) &&
        (!default.bCounterattack_OnlyOnEnemyTurn || TacticalRules.GetUnitActionTeam() != OwnerState.GetTeam()))
    {
        // A dodge happened and this was a melee attack
        // Activate the counterattack ability (if the unit is not impaired)
        UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(OwnerState.ObjectID));
        if (UnitState == none)
        {
            UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OwnerState.ObjectID));
        }
        UnitState.GetUnitValue(default.Counterattack_CounterName, CounterattackUnitValue);
        iCounter = int(CounterattackUnitValue.fValue);
        iCounterMax = `GetConfigInt("M31_PA_Counterattack_ActivationsPerTurn");

        if ((iCounterMax == 0 || iCounter < iCounterMax) && !UnitState.IsImpaired())
        {
            //Find an ability that can use counter attack action points
            foreach UnitState.Abilities(UseMeleeAbilityRef)
            {
                AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(UseMeleeAbilityRef.ObjectID));
                AbilityTemplate = AbilityState.GetMyTemplate();
                if (AbilityTemplate.AbilityCosts.Length > 0)
                {
                    ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[0]);
                    if (ActionPointCost != None && ActionPointCost.AllowedTypes.Find(class'X2CharacterTemplateManager'.default.CounterattackActionPoint) > -1)
                    {
                        bFoundUsableMeleeAbility = true;
                        break;
                    }
                }
            }

            if (bFoundUsableMeleeAbility)
            {
                //  Give the unit an action point so they can activate counterattack
                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', OwnerState.ObjectID));
                UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);

                TacticalRules.SubmitGameState(NewGameState);

                if (TacticalRules.GetGameRulesCache_Unit(OwnerStateObject, UnitCache))
                {
                    for (i = 0; i < UnitCache.AvailableActions.Length; ++i)
                    {
                        if (UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == UseMeleeAbilityRef.ObjectID)
                        {
                            for (j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j)
                            {
                                if (UnitCache.AvailableActions[i].AvailableTargets[j].PrimaryTarget == AbilityContext.InputContext.SourceObject)
                                {
                                    if (UnitCache.AvailableActions[i].AvailableCode == 'AA_Success')
                                    {
                                        UnitState.SetUnitFloatValue(default.Counterattack_CounterName, iCounter + 1.0, eCleanup_BeginTurn);
                                        class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j);
                                    }
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate CripplingBlow()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PersistentStatChange     Effect;

    Template = CreateBayonetAbility('M31_PA_CripplingBlow', false);

    Template.IconImage = "img:///BetterIcons.Perks.Hamstring";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    AddCooldown(Template, `GetConfigInt("M31_PA_CripplingBlow_Cooldown"));

    Template.AbilityCosts.Length = 0;
    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Effect = new class'X2Effect_PersistentStatChange';
    Effect.EffectName = 'M31_PA_CripplingBlow_Debuff';
    Effect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_CripplingBlow_AimPenalty"));
    Effect.AddPersistentStatChange(eStat_Defense, -1 * `GetConfigInt("M31_PA_CripplingBlow_DefensePenalty"));
    Effect.AddPersistentStatChange(eStat_Dodge, -1 * `GetConfigInt("M31_PA_CripplingBlow_DodgePenalty"));
    Effect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_CripplingBlow_MobilityPenalty"));
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_CripplingBlow_Duration"), default.bCripplingBlow_InfiniteDuration, false, true, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, `GetLocalizedString("M31_PA_CripplingBlow_DebuffText"), Template.IconImage,,, Template.AbilitySourceName);
    if (default.bCripplingBlow_AllowStack)
    {
        Effect.DuplicateResponse = eDupe_Allow;
    }
    else
    {
        Effect.DuplicateResponse = eDupe_Refresh;
    }
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate Bladestorm()
{
    local X2AbilityTemplate                 Template;

    Template = Passive('M31_PA_Bladestorm', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, false);

    Template.AdditionalAbilities.AddItem('Bladestorm');

    return Template;
}

defaultproperties
{
    Counterattack_CounterName = "M31_PA_Counterattack_Counter"
    SidewinderCooldownEffectName = "M31_Sidewinder_Cooldown"
    SidewinderEventName = "M31_Sidewinder_Trigger"
    SidewinderOriginalGroupValueName = "M31_Sidewinder_OriginalGroupValueName"
}