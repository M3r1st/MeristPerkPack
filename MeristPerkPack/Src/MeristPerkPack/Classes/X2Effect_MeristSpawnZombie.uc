class X2Effect_MeristSpawnZombie extends X2Effect_SpawnPsiZombie;

var name LinkAbilityName;
var name AltRequiredAbility;
var name UnitToSpawnHumanName, AltUnitToSpawnHumanName;

var privatewrite bool bLog;

function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    SourceUnit, TargetUnit;
    local XComHumanPawn         HumanPawn;
    local name                  UnitName;

    History = `XCOMHISTORY;

    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (TargetUnit != none)
    {
        HumanPawn = XComHumanPawn(XGUnit(History.GetVisualizer(TargetUnit.ObjectID)).GetPawn());
    }

    UnitName = UnitToSpawnName;
    if (HumanPawn != none)
    {
        UnitName = UnitToSpawnHumanName;
    }

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit != none)
    {
        if (SourceUnit.HasSoldierAbility(AltRequiredAbility, true))
        {
            UnitName = AltUnitToSpawnName;
            if (HumanPawn != none)
            {
                UnitName = AltUnitToSpawnHumanName;
            }
        }
    }

    return UnitName;
}

function OnSpawnComplete(const out EffectAppliedData ApplyEffectParameters, StateObjectReference NewUnitRef, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit    ZombieUnit, DeadUnit;
    local EffectAppliedData     NewEffectParams;
    local X2Effect              SireLinkEffect;
    local X2EventManager        EventManager;

    EventManager = `XEVENTMGR;

    ZombieUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewUnitRef.ObjectID));
    if (ZombieUnit == none)
    {
        `LOG(GetFuncName() $ ": spawned zombie unit is missing", default.bLog, self.Class.Name);
        return;
    }

    DeadUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (DeadUnit == none)
    {
        DeadUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    }
    if (DeadUnit == none)
    {
        `LOG(GetFuncName() $ ": dead unit is missing", default.bLog, self.Class.Name);
        return;
    }

    if (DeadUnit.bReadOnly)
    {
        `LOG(GetFuncName() $ ": This cannot run on a read only object: " $ DeadUnit.ObjectID, default.bLog, self.Class.Name);
        return;
    }

    // The zombie can't become a zombie once dead and save the dead unit's ref so it can be accessed later
    ZombieUnit.SetUnitFloatValue(TurnedZombieName, 1, eCleanup_BeginTactical);

    // Link the source and zombie
    NewEffectParams = ApplyEffectParameters;
    NewEffectParams.EffectRef.ApplyOnTickIndex = INDEX_NONE;
    NewEffectParams.EffectRef.LookupType = TELT_AbilityTargetEffects;
    NewEffectParams.EffectRef.SourceTemplateName = LinkAbilityName;
    NewEffectParams.EffectRef.TemplateEffectLookupArrayIndex = 0;
    NewEffectParams.TargetStateObjectRef = ZombieUnit.GetReference();

    SireLinkEffect = class'X2Effect'.static.GetX2Effect(NewEffectParams.EffectRef);
    if (SireLinkEffect == none)
    {
        `LOG(GetFuncName() $ ": link effect is missing", default.bLog, self.Class.Name);
        return;
    }
    SireLinkEffect.ApplyEffect(NewEffectParams, ZombieUnit, NewGameState);

    // Don't allow the dead unit to become a zombie again
    DeadUnit.SetUnitFloatValue(TurnedZombieName, 1, eCleanup_BeginTactical);

    // Remove the dead unit from play
    EventManager.TriggerEvent('UnitRemovedFromPlay', DeadUnit, DeadUnit, NewGameState);

    // Make sure the zombie doesn't spawn with any action points this turn
    ZombieUnit.ActionPoints.Length = 0;

    EventManager.TriggerEvent('UnitMoveFinished', ZombieUnit, ZombieUnit, NewGameState);
}