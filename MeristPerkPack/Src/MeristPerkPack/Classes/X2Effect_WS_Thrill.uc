class X2Effect_WS_Thrill extends X2Effect_Persistent config(GameData_SoldierSkills);

var int AimBonusPerStack;
var int CritBonusPerStack;
var int MaxStacks;
var bool bExcludeRobotic;

var name CountValueName;
var config array<name> Thrill_ExcludeCharacterTemplates;
var config array<name> Thrill_ExcludeCharacterGroups;

var localized string strFriendlyName;
var localized string strFriendlyDesc;
var localized string strFriendlyDesc_Stacks;

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager    EventMgr;
    local Object            EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'UnitDied', EffectEventListener_Thrill, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn EffectEventListener_Thrill(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          EffectState;
    local X2Effect_WS_Thrill            Effect;
    local XComGameState_Unit            SourceUnit, TargetUnit;
    local GameRulesCache_VisibilityInfo VisInfo;
    local UnitValue                     CountUnitValue;
    local XComGameState                 NewGameState;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XComGameState_Effect(CallbackData);
        if (EffectState != none)
        {
            Effect = X2Effect_WS_Thrill(EffectState.GetX2Effect());
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            TargetUnit = XComGameState_Unit(EventData);

            if (Effect != none && SourceUnit != none && TargetUnit != none)
            {
                SourceUnit.GetUnitValue(Effect.CountValueName, CountUnitValue);
                if (Effect.MaxStacks <= 0 || CountUnitValue.fValue < Effect.MaxStacks)
                {
                    if (SourceUnit.IsEnemyUnit(TargetUnit) && SourceUnit.IsAbleToAct())
                    {
                        if ((!Effect.bExcludeRobotic || !TargetUnit.IsRobotic())
                            && default.Thrill_ExcludeCharacterGroups.Find(TargetUnit.GetMyTemplate().CharacterGroupName) == INDEX_NONE
                            && default.Thrill_ExcludeCharacterTemplates.Find(TargetUnit.GetMyTemplateName()) == INDEX_NONE)
                        {
                            if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo, GameState.HistoryIndex - 1))
                            {
                                if (VisInfo.bVisibleGameplay)
                                {
                                    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                                    SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
                                    SourceUnit.SetUnitFloatValue(Effect.CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);

                                    NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                                    XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.TriggerAbilityFlyoverVisualizationFn;

                                    `TACTICALRULES.SubmitGameState(NewGameState);
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
    local int Counter;
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    Counter = GetCurrentStacks(Attacker);

    if (Counter != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = Counter * AimBonusPerStack;
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Counter * CritBonusPerStack;
        ShotModifiers.AddItem(CritInfo);
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return GetCurrentStacks(TargetUnit) > 0;
}

function int GetCurrentStacks(XComGameState_Unit UnitState)
{
    local UnitValue CountUnitValue;

    UnitState.GetUnitValue(CountValueName, CountUnitValue);

    return Min(int(CountUnitValue.fValue), MaxStacks);
}

static function string GetFriendlyDescOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameStateHistory  History;
    local XComGameState_Effect  EffectState;
    local X2Effect_WS_Thrill    Effect;
    local XComGameState_Unit    UnitState;
    local string    OutString;
    local int       Count;

    History = `XCOMHISTORY;

    EffectState = XComGameState_Effect(ParseObj);

    if (EffectState != none)
    {
        Effect = X2Effect_WS_Thrill(EffectState.GetX2Effect());
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (Effect != none && UnitState != none)
        {
            Count = Effect.GetCurrentStacks(UnitState);

            OutString = default.strFriendlyDesc_Stacks;

            OutString = Repl(OutString, "[X]", Count * Effect.AimBonusPerStack);
            OutString = Repl(OutString, "[Y]", Count * Effect.CritBonusPerStack);
            OutString = Repl(OutString, "[Z]", Count);

            return OutString;
        }
    }

    return "";
}

defaultproperties
{
    EffectName = M31_PA_WS_Thrill
    DuplicateResponse = eDupe_Ignore

    CountValueName = M31_PA_WS_Thrill_Counter
}