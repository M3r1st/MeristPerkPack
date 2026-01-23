class X2Effect_ChasingFire extends X2Effect_Persistent dependson(X2Effect_MeristReserveOverwatchPoints);

var bool bOnlyWhenAttackMisses;
var bool bOnlyWhenAttackHits;
var bool bAllowActivationOnSuppression;
var bool bAnyHostileAction;
var int ActivationPercentChance;

var int ActivationsPerTargetPerTurn;
var string TargetCountValueNamePrefix;

var bool bMatchSourceWeapon;
var array<OverwatchAbilityInfo> AbilitiesToActivate;
var int EventPriority;


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_ChasingFire, ELD_OnStateSubmitted, EventPriority,,, EffectObj);
}

function AddAbilityToActivate(name AbiltiyName, optional int Priority = 50)
{
    local OverwatchAbilityInfo NewAbilityToActivate;

    NewAbilityToActivate.AbilityName = AbiltiyName;
    NewAbilityToActivate.Priority = Priority;

    AbilitiesToActivate.AddItem(NewAbilityToActivate);
}

static function EventListenerReturn EffectEventListener_ChasingFire(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            AttackingUnit, CoveringUnit, TargetUnit;
    local XComGameState_Effect          EffectState;
    local X2Effect_ChasingFire          Effect;
    local XComGameState_Ability         EventAbilityState;
    local X2AbilityTemplate             EventAbilityTemplate;
    local int                           RandRoll;
    local UnitValue                     CountUnitValue;
    local name                          CountValueName;

    History = `XCOMHISTORY;

    EffectState = XComGameState_Effect(CallbackData);

    if (EffectState != none)
    {
        AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

        if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
        {
            Effect = X2Effect_ChasingFire(EffectState.GetX2Effect());
            CoveringUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            AttackingUnit = XComGameState_Unit(EventSource);
            TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
            EventAbilityState = XComGameState_Ability(EventData);

            if (Effect != none && CoveringUnit != none && AttackingUnit != none && TargetUnit != none && EventAbilityState != none)
            {
                // The attacker is the owner, is not friendly or the target is not an enemy
                if (AttackingUnit.ObjectID == CoveringUnit.ObjectID || !CoveringUnit.IsFriendlyUnit(AttackingUnit) || !CoveringUnit.IsEnemyUnit(TargetUnit))
                {
                    return ELR_NoInterrupt;
                }
                EventAbilityTemplate = EventAbilityState.GetMyTemplate();
                // The ability is not offensive or doesn't deal damage
                if (!EventAbilityState.IsAbilityInputTriggered()
                    || EventAbilityTemplate.Hostility != eHostility_Offensive
                    || !Effect.bAllowActivationOnSuppression && EventAbilityTemplate.bIsASuppressionEffect
                    || !Effect.bAnyHostileAction && !class'M31_Helpers'.static.AbilityDealsDamage(EventAbilityState, AttackingUnit, TargetUnit))
                {
                    return ELR_NoInterrupt;
                }
                // Is this hit result allowed?
                if (Effect.bOnlyWhenAttackMisses && class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
                    return ELR_NoInterrupt;
                if (Effect.bOnlyWhenAttackHits && class'XComGameStateContext_Ability'.static.IsHitResultMiss(AbilityContext.ResultContext.HitResult))
                    return ELR_NoInterrupt;
                // Has a limit on activations per target per turn
                if (Effect.ActivationsPerTargetPerTurn > 0)
                {
                    CountValueName = name(Effect.TargetCountValueNamePrefix $ CoveringUnit.ObjectID);
                    if (TargetUnit.GetUnitValue(CountValueName, CountUnitValue) && CountUnitValue.fValue >= Effect.ActivationsPerTargetPerTurn)
                    {
                        return ELR_NoInterrupt;
                    }
                }
                // Try random roll
                if (Effect.ActivationPercentChance > 0)
                {
                    RandRoll = `SYNC_RAND_STATIC(100);
                    if (RandRoll >= Effect.ActivationPercentChance)
                    {
                        return ELR_NoInterrupt;
                    }
                }

                Effect.HandleActivation(EffectState, CoveringUnit, TargetUnit, GameState);
            }
        }
    }
    return ELR_NoInterrupt;
}

simulated function HandleActivation(XComGameState_Effect EffectState, XComGameState_Unit CoveringUnit, XComGameState_Unit TargetUnit, XComGameState GameState)
{
    local XComGameStateHistory          History;
    local XComGameState                 NewGameState;
    local StateObjectReference          AbilityRef;
    local XComGameState_Ability         AbilityState;
    local OverwatchAbilityInfo          AbilityInfo;
    local array<OverwatchAbilityInfo>   AbilitiesToActivateSorted;
    local name                          AbilityName;
    local UnitValue                     CountUnitValue;
    local name                          CountValueName;
    History = `XCOMHISTORY;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(default.Class.Name));
    EffectState = XComGameState_Effect(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
    EffectState.GrantsThisTurn++;

    TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
    CountValueName = name(TargetCountValueNamePrefix $ CoveringUnit.ObjectID);
    TargetUnit.GetUnitValue(CountValueName, CountUnitValue);
    TargetUnit.SetUnitFloatValue(CountValueName, CountUnitValue.fValue + 1.0, eCleanup_BeginTurn);

    foreach AbilitiesToActivate(AbilityInfo)
    {
        AbilitiesToActivateSorted.AddItem(AbilityInfo);
    }
    AbilitiesToActivateSorted.Sort(class'X2Effect_MeristReserveOverwatchPoints'.static.SortOverwatchAbilities);

    foreach AbilitiesToActivateSorted(AbilityInfo)
    {
        AbilityName = AbilityInfo.AbilityName;
        if (bMatchSourceWeapon && EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
            AbilityRef = CoveringUnit.FindAbility(AbilityName, EffectState.ApplyEffectParameters.ItemStateObjectRef);
        else
            AbilityRef = CoveringUnit.FindAbility(AbilityName);

        if (AbilityRef.ObjectID != 0)
        {
            AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
            if (AbilityState != none)
            {
                if (AbilityState.CanActivateAbilityForObserverEvent(TargetUnit, CoveringUnit) == 'AA_Success')
                {
                    if (NewGameState != none)
                    {
                        NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                        XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = ChasingFire_BuildVisualization;
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }

                    AbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
                    return;
                }
            }
        }
    }

    if (NewGameState != none)
    {
        History.CleanupPendingGameState(NewGameState);
    }
}

static function ChasingFire_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState_Unit            AbilityOwner;

    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   ActionMetadata;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
    local bool                          bGoodAbility;
    local EWidgetColor                  FlyoverColor;

    History = `XCOMHISTORY;
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Ability', AbilityState)
    {
        break;
    }
    if (AbilityState != none)
    {
        AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        AbilityTemplate = AbilityState.GetMyTemplate();

        if (AbilityOwner != none)
        {
            ActionMetadata = EmptyTrack;
            History.GetCurrentAndPreviousGameStatesForObjectID(AbilityOwner.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,, VisualizeGameState.HistoryIndex);
            ActionMetadata.StateObject_NewState = AbilityOwner;
            ActionMetadata.VisualizeActor = AbilityOwner.GetVisualizer();

            bGoodAbility = AbilityOwner.IsFriendlyToLocalPlayer();
            FlyoverColor = bGoodAbility ? eColor_Good : eColor_Bad;

            SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', FlyoverColor, AbilityTemplate.IconImage, `DEFAULTFLYOVERLOOKATTIME, true);
        }
    }
}

defaultproperties
{
    bAnyHostileAction = true
    bAllowActivationOnSuppression = true
    EventPriority = 60

    TargetCountValueNamePrefix = "M31_ChasingFire_"
}