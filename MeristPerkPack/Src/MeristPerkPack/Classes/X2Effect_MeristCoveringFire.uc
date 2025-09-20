class X2Effect_MeristCoveringFire extends X2Effect_CoveringFire dependson(X2Effect_MeristReserveOverwatchPoints);

var private name AbilityToActivate;

var bool bDirectAttackOnly_AllowMultiTarget;
var bool bOnlyWhenAttackHits;
var bool bAnyHostileAction;

var bool bMatchSourceWeapon;
var array<OverwatchAbilityInfo> AbilitiesToActivate;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', NewCoveringFireCheck, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn NewCoveringFireCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateHistory          History;

    local XComGameState_Unit            AttackingUnit, CoveringUnit;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          CoveringFireEffectState;
    local X2Effect_MeristCoveringFire   CoveringFireEffect;
    local XComGameState_Ability         EventAbilityState;
    local X2AbilityTemplate             EventAbilityTemplate;

    local bool                          bIsDirectAttack;
    local int                           RandRoll;
    local int                           Index;

    local StateObjectReference          AbilityRef;
    local XComGameState_Ability         AbilityState;
    local OverwatchAbilityInfo          AbilityInfo;
    local array<OverwatchAbilityInfo>   AbilitiesToActivateSorted;
    local name                          AbilityName;
    local bool                          bCanUseAbility;
    local X2AbilityCost                 Cost;

    local XComGameState                 NewGameState;    

    CoveringFireEffectState = XComGameState_Effect(CallbackData);

    if (CoveringFireEffectState != none)
    {
        AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
        CoveringFireEffect = X2Effect_MeristCoveringFire(CoveringFireEffectState.GetX2Effect());
        CoveringUnit = XComGameState_Unit(History.GetGameStateForObjectID(CoveringFireEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        AttackingUnit = XComGameState_Unit(EventSource);
        EventAbilityState = XComGameState_Ability(EventData);

        if (AbilityContext != none && CoveringFireEffect != none && CoveringUnit != none && AttackingUnit != none && EventAbilityState != none)
        {
            EventAbilityTemplate = EventAbilityState.GetMyTemplate();
            if (EventAbilityState.GetMyTemplate().Hostility != eHostility_Offensive
                || !(CoveringFireEffect.bAnyHostileAction
                || EventAbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState) && !EventAbilityTemplate.bIsASuppressionEffect))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.bOnlyDuringEnemyTurn && `TACTICALRULES.GetUnitActionTeam() == CoveringUnit.GetTeam())
                return ELR_NoInterrupt;

            if (CoveringFireEffect.bPreEmptiveFire)
            {
                //  for pre emptive fire, only process during the interrupt step
                if (AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
                    return ELR_NoInterrupt;
            }
            else
            {
                //  for non-pre emptive fire, don't process during the interrupt step
                if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
                    return ELR_NoInterrupt;
            }

            if (CoveringFireEffect.ActivationPercentChance > 0)
            {
                RandRoll = `SYNC_RAND_STATIC(100);
                if (RandRoll >= CoveringFireEffect.ActivationPercentChance)
                {
                    return ELR_NoInterrupt;
                }
            }

            bIsDirectAttack = AbilityContext.InputContext.PrimaryTarget.ObjectID == CoveringUnit.ObjectID;
            if (CoveringFireEffect.bDirectAttackOnly && !bIsDirectAttack)
            {
                if (CoveringFireEffect.bDirectAttackOnly_AllowMultiTarget)
                {
                    for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
                    {
                        if (AbilityContext.InputContext.MultiTargets[Index].ObjectID == CoveringUnit.ObjectID)
                        {
                            bIsDirectAttack = true;
                        }
                    }
                }
                
                if (!bIsDirectAttack)
                    return ELR_NoInterrupt;
            }
                
            if (CoveringFireEffect.bOnlyWhenAttackMisses && class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.bOnlyWhenAttackHits && class'XComGameStateContext_Ability'.static.IsHitResultMiss(AbilityContext.ResultContext.HitResult))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.GrantActionPoint != ''
                && (CoveringFireEffect.MaxPointsPerTurn > CoveringFireEffectState.GrantsThisTurn || CoveringFireEffect.MaxPointsPerTurn <= 0))
            {
                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                CoveringFireEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(CoveringFireEffectState.Class, CoveringFireEffectState.ObjectID));
                CoveringFireEffectState.GrantsThisTurn++;

                CoveringUnit = XComGameState_Unit(NewGameState.ModifyStateObject(CoveringUnit.Class, CoveringUnit.ObjectID));
                CoveringUnit.ReserveActionPoints.AddItem(CoveringFireEffect.GrantActionPoint);
            }

            foreach CoveringFireEffect.AbilitiesToActivate(AbilityInfo)
            {
                AbilitiesToActivateSorted.AddItem(AbilityInfo);
            }
            AbilitiesToActivateSorted.Sort(class'X2Effect_MeristReserveOverwatchPoints'.static.SortOverwatchAbilities);

            foreach AbilitiesToActivateSorted(AbilityInfo)
            {
                AbilityName = AbilityInfo.AbilityName;
                if (CoveringFireEffect.bMatchSourceWeapon && CoveringFireEffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
                    AbilityRef = CoveringUnit.FindAbility(AbilityName, CoveringFireEffectState.ApplyEffectParameters.ItemStateObjectRef);
                else
                    AbilityRef = CoveringUnit.FindAbility(AbilityName);

                if (AbilityRef.ObjectID != 0)
                {
                    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
                    if (AbilityState != none)
                    {
                        if (CoveringFireEffect.bSelfTargeting && AbilityState.CanActivateAbilityForObserverEvent(CoveringUnit) == 'AA_Success')
                        {
                            `TACTICALRULES.SubmitGameState(NewGameState);
                            AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), CoveringFireEffect.bUseMultiTargets);
                            return ELR_NoInterrupt;
                        }
                        else if (AbilityState.CanActivateAbilityForObserverEvent(AttackingUnit) == 'AA_Success')
                        {
                            `TACTICALRULES.SubmitGameState(NewGameState);
                            if (CoveringFireEffect.bUseMultiTargets)
                            {
                                AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), true);
                            }
                            else
                            {
                                AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, AttackingUnit.ObjectID);
                                if (AbilityContext.Validate())
                                {
                                    `TACTICALRULES.SubmitGameStateContext(AbilityContext);
                                }
                            }
                            return ELR_NoInterrupt;
                        }
                    }
                }
            }
            History.CleanupPendingGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    bAnyHostileAction = true
}