//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_HitAndRun
//  AUTHOR:  Merist / based on X2Effect_HitAndRun by John Lumpkin (Pavonis Interactive)
//  PURPOSE: Hit and Run effect to grant free action
//---------------------------------------------------------------------------------------

class X2Effect_HitAndRun extends X2Effect_Persistent;

var bool bMatchSourceWeapon;
var array<name> AllowedAbilities;
var int ActivationsPerTurn;
var name CounterName;
var name PointType;
var name FlyoverEventName;

var bool bApplyToUnflankable;
var bool bValidateRunAndGun;
var bool bValidateCloseEncounters;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    UnitState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    EventMgr.RegisterForEvent(EffectObj, FlyoverEventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, 30 , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Unit                TargetUnit;
    local XComGameState_Ability             AbilityState;
    local GameRulesCache_VisibilityInfo     VisInfo;
    local UnitValue UnitValue;
    local int iUsesThisTurn;
    local bool bValidTarget;

    if (!ValidateSuperKill(SourceUnit))
        return false;

    if (class'M31_AbilityHelpers'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
        return false;

    SourceUnit.GetUnitValue(CounterName, UnitValue);
    iUsesThisTurn = int(UnitValue.fValue);

    if (iUsesThisTurn >= ActivationsPerTurn)
        return false;

    if (kAbility.IsMeleeAbility())
        return false;

    if (bMatchSourceWeapon && kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return false;

    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

    if (TargetUnit != none)
    {
        if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
        {
            if (SourceUnit.CanFlank() && TargetUnit.IsEnemyUnit(SourceUnit))
            {
                if (TargetUnit.GetMyTemplate().bCanTakeCover)
                {
                    if ((VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0 && TargetUnit.GetTeam() != eTeam_XCom))
                        bValidTarget = true;
                }
                else
                {
                    bValidTarget = bApplyToUnflankable;
                }

                if (bValidTarget)
                {
                    if (AllowedAbilities.Length == 0 || AllowedAbilities.Find(kAbility.GetMyTemplateName()) != INDEX_NONE)
                    {
                        if (kAbility.IsAbilityInputTriggered())
                        {
                            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
                            if (AbilityState != none)
                            {
                                SourceUnit.SetUnitFloatValue(CounterName, iUsesThisTurn + 1.0, eCleanup_BeginTurn);
                                if (PointType != '')
                                    SourceUnit.ActionPoints.AddItem(PointType);
                                else
                                    SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);

                                `XEVENTMGR.TriggerEvent(FlyoverEventName, AbilityState, SourceUnit, NewGameState);
                            }
                        }
                    }
                }
            }
        }
    }

    return false;
}

function bool ValidateSuperKill(XComGameState_Unit SourceUnit)
{
    local UnitValue UnitValue;
    local int iUsesThisTurn;

    if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
        return false;

    if (bValidateRunAndGun)
    {
        SourceUnit.GetUnitValue('RunAndGun_SuperKillCheck', UnitValue);
        iUsesThisTurn = int(UnitValue.fValue);

        if (iUsesThisTurn >= 1)
            return false;
    }

    if (bValidateCloseEncounters)
    {
        SourceUnit.GetUnitValue('CloseEncountersUses', UnitValue);
        iUsesThisTurn = int(UnitValue.fValue);

        if (iUsesThisTurn >= 1)
            return false;
    }

    return true;
}

defaultproperties
{
    CounterName = HitandRunUses
    FlyoverEventName = HitandRun
    bMatchSourceWeapon = true
    bValidateRunAndGun = true
    bValidateCloseEncounters = true
}