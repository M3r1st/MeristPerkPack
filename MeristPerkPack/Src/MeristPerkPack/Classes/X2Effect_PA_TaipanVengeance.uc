class X2Effect_PA_TaipanVengeance extends X2Effect_Persistent;

var privatewrite bool bLog;

var int AimBonus;
var int AimBonusHit;
var int CritBonus;
var int CritBonusHit;
var int AllyBonusModifierPrc;
var bool bTreatBondmateAsSelf;
var bool bRequireVisibility;
var bool bAnyHostileAction;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', AbilityTriggerEventListener_TaipanVengeance, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_TaipanVengeance(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XCGS_Effect_PA_TaipanVengeance    EffectState;
    local X2Effect_PA_TaipanVengeance       Effect;
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Ability             AbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local XComGameState_Unit                EffectSourceUnit, AbilitySourceUnit, UnitState;
    local StateObjectReference              BondmateRef;
    local XComGameState                     NewGameState;
    local GameRulesCache_VisibilityInfo     VisInfo;
    local bool bSelfTarget, bSelfTargetHit, bAllyTarget, bAllyTargetHit;
    local bool bCanSeeTheAttacker, bCanSeeTheTarget;
    local bool bDealsDamage;
    local bool bHasSoldierBond;
    local int Index;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    `LOG("Start 1", default.bLog, GetFuncName());
    if (AbilityContext == none || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
        return ELR_NoInterrupt;

    EffectState = XCGS_Effect_PA_TaipanVengeance(CallbackData);
    Effect = X2Effect_PA_TaipanVengeance(EffectState.GetX2Effect());
    AbilityState = XComGameState_Ability(EventData);
    AbilitySourceUnit = XComGameState_Unit(EventSource);
    EffectSourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    `LOG("Start 2", default.bLog, GetFuncName());
    if (EffectState == none || Effect ==  none || AbilityState == none || AbilitySourceUnit == none || EffectSourceUnit == none)
        return ELR_NoInterrupt; 

    AbilityTemplate = AbilityState.GetMyTemplate();

    `LOG("Validating Ability", default.bLog, GetFuncName());

    bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);
    if (AbilityTemplate.Hostility != eHostility_Offensive || !(Effect.bAnyHostileAction || bDealsDamage && !AbilityTemplate.bIsASuppressionEffect))
        return ELR_NoInterrupt;
        
    if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(EffectSourceUnit.ObjectID, AbilitySourceUnit.ObjectID, VisInfo, AbilityContext.AssociatedState.HistoryIndex))
    {
        if (VisInfo.bVisibleGameplay)
        {
            `LOG("Can see the attacker", default.bLog, GetFuncName());
            bCanSeeTheAttacker = true;
        }
    }

    if (Effect.bTreatBondmateAsSelf)
        bHasSoldierBond = EffectSourceUnit.HasSoldierBond(BondmateRef);

    if (AbilityContext.InputContext.PrimaryTarget.ObjectID == EffectSourceUnit.ObjectID)
    {
        bSelfTarget = true;
        bSelfTargetHit = class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult);
        bCanSeeTheTarget = true;
        `LOG("The source is the target", default.bLog, GetFuncName());
    }
    else
    {
        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
        if (UnitState != none && EffectSourceUnit.IsFriendlyUnit(UnitState))
        {
            if (!bCanSeeTheTarget)
            {
                if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(EffectSourceUnit.ObjectID, UnitState.ObjectID, VisInfo, AbilityContext.AssociatedState.HistoryIndex))
                {
                    if (VisInfo.bVisibleGameplay)
                    {
                        bCanSeeTheTarget = true;
                        `LOG("Can see the target", default.bLog, GetFuncName());
                    }
                }
            }
            if (Effect.bTreatBondmateAsSelf && bHasSoldierBond && UnitState.ObjectID == BondmateRef.ObjectID)
            {
                bSelfTarget = true;
                bSelfTargetHit = class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult);
                `LOG("The bondmate is the target", default.bLog, GetFuncName());
            }
            else
            {
                bAllyTarget = true;
                bAllyTargetHit = class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult);
                `LOG("An ally is the target", default.bLog, GetFuncName());
            }
        }
    }


    for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
    {
        if (AbilityContext.InputContext.MultiTargets[Index].ObjectID == EffectSourceUnit.ObjectID)
        {
            bSelfTarget = true;
            bSelfTargetHit = class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult);
            bCanSeeTheTarget = true;
            `LOG("The source is the target", default.bLog, GetFuncName());
        }
        else
        {
            UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[Index].ObjectID));
            if (UnitState != none && EffectSourceUnit.IsFriendlyUnit(UnitState))
            {
                if (!bCanSeeTheTarget)
                {
                    if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(EffectSourceUnit.ObjectID, UnitState.ObjectID, VisInfo, AbilityContext.AssociatedState.HistoryIndex))
                    {
                        if (VisInfo.bVisibleGameplay)
                        {
                            bCanSeeTheTarget = true;
                            `LOG("Can see the target", default.bLog, GetFuncName());
                        }
                    }
                }
                if (Effect.bTreatBondmateAsSelf && bHasSoldierBond && UnitState.ObjectID == BondmateRef.ObjectID)
                {
                    bSelfTarget = true;
                    bSelfTargetHit = class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.MultiTargetHitResults[Index]);
                    `LOG("The bondmate is the target", default.bLog, GetFuncName());
                    break;
                }
                else
                {
                    bAllyTarget = true;
                    bAllyTargetHit = class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.MultiTargetHitResults[Index]);
                    `LOG("An ally is the target", default.bLog, GetFuncName());
                    break;
                }
            }
        }
    }

    if (!Effect.bRequireVisibility || bCanSeeTheAttacker || bCanSeeTheTarget)
    {
        if (bSelfTarget || bAllyTarget)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
            
            EffectState = XCGS_Effect_PA_TaipanVengeance(NewGameState.ModifyStateObject(class'XCGS_Effect_PA_TaipanVengeance', EffectState.ObjectID));

            if (bSelfTarget)
            {
                `LOG("Self bonus", default.bLog, GetFuncName());
                if (bSelfTargetHit)
                    EffectState.AddToHitBonus(AbilitySourceUnit.ObjectID, Effect.AimBonusHit, Effect.CritBonusHit);
                else
                    EffectState.AddToHitBonus(AbilitySourceUnit.ObjectID, Effect.AimBonus, Effect.CritBonus);
            }
            else if (bAllyTarget)
            {
                `LOG("Ally bonus", default.bLog, GetFuncName());
                if (bAllyTargetHit)
                    EffectState.AddToHitBonus(AbilitySourceUnit.ObjectID,
                        Effect.AimBonusHit * Effect.AllyBonusModifierPrc / 100, Effect.CritBonusHit * Effect.AllyBonusModifierPrc / 100);
                else
                    EffectState.AddToHitBonus(AbilitySourceUnit.ObjectID,
                        Effect.AimBonus * Effect.AllyBonusModifierPrc / 100, Effect.CritBonus * Effect.AllyBonusModifierPrc / 100);
            }

            `TACTICALRULES.SubmitGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local XCGS_Effect_PA_TaipanVengeance VengeanceEffectState;
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    local int OutAimBonus;
    local int OutCritBonus;

    VengeanceEffectState = XCGS_Effect_PA_TaipanVengeance(EffectState);

    if (VengeanceEffectState != none)
    {
        if (VengeanceEffectState.GetToHitBonus(Target.ObjectID, OutAimBonus, OutCritBonus))
        {
            AimInfo.ModType = eHit_Success;
            AimInfo.Reason = FriendlyName;
            AimInfo.Value = OutAimBonus;
            ShotModifiers.AddItem(AimInfo);

            CritInfo.ModType = eHit_Crit;
            CritInfo.Reason = FriendlyName;
            CritInfo.Value = OutCritBonus;
            ShotModifiers.AddItem(CritInfo);
        }
    }
}

defaultproperties
{
    EffectName = M31_PA_TaipanVengeance
    DuplicateResponse = eDupe_Ignore
    GameStateEffectClass = class'XCGS_Effect_PA_TaipanVengeance'

    bLog = false
}
