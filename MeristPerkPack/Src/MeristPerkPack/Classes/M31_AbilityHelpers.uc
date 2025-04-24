class M31_AbilityHelpers extends X2Ability;

static function X2AbilityTemplate CreatePassiveWeaponEffectAttack(name DataName, string IconImage, optional X2Effect Effect = none)
{
    local X2AbilityTemplate     Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityToHitCalc = default.DeadEye;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.bAllowAmmoEffects = false;
	Template.bAllowBonusWeaponEffects = false;
	Template.bAllowFreeFireWeaponUpgrade = false;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    if (Effect != none)
    {
        Template.AddTargetEffect(Effect);
    }

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	Template.bUsesFiringCamera = false;

	Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    // Template.BuildVisualizationFn = FollowUpShot_BuildVisualization;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.MergeVisualizationFn = FollowUpShot_MergeVisualization;
    Template.BuildInterruptGameStateFn = none;
    Template.bCrossClassEligible = false;
    return Template;
}

static function X2Effect_PersistentStatChange CreateHackDefenseReductionStatusEffect(
    name EffectName,
    int HackDefenseChangeAmount,
    optional X2Condition Condition)
{
    
    local X2Effect_PersistentStatChange HackDefenseReductionEffect;
    HackDefenseReductionEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(HackDefenseChangeAmount, Condition);
    HackDefenseReductionEffect.EffectName = EffectName;
    HackDefenseReductionEffect.DuplicateResponse = eDupe_Allow;
    HackDefenseReductionEffect.IconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
    return HackDefenseReductionEffect;
}

static function X2Effect_PersistentStatChange CreateRoboticDisorientedStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f)
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Condition_UnitProperty			UnitPropCondition;

    PersistentStatChangeEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    PersistentStatChangeEffect.TargetConditions.Length = 0;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeRobotic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

    return PersistentStatChangeEffect;
}

static function X2Effect_ImmediateAbilityActivation CreateImpairingEffect()
{
    local X2Effect_ImmediateAbilityActivation   ImpairingAbilityEffect;
    local X2Condition_AbilityProperty           AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
    ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
    ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
    ImpairingAbilityEffect.AbilityName = class'X2Ability_Impairing'.default.ImpairingAbilityName;
    ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
    ImpairingAbilityEffect.VisualizationFn = class'X2Ability_Impairing'.static.ImpairingAbilityEffectTriggeredVisualization;
    ImpairingAbilityEffect.TargetConditions.AddItem(AbilityCondition);

    return ImpairingAbilityEffect;
}

static function X2Effect_PersistentStatChange CreatePoisonedEffect()
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_Poison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(
        ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, class'X2StatusEffects'.default.PoisonedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_Poison_MobilityPenalty"));
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_Poison_AimPenalty"));
    PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.PoisonedVisualization;
    PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationTicked;
    PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationRemoved;
    PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
    PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
    PersistentStatChangeEffect.bCanTickEveryAction = true;
    PersistentStatChangeEffect.EffectAppliedEventName = 'PoisonedEffectAdded';

    if (class'X2StatusEffects'.default.PoisonEnteredParticle_Name != "")
    {
        PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.PoisonEnteredParticle_Name;
        PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.PoisonEnteredSocket_Name;
        PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.PoisonEnteredSocketsArray_Name;
    }
    PersistentStatChangeEffect.PersistentPerkName = class'X2StatusEffects'.default.PoisonEnteredPerk_Name;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropertyCondition);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_PA_Poison_DamagePerTurn");
    DamageEffect.EffectDamageValue.Spread = `GetConfigInt("M31_PA_Poison_DamagePerTurn_Spread");
    DamageEffect.EffectDamageValue.DamageType = 'Poison';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS; // Issue #89
    PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    PersistentStatChangeEffect.TargetConditions.AddItem(EffectCondition);

    return PersistentStatChangeEffect;
}

static function X2Effect_PersistentStatChange CreateEnhancedPoisonedEffect()
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource   EffectCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(
        ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, class'X2StatusEffects'.default.PoisonedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_poisoned");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * `GetConfigInt("M31_PA_EnhancedPoison_MobilityPenalty"));
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, -1 * `GetConfigInt("M31_PA_EnhancedPoison_AimPenalty"));
    PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.PoisonedVisualization;
    PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationTicked;
    PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationRemoved;
    PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
    PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
    PersistentStatChangeEffect.bCanTickEveryAction = true;
    PersistentStatChangeEffect.EffectAppliedEventName = 'PoisonedEffectAdded';

    if (class'X2StatusEffects'.default.PoisonEnteredParticle_Name != "")
    {
        PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.PoisonEnteredParticle_Name;
        PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.PoisonEnteredSocket_Name;
        PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.PoisonEnteredSocketsArray_Name;
    }
    PersistentStatChangeEffect.PersistentPerkName = class'X2StatusEffects'.default.PoisonEnteredPerk_Name;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropertyCondition);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue.Damage = `GetConfigInt("M31_PA_EnhancedPoison_DamagePerTurn");
    DamageEffect.EffectDamageValue.Spread = `GetConfigInt("M31_PA_EnhancedPoison_DamagePerTurn_Spread");
    DamageEffect.EffectDamageValue.DamageType = 'Poison';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTypes.AddItem('Poison');
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS; // Issue #89
    PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    PersistentStatChangeEffect.TargetConditions.AddItem(EffectCondition);

    return PersistentStatChangeEffect;
}

static function AddEnhancedPoisonEffectToTarget(out X2AbilityTemplate Template)
{
    Template.AddTargetEffect(CreateEnhancedPoisonedEffect());
    Template.AddTargetEffect(CreatePoisonedEffect());
}

static function AddEnhancedPoisonEffectToMultiTarget(out X2AbilityTemplate Template)
{
    Template.AddMultiTargetEffect(CreateEnhancedPoisonedEffect());
    Template.AddMultiTargetEffect(CreatePoisonedEffect());
}

static function AddBlindingPoisonEffectToTarget(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffectsOnSource   EffectCondition, EffectConditionEnhanced;
    local X2Effect_Blind                    BlindEffect, BlindEffectEnhanced;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"));
    BlindEffect.DamageTypes.AddItem('Poison');
    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    BlindEffect.TargetConditions.AddItem(EffectCondition);
    BlindEffect.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddTargetEffect(BlindEffect);

    BlindEffectEnhanced = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_Poison_Duration"));
    BlindEffectEnhanced.DamageTypes.AddItem('Poison');
    EffectConditionEnhanced = new class'X2Condition_UnitEffectsOnSource';
    EffectConditionEnhanced.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectConditionEnhanced.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    BlindEffectEnhanced.TargetConditions.AddItem(EffectConditionEnhanced);
    BlindEffectEnhanced.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddTargetEffect(BlindEffectEnhanced);
}

static function AddBlindingPoisonEffectToMultiTarget(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffectsOnSource   EffectCondition, EffectConditionEnhanced;
    local X2Effect_Blind                    BlindEffect, BlindEffectEnhanced;
    local X2Condition_UnitProperty          UnitPropertyCondition;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;

    BlindEffect = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_EnhancedPoison_Duration"));
    BlindEffect.DamageTypes.AddItem('Poison');
    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectCondition.AddRequireEffect('M31_PA_EnhancedPoison_Valid', 'AA_MissingRequiredEffect');
    BlindEffect.TargetConditions.AddItem(EffectCondition);
    BlindEffect.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddMultiTargetEffect(BlindEffect);

    BlindEffectEnhanced = class'BitterfrostHelper'.static.CreateBlindEffect(`GetConfigInt("M31_PA_Poison_Duration"));
    BlindEffectEnhanced.DamageTypes.AddItem('Poison');
    EffectConditionEnhanced = new class'X2Condition_UnitEffectsOnSource';
    EffectConditionEnhanced.AddRequireEffect('M31_PA_BlindingPoison_Valid', 'AA_MissingRequiredEffect');
    EffectConditionEnhanced.AddExcludeEffect('M31_PA_EnhancedPoison_Valid', 'AA_AbilityUnavailable');
    BlindEffectEnhanced.TargetConditions.AddItem(EffectConditionEnhanced);
    BlindEffectEnhanced.TargetConditions.AddItem(UnitPropertyCondition);
    Template.AddMultiTargetEffect(BlindEffectEnhanced);
}

static function AddAdjacencyCondition(out X2AbilityTemplate Template)
{
    local X2Condition_UnitProperty                  AdjacencyCondition;

    AdjacencyCondition = new class'X2Condition_UnitProperty';
    AdjacencyCondition.RequireWithinRange = true;
    AdjacencyCondition.WithinRange = 144;
    Template.AbilityTargetConditions.AddItem(AdjacencyCondition);
}

    
static function X2AbilityTemplate CreateAnimSetPassive(name TemplateName, string AnimSetPath)
{
    local X2AbilityTemplate                 Template;
    local X2Effect_AdditionalAnimSets        AnimSetEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    
    AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
    AnimSetEffect.AddAnimSetWithPath(AnimSetPath);
    AnimSetEffect.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(AnimSetEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

static final function int GetActionPoints(const XComGameState_Unit Unit, array<name> AllowedTypes)
{
    local int i, Count;

    for (i = 0; i < Unit.ActionPoints.Length; i++)
    {
        if (AllowedTypes.Find(Unit.ActionPoints[i]) != INDEX_NONE) {
            Count++;
        }
    }
    return Count;
}

// Helpers_LW.uc
static final function bool IsUnitInterruptingEnemyTurn(XComGameState_Unit UnitState)
{
    local XComGameState_BattleData BattleState;

    BattleState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    return BattleState.InterruptingGroupRef == UnitState.GetGroupMembership().GetReference();
}

// Iridar's Perk Pack
// final static function FollowUpShot_BuildVisualization(XComGameState VisualizeGameState)
// {	
// 	local XComGameStateVisualizationMgr		VisMgr;
// 	local XComGameStateContext_Ability		AbilityContext;
// 	local array<X2Action>					FindActions;
// 	local X2Action							FindAction;
// 	local X2Action							ChildAction;
// 	local VisualizationActionMetadata		ActionMetadata;
// 	local X2Action_MarkerNamed				EmptyAction;
// 	local X2Action_ApplyWeaponDamageToTerrain			DamageTerrainAction;
// 	local X2Action_ApplyWeaponDamageToTerrain_NoFlinch	NoFlinchAction;

// 	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

// 	VisMgr = `XCOMVISUALIZATIONMGR;
// 	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());

// 	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToTerrain', FindActions);

// 	foreach FindActions(FindAction)
// 	{
// 		DamageTerrainAction = X2Action_ApplyWeaponDamageToTerrain(FindAction);
// 		ActionMetadata = DamageTerrainAction.Metadata;

// 		NoFlinchAction = X2Action_ApplyWeaponDamageToTerrain_NoFlinch(class'X2Action_ApplyWeaponDamageToTerrain_NoFlinch'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,,, DamageTerrainAction.ParentActions));

// 		foreach DamageTerrainAction.ChildActions(ChildAction)
// 		{
// 			VisMgr.ConnectAction(ChildAction, VisMgr.BuildVisTree, false, NoFlinchAction);
// 		}

// 		// Nuke the original action out of the tree.
// 		EmptyAction = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', AbilityContext));
// 		EmptyAction.SetName("ReplaceDamageTerrainAction");
// 		VisMgr.ReplaceNode(EmptyAction, DamageTerrainAction);
// 	}
// }


final static function FollowUpShot_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local array<X2Action>					FindActions;
	local X2Action							FindAction;
	local X2Action							FireAction;
	local X2Action_MarkerTreeInsertBegin	MarkerStart;
	local X2Action_MarkerTreeInsertEnd		MarkerEnd;
	local X2Action							WaitAction;
	local X2Action							ChildAction;
	local X2Action_MarkerNamed				MarkerAction;
	local array<X2Action>					MarkerActions;
	local array<X2Action>					DamageUnitActions;
	local array<X2Action>					DamageTerrainActions;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local bool								bFoundHistoryIndex;

	VisMgr = `XCOMVISUALIZATIONMGR;
	AbilityContext = XComGameStateContext_Ability(BuildTree.StateChangeContext);
	
	//	Find all Fire Actions in the triggering ability's Vis Tree performed by the unit that used the FollowUpShot.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', FindActions,, AbilityContext.InputContext.SourceObject.ObjectID);
	
	// Find all Damage Unit / Damage Terrain actions in the triggering ability visualization tree that are playing on the primary target of the follow up shot.
	// Damage Terrain actions play the damage flyover for damageable non-unit objects, like Alien Relay.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToUnit', DamageUnitActions,, AbilityContext.InputContext.PrimaryTarget.ObjectID);
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', DamageTerrainActions,, AbilityContext.InputContext.PrimaryTarget.ObjectID);

	// If there are several Fire Actions in the triggering ability tree (e.g. Faceoff), we need to find the right Fire Action that fires at the same target this instance of Follow Up Shot was fired at.
	// This info is not stored in the Fire Action itself, so we find the needed Fire Action by looking at its children Damage Unit / Damage Terrain actions,
	// as well as the visualization index recorded in FollowUpShot's context by its ability trigger.
	foreach FindActions(FireAction)
	{
		if (FireAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{	
			foreach FireAction.ChildActions(ChildAction)
			{
				if (DamageTerrainActions.Find(ChildAction) != INDEX_NONE)
				{
					bFoundHistoryIndex = true;
					break;
				}
				if (DamageUnitActions.Find(ChildAction) != INDEX_NONE)
				{
					bFoundHistoryIndex = true;
					break;
				}
			}
		}

		if (bFoundHistoryIndex)
				break;
	}

	// If we didn't find the correct Fire Action, we call the failsafe Merge Vis Function,
	// which will make both Singe's Target Effects apply seperately after the triggering ability's visualization finishes.
	if (!bFoundHistoryIndex)
	{
		`LOG("WARNING ::" @ GetFuncName() @ "Failed to find the correct Fire Action, using a failsafe.",, 'MeristPerkPack');
		AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
		return;
	}

	// Find the start and end of the FollowUpShot's Vis Tree
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

	// Will need these later to tie the shoelaces.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', MarkerActions);

	//	Add a Wait For Effect Action after the triggering ability's Fire Action. This will allow Singe's Effects to visualize the moment the triggering ability connects with the target.
	ActionMetaData = FireAction.Metadata;
	WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, FireAction);

	//	Insert the Singe's Vis Tree right after the Wait For Effect Action
	VisMgr.ConnectAction(MarkerStart, VisualizationTree, false, WaitAction);

	// Main part of Merge Vis is done, now we just tidy up the ending part. 
	// As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
	// Cycle through Marker Actions we got earlier and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
	foreach MarkerActions(FindAction)
	{
		MarkerAction = X2Action_MarkerNamed(FindAction);

		if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			//	TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
			if (MarkerEnd != none)
			{
				//	"tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are fully visualized.
				VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
			}
			else
			{
				VisMgr.GetAllLeafNodes(BuildTree, FindActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,,, FindActions);
			}
			break;
		}
	}
}

static function EventListenerReturn KillMailListener_Self(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Ability             AbilityState;
    local XComGameStateContext_Ability      AbilityContext;

    SourceUnit = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        if (AbilityState.OwnerStateObject.ObjectID == SourceUnit.ObjectID)
        {
            return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
        }
    }

    return ELR_NoInterrupt;
}