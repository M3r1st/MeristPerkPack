class X2Effect_PA_HardenedShield extends X2Effect_Persistent;

var int CritResistance;

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ModInfo;

    if (IsEffectCurrentlyRelevant(EffectState, Target))
    {
        ModInfo.ModType = eHit_Crit;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = -1 * CritResistance;
        ShotModifiers.AddItem(ModInfo);
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return TargetUnit.IsUnitAffectedByEffectName(class'X2AbilitySet_PA_Muton'.default.PersonalShieldEffectName);
}

defaultproperties
{
    EffectName = M31_PA_HardenedShield
    DuplicateResponse = eDupe_Ignore
}