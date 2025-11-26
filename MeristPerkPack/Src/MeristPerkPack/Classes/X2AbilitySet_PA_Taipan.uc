class X2AbilitySet_PA_Taipan extends X2AbilitySet_PlayableAliens;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(VeryAngryBite());
    Templates.AddItem(CrystallineCornea());
    Templates.AddItem(MalevolentFocus());
    Templates.AddItem(TaipanBloodThirst());
    Templates.AddItem(TaipanAmbush());
        Templates.AddItem(TaipanAmbushAttack());
    Templates.AddItem(TaipanAmbush2());
        Templates.AddItem(TaipanAmbush2Trigger());
    Templates.AddItem(TaipanReturnFire());
        Templates.AddItem(TaipanReturnFireAttack());
    Templates.AddItem(TaipanWatchThemRun());
        Templates.AddItem(TaipanWatchThemRunTrigger());
    Templates.AddItem(TaipanBite());
    Templates.AddItem(TaipanDeadlyBite());
        Templates.AddItem(TaipanDeadlyBiteAttack());
        Templates.AddItem(TaipanDeadlyBiteChaserAttack());
    Templates.AddItem(TaipanCruelty());
        Templates.AddItem(TaipanCrueltyTrigger());
    Templates.AddItem(TaipanVengeance());
    Templates.AddItem(TaipanBloodHunter());
    Templates.AddItem(TaipanStealth());

    return Templates;
}

static function X2AbilityTemplate VeryAngryBite()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    Template = StandardMelee('M31_PA_VeryAngryBite', "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    Template.bLimitTargetIcons = true;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    ActionPointCost.bFreeCost = `GetConfigBool("M31_PA_VeryAngryBite_bFreeAction");
    if (`GetConfigBool("M31_PA_VeryAngryBite_bAllowMovementActionPoint"))
        ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PA_VeryAngryBite_Cooldown"));

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_VeryAngryBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_VeryAngryBite_CritBonus");
    ToHitCalc.bAllowCrit = `GetConfigBool("M31_PA_VeryAngryBite_bAllowCrit");
    ToHitCalc.bReactionFire = `GetConfigBool("M31_PA_VeryAngryBite_bIsReactonFire");
    Template.AbilityToHitCalc = ToHitCalc;

    Template.AbilityTargetConditions.Length = 0;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    AddAdjacencyCondition(Template);

    Template.AddShooterEffectExclusions();

    Template.AddTargetEffect(CreateVeryAngryBiteDamageEffect());
    Template.AddTargetEffect(CreateVeryAngryBiteBleedingEffect());
    
    Template.bOverrideMeleeDeath = false;
    Template.bShowActivation = true;

    SetFireAnim(Template, 'HL_M31_ViciousBite');

    Template.OverrideAbilityAvailabilityFn = TaipanBite_OverrideAbilityAvailability;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2Effect_ApplyDamageWithRank CreateVeryAngryBiteDamageEffect()
{
    local X2Effect_ApplyDamageWithRank PhysicalDamageEffect;

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_VeryAngryBite_Damage");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_VeryAngryBite_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_VeryAngryBite_CritDamagePerRank");

    return PhysicalDamageEffect;
}

static function X2Effect_Persistent CreateVeryAngryBiteBleedingEffect()
{
    local X2Effect_Persistent BleedingEffect;
    
    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_VeryAngryBite_BleedDuration"),
        `GetConfigInt("M31_PA_VeryAngryBite_BleedDamage"),
        `GetConfigInt("M31_PA_VeryAngryBite_BleedDamage_Spread"),
        `GetConfigFloat("M31_PA_VeryAngryBite_BleedDamage_Prc"));
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_PA_VeryAngryBite_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding"); 

    return BleedingEffect;
}

static function X2AbilityTemplate CrystallineCornea()
{
    local X2AbilityTemplate             Template;
    local X2Effect_CrystallineCornea    Effect;
    
    Template = Passive('M31_PA_CrystallineCornea', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_horror", false, true);

    Effect = new class'X2Effect_CrystallineCornea';
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate MalevolentFocus()
{
    local X2AbilityTemplate             Template;
    local X2Effect_MalevolentFocus      Effect;
    
    Template = Passive('M31_PA_MalevolentFocus', "img:///UILibrary_MeristPerkIcons.UIPerk_MalevolentFocus", false, true);

    Effect = new class'X2Effect_MalevolentFocus';
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Effect.BuildPersistentEffect(1, true, false);
    
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate TaipanBloodThirst()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_TaipanBloodThirst     Effect;
    
    Template = Passive('M31_PA_TaipanBloodThirst', "img:///UILibrary_XPACK_Common.UIPerk_bleeding", false, true);

    Effect = new class'X2Effect_PA_TaipanBloodThirst';
    Effect.iDefaultDamagePerStack = `GetConfigInt("M31_PA_TaipanBloodThirst_DamagePerStack");
    Effect.iMaxStacks = `GetConfigInt("M31_PA_TaipanBloodThirst_MaxStacks");
    Effect.iMaxStacksPerTurn = `GetConfigInt("M31_PA_TaipanBloodThirst_MaxStacksPerTurn");
    Effect.iStackDuration = `GetConfigInt("M31_PA_TaipanBloodThirst_StackDuration");
    Effect.bRefreshDuration = `GetConfigBool("M31_PA_TaipanBloodThirst_bRefreshDuration");
    Effect.bMatchSourceWeapon = `GetConfigBool("M31_PA_TaipanBloodThirst_bMatchSourceWeapon");
    Effect.bIncreaseOnlyOnHit = `GetConfigBool("M31_PA_TaipanBloodThirst_bIncreaseOnlyOnHit");
    Effect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, `GetLocalizedString("M31_BloodThirst_BuffText"), Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    return Template;
}

static function X2AbilityTemplate TaipanAmbush()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_TaipanAmbush      Effect;

    Template = Passive('M31_PA_TaipanAmbush', "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol", false, true);

    Effect = new class'X2Effect_PA_TaipanAmbush';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_TaipanAmbush_Attack');

    return Template;
}

static function X2AbilityTemplate TaipanAmbushAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_Visibility            VisibilityCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;

    Template = Attack('M31_PA_TaipanAmbush_Attack', "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol", false, true);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'ObjectMoved';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    VisibilityCondition.bAllowSquadsight = false;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    // Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn'); // Allow to be usable during unit's own turn
    Template.AddShooterEffectExclusions();

    AddBladestormMark(Template, 'M31_PA_TaipanAmbush_MarkTarget');
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_TaipanAmbush_Counter', `GetConfigInt("M31_PA_TaipanAmbush_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    return Template;
}

static function X2AbilityTemplate TaipanAmbush2()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_TaipanAmbush      Effect;

    Template = Passive('M31_PA_TaipanAmbush2', "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol", false, true);

    Effect = new class'X2Effect_PA_TaipanAmbush';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_TaipanAmbush2_Trigger');

    return Template;
}

static function X2AbilityTemplate TaipanAmbush2Trigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;

    Template = SelfTargetTrigger('M31_PA_TaipanAmbush2_Trigger', "img:///UILibrary_DLC3Images.UIPerk_spark_hunterprotocol");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.Priority = 40;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    AddSuppressedCondition(Template);
    Template.AddShooterEffectExclusions();

    Template.AddTargetEffect(new class'X2Effect_MeristReserveOverwatchPoints');
    Template.AddTargetEffect(class'X2Effect_MeristCoveringFire'.static.CreateCoveringFireEffect());

    Template.BuildVisualizationFn = Ambush_BuildVisualization;

    return Template;
}

static function X2AbilityTemplate TaipanReturnFire()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_TaipanReturnFire', "img:///UILibrary_PerkIcons.UIPerk_returnfire", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_TaipanReturnFire_Attack');

    return Template;
}

static function X2AbilityTemplate TaipanReturnFireAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    ToHitCalc;
    local X2AbilityTarget_Single            SingleTarget;

    Template = Attack('M31_PA_TaipanReturnFire_Attack', "img:///UILibrary_PerkIcons.UIPerk_returnfire", false, true);
    
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    Template.AbilityTriggers.Length = 0;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_TaipanReturnFire;
    Trigger.ListenerData.Priority = 45;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    // Template.AbilityShooterConditions.AddItem(new class'X2Condition_NotItsOwnTurn'); // Allow to be usable during unit's own turn
    Template.AddShooterEffectExclusions();

    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_TaipanReturnFire_Counter', `GetConfigInt("M31_PA_TaipanReturnFire_ActivationsPerTurn"));

    SingleTarget = new class'X2AbilityTarget_Single';
    SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
    Template.AbilityTargetStyle = SingleTarget;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
    ToHitCalc.bReactionFire = true;
    ToHitCalc.bIgnoreCoverBonus = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

    AddAmmoCost(Template, 1);

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_TaipanReturnFire(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Ability             AbilityState, CallbackAbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local XComGameState_Unit                CallbackAbilitySourceUnit, AbilitySourceUnit;
    local StateObjectReference              BondmateRef;
    local bool bHasSoldierBond;
    local int Index;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext == none || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
        return ELR_NoInterrupt;

    AbilityState = XComGameState_Ability(EventData);
    AbilitySourceUnit = XComGameState_Unit(EventSource);
    CallbackAbilityState = XComGameState_Ability(CallbackData);
    CallbackAbilitySourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CallbackAbilityState.OwnerStateObject.ObjectID));

    if (AbilityState == none || AbilitySourceUnit == none || CallbackAbilityState == none || CallbackAbilitySourceUnit == none)
        return ELR_NoInterrupt; 

    AbilityTemplate = AbilityState.GetMyTemplate();

    if (!AbilityState.IsAbilityInputTriggered() || AbilityTemplate.Hostility != eHostility_Offensive)
        return ELR_NoInterrupt;
        
    bHasSoldierBond = CallbackAbilitySourceUnit.HasSoldierBond(BondmateRef);

    if (AbilityContext.InputContext.PrimaryTarget.ObjectID == CallbackAbilitySourceUnit.ObjectID
        || bHasSoldierBond && AbilityContext.InputContext.PrimaryTarget.ObjectID == BondmateRef.ObjectID)
    {
        if (CallbackAbilityState.CanActivateAbilityForObserverEvent(AbilitySourceUnit) == 'AA_Success')
        {
            CallbackAbilityState.AbilityTriggerAgainstSingleTarget(AbilitySourceUnit.GetReference(), false);
            return ELR_NoInterrupt;
        }
    }
    
    for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
    {
        if (AbilityContext.InputContext.MultiTargets[Index].ObjectID == CallbackAbilitySourceUnit.ObjectID
            || bHasSoldierBond && AbilityContext.InputContext.MultiTargets[Index].ObjectID == BondmateRef.ObjectID)
        {
            if (CallbackAbilityState.CanActivateAbilityForObserverEvent(AbilitySourceUnit) == 'AA_Success')
            {
                CallbackAbilityState.AbilityTriggerAgainstSingleTarget(AbilitySourceUnit.GetReference(), false);
                return ELR_NoInterrupt;
            }
        }
    }

    return ELR_NoInterrupt;
}

static function X2AbilityTemplate TaipanWatchThemRun()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PA_TaipanWatchThemRun    Effect;

    Template = Passive('M31_PA_TaipanWatchThemRun', "img:///UILibrary_FavidsPerkPack.UIPerk_Opportunist", false, true);

    Effect = new class'X2Effect_PA_TaipanWatchThemRun';
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_TaipanWatchThemRun_Trigger');
    Template.AdditionalAbilities.AddItem('CoveringFire');

    return Template;
}

static function X2AbilityTemplate TaipanWatchThemRunTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;

    Template = SelfTargetTrigger('M31_PA_TaipanWatchThemRun_Trigger', "img:///UILibrary_FavidsPerkPack.UIPerk_Opportunist");

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = class'X2Effect_PA_TaipanWatchThemRun'.default.EventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    AddSuppressedCondition(Template);
    Template.AddShooterEffectExclusions();

    Template.AddTargetEffect(new class'X2Effect_MeristReserveOverwatchPoints');
    Template.AddTargetEffect(class'X2Effect_MeristCoveringFire'.static.CreateCoveringFireEffect());

    AddUnitValueCondition(Template, 'M31_PA_TaipanWatchThemRun_Counter', `GetConfigInt("M31_PA_TaipanWatchThemRun_ActivationsPerTurn"));

    Template.BuildVisualizationFn = Ambush_BuildVisualization;

    return Template;
}

static function X2AbilityTemplate TaipanBite()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  StandardMelee;
    local X2AbilityTarget_MovingMelee_FixedRange MeleeTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_ApplyDamageWithRank      PhysicalDamageEffect;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    Template = MovingMelee('M31_PA_TaipanBite', "img:///UILibrary_MZChimeraIcons.Ability_ViciousBite", false, false);

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

    StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
    StandardMelee.BuiltInHitMod = `GetConfigInt("M31_PA_TaipanBite_AimBonus");
    StandardMelee.BuiltInCritMod = `GetConfigInt("M31_PA_TaipanBite_CritBonus");
    StandardMelee.bAllowCrit = `GetConfigBool("M31_PA_TaipanBite_bAllowCrit");
    Template.AbilityToHitCalc = StandardMelee;

    MeleeTarget = new class'X2AbilityTarget_MovingMelee_FixedRange';
    MeleeTarget.iFixedRange = 1;
    Template.AbilityTargetStyle = MeleeTarget;
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    Template.AddShooterEffectExclusions();

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = false;
    ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
    Template.AbilityCosts.AddItem(ActionPointCost);

    AddCooldown(Template, `GetConfigInt("M31_PA_TaipanBite_Cooldown"));

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_TaipanBite_Damage");
    PhysicalDamageEffect.EffectDamageValue.Rupture = `GetConfigInt("M31_PA_TaipanBite_Rupture");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_TaipanBite_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_TaipanBite_CritDamagePerRank");
    Template.AddTargetEffect(PhysicalDamageEffect);

    Template.AddTargetEffect(CreateTaipanBiteBleedingEffect());
    
    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bSkipMoveStop = true;
    Template.bOverrideMeleeDeath = false;

    Template.bShowActivation = true;

    Template.OverrideAbilityAvailabilityFn = TaipanBite_OverrideAbilityAvailability;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

function TaipanBite_OverrideAbilityAvailability(out AvailableAction Action, XComGameState_Ability AbilityState, XComGameState_Unit OwnerState)
{
    if (Action.AvailableCode == 'AA_Success')
    {
        if (OwnerState.ActionPoints.Length == 1 && OwnerState.ActionPoints[0] == class'X2CharacterTemplateManager'.default.MoveActionPoint)
            Action.ShotHUDPriority = class'UIUtilities_Tactical'.const.PARRY_PRIORITY;
    }
}

static function X2Effect_Persistent CreateTaipanBiteBleedingEffect()
{

    local X2Effect_Persistent BleedingEffect;
    
    BleedingEffect = class'M31_Helpers'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PA_TaipanBite_BleedDuration"),
        `GetConfigInt("M31_PA_TaipanBite_BleedDamage"),
        `GetConfigInt("M31_PA_TaipanBite_BleedDamage_Spread"),
        `GetConfigFloat("M31_PA_TaipanBite_BleedDamage_Prc"));
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_PA_TaipanBite_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding"); 

    return BleedingEffect;
}

static function X2AbilityTemplate TaipanDeadlyBite()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_PA_TaipanDeadlyBite', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, true);

    Template.AdditionalAbilities.AddItem('M31_PA_TaipanDeadlyBite_Attack');
    Template.AdditionalAbilities.AddItem('M31_PA_TaipanDeadlyBite_ChaserAttack');

    return Template;
}

static function X2AbilityTemplate TaipanDeadlyBiteAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    Template = StandardMelee('M31_PA_TaipanDeadlyBite_Attack', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_TaipanDeadlyBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_TaipanDeadlyBite_CritBonus");
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

    AddBladestormMark(Template, 'M31_PA_TaipanDeadlyBite_MarkTarget');
    AddSuppressedCondition(Template);

    Template.AddTargetEffect(CreateTaipanDeadlyBiteDamageEffect());
    Template.AddTargetEffect(CreateTaipanBiteBleedingEffect());

    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2AbilityTemplate TaipanDeadlyBiteChaserAttack()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StandardMelee  ToHitCalc;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_Visibility            VisibilityCondition;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    Template = StandardMelee('M31_PA_TaipanDeadlyBite_ChaserAttack', "img:///UILibrary_MeristPerkIcons.UIPerk_BleedingBite", false, false);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.BuildInterruptGameStateFn = none;

    ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    ToHitCalc.BuiltInHitMod = `GetConfigInt("M31_PA_TaipanDeadlyBite_AimBonus");
    ToHitCalc.BuiltInCritMod = `GetConfigInt("M31_PA_TaipanDeadlyBite_CritBonus");
    ToHitCalc.bReactionFire = true;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

    Template.AbilityTriggers.Length = 0;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = 'AbilityActivated';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_None;
    Trigger.ListenerData.EventFn = class'M31_Helpers'.static.AbilityTriggerEventListener_ChasingAttack;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.Length = 0;
    Template.AbilityTargetConditions.Length = 0;
    
    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bRequireBasicVisibility = true;
    VisibilityCondition.bDisablePeeksOnMovement = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeSquadmates = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
    AddAdjacencyCondition(Template);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    Template.AbilityShooterConditions.AddItem(new class'X2Condition_ItsOwnTurn');
    Template.AddShooterEffectExclusions();

    if (`GetConfigBool("M31_PA_TaipanDeadlyBite_bExclusiveMark"))
    {
        AddBladestormMark(Template, 'M31_PA_TaipanDeadlyBite_ChaserMarkTarget');
    }
    else
    {
        AddBladestormMark(Template, 'M31_PA_TaipanDeadlyBite_MarkTarget');
    }
    AddSuppressedCondition(Template);
    AddUnitValueCondition(Template, 'M31_PA_TaipanDeadlyBite_Counter', `GetConfigInt("M31_PA_TaipanDeadlyBite_ActivationsPerTurn"));

    Template.AddTargetEffect(CreateTaipanDeadlyBiteDamageEffect());
    Template.AddTargetEffect(CreateTaipanBiteBleedingEffect());

    Template.CustomFireAnim = 'HL_M31_ViciousBite';
    Template.bShowActivation = true;
    Template.bFrameEvenWhenUnitIsHidden = true;

    Template.AdditionalAbilities.AddItem('M31_PA_ViperBite_Anims');

    return Template;
}

static function X2Effect_ApplyDamageWithRank CreateTaipanDeadlyBiteDamageEffect()
{
    local X2Effect_ApplyDamageWithRank PhysicalDamageEffect;

    PhysicalDamageEffect = new class'X2Effect_ApplyDamageWithRank';
    PhysicalDamageEffect.EffectDamageValue = `GetConfigDamage("M31_PA_TaipanDeadlyBite_Damage");
    PhysicalDamageEffect.fDamagePerRank = `GetConfigFloat("M31_PA_TaipanDeadlyBite_DamagePerRank");
    PhysicalDamageEffect.fCritDamagePerRank = `GetConfigFloat("M31_PA_TaipanDeadlyBite_CritDamagePerRank");

    return PhysicalDamageEffect;
}

static function X2AbilityTemplate TaipanCruelty()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_TaipanCruelty     Effect;

    Template = Passive('M31_PA_TaipanCruelty', "img:///UILibrary_WOTC_APA_Class_Pack_LW.perk_ApexPredator", false, true);

    Effect = new class'X2Effect_PA_TaipanCruelty';
    Effect.DamageBonusPrc = `GetConfigInt("M31_PA_TaipanCruelty_DamageBonusPrc");
    Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    Template.AdditionalAbilities.AddItem('M31_PA_TaipanCruelty_Trigger');

    return Template;
}

static function X2AbilityTemplate TaipanCrueltyTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_Fear                     PanickedEffect;

    Template = SelfTargetTrigger('M31_PA_TaipanCruelty_Trigger', "img:///UILibrary_WOTC_APA_Class_Pack_LW.perk_ApexPredator");

    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.EventID = class'X2Effect_PA_TaipanCruelty'.default.EventName;
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
    Trigger.ListenerData.Priority = 60;
    Template.AbilityTriggers.AddItem(Trigger);

    PanickedEffect = new class'X2Effect_Fear';
    PanickedEffect.ApplyChanceFn = ApplyChance_TaipanCrueltyPanic;
    PanickedEffect.EffectName = class'X2AbilityTemplateManager'.default.PanickedName;
    PanickedEffect.BuildPersistentEffect(class'X2StatusEffects'.default.PANICKED_TURNS, , , , eGameRule_PlayerTurnBegin);
    PanickedEffect.AddPersistentStatChange(eStat_Offense, class'X2StatusEffects'.default.PANICKED_AIM_ADJUST);
    PanickedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.PANICKED_HIERARCHY_VALUE;
    PanickedEffect.EffectAppliedEventName = 'PanickedEffectApplied';
    PanickedEffect.bRemoveWhenSourceDies = true;
    Template.AddTargetEffect(PanickedEffect);
    
    Template.bShowActivation = false;

    return Template;
}

function name ApplyChance_TaipanCrueltyPanic(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;
    local name ImmuneName;
    local int AttackVal, DefendVal, TargetRoll, RandRoll;
    
    TargetUnit = XComGameState_Unit(kNewTargetState);
    if (TargetUnit != none)
    {
        foreach class'X2AbilityToHitCalc_PanicCheck'.default.PanicImmunityAbilities(ImmuneName)
        {
            if (TargetUnit.FindAbility(ImmuneName).ObjectID != 0)
            {
                return 'AA_UnitIsImmune';
            }
        }

        if (`GetConfigBool("M31_PA_TaipanCruelty_bGuaranteed"))
        {
            return 'AA_Success';
        }
        
        AttackVal = `GetConfigInt("M31_PA_TaipanCruelty_BaseChance");
        DefendVal = TargetUnit.GetCurrentStat(eStat_Will);
        TargetRoll = AttackVal - DefendVal;
        TargetRoll = Clamp(TargetRoll, 0, 100);
        RandRoll = `SYNC_RAND(100);
        if (RandRoll < TargetRoll)
        {
            return 'AA_Success';
        }
    }

    return 'AA_EffectChanceFailed';
}


static function X2AbilityTemplate TaipanVengeance()
{
    local X2AbilityTemplate             Template;
    local X2Effect_PA_TaipanVengeance   Effect;
    local X2Effect_DedicatedOverwatch   OverwatchEffect;
    
    Template = Passive('M31_PA_TaipanVengeance', "img:///UILibrary_MW.UIPerk_triangulation", false, true);

    Effect = new class'X2Effect_PA_TaipanVengeance';
    Effect.AimBonus = `GetConfigInt("M31_PA_TaipanVengeance_AimBonus");
    Effect.AimBonusHit = `GetConfigInt("M31_PA_TaipanVengeance_AimBonusHit");
    Effect.CritBonus = `GetConfigInt("M31_PA_TaipanVengeance_CritBonus");
    Effect.CritBonusHit = `GetConfigInt("M31_PA_TaipanVengeance_CritBonusHit");
    Effect.AllyBonusModifierPrc = `GetConfigInt("M31_PA_TaipanVengeance_AllyBonusModifierPrc");
    Effect.bTreatBondmateAsSelf = `GetConfigBool("M31_PA_TaipanVengeance_bTreatBondmateAsSelf");
    Effect.bRequireVisibility = `GetConfigBool("M31_PA_TaipanVengeance_bRequireVisibility");
    Effect.bAnyHostileAction = `GetConfigBool("M31_PA_TaipanVengeance_bAnyHostileAction");
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Effect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(Effect);

    OverwatchEffect = new class'X2Effect_DedicatedOverwatch';
    OverwatchEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(OverwatchEffect);

    return Template;
}

static function X2AbilityTemplate TaipanBloodHunter()
{
    local X2AbilityTemplate Template;
    
    Template = Passive('M31_PA_TaipanBloodHunter', "img:///UILibrary_LW_PerkPack.LW_AbilityAdrenalNeurosympathy", false, true);

    return Template;
}

static function X2AbilityTemplate TaipanStealth()
{
    local X2AbilityTemplate             Template;
    local X2AbilityCooldown_Extended    Cooldown;
    local X2Effect_RangerStealth        StealthEffect;
    
    Template = SelfTargetActivated('M31_PA_TaipanStealth', "img:///UILibrary_SOHunter.UIPerk_fade", false);

    Cooldown = new class'X2AbilityCooldown_Extended';
    Cooldown.iNumTurns = `GetConfigInt("M31_PA_TaipanStealth_Cooldown");
    Cooldown.bDoNotApplyOnHit = true;
    Template.AbilityCooldown = Cooldown;

    AddActionPointCost(Template, eCost_SingleConsumeAll);

    Template.AbilityShooterConditions.AddItem(new class'X2Condition_Stealth');
    Template.AddShooterEffectExclusions();

    StealthEffect = new class'X2Effect_RangerStealth';
    StealthEffect.EffectName = 'M31_PA_TaipanStealth';
    StealthEffect.EffectRemovedFn = TaipanStealth_EffectRemoved;
    StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
    StealthEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    Template.AddTargetEffect(StealthEffect);

    Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

    Template.ActivationSpeech = 'ActivateConcealment';

    return Template;
}

static function TaipanStealth_EffectRemoved(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed)
{
    local XComGameStateHistory  History;
    local XComGameState_Ability AbilityState;
    local X2AbilityTemplate     AbilityTemplate;

    History = `XCOMHISTORY;

    AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    if (AbilityState == none)
    {
        AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
        if (AbilityState != none)
            AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
    }

    if (AbilityState != none)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
        if (AbilityTemplate.AbilityCooldown != none)
        {
            AbilityState.iCooldown = AbilityTemplate.AbilityCooldown.iNumTurns;
        }
    }
}
