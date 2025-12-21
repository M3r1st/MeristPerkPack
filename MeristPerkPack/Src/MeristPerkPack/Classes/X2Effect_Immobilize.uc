//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Immobilize.uc
//  AUTHOR:  Grobobobo/Taken  from Favid
//  PURPOSE: Effect that Immobilizes the target
//---------------------------------------------------------------------------------------
class X2Effect_Immobilize extends X2Effect_PersistentStatChange;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(kNewTargetState);
    UnitState.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 1);

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (UnitState != none)
    {
        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
        UnitState.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
    }

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

static function X2Effect_Immobilize CreateMaimedStatusEffect(optional int NumTurns = 1, optional X2AbilityTemplate Template)
{
    local X2Effect_Immobilize ImmobilizeEffect;

    ImmobilizeEffect = new class'X2Effect_Immobilize';
    ImmobilizeEffect.AddPersistentStatChange(eStat_Mobility, 0.0f, MODOP_PostMultiplication);
    ImmobilizeEffect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnEnd);
    ImmobilizeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.strFriendlyName, default.strFriendlyDesc, Template.IconImage,,, Template.AbilitySourceName);
    ImmobilizeEffect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;

    return ImmobilizeEffect;
}

defaultproperties
{
    EffectName = Immobilize
    DuplicateResponse = eDupe_Refresh

    bCanTickEveryAction = true
}