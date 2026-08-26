class X2Effect_PersistentAuraWithStats extends X2Effect_ModifyStats abstract;

var float Radius;
var bool bIncludeOwner;
var bool bIncludeFriendly;
var bool bIncludeHostile;
var bool bIsUnique;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

var name UnApplyFromStatsEventName;
var name OnEffectRemovedEventName;
var name UpdateEventName;

var protected array<StatChange> m_aStatChanges;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit, TargetUnit;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    History = `XCOMHISTORY;

    EffectObj = EffectGameState;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    If (SourceUnit.ObjectID != TargetUnit.ObjectID)
    {

        EventMgr.RegisterForEvent(EffectObj, 'MindControlled', UpdateStats_OSS, ELD_OnStateSubmitted, 20, TargetUnit,, EffectObj);
        EventMgr.RegisterForEvent(EffectObj, 'UnitMoveFinished', UpdateStats_OSS, ELD_OnStateSubmitted, 20, TargetUnit,, EffectObj);
        EventMgr.RegisterForEvent(EffectObj, 'UnitDied', UpdateStats_OSS, ELD_OnStateSubmitted, 20, TargetUnit,, EffectObj);

        if (OnEffectRemovedEventName != '')
            EventMgr.RegisterForEvent(EffectObj, OnEffectRemovedEventName, UpdateStats_OSS, ELD_OnStateSubmitted, 15, TargetUnit,, EffectObj);

        if (UnApplyFromStatsEventName != '')
            EventMgr.RegisterForEvent(EffectObj, UnApplyFromStatsEventName, UpdateStats_OSS, ELD_OnStateSubmitted, 10, TargetUnit,, EffectObj);
    }

    EventMgr.RegisterForEvent(EffectObj, UpdateEventName, UpdateStats_Immediate, ELD_Immediate, 20, SourceUnit,, EffectObj);
}

static function EventListenerReturn UpdateStats_OSS(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XCGS_Effect_PersistentAura    EffectState;
    local XComGameState_Unit            TargetUnit;
    local XComGameState                 NewGameState;

    History = `XCOMHISTORY;

    EffectState = XCGS_Effect_PersistentAura(CallbackData);
    if (EffectState != none)
    {
        TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (TargetUnit != none)
        {
            if (EffectState.ShouldUpdateStats(TargetUnit, GameState))
            {
                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update" $ EffectState.GetX2Effect().EffectName);
                EffectState = XCGS_Effect_PersistentAura(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
                EffectState.UpdateStats(TargetUnit, NewGameState);
                `TACTICALRULES.SubmitGameState(NewGameState);
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn UpdateStats_Immediate(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XCGS_Effect_PersistentAura    EffectState;
    local XComGameState_Unit            TargetUnit, OldTargetState;

    if (NewGameState != none)
    {
        History = `XCOMHISTORY;

        EffectState = XCGS_Effect_PersistentAura(CallbackData);
        if (EffectState != none)
        {
            TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            if (TargetUnit == none)
                OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            if (OldTargetState != none)
            {
                if (EffectState.ShouldUpdateStats(OldTargetState, NewGameState))
                {
                    EffectState = XCGS_Effect_PersistentAura(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                    TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
                    EffectState.UpdateStats(TargetUnit, NewGameState);
                }
            }
            else if (TargetUnit != none)
            {
                if (EffectState.ShouldUpdateStats(TargetUnit, NewGameState))
                {
                    EffectState = XCGS_Effect_PersistentAura(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                    EffectState.UpdateStats(TargetUnit, NewGameState);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, optional EStatModOp InModOp=MODOP_Addition )
{
    local StatChange NewChange;
    
    NewChange.StatType = StatType;
    NewChange.StatAmount = StatAmount;
    NewChange.ModOp = InModOp;

    m_aStatChanges.AddItem(NewChange);
}

function array<StatChange> GetStatChanges(const out XComGameState_Effect EffectState, const out XComGameState GameState)
{
    return m_aStatChanges;
}

function bool IsUniqueModifier()
{
    return bIsUnique;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XCGS_Effect_PersistentAura    AuraEffectState;

    AuraEffectState = XCGS_Effect_PersistentAura(NewEffectState);

    if (AuraEffectState == none)
    {
        `LOG("ERROR: NewEffectState is not XCGS_Effect_PersistentAura", true, self.Class.Name);
        return;
    }

    super(X2Effect_Persistent).OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, AuraEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit kOldTargetUnitState, kNewTargetUnitState;

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    if (OnEffectRemovedEventName != '')
    {
        kOldTargetUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        if (kOldTargetUnitState != none)
        {
            kNewTargetUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(kOldTargetUnitState.Class, kOldTargetUnitState.ObjectID));
            `XEVENTMGR.TriggerEvent(OnEffectRemovedEventName, kNewTargetUnitState, kNewTargetUnitState, NewGameState);
        }
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit;
    local XComGameState_Effect  EffectState;
    local StateObjectReference  EffectRef;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit == none || SourceUnit.IsDead() || TargetUnit == none || TargetUnit.IsDead())
    {
        `LOG("Source or target are dead or not found", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, default.Class.Name);
        return false;
    }

    if (SourceUnit.ObjectID == TargetUnit.ObjectID)
    {
        `LOG("Source is the target", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, EffectName);
        return bIncludeOwner;
    }
    else
    {
        if (!bIncludeFriendly && SourceUnit.IsFriendlyUnit(TargetUnit))
        {
            `LOG("Target is friendly", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, EffectName);
            return false;
        }
        if (!bIncludeHostile && SourceUnit.IsEnemyUnit(TargetUnit))
        {
            `LOG("Target is hostile", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, EffectName);
            return false;
        }
        if (Radius > 0 && !class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, Radius * Radius))
        {
            `LOG("Target is not in range", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, EffectName);
            return false;
        }
    }

    if (IsUniqueModifier())
    {
        `LOG("IsUniqueModifier: true", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, default.Class.Name);
        History = `XCOMHISTORY;

        foreach TargetUnit.AffectedByEffects(EffectRef)
        {
            if (EffectRef.ObjectID != EffectGameState.ObjectID)
            {
                EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
                if (EffectState != none)
                {
                    if (EffectState.GetX2Effect().EffectName == EffectName && EffectState.StatChanges.Length > 0)
                    {
                        `LOG(TargetUnit.GetMyTemplateName() $ " is already affected by " $ EffectState.GetX2Effect().EffectName, class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, GetFuncName());
                        `LOG(GetFuncName() $ ": false", class'XCGS_Effect_PersistentAura'.default.bLogRelevancy, default.Class.Name);
                        return false;
                    }
                }
            }
        }
    }
    
    return true;
}

defaultproperties
{
    GameStateEffectClass = class'XCGS_Effect_PersistentAura'

    DuplicateResponse = eDupe_Allow // Do not change

    bIncludeFriendly = true
    bIncludeHostile = false
}
