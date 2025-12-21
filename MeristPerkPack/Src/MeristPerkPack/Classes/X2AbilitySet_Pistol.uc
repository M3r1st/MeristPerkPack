class X2AbilitySet_Pistol extends X2Ability_Extended config(GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(ClutchShot());
    Templates.AddItem(ClutchShotCrit());
    Templates.AddItem(ClutchShotReset());
        Templates.AddItem(ClutchShotResetTrigger());
    Templates.AddItem(PistolAvenger());
        Templates.AddItem(PistolAvengerAttack());
    Templates.AddItem(PistolDetonationShot());
    Templates.AddItem(PistolDisarmingShot());
    Templates.AddItem(PistolMaim());
    Templates.AddItem(ReflexShot());
        Templates.AddItem(ReflexShotAttack());
    Templates.AddItem(PistolRouletteShot());
    Templates.AddItem(SleightOfHand());
    Templates.AddItem(Undertaker());

    return Templates;
}

static function X2AbilityTemplate ClutchShot()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    Template = Attack('M31_ClutchShot', "img:///UILibrary_LW_PerkPack.LW_AbilityClutchShot", false, false);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    AddPistolActionPointCost(Template);

    AddCooldown(Template, `GetConfigInt("M31_ClutchShot_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_ClutchShot_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    AddSuppressedCondition(Template);

    return Template;
}

static function X2AbilityTemplate ClutchShotCrit()
{
    local X2AbilityTemplate         Template;
    local X2Effect_ClutchShotCrit   Effect;

    Template = Passive('M31_ClutchShotCrit', "", false, true);
    
    Effect = new class'X2Effect_ClutchShotCrit';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.PrerequisiteAbilities.AddItem('M31_ClutchShot');

    return Template;
}

static function X2AbilityTemplate ClutchShotReset()
{
    local X2AbilityTemplate         Template;

    Template = Passive('M31_ClutchShotReset', "", false, true);

    Template.AdditionalAbilities.AddItem('M31_ClutchShotReset_Trigger');
    Template.PrerequisiteAbilities.AddItem('M31_ClutchShot');

    return Template;
}

static function X2AbilityTemplate ClutchShotResetTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_ReduceCooldowns          Effect;

    Template = SelfTargetTrigger('M31_ClutchShotReset_Trigger', "");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_ClutchShotReset;
    Trigger.ListenerData.Priority = 40;
    Template.AbilityTriggers.AddItem(Trigger);

    Effect = new class'X2Effect_ReduceCooldowns';
    Effect.Amount = `GetConfigInt("M31_ClutchShotReset_CooldownReduction");
    Effect.ReduceAll = `GetConfigBool("M31_ClutchShotReset_bReduceAll");
    Template.AddTargetEffect(Effect);

    AddUnitValueCondition(Template, 'M31_ClutchShotReset', `GetConfigInt("M31_ClutchShotReset_ActivationsPerTurn"));

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_ClutchShotReset(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Ability             AbilityState;
    local XComGameStateContext_Ability      AbilityContext;

    SourceUnit = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none
        && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt
        && AbilityContext.InputContext.AbilityTemplateName == 'M31_ClutchShot')
    {
        if (AbilityState.OwnerStateObject.ObjectID == SourceUnit.ObjectID)
        {
            return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate PistolAvenger()
{
    local X2AbilityTemplate             Template;
    local X2Effect_MeristCoveringFire   CoveringFireEffect;

    Template = Passive('M31_PistolAvenger', "img:///UILibrary_XPerkIconPack.UIPerk_pistol_circle", false, true);

    CoveringFireEffect = new class'X2Effect_MeristCoveringFire';
    CoveringFireEffect.EffectName = 'M31_PistolAvenger';
    CoveringFireEffect.bMatchSourceWeapon = true;
    CoveringFireEffect.AddAbilityToActivate('M31_PistolAvenger_Attack');
    CoveringFireEffect.bDirectAttackOnly = false;
    CoveringFireEffect.bDirectAttackOnly_AllowAllies = true;
    CoveringFireEFfect.bDirectAttackOnly_AllowAllies_ExcludeSelf = false;
    CoveringFireEffect.bDirectAttackOnly_AllowMultiTarget = true;
    CoveringFireEffect.bPreEmptiveFire = true;
    CoveringFireEffect.bAnyHostileAction = true;
    CoveringFireEffect.bOnlyDuringEnemyTurn = true;
    CoveringFireEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(CoveringFireEffect);

    Template.AdditionalAbilities.AddItem('M31_PistolAvenger_Attack');

    return Template;
}

static function X2AbilityTemplate PistolAvengerAttack()
{
    local X2AbilityTemplate                 Template;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;

    Template = Attack('M31_PistolAvenger_Attack', "img:///UILibrary_XPerkIconPack.UIPerk_pistol_circle", false, false);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    // Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeSquadmates = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn');
    Template.AddShooterEffectExclusions();

    AddBladestormMark(Template, 'M31_PistolAvenger_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PistolAvenger_Counter', `GetConfigInt("M31_PistolAvenger_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = `GetConfigBool("M31_PistolAvenger_bReactionFire");
    ToHitCalc.bIgnoreCoverBonus = `GetConfigBool("M31_PistolAvenger_bIgnoreCoverBonus");
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate PistolDetonationShot()
{
    local X2AbilityTemplate     Template;
    local X2Effect_TriggerEvent InsanityEvent;

    Template = Attack('M31_PistolDetonationShot', "img:///UILibrary_MZChimeraIcons.Ability_TargetGrenade", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    AddPistolActionPointCost(Template);

    AddCooldown(Template, `GetConfigInt("M31_PistolDetonationShot_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_PistolDetonationShot_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    Template.TargetingMethod = class'X2TargetingMethod_Fuse';
    Template.AbilityTargetConditions.AddItem(new class'X2Condition_FuseTarget');

    InsanityEvent = new class'X2Effect_TriggerEvent';
    InsanityEvent.TriggerEventName = class'X2Ability_PsiOperativeAbilitySet'.default.FuseEventName;
    InsanityEvent.ApplyChance = 100;
    Template.AddTargetEffect(InsanityEvent);

    AddSuppressedCondition(Template);

    Template.DamagePreviewFn = DetonationShot_DamagePreview;

    return Template;
}

function bool DetonationShot_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
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
    local X2AbilityTemplate Template;

    Template = Attack('M31_PistolDisarmingShot', "img:///UILibrary_MeristPerkIcons.UIPerk_DisarmingShot", false, false);
    
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    AddPistolActionPointCost(Template);

    AddCooldown(Template, `GetConfigInt("M31_PistolDisarmingShot_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_PistolDisarmingShot_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    // Template.AbilityTargetConditions.AddItem(new class'X2Condition_DisarmWeapon');
    Template.AddTargetEffect(new class'X2Effect_DisarmWeapon');
    Template.AddTargetEffect(class'X2AbilitySet_Merist'.static.CreateDisarmingShotEffect(Template));

    AddSuppressedCondition(Template);

    return Template;
}

static function X2AbilityTemplate PistolMaim()
{
    local X2AbilityTemplate Template;

    Template = Attack('M31_PistolMaim', "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

    AddPistolActionPointCost(Template);

    AddCooldown(Template, `GetConfigInt("M31_PistolMaim_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_PistolMaim_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    
    Template.AddTargetEffect(class'X2Effect_Immobilize'.static.CreateMaimedStatusEffect(, Template));

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

    AddOverwatchTriggers(Template);

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

static function X2AbilityTemplate PistolRouletteShot()
{
    local X2AbilityTemplate Template;

    Template = Attack('M31_PistolRouletteShot', "", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;

    AddPistolActionPointCost(Template);

    AddCooldown(Template, `GetConfigInt("M31_PistolRouletteShot_Cooldown"));
    AddAmmoCost(Template, `GetConfigInt("M31_PistolRouletteShot_AmmoCost"));

    Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

    AddSuppressedCondition(Template);

    Template.DamagePreviewFn = PistolRouletteShot_DamagePreview;

    Template.AdditionalAbilities.AddItem('M31_PistolRouletteShot_Damage');

    return Template;
}

function bool PistolRouletteShot_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local int MinDamagePrc, MaxDamagePrc;

    AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

    MinDamagePrc = `GetConfigInt("M31_PistolRouletteShot_MinDamagePrc");
    MaxDamagePrc = `GetConfigInt("M31_PistolRouletteShot_MaxDamagePrc");

    MinDamagePreview.Damage = MinDamagePreview.Damage * MinDamagePrc / 100;
    MaxDamagePreview.Damage = MaxDamagePreview.Damage * MaxDamagePrc / 100;

    return true;
}

static function X2AbilityTemplate PistolRouletteShotDamage()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Roulette     Effect;
    
    Template = Passive('M31_PistolRouletteShot_Damage', "", false, true);

    Effect = new class'X2Effect_Roulette';
    Effect.AllowedAbilities.AddItem('M31_PistolRouletteShot');
    Effect.AddRouletteRoll(`GetConfigInt("M31_PistolRouletteShot_MinDamagePrc"), 50);
    Effect.AddRouletteRoll(`GetConfigInt("M31_PistolRouletteShot_MaxDamagePrc"), 50);
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate SleightOfHand()
{
    local X2AbilityTemplate         Template;
    local X2Effect_SleightOfHand    Effect;
    
    Template = Passive('M31_SleightOfHand', "img:///UILibrary_MeristPerkIcons.UIPerk_Gunslinger", false, true);

    Effect = new class'X2Effect_SleightOfHand';
    Effect.AimPerStack = `GetConfigInt("M31_SleightOfHand_AimPerStack");
    Effect.CritPerStack = `GetConfigInt("M31_SleightOfHand_CritPerStack");
    Effect.MaxStacks = `GetConfigInt("M31_SleightOfHand_MaxStacks");
    Effect.StackDecay = `GetConfigInt("M31_SleightOfHand_StackDecay");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_SleightOfHand_bMatchSourceWeapon");
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_SleightOfHand_BuffText"), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

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

static function AddPistolActionPointCost(X2AbilityTemplate Template)
{
    local X2AbilityCost_ActionPoints ActionPointCost;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickdraw');
    ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('DP_BulletTime');

    Template.AbilityCosts.AddItem(ActionPointCost);
}