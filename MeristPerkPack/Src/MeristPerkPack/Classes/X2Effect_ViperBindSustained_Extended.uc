class X2Effect_ViperBindSustained_Extended extends X2Effect_ViperBindSustained config(GameData_SoldierSkills);

var int iTurnsForFirstIncrease;
var bool bUseExponentialDamageIncrease;
var bool bUseGeometricDamageIncrease;

var config array<name> ClearBindSourceEvents;
var config array<name> ClearBindTargetEvents;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local XComGameStateHistory  History;
    local X2EventManager        EventMgr;
    local XComGameState_Unit    SourceUnit, TargetUnit;
    local Object                EffectObj;
    local int                   i;

    super.RegisterForEvents(EffectGameState);

    History = `XCOMHISTORY;
    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    for (i = 0; i < default.ClearBindSourceEvents.Length; ++i )
    {
        EventMgr.RegisterForEvent(EffectObj, RegisterAdditionalEventsLikeImpair[i], EffectGameState.OnSourceBecameImpaired, ELD_OnStateSubmitted, 55, SourceUnit);
    }
    for (i = 0; i < default.ClearBindTargetEvents.Length; ++i )
    {
        EventMgr.RegisterForEvent(EffectObj, RegisterAdditionalEventsLikeImpair[i], EffectGameState.OnSourceBecameImpaired, ELD_OnStateSubmitted, 55, TargetUnit);
    }
}

function float GetPreDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameState_Unit TargetUnit,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    // This effect scales the damage based upon the number of full turns the unit has been bound by the viper
    if (class'X2AbilitySet_ViperBindAndPull'.default.BindCrush_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        if ((EffectState.FullTurnsTicked > iTurnsForFirstIncrease))
        {
            if (bUseGeometricDamageIncrease)
                return CurrentDamage * (EffectState.FullTurnsTicked - iTurnsForFirstIncrease) - CurrentDamage;
            
            if (bUseExponentialDamageIncrease)
                return CurrentDamage * (2 ** (EffectState.FullTurnsTicked - iTurnsForFirstIncrease)) - CurrentDamage;
        }
    }

    return 0;
}

defaultproperties
{
    iTurnsForFirstIncrease = 1
}
