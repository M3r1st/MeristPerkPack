class X2AbilitySet_PA_Harrier extends X2AbilitySet_PlayableAliens;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(HarrierBullRush());
    Templates.AddItem(HarrierPunch());
    Templates.AddItem(EndOfGeneva());
    Templates.AddItem(FineControl());
    Templates.AddItem(VileMix());
    Templates.AddItem(BlasterMaster());
    Templates.AddItem(NoGraze());
    Templates.AddItem(HarrierGrenade());
        Templates.AddItem(HarrierGrenadeFuse());
    Templates.AddItem(HarrierPoisonGrenade());
    Templates.AddItem(HarrierFireGrenade());
    Templates.AddItem(HarrierRadGrenade());
    Templates.AddItem(HarrierFuseGrenade());
    Templates.AddItem(HarrierCyclic('M31_PA_HarrierCyclic', 'M31_PA_HarrierCyclic2', true));
        Templates.AddItem(HarrierCyclic('M31_PA_HarrierCyclic2', 'M31_PA_HarrierCyclic3'));
        Templates.AddItem(HarrierCyclic('M31_PA_HarrierCyclic3'));

    return Templates;
}

static function X2AbilityTemplate HarrierBullRush()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local array<name>                       SkipExclusions;

    Template = MovingMelee('M31_PA_HarrierBullRush', "img:///UILibrary_SOCombatEngineer.UIPerk_bullrush", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;

    AddActionPointCost(Template, eCost_SingleConsumeAll);
    AddCooldown(Template, `GetConfigInt("M31_PA_HarrierBullRush_Cooldown"));
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_HarrierBullRush_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_HarrierBullRush_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    AddSuppressedCondition(Template);
    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunnedStatusEffect(`GetConfigInt("M31_PA_HarrierBullRush_StunDuration"), 100, false));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

    Template.bShowActivation = true;
    Template.bSkipFireAction = false;

    Template.bOverrideMeleeDeath = true;

    return Template;
}

static function X2AbilityTemplate HarrierPunch()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local array<name>                       SkipExclusions;

    Template = MovingMelee('M31_PA_HarrierPunch', "img:///UILibrary_PerkIcons.UIPerk_muton_punch", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

    AddActionPointCost(Template, eCost_Single);
    
    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_HarrierPunch_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_HarrierPunch_CritBonus");
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);
    
    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

    Template.bShowActivation = false;
    Template.bSkipFireAction = false;

    // Template.CustomFireAnim = 'FF_MutonPunch';
    Template.bOverrideMeleeDeath = true;

    return Template;
}

static function X2AbilityTemplate EndOfGeneva()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_PA_HarrierEndOfGeneva', "img:///UILibrary_LW_PerkPack.LW_AbilityCloseEncounters", false, true);

    return Template;
}

static function X2AbilityTemplate FineControl()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_PA_HarrierFineControl', "img:///UILibrary_PerkIcons.UIPerk_panic", false, true);

    return Template;
}

static function X2AbilityTemplate VileMix()
{
    local X2AbilityTemplate         Template;
    local X2Effect_VileMixSource    Effect;
    
    Template = Passive('M31_PA_HarrierVileMix', "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", false, true);

    Effect = new class'X2Effect_VileMixSource';
    Effect.DOTDamageBonus = `GetConfigInt("M31_PA_HarrierVileMix_DOTDamageBonus");
    Effect.bMatchSourceWeapon = false;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate BlasterMaster()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_AddGrenade               Effect;

    Template = Passive('M31_PA_HarrierBlasterMaster', "img:///UILibrary_PerkIcons.UIPerk_muton_aliengrenade", false, true);
        
    Effect = new class'X2Effect_AddGrenade';
    Effect.bAllowUpgrades = false;
    Effect.DataName = 'MutonGrenade';
    Effect.SkipAbilities.AddItem('SmallItemWeight');
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate NoGraze()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Persistent               PersistentEffect;
    local X2Effect_ChangeAbilityHitContext  Effect;
    
    Template = Passive('M31_PA_NoGraze', "img:///UILibrary_FavidsPerkPack.UIPerk_Concentration", false, false);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = name("M31_PA_NoGraze_Passive");
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    Effect = new class'X2Effect_ChangeAbilityHitContext';
    Effect.bMatchSourceWeapon = true;
    Effect.ChangeHitResults[eHit_Graze] = eHit_Success;
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate HarrierGrenade()
{
    local X2AbilityTemplate             Template;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    
    Template = CreateHarrierGrenadeAbility('M31_PA_HarrierGrenade', "img:///KetarosPkg_Abilities.UIPerk_raisingshot");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 1;

    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    AddAmmoCost(Template, 1);

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    Template.AdditionalAbilities.AddItem('M31_PA_HarrierGrenadeFuse');

    return Template;
}

static function X2AbilityTemplate HarrierGrenadeFuse()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    
    Template = SelfTargetTrigger('M31_PA_HarrierGrenadeFuse', "img:///KetarosPkg_Abilities.UIPerk_raisingshot");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.FuseListener;
    Template.AbilityTriggers.AddItem(Trigger);

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = true;
    RadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    AddAmmoCost(Template, 1);

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(DamageEffect);

    Template.MergeVisualizationFn = FuseMergeVisualization;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.bShowActivation = true;
    Template.bSkipExitCoverWhenFiring = true;
    Template.bHideWeaponDuringFire = false;
    Template.ActionFireClass = class'X2Action_Fire_IgniteFuse';

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    return Template;
}


static function X2AbilityTemplate HarrierPoisonGrenade()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_Persistent           PoisonedEffect;
    local X2Effect_ApplyPoisonToWorld   WorldPoisonEffect;
    
    Template = CreateHarrierGrenadeAbility('M31_PA_HarrierPoisonGrenade', "img:///UILibrary_MZChimeraIcons.Ability_PoisonSpit", `GetConfigFloat('M31_PA_HarrierPoisonGrenade_BaseRadiusModifer'));

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 2;

    AddAmmoCost(Template, `GetConfigInt('M31_PA_HarrierPoisonGrenade_AmmoCost'));
    AddSuppressedCondition(Template);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_HarrierPoisonGrenade_Cooldown");
    Cooldown.AddCooldownModifier('M31_PA_HarrierEndOfGeneva', -1 * `GetConfigInt("M31_PA_HarrierPoisonGrenade_CooldownReductionEOG"));
    Template.AbilityCooldown = Cooldown;

    PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
    Template.AddTargetEffect(PoisonedEffect);
    Template.AddMultiTargetEffect(PoisonedEffect);

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    WorldPoisonEffect = new class'X2Effect_ApplyPoisonToWorld';
    WorldPoisonEffect.bApplyOnHit = true;
    WorldPoisonEffect.bApplyOnMiss = true;
    Template.AddMultiTargetEffect(WorldPoisonEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate HarrierFireGrenade()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_Burning              BurningEffect;
    local X2Effect_ApplyFireToWorld     WorldFireEffect;
    
    Template = CreateHarrierGrenadeAbility('M31_PA_HarrierFireGrenade', "img:///UILibrary_MZChimeraIcons.Grenade_Fire", `GetConfigFloat('M31_PA_HarrierFireGrenade_BaseRadiusModifer'));

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 3;

    AddAmmoCost(Template, `GetConfigInt('M31_PA_HarrierFireGrenade_AmmoCost'));
    AddSuppressedCondition(Template);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_HarrierFireGrenade_Cooldown");
    Cooldown.AddCooldownModifier('M31_PA_HarrierEndOfGeneva', -1 * `GetConfigInt("M31_PA_HarrierFireGrenade_CooldownReductionEOG"));
    Template.AbilityCooldown = Cooldown;

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1);
    Template.AddTargetEffect(BurningEffect);
    Template.AddMultiTargetEffect(BurningEffect);

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    WorldFireEffect = new class'X2Effect_ApplyFireToWorld';
    WorldFireEffect.bApplyOnHit = true;
    WorldFireEffect.bApplyOnMiss = true;
    Template.AddMultiTargetEffect(WorldFireEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate HarrierRadGrenade()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local array<X2Effect>               RadiationEffects;
    local X2Effect                      Effect;
    
    Template = CreateHarrierGrenadeAbility('M31_PA_HarrierRadGrenade', "img:///KetarosPkg_Abilities.UIPerk_radiation", `GetConfigFloat('M31_PA_HarrierRadGrenade_BaseRadiusModifer'));

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 4;

    AddAmmoCost(Template, `GetConfigInt('M31_PA_HarrierRadGrenade_AmmoCost'));
    AddSuppressedCondition(Template);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_HarrierRadGrenade_Cooldown");
    Cooldown.AddCooldownModifier('M31_PA_HarrierEndOfGeneva', -1 * `GetConfigInt("M31_PA_HarrierRadGrenade_CooldownReductionEOG"));
    Template.AbilityCooldown = Cooldown;

    RadiationEffects = class'M31_Helpers'.static.CreateRadiationEffects();
    foreach RadiationEffects(Effect)
    {
        Template.AddTargetEffect(Effect);
        Template.AddMultiTargetEffect(Effect);
    }

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate HarrierFuseGrenade()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_TriggerEvent         InsanityEvent;
    
    Template = CreateHarrierGrenadeAbility('M31_PA_HarrierFuseGrenade', "img:///UILibrary_MZChimeraIcons.Grenade_Plasma", `GetConfigFloat('M31_PA_HarrierFuseGrenade_BaseRadiusModifer'));

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 5;

    AddAmmoCost(Template, `GetConfigInt('M31_PA_HarrierFuseGrenade_AmmoCost'));
    AddSuppressedCondition(Template);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_HarrierFuseGrenade_Cooldown");
    Cooldown.AddCooldownModifier('M31_PA_HarrierEndOfGeneva', -1 * `GetConfigInt("M31_PA_HarrierFuseGrenade_CooldownReductionEOG"));
    Template.AbilityCooldown = Cooldown;

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
    InsanityEvent.ApplyChance = 100;
    InsanityEvent.TargetConditions.AddItem(new class'X2Condition_FuseTarget');
    Template.AddTargetEffect(InsanityEvent);
    Template.AddMultiTargetEffect(InsanityEvent);

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate HarrierCyclic(name DataName, optional name PostEventName, optional bool bFirst)
{
    local X2AbilityTemplate                 Template;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    
    Template = CreateHarrierGrenadeAbility(DataName, "img:///UILibrary_LW_PerkPack.LW_AbilityCyclicFire");

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 6;

    if (bFirst)
    {
        Template.bDisplayInUITooltip = true;
        Template.bDisplayInUITacticalText = true;

        Template.AbilityCosts.Length = 0;

        AmmoCost = new class'X2AbilityCost_Ammo';
        AmmoCost.iAmmo = 3;
        AmmoCost.bFreeCost = true;
        Template.AbilityCosts.AddItem(AmmoCost);

        AmmoCost = new class'X2AbilityCost_Ammo';
        AmmoCost.iAmmo = 1;
        Template.AbilityCosts.AddItem(AmmoCost);

        AddSuppressedCondition(Template);
        AddCooldown(Template, `GetConfigInt("M31_PA_HarrierCyclic_Cooldown"));
        AddActionPointCost(Template, eCost_DoubleConsumeAll);

        Template.AdditionalAbilities.AddItem('M31_PA_HarrierCyclic2');
        Template.AdditionalAbilities.AddItem('M31_PA_HarrierCyclic3');

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

        Template.AbilityCosts.Length = 0;

        AmmoCost = new class'X2AbilityCost_Ammo';
        AmmoCost.iAmmo = 1;
        Template.AbilityCosts.AddItem(AmmoCost);

        Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
        Template.BuildInterruptGameStateFn = none;
    }

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bIgnoreCoverBonus = true;
    StandardAim.BuiltInHitMod = -1 * `GetConfigInt("M31_PA_HarrierCyclic_AimPenalty");
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    DamageEffect = new class'X2Effect_Shredder';
    DamageEffect.bExplosiveDamage = true;
    Template.AddTargetEffect(DamageEffect);
    Template.AddMultiTargetEffect(DamageEffect);

    if (PostEventName != '')
        Template.PostActivationEvents.AddItem(PostEventName);

    return Template;
}

static function X2AbilityTemplate CreateHarrierGrenadeAbility(
    name DataName,
    string IconImage,
    optional float fBaseRadiusModifier)
{
    local X2AbilityTemplate                     Template;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2AbilityToHitCalc_MultiStandardAim   StandardAim;
    local X2Condition_FineControl               FineControlCondition;
    local X2AbilityCost_ActionPoints            ActionCost;
    local X2Effect_VileMix                      VileMixEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    ActionCost = ActionPointCost(eCost_SingleConsumeAll);
    ActionCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_PA_HarrierEndOfGeneva');
    Template.AbilityCosts.AddItem(ActionCost);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    FineControlCondition = new class'X2Condition_FineControl';
    FineControlCondition.FineControlAbilities.AddItem('M31_PA_HarrierFineControl');
    Template.AbilityMultiTargetConditions.AddItem(FineControlCondition);

    Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = true;
    RadiusMultiTarget.fTargetRadius = fBaseRadiusModifier;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Template.bAllowAmmoEffects = false;
    Template.bAllowBonusWeaponEffects = false;
    Template.bAllowFreeFireWeaponUpgrade = false;

    StandardAim = new class'X2AbilityToHitCalc_MultiStandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bIgnoreCoverBonus = true;
    StandardAim.bMultiGuaranteedHit = true;
    StandardAim.bMultiAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    VileMixEffect = class'X2Effect_VileMix'.static.HarrierVileMixEffect();
    Template.AddTargetEffect(VileMixEffect);
    Template.AddMultiTargetEffect(VileMixEffect);

    Template.TargetingMethod = class'X2TargetingMethod_TopDown';
    // Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
    Template.bUsesFiringCamera = true;
    Template.CinescriptCameraType = "StandardGunFiring";

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    Template.bCrossClassEligible = false;

    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.PostActivationEvents.AddItem('StandardShotActivated');

    Template.ModifyNewContextFn = HarrierShot_ModifyActivatedAbilityContext;

    return Template;
}

static function HarrierShot_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
    local XComGameStateHistory          History;
    local vector                        NewLocation;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local AvailableTarget               Target;
    local XComGameStateContext_Ability  AbilityContext;
    local AbilityResultContext          OldResultContext;

    History = `XCOMHISTORY;
    
    AbilityContext = XComGameStateContext_Ability(Context);

    // `LOG("Running Modify Context FN: " @ AbilityContext.IsResultContextMiss() @ AbilityContext.ResultContext.HitResult,, 'Merist');

    if (AbilityContext.IsResultContextMiss())
    {

        AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

        NewLocation = class'X2Ability'.static.FindOptimalMissLocation(AbilityContext, false);

        // `LOG("This is a miss. Original location:" @ AbilityContext.InputContext.TargetLocations[0] @ AbilityContext.ResultContext.ProjectileHitLocations[0] @ ", new location:" @ NewLocation,, 'Merist');

        AbilityTemplate = AbilityState.GetMyTemplate();

        AbilityState.GatherAdditionalAbilityTargetsForLocation(NewLocation, Target);
        AbilityContext.InputContext.MultiTargets = Target.AdditionalTargets;

        if (AbilityTemplate.AbilityToHitCalc != none)
        {
            // `LOG("Rolling ability hits for new targets",, 'Merist');
            OldResultContext = AbilityContext.ResultContext;
            Target.PrimaryTarget = AbilityContext.InputContext.PrimaryTarget;
            Target.AdditionalTargets = AbilityContext.InputContext.MultiTargets;
            AbilityTemplate.AbilityToHitCalc.RollForAbilityHit(AbilityState, Target, AbilityContext.ResultContext);
            AbilityContext.ResultContext.HitResult = OldResultContext.HitResult;
            AbilityContext.ResultContext.ArmorMitigation = OldResultContext.ArmorMitigation;
            AbilityContext.ResultContext.CalculatedHitChance = OldResultContext.CalculatedHitChance;
        }

        AbilityContext.InputContext.TargetLocations.Length = 0;
        AbilityContext.InputContext.TargetLocations.AddItem(NewLocation);

        AbilityContext.ResultContext.ProjectileHitLocations.Length = 0;
        AbilityContext.ResultContext.ProjectileHitLocations.AddItem(NewLocation);
    }
}

// OLD
// static function HarrierShot_ModifyActivatedAbilityContext(XComGameStateContext Context)
// {
//     local XComGameStateHistory          History;
//     local vector                        NewLocation;
//     local XComGameState_Ability         AbilityState;
//     local X2AbilityTemplate             AbilityTemplate;
//     local AvailableTarget               Target;
//     local XComGameStateContext_Ability  AbilityContext;
//     local array<EAbilityHitResult>      ResultsToExclude;
//     local AbilityResultContext          PrevResultContext;
//     local int Index;

//     History = `XCOMHISTORY;
    
//     AbilityContext = XComGameStateContext_Ability(Context);

//     ResultsToExclude.AddItem(eHit_Untouchable);
//     ResultsToExclude.AddItem(eHit_Parry);
//     ResultsToExclude.AddItem(eHit_Deflect);
//     ResultsToExclude.AddItem(eHit_Reflect);
//     ResultsToExclude.AddItem(eHit_Crit);
//     ResultsToExclude.AddItem(eHit_LightningReflexes);

//     // `LOG("Running Modify Context FN: " @ AbilityContext.IsResultContextMiss() @ AbilityContext.ResultContext.HitResult,, 'Merist');

//     if (AbilityContext.IsResultContextMiss())
//     {

//         AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

//         NewLocation = class'X2Ability'.static.FindOptimalMissLocation(AbilityContext, false);

//         // `LOG("This is a miss. Original location:" @ AbilityContext.InputContext.TargetLocations[0] @ AbilityContext.ResultContext.ProjectileHitLocations[0] @ ", new location:" @ NewLocation,, 'Merist');

//         AbilityTemplate = AbilityState.GetMyTemplate();

//         AbilityState.GatherAdditionalAbilityTargetsForLocation(NewLocation, Target);
//         AbilityContext.InputContext.MultiTargets = Target.AdditionalTargets;

//         if (AbilityTemplate.AbilityToHitCalc != none)
//         {
//             // `LOG("Rolling ability hits for new targets",, 'Merist');
//             PrevResultContext = AbilityContext.ResultContext;
//             Target.PrimaryTarget = AbilityContext.InputContext.PrimaryTarget;
//             Target.AdditionalTargets = AbilityContext.InputContext.MultiTargets;
//             AbilityTemplate.AbilityToHitCalc.RollForAbilityHit(AbilityState, Target, AbilityContext.ResultContext);
//             AbilityContext.ResultContext.HitResult = PrevResultContext.HitResult;
//             AbilityContext.ResultContext.ArmorMitigation = PrevResultContext.ArmorMitigation;
//             AbilityContext.ResultContext.CalculatedHitChance = PrevResultContext.CalculatedHitChance;
//         }

//         // `LOG("Forcing the multi target hit results to success for new targets",, 'Merist');

//         for (Index = 0; Index < AbilityContext.ResultContext.MultiTargetHitResults.Length; Index++)
//         {
//             if (ResultsToExclude.Find(AbilityContext.ResultContext.MultiTargetHitResults[Index]) == INDEX_NONE)
//             {
//                 AbilityContext.ResultContext.MultiTargetHitResults[Index] = eHit_Success;
//             }
//         }

//         AbilityContext.InputContext.TargetLocations.Length = 0;
//         AbilityContext.InputContext.TargetLocations.AddItem(NewLocation);

//         AbilityContext.ResultContext.ProjectileHitLocations.Length = 0;
//         AbilityContext.ResultContext.ProjectileHitLocations.AddItem(NewLocation);
//     }
//     else
//     {
//         // `LOG("This is a hit. Forcing the multi target hit results to success",, 'Merist');

//         for (Index = 0; Index < AbilityContext.ResultContext.MultiTargetHitResults.Length; Index++)
//         {
//             if (ResultsToExclude.Find(AbilityContext.ResultContext.MultiTargetHitResults[Index]) == INDEX_NONE)
//             {
//                 AbilityContext.ResultContext.MultiTargetHitResults[Index] = eHit_Success;
//             }
//         }
//     }
// }