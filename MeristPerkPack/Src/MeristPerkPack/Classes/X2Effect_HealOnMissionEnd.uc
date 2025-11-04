class X2Effect_HealOnMissionEnd extends X2Effect_Persistent;

var int HealAmount;

var bool bApplyToSelf;
var bool bApplyToAllies;

var privatewrite name HealValueName;
var privatewrite name BleedoutValueName;

var privatewrite bool bLog;

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_HeadquartersXCom    XComHQ;
    local XComGameStateHistory              History;
    local StateObjectReference              UnitRef;
    local XComGameState_Unit                SourceUnit;
    local XComGameState_Unit                TargetUnit;
    local UnitValue UnitVal;
    local int Healing;

    `LOG(GetFuncName(), default.bLog, 'X2Effect_HealOnMissionEnd');

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    History = `XCOMHISTORY;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit != none)
    {
        if (IsEffectValidForSource(SourceUnit))
        {
            `LOG("The effect is valid for the source (" $ SourceUnit.GetFullName() $ ")", default.bLog, 'X2Effect_HealOnMissionEnd');
            Healing = GetHealAmount(SourceUnit, SourceUnit);
            if (bApplyToSelf)
            {
                `LOG("Applying healing to self", default.bLog, 'X2Effect_HealOnMissionEnd');
                SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
                SourceUnit.GetUnitValue(default.HealValueName, UnitVal);
                `LOG("Increasing value by " $ Healing $ " (current: " $ int(UnitVal.fValue) $ ")", default.bLog, 'X2Effect_HealOnMissionEnd');
                SourceUnit.SetUnitFloatValue(default.HealValueName, UnitVal.fValue + Healing, eCleanup_BeginTactical);
            }
            if (bApplyToAllies)
            {
                `LOG("Applying healing to the allies", default.bLog, 'X2Effect_HealOnMissionEnd');
                XComHQ = `XCOMHQ;
                if (XComHQ != none)
                {
                    `LOG("Applying healing to the squad", default.bLog, 'X2Effect_HealOnMissionEnd');
                    foreach XComHQ.Squad(UnitRef)
                    {
                        if (UnitRef.ObjectID == 0)
                            continue;

                        TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
                        if (TargetUnit.IsSoldier())
                        {
                            `LOG(TargetUnit.GetFullName() $ " is a soldier", default.bLog, 'X2Effect_HealOnMissionEnd');
                            if (TargetUnit.ObjectID != SourceUnit.ObjectID && IsEffectValidForTarget(TargetUnit))
                            {
                                `LOG("The effect is valid for the target", default.bLog, 'X2Effect_HealOnMissionEnd');
                                TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
                                TargetUnit.GetUnitValue(default.HealValueName, UnitVal);
                                `LOG("Increasing value by " $ Healing $ " (current: " $ int(UnitVal.fValue) $ ")", default.bLog, 'X2Effect_HealOnMissionEnd');
                                TargetUnit.SetUnitFloatValue(default.HealValueName, UnitVal.fValue + Healing, eCleanup_BeginTactical);
                            }
                        }
                    }

                    `LOG("Applying healing to the crew", default.bLog, 'X2Effect_HealOnMissionEnd');
                    foreach XComHQ.Crew(UnitRef)
                    {
                        if (UnitRef.ObjectID == 0)
                            continue;

                        TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
                        if (TargetUnit.IsSoldier() && TargetUnit.bSpawnedFromAvenger)
                        {
                            `LOG(TargetUnit.GetFullName() $ " is a soldier and is spanwed from the Avenger", default.bLog, 'X2Effect_HealOnMissionEnd');
                            if (TargetUnit.ObjectID != SourceUnit.ObjectID && IsEffectValidForTarget(TargetUnit))
                            {
                                `LOG("The effect is valid for the target", default.bLog, 'X2Effect_HealOnMissionEnd');
                                TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
                                TargetUnit.GetUnitValue(default.HealValueName, UnitVal);
                                `LOG("Increasing value by " $ Healing $ " (current: " $ int(UnitVal.fValue) $ ")", default.bLog, 'X2Effect_HealOnMissionEnd');
                                TargetUnit.SetUnitFloatValue(default.HealValueName, UnitVal.fValue + Healing, eCleanup_BeginTactical);
                            }
                        }
                    }
                }
            }
        }
    }
}

static function bool IsEffectValidForSource(XComGameState_Unit SourceUnit)
{
    local UnitValue UnitVal;

    if (SourceUnit == none)         { return false; }
    if (SourceUnit.IsDead())        { return false; }
    if (SourceUnit.bCaptured)       { return false; }
    if (SourceUnit.LowestHP == 0)   { return false; }
    if (SourceUnit.IsBleedingOut()) { return false; }
    if (SourceUnit.GetUnitValue(default.BleedoutValueName, UnitVal) && int(UnitVal.fValue) > 0)
    {
        return false;
    }

    return true;
}

static function bool IsEffectValidForTarget(XComGameState_Unit TargetUnit)
{
    local UnitValue UnitVal;

    if (TargetUnit == none)         { return false; }
    if (TargetUnit.IsDead())        { return false; }
    if (TargetUnit.bCaptured)       { return false; }
    if (TargetUnit.LowestHP == 0)   { return false; }
    if (TargetUnit.IsBleedingOut()) { return false; }
    if (TargetUnit.GetUnitValue(default.BleedoutValueName, UnitVal) && int(UnitVal.fValue) > 0)
    {
        return false;
    }

    return true;
}

simulated function int GetHealAmount(optional XComGameState_Unit SourceUnit, optional XComGameState_Unit TargetUnit)
{
    return HealAmount;
}

defaultproperties
{
    EffectName = M31_HealOnMissionEnd

    bLog = true
}