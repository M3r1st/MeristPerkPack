class X2Ability_Extended extends X2Ability;

// Used by ActionPointCost and related functions
enum EActionPointCost
{
    eCost_Free,                 // No action point cost, but you must have an action point available.
    eCost_Single,               // Costs a single action point.
    eCost_SingleConsumeAll,     // Costs a single action point, ends the turn.
    eCost_Double,               // Costs two action points.
    eCost_DoubleConsumeAll,     // Costs two action points, ends the turn.
    eCost_Weapon,               // Costs as much as a weapon shot.
    eCost_WeaponConsumeAll,     // Costs as much as a weapon shot, ends the turn.
    eCost_Overwatch,            // No action point cost, but displays as ending the turn. Used for 
                                // abilities that have an X2Effect_ReserveActionPoints or similar.
    eCost_OverwatchWeapon,
    eCost_None,                 // No action point cost. For abilities which may be triggered during
                                // the enemy turn. You should use eCost_Free for activated abilities.
};

enum EHUDPriorityType
{
    ePriorityType_None,
    ePriorityType_Primary,
    ePriorityType_Pistol,
    ePriorityType_Secondary,
    ePriorityType_Melee,
    ePriorityType_Psi
};

static function X2AbilityTemplate Passive(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bDisplayInUI = false, optional bool bUniqueSource = true)
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = bUniqueSource;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    if (bDisplayInUI)
    {
        PersistentEffect = new class'X2Effect_Persistent';
        PersistentEffect.EffectName = (InStr(TemplateName, "_Passive") != INDEX_NONE ? TemplateName : name(TemplateName $ "_Passive"));
        PersistentEffect.BuildPersistentEffect(1, true, false);
        PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
        Template.AddTargetEffect(PersistentEffect);
    }

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

static function X2AbilityTemplate SelfTargetActivated(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false)
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.DisplayTargetHitChance = false;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipFireAction = true;
    Template.bShowActivation = true;

    return Template;
}

static function X2AbilityTemplate SelfTargetTrigger(name TemplateName, string IconImage)
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipFireAction = true;

    return Template;
}

static function X2AbilityTemplate Attack(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate         Template;
    local X2Condition_Visibility    VisibilityCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk'; 
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    VisibilityCondition = new class'X2Condition_Visibility';
    VisibilityCondition.bRequireGameplayVisible = true;
    VisibilityCondition.bAllowSquadsight = true;
    Template.AbilityTargetConditions.AddItem(VisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
        Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

        Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
    }

    Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

    Template.bAllowFreeFireWeaponUpgrade = true;

    Template.AssociatedPassives.AddItem('HoloTargeting');

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
        
    Template.CinescriptCameraType = "StandardGunFiring";
    Template.bUsesFiringCamera = true;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate StandardMelee(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;
    Template.bLimitTargetIcons = true;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    // Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    }

    Template.bAllowBonusWeaponEffects = true;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function X2AbilityTemplate MovingMelee(name TemplateName, string IconImage,
    optional bool bCrossClassEligible = false, optional bool bAddDefaultEffects = true)
{
    local X2AbilityTemplate Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.DisplayTargetHitChance = true;

    Template.bCrossClassEligible = bCrossClassEligible;

    Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
    Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
    Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    // Template.AddShooterEffectExclusions();

    Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    if (bAddDefaultEffects)
    {
        Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
    }

    Template.bAllowBonusWeaponEffects = true;

    Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
    Template.SourceMissSpeech = 'SwordMiss';

    Template.bSkipMoveStop = true;

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;

    Template.bShowActivation = true;

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
    Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

    return Template;
}

static function AddCooldown(out X2AbilityTemplate Template, int iNumTurns)
{
    local X2AbilityCooldown AbilityCooldown;

    if (iNumTurns > 0)
    {
        AbilityCooldown = new class'X2AbilityCooldown';
        AbilityCooldown.iNumTurns = iNumTurns;
        Template.AbilityCooldown = AbilityCooldown;
    }
}

static function AddAmmoCost(out X2AbilityTemplate Template, int iAmmo, optional bool bFreeCost)
{
    local X2AbilityCost_Ammo AmmoCost;
    if (iAmmo > 0)
    {
        AmmoCost = new class'X2AbilityCost_Ammo';
        AmmoCost.iAmmo = iAmmo;
        AmmoCost.bFreeCost = bFreeCost;
        Template.AbilityCosts.AddItem(AmmoCost);
    }
}

static function AddCharges(out X2AbilityTemplate Template, int InitialCharges)
{
    local X2AbilityCharges Charges;
    local X2AbilityCost_Charges ChargeCost;

    if (InitialCharges > 0)
    {
        Charges = new class'X2AbilityCharges';
        Charges.InitialCharges = InitialCharges;
        Template.AbilityCharges = Charges;

        ChargeCost = new class'X2AbilityCost_Charges';
        ChargeCost.NumCharges = 1;
        Template.AbilityCosts.AddItem(ChargeCost);
    }
}

static function AddActionPointCost(out X2AbilityTemplate Template, EActionPointCost Cost)
{
    if (Cost != eCost_None)
    {
        Template.AbilityCosts.AddItem(ActionPointCost(Cost));
    }
}

// Helper function for creating an X2AbilityCost_ActionPoints.
static function X2AbilityCost_ActionPoints ActionPointCost(EActionPointCost Cost)
{
    local X2AbilityCost_ActionPoints AbilityCost;

    AbilityCost = new class'X2AbilityCost_ActionPoints';
    switch (Cost)
    {
        case eCost_Free:                AbilityCost.iNumPoints = 1; AbilityCost.bFreeCost = true; break;
        case eCost_Single:              AbilityCost.iNumPoints = 1; break;
        case eCost_SingleConsumeAll:    AbilityCost.iNumPoints = 1; AbilityCost.bConsumeAllPoints = true; break;
        case eCost_Double:              AbilityCost.iNumPoints = 2; break;
        case eCost_DoubleConsumeAll:    AbilityCost.iNumPoints = 2; AbilityCost.bConsumeAllPoints = true; break;
        case eCost_Weapon:              AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; break;
        case eCost_WeaponConsumeAll:    AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; AbilityCost.bConsumeAllPoints = true; break;
        case eCost_Overwatch:           AbilityCost.iNumPoints = 1; AbilityCost.bConsumeAllPoints = true; AbilityCost.bFreeCost = true; break;
        case eCost_OverwatchWeapon:     AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; AbilityCost.bConsumeAllPoints = true; AbilityCost.bFreeCost = true; break;
        case eCost_None:                AbilityCost.iNumPoints = 0; break;
    }

    return AbilityCost;
}

static function SetFireAnim(out X2AbilityTemplate Template, name Anim)
{
    Template.CustomFireAnim = Anim;
    Template.CustomFireKillAnim = Anim;
    Template.CustomMovingFireAnim = Anim;
    Template.CustomMovingFireKillAnim = Anim;
    Template.CustomMovingTurnLeftFireAnim = Anim;
    Template.CustomMovingTurnLeftFireKillAnim = Anim;
    Template.CustomMovingTurnRightFireAnim = Anim;
    Template.CustomMovingTurnRightFireKillAnim = Anim;
}

static function AddBladestormMark(out X2AbilityTemplate Template, name MarkName, optional bool bFullTurn = true)
{
    local X2Effect_Persistent BladestormTargetEffect;
    local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;

    if (bFullTurn)
    {
        BladestormTargetEffect = new class'X2Effect_Persistent';
        BladestormTargetEffect.EffectName = MarkName;
        BladestormTargetEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
        BladestormTargetEffect.bUseSourcePlayerState = true;
        BladestormTargetEffect.SetupEffectOnShotContextResult(true, true);
        Template.AddTargetEffect(BladestormTargetEffect);
    }
    else
    {
        BladestormTargetEffect = new class'X2Effect_Persistent';
        BladestormTargetEffect.EffectName = MarkName;
        BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
        BladestormTargetEffect.SetupEffectOnShotContextResult(true, true);
        Template.AddTargetEffect(BladestormTargetEffect);
    }
    
    BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    BladestormTargetCondition.AddExcludeEffect(MarkName, 'AA_DuplicateEffectIgnored');
    Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);
}

static function AddSuppressedCondition(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffects SuppressedCondition;

    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    // SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    SuppressedCondition.AddExcludeEffect('AreaSuppression', 'AA_UnitIsSuppressed'); // Not building against LWOTC
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);
}

static function AddAdjacencyCondition(out X2AbilityTemplate Template, optional int Range = 144)
{
    local X2Condition_UnitProperty AdjacencyCondition;

    AdjacencyCondition = new class'X2Condition_UnitProperty';
    AdjacencyCondition.ExcludeDead = false;
    AdjacencyCondition.ExcludeFriendlyToSource = false;
    AdjacencyCondition.RequireWithinRange = true;
    AdjacencyCondition.WithinRange = Range;
    Template.AbilityTargetConditions.AddItem(AdjacencyCondition);
}

static function AddUnitValueCondition(out X2AbilityTemplate Template, name ValueName, int MaxValue, optional EUnitValueCleanup CleanupType)
{
    local X2Condition_UnitValue         ValueCondition;
    local X2Effect_IncrementUnitValue   UnitValueEffect;

    if (MaxValue > 0)
    {
        ValueCondition = new class'X2Condition_UnitValue';
        ValueCondition.AddCheckValue(ValueName, MaxValue, eCheck_LessThan);
        Template.AbilityShooterConditions.AddItem(ValueCondition);
    }

    UnitValueEffect = new class'X2Effect_IncrementUnitValue';
    UnitValueEffect.UnitName = ValueName;
    UnitValueEffect.NewValueToSet = 1;
    UnitValueEffect.CleanupType = CleanupType;
    UnitValueEffect.SetupEffectOnShotContextResult(true, true);
    Template.AddShooterEffect(UnitValueEffect);
}

static function AddOverwatchTriggers(out X2AbilityTemplate Template, optional bool bMovement = true, optional bool bAttack = true)
{
    local X2AbilityTrigger_EventListener Trigger;

    if (bMovement)
    {
        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.EventID = 'ObjectMoved';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.Filter = eFilter_None;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
        Template.AbilityTriggers.AddItem(Trigger);
    }

    if (bAttack)
    {
        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.EventID = 'AbilityActivated';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.Filter = eFilter_None;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
        Template.AbilityTriggers.AddItem(Trigger);
    }
}

static function EventListenerReturn AbilityTriggerEventListener_ChasingAttack(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Ability         CallbackAbilityState;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Unit            Attacker;
    local XComGameState_Unit            TargetUnit;
    local X2AbilityTemplate             AbilityTemplate;
    local bool bDealsDamage;
    
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        AbilityState = XComGameState_Ability(EventData);
        CallbackAbilityState = XComGameState_Ability(CallbackData);
        Attacker = XComGameState_Unit(EventSource);
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CallbackAbilityState.OwnerStateObject.ObjectID));
        TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
        if (AbilityState != none && CallbackAbilityState != none && Attacker != none && SourceUnit != none && TargetUnit != none)
        {
            if (AbilityState.IsAbilityInputTriggered())
            {
                if (SourceUnit.IsEnemyUnit(TargetUnit) && SourceUnit.IsFriendlyUnit(Attacker) && SourceUnit.ObjectID != Attacker.ObjectID)
                {
                    AbilityTemplate = AbilityState.GetMyTemplate();
                    bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);
                    if (AbilityTemplate.Hostility == eHostility_Offensive && bDealsDamage && !AbilityTemplate.bIsASuppressionEffect)
                    {
                        if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit, SourceUnit) == 'AA_Success')
                            CallbackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false);
                    }

                }
            }

        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn AbilityTriggerEventListener_BladestormConcealment(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameState_Unit            AbilityOwner;
    local XComGameState_Ability         CallbackAbilityState;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            TargetUnit;

    AbilityOwner = XComGameState_Unit(EventSource);
    CallbackAbilityState = XComGameState_Ability(CallbackData);

    if (AbilityOwner == none || CallbackAbilityState == none)
        return ELR_NoInterrupt;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
    if (AbilityContext != none && AbilityContext.InputContext.SourceObject != AbilityOwner.ConcealmentBrokenByUnitRef)
        return ELR_NoInterrupt;

    History = `XCOMHISTORY;

    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityOwner.ConcealmentBrokenByUnitRef.ObjectID));
    if (TargetUnit == none)
        return ELR_NoInterrupt;

    if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
    {
        CallbackAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn AbilityTriggerEventListener_BuffMe(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         CallbackAbilityState;
    local XComGameState_Unit            TargetUnit;
    local int                           VisualizeIndex;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        CallbackAbilityState = XComGameState_Ability(CallbackData);
        TargetUnit = XComGameState_Unit(EventSource);

        VisualizeIndex = GameState.HistoryIndex;

        if (CallbackAbilityState.OwnerStateObject.ObjectID != TargetUnit.ObjectID)
        {
            if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
            {
                CallbackAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false, VisualizeIndex);
            }
        }
        else
        {
            foreach History.IterateByClassType(class'XComGameState_Unit', TargetUnit,,, GameState.HistoryIndex)
            {
                if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
                {
                    CallbackAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false, VisualizeIndex);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn CoveringFireAttackListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability         CallbackAbilityState;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameStateContext_Ability  AbilityContext;
    local X2AbilityTemplate             AbilityTemplate;

    CallbackAbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    if (AbilityContext != none && AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt && CallbackAbilityState != none)
    {
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CallbackAbilityState.OwnerStateObject.ObjectID));
        if (SourceUnit != none && SourceUnit.HasSoldierAbility('CoveringFire', true))
        {
            TargetUnit = XComGameState_Unit(EventSource);
            AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
            if (AbilityTemplate != none && AbilityTemplate.Hostility == eHostility_Offensive)
            {
                if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
                {
                    CallbackAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function bool ChainShot_DamagePreview_Static(name ChainAbilityName, XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local XComGameState_Unit    AbilityOwner;
    local StateObjectReference  ChainShot2Ref;
    local XComGameState_Ability ChainShot2Ability;
    local XComGameStateHistory  History;

    AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

    if (ChainAbilityName != '')
    {
        History = `XCOMHISTORY;
        AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        ChainShot2Ref = AbilityOwner.FindAbility(ChainAbilityName);
        ChainShot2Ability = XComGameState_Ability(History.GetGameStateForObjectID(ChainShot2Ref.ObjectID));
        if (ChainShot2Ability != none)
        {
            ChainShot2Ability.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
        }
    }
    return true;
}

static function SetAbilityShotHUDPriority(out X2AbilityTemplate Template,
    optional EHUDPriorityType Type,
    optional EActionPointCost Cost,
    optional EAbilityHostility Hostility)
{
    local int CostPriority;
    local int Priority;

    switch (Cost)
    {
        case eCost_Free:
            CostPriority = 0;
            break;
        case eCost_Single:
            CostPriority = 1;
            break;
        case eCost_SingleConsumeAll:
            CostPriority = 2;
            break;
        case eCost_WeaponConsumeAll:
            CostPriority = 3;
            break;
        default:
            CostPriority = 4;
    }

    switch (Type)
    {
        case ePriorityType_Primary:
            switch (Hostility)
            {
                case eHostility_Offensive:
                    Priority = 0 + CostPriority;
                    break;
                default:
                    Priority = 20 + CostPriority;
            }
            break;
        case ePriorityType_Pistol:
            switch (Hostility)
            {
                case eHostility_Offensive:
                    Priority = 10 + CostPriority;
                    break;
                default:
                    Priority = 25 + CostPriority;
            }
            break;
        case ePriorityType_Secondary:
        case ePriorityType_Melee:
            switch (Hostility)
            {
                case eHostility_Offensive:
                    Priority = 30 + CostPriority;
                    break;
                default:
                    Priority = 40 + CostPriority;
            }
            break;
        case ePriorityType_Psi:
            switch (Hostility)
            {
                case eHostility_Offensive:
                    Priority = 50 + CostPriority;
                    break;
                default:
                    Priority = 60 + CostPriority;
            }
            break;
        default:
            switch (Hostility)
            {
                case eHostility_Offensive:
                    Priority = 70 + CostPriority;
                    break;
                default:
                    Priority = 80 + CostPriority;
            }
    }

    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + Priority;
}