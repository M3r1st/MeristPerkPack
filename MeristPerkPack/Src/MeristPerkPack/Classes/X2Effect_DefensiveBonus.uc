class X2Effect_DefensiveBonus extends X2Effect_PersistentStatChange;

var int CritResistance;
var int DamageReduction;

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo  ModInfo;
    
    ModInfo.ModType = eHit_Crit;
    ModInfo.Reason = FriendlyName;
    ModInfo.Value = -1 * CritResistance;
    ShotModifiers.AddItem(ModInfo);
}

function int GetDefendingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    optional XComGameState NewGameState)
{
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            return -1 * Min(CurrentDamage, DamageReduction);
        }
    }
}

defaultproperties
{
    EffectName = M31_PA_WS_ReinforcedScales
}