class X2Effect_WS_RebelYell extends X2Effect_ModifyStats config(GameData_SoldierSkills);

var array<StatChange> m_aStatChanges;
var array<StatChange> m_aStatChangesAlt;

var config array<name> CharacterNamesAlt;

simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, optional bool AltStat, optional EStatModOp InModOp=MODOP_Addition)
{
    local StatChange NewChange;
    NewChange.StatType = StatType;
    NewChange.StatAmount = StatAmount;
    NewChange.ModOp = InModOp;

    if (AltStat)
        m_aStatChangesAlt.AddItem(NewChange);
    else
        m_aStatChanges.AddItem(NewChange);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit        TargetUnit;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (TargetUnit != none)
    {
        if (CharacterNamesAlt.Find(TargetUnit.GetMyTemplateName()) != -1)
            NewEffectState.StatChanges = m_aStatChangesAlt;
        else
            NewEffectState.StatChanges = m_aStatChanges;

        super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return EffectGameState.StatChanges.Length > 0;
}

defaultproperties
{
    EffectName = M31_PA_WS_RebelYell
}
