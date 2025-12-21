class X2Effect_PA_Counterattack extends X2Effect_Counterattack;

var int DodgeBase;
var int DodgeReductionPerHit;
var int ActivationsPerTurn;

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local UnitValue CountUnitValue;
    local ShotModifierInfo ModInfo;
    local int DodgeBonus;

    if (bMelee)
    {
        if (IsEffectCurrentlyRelevant(EffectState, Target))
        {
            if (FindUsableCounterattackAbility(Target, Attacker) != none)
            {
                Target.GetUnitValue(CountValueName, CountUnitValue);
                DodgeBonus = Min(0, DodgeBase - DodgeReductionPerHit * int(CountUnitValue.fValue));

                ModInfo.ModType = eHit_Graze;
                ModInfo.Reason = FriendlyName;
                ModInfo.Value = DodgeBonus;
                ShotModifiers.AddItem(ModInfo);
            }
        }
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue CountUnitValue;

    if (CountValueName != '')
    {
        TargetUnit.GetUnitValue(CountValueName, CountUnitValue);
        if (ActivationsPerTurn > 0 && CountUnitValue.fValue >= ActivationsPerTurn)
            return false;
    }

    return super.IsEffectCurrentlyRelevant(EffectGameState, TargetUnit);
}

defaultproperties
{
    EffectName = M31_PA_Counterattack
    
    CountValueName = M31_PA_Counterattack_Counter
}