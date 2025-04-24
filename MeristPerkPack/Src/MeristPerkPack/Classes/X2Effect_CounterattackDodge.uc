class X2Effect_CounterattackDodge extends X2Effect_Persistent;

var int DodgeBase;
var int DodgeReductionPerHit;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;
    local UnitValue         CounterattackUnitValue;
    local int               iCounter;
    local int               DodgeMod;

    Target.GetUnitValue(class'X2AbilitySet_PlayableAliens'.default.Counterattack_CounterName, CounterattackUnitValue);
    iCounter = int(CounterattackUnitValue.fValue);

    DodgeMod = DodgeBase - DodgeReductionPerHit * iCounter;
    if (bMelee && DodgeMod > 0)
    {
        ModInfo.ModType = eHit_Graze;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = DodgeMod;
        ShotModifiers.AddItem(ModInfo);
    }
}