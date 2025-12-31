class X2Effect_WeaponEffect extends X2Effect_Persistent;

var name AttackName;
var array<name> AllowedAbilities;
var bool bApplyToSingleTarget;
var bool bApplyToMultiTarget;
var array<EAbilityHitResult> AllowedHitResults;

// If `true`, requires AbilityTemplate.bAllowAmmoEffects to be `true`
var bool bCountsAsAmmoEffect;
// If `true`, requires AbilityTemplate.bAllowBonusWeaponEffects to be `true`
var bool bCountsAsWeaponEffect;

// If `true`, requires the attack's source weapon and the follow-up ability's source weapon to match
// OR the category of the source weapon should match one of the additional categories
var bool bMatchSourceWeapon;
var array<name> AdditionalWeaponCategories;

var int EventPriority;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetUnit;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_WeaponEffect, ELD_OnStateSubmitted, EventPriority, TargetUnit,, EffectObj);
}

static function EventListenerReturn EffectEventListener_WeaponEffect(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local XComGameState_Unit            OldSourceState, OldTargetState;
    local XComGameState_Ability         AbilityState, AttackAbilityState;
    local StateObjectReference          AttackAbilityRef;
    local XComGameState_Effect          EffectState;
    local XComGameState_Item            SourceWeapon;
    local X2Effect_WeaponEffect         Effect;
    local X2AbilityTemplate             AbilityTemplate;
    local X2AbilityMultiTarget_BurstFire BurstFire;
    local XComGameStateContext          FindContext;
    local int                           VisualizeIndex;
    local bool                          bDealsDamage;
    local bool                          bHit;
    local int                           NumShots;
    local int                           i;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        EffectState = XComGameState_Effect(CallbackData);

        if (SourceUnit != none && AbilityState != none && EffectState != none)
        {
            Effect = X2Effect_WeaponEffect(EffectState.GetX2Effect());

            if (Effect != none)
            {
                if (Effect.AllowedAbilities.Length > 0 && Effect.AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
                {
                    return ELR_NoInterrupt;
                }

                if (AbilityState.SourceWeapon.ObjectID == 0)
                {
                    return ELR_NoInterrupt;
                }

                AbilityTemplate = AbilityState.GetMyTemplate();
                if (AbilityTemplate.Hostility != eHostility_Offensive || AbilityTemplate.bIsASuppressionEffect)
                {
                    return ELR_NoInterrupt;
                }

                if (Effect.bCountsAsAmmoEffect && !AbilityTemplate.bAllowAmmoEffects
                    || Effect.bCountsAsWeaponEffect && !AbilityTemplate.bAllowBonusWeaponEffects)
                {
                    return ELR_NoInterrupt;
                }

                if (Effect.bMatchSourceWeapon)
                {
                    SourceWeapon = AbilityState.GetSourceWeapon();
                    AttackAbilityRef = SourceUnit.FindAbility(Effect.AttackName, SourceWeapon.GetReference());
                    AttackAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AttackAbilityRef.ObjectID));
                    if (AttackAbilityState == none)
                    {
                        if (Effect.AdditionalWeaponCategories.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE)
                        {
                            AttackAbilityRef = SourceUnit.FindAbility(Effect.AttackName);
                            AttackAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AttackAbilityRef.ObjectID));
                        }
                    }
                }
                else
                {
                    AttackAbilityRef = SourceUnit.FindAbility(Effect.AttackName);
                    AttackAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AttackAbilityRef.ObjectID));
                }

                if (AttackAbilityState == none)
                {
                    return ELR_NoInterrupt;
                }

                VisualizeIndex = GameState.HistoryIndex;
                FindContext = AbilityContext;
                while (FindContext.InterruptionHistoryIndex > -1)
                {
                    FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
                    VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
                }

                OldSourceState = XComGameState_Unit(History.GetGameStateForObjectID(SourceUnit.ObjectID,, GameState.HistoryIndex - 1));

                if (Effect.bApplyToSingleTarget)
                {
                    TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

                    if (TargetUnit != none)
                    {
                        bHit = false;
                        if (Effect.AllowedHitResults.Length > 0)
                        {
                            bHit = Effect.AllowedHitResults.Find(AbilityContext.ResultContext.HitResult) != INDEX_NONE;
                        }
                        else
                        {
                            bHit = AbilityContext.IsResultContextHit();
                        }
                        if (bHit && AttackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit, SourceUnit) == 'AA_Success')
                        {
                            OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID,, GameState.HistoryIndex - 1));
                            bDealsDamage = class'M31_Helpers'.static.AbilityDealsDamage(AbilityState, OldSourceState, OldTargetState);
                            if (bDealsDamage)
                            {
                                NumShots = 1;
                                BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
                                if (BurstFire != none)
                                {
                                    NumShots += BurstFire.NumExtraShots;
                                }
                                for (i = 0; i < NumShots; i++)
                                {
                                    AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
                                }
                            }
                        }
                    }
                }
                if (Effect.bApplyToMultiTarget)
                {
                    if (AbilityTemplate.AbilityMultiTargetStyle != none)
                    {
                        BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
                        if (BurstFire == none)
                        {
                            for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
                            {
                                TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[i].ObjectID));

                                if (TargetUnit != none)
                                {
                                    bHit = false;
                                    if (Effect.AllowedHitResults.Length > 0)
                                    {
                                        bHit = Effect.AllowedHitResults.Find(AbilityContext.ResultContext.MultiTargetHitResults[i]) != INDEX_NONE;
                                    }
                                    else
                                    {
                                        bHit = AbilityContext.IsResultContextMultiHit(i);
                                    }
                                    if (bHit && AttackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit, SourceUnit) == 'AA_Success')
                                    {
                                        OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID,, GameState.HistoryIndex - 1));
                                        bDealsDamage = class'M31_Helpers'.static.AbilityDealsDamage(AbilityState, OldSourceState, OldTargetState, true);
                                        if (bDealsDamage)
                                        {
                                            AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.MultiTargets[i], false, VisualizeIndex);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function FollowUpShot_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
    local XComGameStateVisualizationMgr     VisMgr;
    local array<X2Action>                   FindActions;
    local X2Action                          FindAction;
    local X2Action                          FireAction;
    local X2Action_MarkerTreeInsertBegin    MarkerStart;
    local X2Action_MarkerTreeInsertEnd      MarkerEnd;
    local X2Action                          WaitAction;
    local X2Action                          ChildAction;
    local X2Action_MarkerNamed              MarkerAction;
    local array<X2Action>                   MarkerActions;
    local array<X2Action>                   DamageUnitActions;
    local array<X2Action>                   DamageTerrainActions;
    local XComGameStateContext_Ability      AbilityContext;
    local VisualizationActionMetadata       ActionMetadata;
    local bool                              bFoundHistoryIndex;

    VisMgr = `XCOMVISUALIZATIONMGR;
    AbilityContext = XComGameStateContext_Ability(BuildTree.StateChangeContext);
    
    //  Find all Fire Actions in the triggering ability's Vis Tree performed by the unit that used the FollowUpShot.
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

    //  Add a Wait For Effect Action after the triggering ability's Fire Action. This will allow Singe's Effects to visualize the moment the triggering ability connects with the target.
    ActionMetaData = FireAction.Metadata;
    WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext, false, FireAction);

    //  Insert the Singe's Vis Tree right after the Wait For Effect Action
    VisMgr.ConnectAction(MarkerStart, VisualizationTree, false, WaitAction);

    // Main part of Merge Vis is done, now we just tidy up the ending part. 
    // As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
    // Cycle through Marker Actions we got earlier and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
    foreach MarkerActions(FindAction)
    {
        MarkerAction = X2Action_MarkerNamed(FindAction);

        if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
        {
            //  TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
            if (MarkerEnd != none)
            {
                //  "tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are fully visualized.
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

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bApplyToSingleTarget = true
    bApplyToMultiTarget = true
    bMatchSourceWeapon = true
    EventPriority = 40
}
