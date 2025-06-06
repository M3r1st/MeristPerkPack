class X2Effect_EnhancedEnergyShield extends X2Effect_PersonalShield config(GameData_SoldierSkills);

struct AdditionalShieldAmountFromConfigInfo
{
    var name RequiredAbility;
    var int AdditionalAmount;
};

var config array<AdditionalShieldAmountFromConfigInfo> AdditionalShieldAmountFromConfig;
var privatewrite name EnergyShield_ShieldRemovedEventName;

simulated function int GetAdditionalShieldAmountFromAbilities(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;
    local AdditionalShieldAmountFromConfigInfo Info;
    local int Shield;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        foreach AdditionalShieldAmountFromConfig(Info)
        {
            if (SourceUnit.HasSoldierAbility(Info.RequiredAbility))
            {
                Shield += Info.AdditionalAmount;
            }
        }
    }

    return Shield + super.GetAdditionalShieldAmountFromAbilities(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    `assert(TargetUnit != none);

    `XEVENTMGR.TriggerEvent(default.EnergyShield_ShieldRemovedEventName, RemovedEffectState, TargetUnit, NewGameState);

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

defaultproperties
{
    EnergyShield_ShieldRemovedEventName = M31_EnergyShield_ShieldRemoved
}