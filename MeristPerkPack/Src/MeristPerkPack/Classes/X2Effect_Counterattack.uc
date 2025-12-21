class X2Effect_Counterattack extends X2Effect_ChangeResultContextAsTarget;

var bool bOnlyOnEnemyTurn;
var name CountValueName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'PostModifyNewAbilityContext', OnPostModifyNewAbilityContext, ELD_Immediate, EventPriority,,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_Counterattack, ELD_OnStateSubmitted, 51,,, EffectObj);
}

static function EventListenerReturn OnPostModifyNewAbilityContext(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local XComGameState_Unit            Attacker, Defender;
    local X2Effect_Counterattack        Effect;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(EventData);
    AbilityState = XComGameState_Ability(EventSource);
    EffectState = XComGameState_Effect(CallbackObject);

    if (AbilityContext == none || AbilityState == none || EffectState == none)
        return ELR_NoInterrupt;

    Defender = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    Attacker = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

    if (Defender == none || Attacker == none)
        return ELR_NoInterrupt;

    if (AbilityContext.InputContext.PrimaryTarget.ObjectID == Defender.ObjectID)
    {
        Effect = X2Effect_Counterattack(EffectState.GetX2Effect());

        if (Effect != none)
        {
            if (Effect.IsAbilityRelevant(AbilityState, Defender, Attacker, EffectState))
            {
                if (Effect.IsEffectCurrentlyRelevant(EffectState, Defender))
                {
                    if (FindUsableCounterattackAbility(Defender, Attacker) != none)
                    {
                        if (AbilityContext.ResultContext.HitResult != Effect.ChangeHitResults[AbilityContext.ResultContext.HitResult])
                        {
                            AbilityContext.ResultContext.HitResult = Effect.ChangeHitResults[AbilityContext.ResultContext.HitResult];
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn EffectEventListener_Counterattack(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            Attacker, Defender;
    local XComGameState_Ability         AbilityState, CounterattackAbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_Counterattack        Effect;
    local XComGameState                 NewGameState;
    local UnitValue                     CountUnitValue;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    EffectState = XComGameState_Effect(CallbackData);

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        if (AbilityContext.InputContext.PrimaryTarget == EffectState.ApplyEffectParameters.TargetStateObjectRef
            && AbilityContext.ResultContext.HitResult == eHit_CounterAttack)
        {
            Attacker = XComGameState_Unit(EventSource);
            Defender = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            AbilityState = XComGameState_Ability(EventData);
            
            if (Attacker != none && Defender != none && AbilityState != none && EffectState != none)
            {
                Effect = X2Effect_Counterattack(EffectState.GetX2Effect());

                if (Effect != none)
                {
                    if (Effect.IsEffectCurrentlyRelevant(EffectState, Defender))
                    {
                        CounterattackAbilityState = FindUsableCounterattackAbility(Defender, Attacker);
                        if (CounterattackAbilityState != none)
                        {
                            if (Effect.CountValueName != '')
                            {
                                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                                Defender = XComGameState_Unit(NewGameState.ModifyStateObject(Defender.Class, Defender.ObjectID));
                                Defender.GetUnitValue(Effect.CountValueName, CountUnitValue);
                                Defender.SetUnitFloatValue(Effect.CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
                                 `TACTICALRULES.SubmitGameState(NewGameState);
                            }
                            CounterattackAbilityState.AbilityTriggerAgainstSingleTarget(Attacker.GetReference(), false);
                            return ELR_NoInterrupt;
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    if (class'M31_Helpers'.static.IsUnitInterruptingEnemyTurn(TargetUnit))
    {
        return false;
    }

    if (bOnlyOnEnemyTurn && `TACTICALRULES.GetUnitActionTeam() == TargetUnit.GetTeam())
    {
        return false;
    }

    return true;
}

function bool IsAbilityRelevant(XComGameState_Ability AbilityState, XComGameState_Unit Defender, XComGameState_Unit Attacker, XComGameState_Effect EffectState)
{
    return AbilityState.IsMeleeAbility();
}

static function XComGameState_Ability FindUsableCounterattackAbility(XComGameState_Unit Defender, XComGameState_Unit Attacker)
{
    local XComGameStateHistory  History;
    local XComGameState_Ability AbilityState;
    local StateObjectReference  AbilityRef;

    History = `XCOMHISTORY;

    foreach Defender.Abilities(AbilityRef)
    {
        AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
        if (IsCounterattackAbility(AbilityState))
        {
            if (AbilityState.CanActivateAbilityForObserverEvent(Attacker, Defender) == 'AA_Success')
            {
                return AbilityState;
            }
        }
    }

    return none;
}

static function bool IsCounterattackAbility(XComGameState_Ability AbilityState)
{
    local X2AbilityTemplate             AbilityTemplate;
    local X2AbilityCost                 AbilityCost;
    local X2AbilityCost_ActionPoints    ActionPointCost;

    AbilityTemplate = AbilityState.GetMyTemplate();
    
    foreach AbilityTemplate.AbilityCosts(AbilityCost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
        if (ActionPointCost != none)
        {
            if (ActionPointCost.AllowedTypes.Find(class'X2CharacterTemplateManager'.default.CounterattackActionPoint) != INDEX_NONE)
            {
                return true;
            }
        }
    }

    return false;
}

static function AddCounterattackActionPointCost(out X2AbilityTemplate Template)
{
    local X2AbilityCost_ActionPoints ActionPointCost;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 0;
    ActionPointCost.bConsumeAllPoints = false;
    ActionPointCost.AllowedTypes.Length = 0;
    ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);

    Template.AbilityCosts.AddItem(ActionPointCost);
}


static function CounterAttack_MergeVisualization_MrNice(X2Action BuildTree, out X2Action VisualizationTree)
{
    local XComGameStateVisualizationMgr         VisMgr;
    local X2Action_MarkerTreeInsertBegin        MarkerStart;
    local X2Action_MarkerTreeInsertEnd          MarkerEnd;
    local X2Action_ApplyWeaponDamageToUnit      ApplyDamage;
    local XComGameStateContext_Ability          Context;
    local Array<X2Action>                       FoundActions;
    local X2Action                              FoundAction;
    local X2Action                              FireAction;
    local X2Action                              ExitCoverAction;
    local X2Action                              EnterCoverAction;
    local X2Action                              DeathAction;
    local X2Action_MarkerNamed                  FireReplace;
    local X2Action_MarkerNamed                  ExitReplace;
    local X2Action_MarkerNamed                  EnterReplace;
    local X2Action                              Action;
    local VisualizationActionMetadata           Metadata;
    // local X2Action_MoveTurn                     MoveTurnAction;
    // local XComGameState_Unit                    CounteredUnit;

    VisMgr = `XCOMVISUALIZATIONMGR;

    MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
    MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));
    Context = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

    //  Make the Countering unit always face the Countered unit (this doesn't always happen automatically) -- not sure it actually works
    //CounteredUnit = XComGameState_Unit(MarkerStart.StateChangeContext.AssociatedState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
    //Metadata = MarkerStart.Metadata;
    //MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(Metadata, Context, false, MarkerStart));
    //MoveTurnAction.m_vFacePoint =  `XWORLD.GetPositionFromTileCoordinates(CounteredUnit.TileLocation);
    //MoveTurnAction.UpdateAimTarget = true;

    //Find the apply weapon damage relevant to this counterattack
    VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToUnit', FoundActions, , Context.InputContext.SourceObject.ObjectID);
    if (FoundActions.Length > 0)
    {	
        ApplyDamage = X2Action_ApplyWeaponDamageToUnit(FoundActions[0]);

        DeathAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_Death');
        if (DeathAction != none)
        {
            FoundActions.Length = 0;
            if (ApplyDamage.ParentActions[0].HasChildOfType(class'X2Action_EnterCover', FoundActions))
            {
                X2Action_EnterCover(FoundActions[0]).bSkipEnterCover = true;
            }
        }

        FireAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_Fire');
        if (FireAction != none)
        {
            FireReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', MarkerStart.StateChangeContext));
            FireReplace.SetName("FireActionCounterAttackStub");
            VisMgr.ReplaceNode(FireReplace, FireAction);
        }
        
        ExitCoverAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_ExitCover');
        if (ExitCoverAction != none)
        {
            ExitReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', MarkerStart.StateChangeContext));
            ExitReplace.SetName("ExitActionCounterAttackStub");
            VisMgr.ReplaceNode(ExitReplace, ExitCoverAction);
        }

        EnterCoverAction = VisMgr.GetNodeOfType(BuildTree, class'X2Action_EnterCover');
        if (EnterCoverAction != none)
        {
            EnterReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', MarkerStart.StateChangeContext));
            EnterReplace.SetName("EnterActionCounterAttackStub");
            VisMgr.ReplaceNode(EnterReplace, EnterCoverAction);
        }

        //EnterCoverAction = VisMgr.GetNodeOfType(VisualizationTree, class'X2Action_EnterCover',, Context.InputContext.PrimaryTarget.ObjectID);

        //  Nuke all X2Action_ApplyWeaponDamageToTerrain in both trees. They happen when the attack doesn't reach its target (Counter-attacked aiblity will always cause this)
        //  While the Counterattack itself will cause this if it misses. These actions cause both participants to flinch, interrupting proper animatitions.
        VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', FoundActions, , Context.InputContext.PrimaryTarget.ObjectID);
        foreach FoundActions(FoundAction)
        {
            EnterReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', FoundAction.StateChangeContext));
            EnterReplace.SetName("ApplyDamageTerrainStub");
            VisMgr.ReplaceNode(EnterReplace, FoundAction);
        }

        VisMgr.GetNodesOfType(BuildTree, class'X2Action_ApplyWeaponDamageToTerrain', FoundActions);
        foreach FoundActions(FoundAction)
        {
            EnterReplace = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', FoundAction.StateChangeContext));
            EnterReplace.SetName("ApplyDamageTerrainStub");
            VisMgr.ReplaceNode(EnterReplace, FoundAction);
        }
        
        VisMgr.InsertSubtree(MarkerStart, MarkerEnd, ApplyDamage);
        //VisMgr.ConnectAction(EnterCoverAction, VisualizationTree,, MarkerEnd);

        Metadata = ApplyDamage.Metadata;
        Action = class'X2Action_WaitForFinishAnim'.static.AddToVisualizationTree(MetaData, ApplyDamage.StateChangeContext, false, ApplyDamage);
        VisMgr.ConnectAction(MarkerEnd, VisualizationTree,, Action);
    }
}

defaultproperties
{
    EffectName = M31_Counterattack
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_Counterattack_Counter

    ChangeHitResults[eHit_Graze] = eHit_CounterAttack
    ChangeHitResults[eHit_Miss] = eHit_CounterAttack

    EventPriority = 45
}