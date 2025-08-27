class X2Effect_WS_Thrill extends X2Effect_Persistent config(GameData_SoldierSkills);

var privatewrite name UnitValueName;
var config array<name> Thrill_ExcludeCharacterTemplates;
var config array<name> Thrill_ExcludeCharacterGroups;

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

    Counter = GetCurrentStackCount(Attacker);

    if (Counter != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = Counter * `GetConfigInt("M31_PA_WS_ThrillOfTheHunt_AimPerStack");
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Counter * `GetConfigInt("M31_PA_WS_ThrillOfTheHunt_CritPerStack");
        ShotModifiers.AddItem(CritInfo);
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return GetCurrentStackCount(TargetUnit) > 0;
}

static function int GetCurrentStackCount(XComGameState_Unit UnitState)
{
    local UnitValue Counter;
    local int CurrentCount;
    UnitState.GetUnitValue(default.UnitValueName, Counter);
    CurrentCount = Min(int(Counter.fValue), `GetConfigInt("M31_PA_WS_ThrillOfTheHunt_MaxStacks"));;
    return CurrentCount;
}

defaultproperties
{
    UnitValueName = M31_PA_WS_GlacialArmor_Counter
}