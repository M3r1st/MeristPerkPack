class X2Effect_PassiveWeaponEffect extends X2Effect_Persistent;

var name AttackName;
var array<name> AllowedAbilities;
var bool bApplyToSingleTarget;
var bool bApplyToMultiTarget;
var bool bCountsAsAmmoEffect;
var bool bCountsAsWeaponEffect;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    SourceUnitState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_WeaponEffect2, ELD_OnStateSubmitted, 40, SourceUnitState,, EffectObj);
}

// static function EventListenerReturn AbilityTriggerEventListener_WeaponEffect(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
// {
//     local XComGameStateContext_Ability		AbilityContext;
//     local XComGameState_Ability				AbilityState, AttackAbilityState;
//     local XComGameState_Unit				SourceUnit, TargetUnit;
//     local XComGameState_Effect				EffectState;
//     local XComGameStateContext				FindContext;
//     local int								VisualizeIndex;
//     local XComGameStateHistory				History;
//     local X2AbilityTemplate					AbilityTemplate;
//     local X2Effect							Effect;
//     local X2Effect_PassiveWeaponEffect		WeaponEffect;
//     local X2AbilityMultiTarget_BurstFire	BurstFire;
//     local bool		bDealsDamage;
//     local int		NumShots;
//     local int		i;
//     local name		AttackAbilityName;

//     History = `XCOMHISTORY;
    
//     AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
//     TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

//     SourceUnit = XComGameState_Unit(EventSource);

//     AbilityState = XComGameState_Ability(EventData);
//     AbilityTemplate = AbilityState.GetMyTemplate();

//     EffectState = XComGameState_Effect(CallbackData);
//     WeaponEffect = X2Effect_PassiveWeaponEffect(EffectState.GetX2Effect());
//     AttackAbilityName = WeaponEffect.AttackName;

//     if (WeaponEffect.AllowedAbilities.Length > 0 && WeaponEffect.AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == -1)
//     {
//         // `LOG("    Ability is not allowed: " $ "<" $ AbilityState.GetMyTemplateName() $ ">");
//         return ELR_NoInterrupt;
//     }

//     if (AbilityState != none && SourceUnit != none && TargetUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
//     {
//         AttackAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility(AttackAbilityName, AbilityContext.InputContext.ItemObject).ObjectID));
//         if (AttackAbilityState != none && AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive())
//         {
//             foreach AbilityTemplate.AbilityTargetEffects(Effect)
//             {
//                 if (X2Effect_ApplyWeaponDamage(Effect) != none)
//                 {
//                     bDealsDamage = true;
//                     break;
//                 }
//             }
//             if (bDealsDamage)
//             {
//                 NumShots = 1;
//                 BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
//                 if (BurstFire != none)
//                 {
//                     NumShots += BurstFire.NumExtraShots;
//                 }
//                 for (i = 0; i < NumShots; i++)
//                 {
//                     VisualizeIndex = GameState.HistoryIndex;
//                     FindContext = AbilityContext;
//                     while (FindContext.InterruptionHistoryIndex > -1)
//                     {
//                         FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
//                         VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
//                     }
//                     // `LOG("    Triggering ability: " $ "<" $ AttackAbilityState.GetMyTemplateName() $ ">");
//                     AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
//                 }
//             }
//         }
//     }
//     return ELR_NoInterrupt;
// }

static function EventListenerReturn AbilityTriggerEventListener_WeaponEffect2(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit, TargetUnit;
    local XComGameState_Ability             AbilityState, AttackAbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local X2Effect_PassiveWeaponEffect      WeaponEffect;
    local X2Effect                          Effect;
    local X2AbilityMultiTarget_BurstFire    BurstFire;
    local int                               VisualizeIndex;
    local XComGameStateContext              FindContext;
    local bool      bDealsDamage;
    local int       NumShots;
    local int       i, k;

    History = `XCOMHISTORY;
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    
    SourceUnit = XComGameState_Unit(EventSource);

    AbilityState = XComGameState_Ability(EventData);
    AbilityTemplate = AbilityState.GetMyTemplate();

    WeaponEffect = X2Effect_PassiveWeaponEffect(XComGameState_Effect(CallbackData).GetX2Effect());

    if (SourceUnit == none || AbilityState == none || AbilityTemplate == none || WeaponEffect == none || AbilityContext.InputContext.ItemObject.ObjectID == 0)
        return ELR_NoInterrupt;

    if (WeaponEffect.AllowedAbilities.Length > 0 && WeaponEffect.AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE ||
        AbilityTemplate.Hostility != eHostility_Offensive)
        return ELR_NoInterrupt;

    if (WeaponEffect.bCountsAsAmmoEffect && !AbilityTemplate.bAllowAmmoEffects ||
        WeaponEffect.bCountsAsWeaponEffect && !AbilityTemplate.bAllowBonusWeaponEffects)
        return ELR_NoInterrupt;

    AttackAbilityState = XComGameState_Ability(
        History.GetGameStateForObjectID(SourceUnit.FindAbility(WeaponEffect.AttackName, AbilityContext.InputContext.ItemObject).ObjectID));

    if (AttackAbilityState == none)
        return ELR_NoInterrupt;

    if (WeaponEffect.bApplyToSingleTarget)
    {
        TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

        if (TargetUnit != none)
        {
            if (AbilityContext.IsResultContextHit() && TargetUnit.IsAlive())
            {
                foreach AbilityTemplate.AbilityTargetEffects(Effect)
                {
                    if (X2Effect_ApplyWeaponDamage(Effect) != none)
                    {
                        bDealsDamage = true;
                        break;
                    }
                }
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
                        VisualizeIndex = GameState.HistoryIndex;
                        FindContext = AbilityContext;
                        while (FindContext.InterruptionHistoryIndex > -1)
                        {
                            FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
                            VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
                        }
                        AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
                    }
                }
            }
        }
    }

    if (WeaponEffect.bApplyToMultiTarget)
    {
        if (AbilityTemplate.AbilityMultiTargetStyle != none)
        {
            BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
            if (BurstFire == none)
            {
                for (k = 0; k < AbilityContext.InputContext.MultiTargets.Length; k++)
                {
                    TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[k].ObjectID));

                    if (TargetUnit != none)
                    {
                        if (AbilityContext.IsResultContextMultiHit(k) && TargetUnit.IsAlive())
                        {
                            foreach AbilityTemplate.AbilityTargetEffects(Effect)
                            {
                                if (X2Effect_ApplyWeaponDamage(Effect) != none)
                                {
                                    bDealsDamage = true;
                                    break;
                                }
                            }
                            if (bDealsDamage)
                            {
                                VisualizeIndex = GameState.HistoryIndex;
                                FindContext = AbilityContext;
                                while (FindContext.InterruptionHistoryIndex > -1)
                                {
                                    FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
                                    VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
                                }
                                AttackAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.MultiTargets[k], false, VisualizeIndex);
                            }
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

// function WeaponEffect_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
// {
//     local XComGameStateVisualizationMgr		VisMgr;
//     local array<X2Action>					arrActions;
//     local X2Action_MarkerTreeInsertBegin	MarkerStart;
//     local X2Action_MarkerTreeInsertEnd		MarkerEnd;
//     local X2Action							WaitAction;
//     local X2Action_MarkerNamed				MarkerAction;
//     local XComGameStateContext_Ability		AbilityContext;
//     local VisualizationActionMetadata		ActionMetadata;
//     local bool bFoundHistoryIndex;
//     local int i;

//     VisMgr = `XCOMVISUALIZATIONMGR;
    
//     MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
//     AbilityContext = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

//     VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', arrActions);

//     for (i = 0; i < arrActions.Length; i++)
//     {
//         if (arrActions[i].StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
//         {
//             bFoundHistoryIndex = true;
//             break;
//         }
//     }
//     if (!bFoundHistoryIndex)
//     {
//         AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
//         return;
//     }

//     AbilityContext = XComGameStateContext_Ability(arrActions[i].StateChangeContext);
//     ActionMetaData = arrActions[i].Metadata;
//     WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext,, arrActions[i]);

//     VisMgr.ConnectAction(MarkerStart, VisualizationTree,, WaitAction);

//     VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions);

//     for (i = 0; i < arrActions.Length; i++)
//     {
//         MarkerAction = X2Action_MarkerNamed(arrActions[i]);

//         if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
//         {
//             MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

//             if (MarkerEnd != none)
//             {
//                 VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
//                 VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
//             }
//             else
//             {
//                 VisMgr.GetAllLeafNodes(BuildTree, arrActions);
//                 VisMgr.ConnectAction(MarkerAction, BuildTree,,, arrActions);
//             }
//             break;
//         }
//     }
// }

DefaultProperties
{
    DuplicateResponse = eDupe_Ignore
    bApplyToSingleTarget = true
    bApplyToMultiTarget = true
}
