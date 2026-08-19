class X2AbilitySet_PA_Berserker extends X2Ability_Extended;

var privatewrite name BashValueName;
var privatewrite name SmashCallbackEffectName;
var privatewrite name AftershockCallbackEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    // Templates.AddItem(Smash());
    // Templates.AddItem(Bash());

    // Templates.AddItem(class'M31_Helpers'.static.CreateAnimSetPassive('M31_PA_BK_Anims', ""));

    return Templates;
}

static function X2AbilityTemplate Smash(name DataName = 'M31_PA_BK_Smash')
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_MultiStandardAim   ToHitCalc;
    local array<name>                       SkipExclusions;
    local X2Effect_ApplyDamageFromTech      DamageEffect;
    local X2Effect_Callback                 CallbackEffect;

    Template = MovingMelee(DataName, "img:///UILibrary_PerkIcons.UIPerk_muton_punch", false, false);

    ToHitCalc = new class'X2AbilityToHitCalc_MultiStandardAim';
    ToHitCalc.bMultiGuaranteedHit = true;
    ToHitCalc.bMultiAllowCrit = false;
    ToHitCalc.bOnlyMultiHitWithSuccess = false;
    ToHitCalc.bMeleeAttack = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
    AddAftershockMultiTarget(Template);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.REND_PRIORITY;

    AddActionPointCost(Template, eCost_SingleConsumeAll);

    SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
    SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
    Template.AddShooterEffectExclusions(SkipExclusions);

    DamageEffect = new class'X2Effect_ApplyDamageFromTech';
    DamageEffect.EffectDamageValues.AddItem(`GetConfigDamage("M31_PA_BK_Smash_Damage_CV"));
    DamageEffect.EffectDamageValues.AddItem(`GetConfigDamage("M31_PA_BK_Smash_Damage_MG"));
    DamageEffect.EffectDamageValues.AddItem(`GetConfigDamage("M31_PA_BK_Smash_Damage_BM"));
    DamageEffect.SpecificSlot = eInvSlot_Armor;
    Template.AddTargetEffect(DamageEffect);

    CallbackEffect = new class'X2Effect_Callback';
    CallbackEffect.EffectName = default.SmashCallbackEffectName;
    CallbackEffect.BuildPersistentEffect(1, false, false, true, eGameRule_PlayerTurnEnd);
    CallbackEffect.bRemoveWhenTargetDies = false;
    Template.AddTargetEffect(DamageEffect);

    Template.bShowActivation = false;
    Template.bSkipFireAction = false;

    Template.bOverrideMeleeDeath = true;

    Template.AdditionalAbilities.AddItem('M31_PA_BK_Bash');

    return Template;
}

static function AddAftershockMultiTarget(out X2AbilityTemplate Template)
{
    local X2AbilityMultiTarget_Cylinder CylinderMultiTarget;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Effect_ApplyDamageFromTech  DamageEffect;
    local X2Effect_Callback             CallbackEffect;

    Template.TargetingMethod = class'X2TargetingMethod_MeleePathWithRadius';

    CylinderMultiTarget = new class'X2AbilityMultiTarget_Cylinder';
    CylinderMultiTarget.fTargetRadius = 0;
    CylinderMultiTarget.fTargetHeight = `GetConfigFloat("M31_PA_BK_Aftershock_Height");
    CylinderMultiTarget.bUseOnlyGroundTiles = true;
    CylinderMultiTarget.AddAbilityBonusRadius('M31_PA_BK_Aftershock', `GetConfigFloat("M31_PA_BK_Aftershock_Radius"));
    Template.AbilityMultiTargetStyle = CylinderMultiTarget;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_BK_Aftershock');
    Template.AbilityMultiTargetConditions.AddItem(AbilityCondition);
    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    DamageEffect = new class'X2Effect_ApplyDamageFromTech';
    DamageEffect.EffectDamageValues.AddItem(`GetConfigDamage("M31_PA_BK_Aftershock_Damage_CV"));
    DamageEffect.EffectDamageValues.AddItem(`GetConfigDamage("M31_PA_BK_Aftershock_Damage_MG"));
    DamageEffect.EffectDamageValues.AddItem(`GetConfigDamage("M31_PA_BK_Aftershock_Damage_BM"));
    DamageEffect.SpecificSlot = eInvSlot_Armor;
    Template.AddMultiTargetEffect(DamageEffect);

    CallbackEffect = new class'X2Effect_Callback';
    CallbackEffect.EffectName = default.AftershockCallbackEffectName;
    CallbackEffect.BuildPersistentEffect(1, false, false, true, eGameRule_PlayerTurnEnd);
    CallbackEffect.bRemoveWhenTargetDies = false;
    Template.AddMultiTargetEffect(DamageEffect);
}

static function X2AbilityTemplate Bash()
{
    local X2AbilityTemplate             Template;
    local X2AbilityToHitCalc_Bash       BashToHitCalc;
    local X2Effect_Stunned              StunnedEffect;
    local X2Effect_Persistent           DisorientedEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'M31_PA_BK_Bash');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_stun";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    BashToHitCalc = new class'X2AbilityToHitCalc_Bash';
    BashToHitCalc.BaseValue = `GetConfigInt("M31_PA_BK_Bash_BaseValue");
    BashToHitCalc.DefenderStatWeight = `GetConfigFloat("M31_PA_BK_Bash_DefenderStatWeight");
    BashToHitCalc.PrimaryWeights = `GetConfigArrayInt("M31_PA_BK_Bash_PrimaryWeights");
    BashToHitCalc.PrimaryCritWeights = `GetConfigArrayInt("M31_PA_BK_Bash_PrimaryCritWeights");
    BashToHitCalc.SecondaryWeights = `GetConfigArrayInt("M31_PA_BK_Bash_SecondaryWeights");
    BashToHitCalc.SecondaryCritWeights = `GetConfigArrayInt("M31_PA_BK_Bash_SecondaryCritWeights");
    Template.AbilityToHitCalc = BashToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    Template.bAllowAmmoEffects = false;
    Template.bAllowBonusWeaponEffects = false;
    Template.bAllowFreeFireWeaponUpgrade = false;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    DisorientedEffect.bRemoveWhenSourceDies = false;
    DisorientedEffect.MinStatContestResult = 1;
    DisorientedEffect.MaxStatContestResult = 1;
    Template.AddTargetEffect(DisorientedEffect);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
    StunnedEffect.bRemoveWhenSourceDies = false;
    StunnedEffect.MinStatContestResult = 2;
    StunnedEffect.MaxStatContestResult = 2;
    Template.AddTargetEffect(StunnedEffect);

    Template.FrameAbilityCameraType = eCameraFraming_Never;
    Template.bSkipExitCoverWhenFiring = true;
    Template.bSkipFireAction = true;
    Template.bShowActivation = false;
    Template.bUsesFiringCamera = false;

    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.MergeVisualizationFn = class'X2Effect_WeaponEffect'.static.FollowUpShot_MergeVisualization;
    Template.BuildInterruptGameStateFn = none;

    Template.bCrossClassEligible = false;

    Template.AdditionalAbilities.AddItem('M31_PA_BK_Bash_Passive');

    return Template;
}

static function X2AbilityTemplate BashPassive()
{
    local X2AbilityTemplate         Template;
    local X2Effect_WeaponEffect     WeaponEffect;

    Template = Passive('M31_PA_BK_Bash_Passive', "img:///UILibrary_PerkIcons.UIPerk_stun", false, false, true);

    WeaponEffect = new class'X2Effect_WeaponEffect';
    WeaponEffect.EffectName = 'M31_PA_BK_Bash';
    WeaponEffect.AttackName = 'M31_PA_BK_Bash';
    WeaponEffect.bMatchSourceWeapon = false;
    WeaponEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(WeaponEffect);

    return Template;
}



defaultproperties
{
    BashValueName = M31_PA_BK_BashResult
    SmashCallbackEffectName = M31_PA_BK_Smash_Callback
    AftershockCallbackEffectName = M31_PA_BK_Aftershock_Callback
}