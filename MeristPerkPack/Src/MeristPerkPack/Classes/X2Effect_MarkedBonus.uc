class X2Effect_MarkedBonus extends X2Effect_Persistent;

var array<name> AllowedAbilities;
var array<name> AllowedEffects;

var bool bMatchSourceWeapon;
var bool bApplyToRanged;
var bool bApplyToMelee;

var int AimBonus;
var int CritBonus;
var int DamageBonus;
var int CritDamageBonus;
var int PierceBonus;
var int ShredBonus;

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (bIndirectFire || bMelee && !bApplyToMelee || !bMelee && !bApplyToRanged)
        return;

    if (!ValidateEffects(Target))
        return;

    if (AimBonus != 0)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);
    }

    if (CritBonus != 0)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus;
        ShotModifiers.AddItem(CritInfo);
    }

}

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    local XComGameState_Unit Target;
    local X2AbilityToHitCalc_StandardAim StandardAim;

    Target = XComGameState_Unit(TargetDamageable);

    if (Target == none)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);

    if (StandardAim == none)
        return 0;
    
    if (StandardAim.bIndirectFire || AbilityState.IsMeleeAbility() && !bApplyToMelee || !AbilityState.IsMeleeAbility() && !bApplyToRanged)
        return 0;

    if (!ValidateEffects(Target))
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
                return DamageBonus + CritDamageBonus;
            else
                return DamageBonus;
        }
    }

    return 0;
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local XComGameState_Unit Target;
    local X2AbilityToHitCalc_StandardAim StandardAim;

    Target = XComGameState_Unit(TargetDamageable);

    if (Target == none)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);

    if (StandardAim == none)
        return 0;
    
    if (StandardAim.bIndirectFire || AbilityState.IsMeleeAbility() && !bApplyToMelee || !AbilityState.IsMeleeAbility() && !bApplyToRanged)
        return 0;

    if (!ValidateEffects(Target))
        return 0;

    return PierceBonus;
}

function int GetExtraShredValue(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    local XComGameState_Unit Target;
    local X2AbilityToHitCalc_StandardAim StandardAim;

    Target = XComGameState_Unit(TargetDamageable);

    if (Target == none)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);

    if (StandardAim == none)
        return 0;
    
    if (StandardAim.bIndirectFire || AbilityState.IsMeleeAbility() && !bApplyToMelee || !AbilityState.IsMeleeAbility() && !bApplyToRanged)
        return 0;

    if (!ValidateEffects(Target))
        return 0;

    return ShredBonus;
}

protected function bool ValidateEffects(XComGameState_Unit UnitState)
{
    local name Effect;

    if (UnitState == none)
        return false;

    foreach AllowedEffects(Effect)
    {
        if (UnitState.AffectedByEffectNames.Find(Effect) != INDEX_NONE)
        {
            return true;
        }
    }
    
    return false;
}