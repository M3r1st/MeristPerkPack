class X2AbilitySet_ChosenArsenal extends XMBAbility;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(BlindSpot());
    Templates.AddItem(ChaosDriver());
        Templates.AddItem(ChaosDriverCharges());
    Templates.AddItem(CollectBounty());
        Templates.AddItem(CollectBountyDamage());
    Templates.AddItem(KillingSpree());
    Templates.AddItem(MarkForDeath());
        Templates.AddItem(MarkForDeathRefund());
    Templates.AddItem(MistTrail());
    Templates.AddItem(PhantomStride());
        Templates.AddItem(PhantomStrideCooldownReduction());

    return Templates;
}

static function X2AbilityTemplate BlindSpot()
{
    local X2AbilityTemplate                     Template;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2Condition_Visibility                VisCondition;
    local XMBEffect_ConditionalBonus            Effect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_CA_BlindSpot');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_FondFarewell";

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.FailOnNonUnits = true;

    VisCondition = new class'X2Condition_Visibility';
    VisCondition.bExcludeGameplayVisible = true;

    Effect = new class'XMBEffect_ConditionalBonus';
    Effect.AddToHitModifier(`GetConfigInt("M31_CA_BlindSpot_CritBonus"), eHit_Crit);
    Effect.AddDamageModifier(`GetConfigInt("M31_CA_BlindSpot_CritDamageBonus"), eHit_Crit);
    Effect.AddArmorPiercingModifier(9999);
    Effect.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
    Effect.AbilityTargetConditions.AddItem(VisCondition);
    Effect.BuildPersistentEffect(1, true);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
    Effect.EffectName = 'M31_CA_BlindSpot';

    Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

static function X2AbilityTemplate ChaosDriver()
{
    local X2AbilityTemplate				Template;
    local X2Effect_ChaosDriver			Effect;
    local X2AbilityCharges 				Charges;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_CA_ChaosDriver');

    Template.AbilitySourceName = 'eAbilitySource_Psionic';

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_MZChimeraIcons.Ability_WarCry";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY + 1;

    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Effect = new class'X2Effect_ChaosDriver';
    Effect.AttackingDamageMultiplierPerCharge = `GetConfigInt("M31_CA_ChaosDriver_BonusPerCharge");
    Effect.DefendingDamageMultiplierPerCharge = `GetConfigInt("M31_CA_ChaosDriver_PenaltyPerCharge");
    Effect.BuildPersistentEffect(`GetConfigInt("M31_CA_ChaosDriver_Duration"), false, true, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_CA_ChaosDriver_BonusText"), Template.IconImage, true, , Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.AbilityCosts.AddItem(default.FreeActionCost);

    if (`GetConfigInt("M31_CA_ChaosDriver_InitialCharges") > 0) {
        AddCooldown(Template, `GetConfigInt("M31_CA_ChaosDriver_Cooldown"));
    }

    Charges = new class 'X2AbilityCharges';
    Charges.InitialCharges = `GetConfigInt("M31_CA_ChaosDriver_InitialCharges");
    Template.AbilityCharges = Charges;

    Template.AbilityCosts.AddItem(new class'X2AbilityCost_Charges_All');

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.ActivationSpeech = 'InTheZone';

    Template.bShowActivation = true;
    Template.bSkipFireAction = true;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.AdditionalAbilities.AddItem('M31_CA_ChaosDriver_Charges');

    return Template;
}

static function X2AbilityTemplate ChaosDriverCharges()
{
    local X2AbilityTemplate					Template;
    local X2Condition_UnitEffects			NoEffectCondition;
    local XMBEffect_AddAbilityCharges		Effect;

    Effect = new class'XMBEffect_AddAbilityCharges';
    Effect.AbilityNames.AddItem('M31_CA_ChaosDriver');
    Effect.BonusCharges = 1;
    Effect.MaxCharges = `GetConfigInt("M31_CA_ChaosDriver_MaxCharges");

    Template = SelfTargetTrigger('M31_CA_ChaosDriver_Charges', "img:///UILibrary_MZChimeraIcons.Ability_WarCry", false, Effect, 'AbilityActivated');

    AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
    AddTriggerTargetCondition(Template, default.CritCondition);

    Template.AbilitySourceName = 'eAbilitySource_Psionic';

    NoEffectCondition = new class'X2Condition_UnitEffects';
    NoEffectCondition.AddExcludeEffect('M31_CA_ChaosDriver', 'AA_AbilityUnavailable');

    AddTriggerShooterCondition(Template, NoEffectCondition);

    Template.bSkipFireAction = true;

    // AddIconPassive(Template);

    return Template;
}

static function X2AbilityTemplate CollectBounty()
{
    local X2AbilityTemplate					Template;
    local X2Effect_Shredder				    WeaponDamageEffect;

    WeaponDamageEffect = new class'X2Effect_Shredder';
    WeaponDamageEffect.bBypassSustainEffects = true;

    Template = Attack('M31_CA_CollectBounty', "img:///UILibrary_MZChimeraIcons.Ability_HoloTargeting", false, WeaponDamageEffect, eCost_Weapon, 1);
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY + 1;
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());

    AddCooldown(Template, `GetConfigInt("M31_CA_CollectBounty_Cooldown"));

    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.AdditionalAbilities.AddItem('M31_CA_CollectBounty_Damage');

    return Template;
}

static function X2AbilityTemplate CollectBountyDamage()
{
    local X2AbilityTemplate					Template;
    local X2Effect_CollectBountyBonus		Effect;

    Effect = new class'X2Effect_CollectBountyBonus';
    
    Template = Passive('M31_CA_CollectBounty_Damage', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect);

    HidePerkIcon(Template);

    return Template;
}

static function X2AbilityTemplate KillingSpree()
{
    local X2AbilityTemplate						Template;
    local XMBEffect_ConditionalBonus			Effect;
    local X2AbilityTrigger_EventListener		EventListenerTrigger;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_CA_KillingSpree');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_InTheZone";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    
    EventListenerTrigger = new class'X2AbilityTrigger_EventListener';
    EventListenerTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListenerTrigger.ListenerData.EventID = 'UnitDied';
    EventListenerTrigger.ListenerData.Filter = eFilter_None;
    EventListenerTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.FullThrottleListener;
    Template.AbilityTriggers.AddItem(EventListenerTrigger);

    Effect = new class'XMBEffect_ConditionalBonus';
    Effect.AddDamageModifier(`GetConfigInt("M31_CA_KillingSpree_DamageBonus"));
    Effect.AddToHitModifier(`GetConfigInt("M31_CA_KillingSpree_CritBonus"), eHit_Crit);
    Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
    Effect.BuildPersistentEffect(`GetConfigInt("M31_CA_KillingSpree_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_CA_KillingSpree_BonusText"), Template.IconImage, true, , Template.AbilitySourceName);
    Effect.EffectName = 'M31_CA_KillingSpree_Stats';
    Template.AddTargetEffect(Effect);

    Template.bSkipFireAction = true;
    Template.bShowActivation = false;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    AddIconPassive(Template);

    return Template;
}

static function X2AbilityTemplate MarkForDeath()
{
    local X2AbilityTemplate				Template;
    local X2Condition_Visibility		TargetVisibilityCondition;
    local X2Condition_UnitEffects		UnitEffectsCondition;
    local X2Effect_MarkForDeath			MarkEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_CA_MarkForDeath');

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;
    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_trackingshot";

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY + 1;

    Template.AbilityCosts.AddItem(default.FreeActionCost);

    if (`GetConfigInt("M31_CA_MarkForDeath_Duration") > 0)
    {
        AddCooldown(Template, `GetConfigInt("M31_CA_MarkForDeath_Duration"));
    }

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    UnitEffectsCondition = new class'X2Condition_UnitEffects';
    UnitEffectsCondition.AddExcludeEffect('M31_CA_MarkForDeath', 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

    TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

    MarkEffect = new class 'X2Effect_MarkForDeath';
    MarkEffect.EffectName = 'M31_CA_MarkForDeath';
    MarkEffect.DuplicateResponse = eDupe_Refresh;
    MarkEffect.BuildPersistentEffect(`GetConfigInt("M31_CA_MarkForDeath_Duration"), false, true, false, eGameRule_PlayerTurnEnd);
    MarkEffect.bRemoveWhenTargetDies = false;
    MarkEffect.SetDisplayInfo(ePerkBuff_Penalty, `GetLocalizedString("M31_CA_MarkedForDeath_FriendlyName"), `GetLocalizedString("M31_CA_MarkedForDeath_FriendlyDesc"), Template.IconImage, , , Template.AbilitySourceName);
    MarkEffect.VisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMarkTarget_VisualizationFn;
    MarkEffect.EffectRemovedVisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMarkTarget_RemovedVisualizationFn;
    Template.AddTargetEffect(MarkEffect);

    Template.ActivationSpeech = 'TargetDefinition';
    Template.bSkipFireAction = true;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMark_BuildVisualization;
    Template.CinescriptCameraType = "ChosenSniper_TrackingShotMark";

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
    
    Template.AdditionalAbilities.AddItem('M31_CA_MarkForDeathRefund');

    return Template;
}

static function X2AbilityTemplate MarkForDeathRefund()
{
    local X2AbilityTemplate							Template;
    local XMBEffect_AbilityCostRefund               Effect;
    local X2Condition_UnitEffects					EffectCondition;

    Effect = new class'XMBEffect_AbilityCostRefund';
    Effect.EffectName = 'M31_CA_MarkForDeath_Refund';
    Effect.TriggeredEvent = 'M31_CA_MarkForDeath_Refund';
    Effect.CountValueName = 'M31_CA_MarkForDeath_RefundCounter';
    Effect.bShowFlyOver = true;

    Effect.AbilityTargetConditions.AddItem(default.RangedCondition);
    Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

    EffectCondition = new class'X2Condition_UnitEffects';
    EffectCondition.AddRequireEffect('M31_CA_MarkForDeath', 'AA_MissingRequiredEffect');
    Effect.AbilityTargetConditions.AddItem(EffectCondition);

    Template = Passive('M31_CA_MarkForDeath_Refund', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_trackingshot", false, Effect);

    HidePerkIcon(Template);

    return Template;
}

static function X2AbilityTemplate MistTrail()
{
    local X2AbilityTemplate					Template;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Effect_Blind					BlindEffect;

    Template = Attack('M31_CA_MistTrail', "img:///UILibrary_MZChimeraIcons.Ability_CascadeLance", false, , , eCost_Single, 1);
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY + 1;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.BuiltInHitMod = `GetConfigInt("M31_CA_MistTrail_AimBonus");
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    AddCooldown(Template, `GetConfigInt("M31_CA_MistTrail_Cooldown"));

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_CA_MistTrail_Duration"));
    Template.AddTargetEffect(BlindEffect);

    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    return Template;
}

static function X2AbilityTemplate PhantomStride()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee_Extended  MeleeTarget;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityCooldown                 Cooldown;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_CA_PhantomStride');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY + 1;
    Template.CinescriptCameraType = "Ranger_Reaper";
    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk";
    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    
    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = `GetConfigInt("M31_CA_PhantomStride_Cooldown");
    Template.AbilityCooldown = Cooldown;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bFreeCost = true;
    ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityToHitCalc = StandardMelee;
    
    MeleeTarget = new class'X2AbilityTarget_MovingMelee_Extended';
    MeleeTarget.iFixedRange = 1;
    MeleeTarget.bUseFixedRange = true;
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    Template.AddTargetEffect(WeaponDamageEffect);
    
    Template.bAllowBonusWeaponEffects = true;
    Template.bSkipMoveStop = true;

    Template.SourceMissSpeech = 'SwordMiss';

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.AdditionalAbilities.AddItem('M31_CA_PhantomStride_CooldownReduction');
    return Template;
}

static function X2AbilityTemplate PhantomStrideCooldownReduction()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_EventListener        EventListener;	
    local X2Effect_ReduceCooldowns              ReduceCooldownsEffect;
        
    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_CA_PhantomStride_CooldownReduction');
    Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_partingsilk";

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.EventID = 'SlashActivated';
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.EventID = 'BladestormActivated';
    EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

    ReduceCooldownsEffect = new class'X2Effect_ReduceCooldowns';
    ReduceCooldownsEffect.Amount = `GetConfigInt("M31_CA_PhantomStride_CooldownReduction");
    ReduceCooldownsEffect.ReduceAll = false;
    ReduceCooldownsEffect.AbilitiesToTick.AddItem('M31_CA_PhantomStride');
    Template.AddTargetEffect(ReduceCooldownsEffect);

    Template.bShowActivation = false;

    Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    HidePerkIcon(Template);

    return Template;
}