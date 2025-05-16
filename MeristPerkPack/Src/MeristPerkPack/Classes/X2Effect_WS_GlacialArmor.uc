class X2Effect_WS_GlacialArmor extends X2Effect_BonusArmor;

var privatewrite name UnitValueName;
var int ActivationsPerTurn;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    if (ValidateEffect(UnitState))
        return `GetConfigInt("M31_PA_WS_GlacialArmor_ArmorBonus");
    else
        return 0;
}

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;

    if (ValidateEffect(Target))
    {
        ModInfo.ModType = eHit_Graze;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = -1 * `GetConfigInt("M31_PA_WS_GlacialArmor_DodgeBonus");
        ShotModifiers.AddItem(ModInfo);
    }
}

function bool ValidateEffect(XComGameState_Unit UnitState)
{
    return GetCurrentStackCount(UnitState) < ActivationsPerTurn
        && (`GetConfigBool("M31_PA_WS_GlacialArmor_bAllowWhileBurning") || !UnitState.IsBurning());
}

static function int GetCurrentStackCount(XComGameState_Unit UnitState)
{
    local UnitValue Counter;
    local int CurrentCount;
    UnitState.GetUnitValue(default.UnitValueName, Counter);
    CurrentCount = int(Counter.fValue);
    return CurrentCount;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    UnitValueName = M31_PA_WS_GlacialArmor_Counter
}