class X2Effect_PersistentAttackBonus extends X2Effect_Persistent;

struct PersistentAttackBonusInfo {
    var float Damage;
    var float CritDamage;
    var int Aim;
    var int Crit;
};

var array<name> AllowedAbilities;
var bool bPercent;
var bool bOverrideCrit;

var PersistentAttackBonusInfo ToAll;

var PersistentAttackBonusInfo ToRobotic;
var PersistentAttackBonusInfo ToOrganic;

var PersistentAttackBonusInfo ToSmall;
var PersistentAttackBonusInfo ToLarge;

var PersistentAttackBonusInfo ToFlanked;
var PersistentAttackBonusInfo ToLowCovered;
var PersistentAttackBonusInfo ToFullCovered;
var PersistentAttackBonusInfo ToUnflankable;

private function ProcessPersistentAttackBonusInfo(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit,
    optional out float Damage, optional out float CritDamage, optional out int Aim, optional out int Crit)
{
    local GameRulesCache_VisibilityInfo VisInfo;

    if (TargetUnit == none)
        return;

    // All
    Damage += ToAll.Damage;
    CritDamage += ToAll.CritDamage;
    Aim += ToAll.Aim;
    Crit += ToAll.Crit;

    // Robotic
    if (TargetUnit.IsRobotic())
    {
        Damage += ToRobotic.Damage;
        CritDamage += ToRobotic.CritDamage;
        Aim += ToRobotic.Aim;
        Crit += ToRobotic.Crit;
    }
    // Organic
    if (!TargetUnit.IsRobotic())
    {
        Damage += ToOrganic.Damage;
        CritDamage += ToOrganic.CritDamage;
        Aim += ToOrganic.Aim;
        Crit += ToOrganic.Crit;
    }

    // Small
    if (TargetUnit.UnitSize == 1)
    {
        Damage += ToSmall.Damage;
        CritDamage += ToSmall.CritDamage;
        Aim += ToSmall.Aim;
        Crit += ToSmall.Crit;
    }
    // Large
    if (TargetUnit.UnitSize > 1)
    {
        Damage += ToLarge.Damage;
        CritDamage += ToLarge.CritDamage;
        Aim += ToLarge.Aim;
        Crit += ToLarge.Crit;
    }

    // Cover-based
    if (TargetUnit.CanTakeCover() && `TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
    {
        switch (VisInfo.TargetCover)
        {
            // Flanked
            case CT_None:
                Damage += ToFlanked.Damage;
                CritDamage += ToFlanked.CritDamage;
                Aim += ToFlanked.Aim;
                Crit += ToFlanked.Crit;
                break;
            // Low Cover
            case CT_MidLevel:
                Damage += ToLowCovered.Damage;
                CritDamage += ToLowCovered.CritDamage;
                Aim += ToLowCovered.Aim;
                Crit += ToLowCovered.Crit;
                break;
            // High Cover
            case CT_Standing:
                Damage += ToFullCovered.Damage;
                CritDamage += ToFullCovered.CritDamage;
                Aim += ToFullCovered.Aim;
                Crit += ToFullCovered.Crit;
                break;
            default:
                `LOG("How did we get here, exactly?", true, 'X2Effect_PersistentAttackBonus');
                break;
        }
    }
    // Unflankable
    if (!TargetUnit.CanTakeCover())
    {
        Damage += ToUnflankable.Damage;
        CritDamage += ToUnflankable.CritDamage;
        Aim += ToUnflankable.Aim;
        Crit += ToUnflankable.Crit;
    }
}

function bool AllowCritOverride()
{
    return bOverrideCrit;
}

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
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    local int AimBonus;
    local int CritBonus;

    if (AbilityState != none)
    {
        if (AllowedAbilities.Length == 0 || AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            ProcessPersistentAttackBonusInfo(Attacker, Target,,, AimBonus, CritBonus);
            if (AimBonus != 0)
            {
                AimInfo.ModType = eHit_Success;
                AimInfo.Reason = FriendlyName;
                AimInfo.Value = AimBonus;
                ShotModifiers.AddItem(AimInfo);

                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = FriendlyName;
                CritInfo.Value = CritBonus;
                ShotModifiers.AddItem(CritInfo);
            }
        }
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
    local XComGameState_Unit TargetUnit;
    local float DamageBonus;
    local float CritDamageBonus;

    if (bPercent)
        return 0;

    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (TargetUnit == none)
        return 0;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (AbilityState != none)
    {
        if (AllowedAbilities.Length == 0 || AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            ProcessPersistentAttackBonusInfo(Attacker, TargetUnit, DamageBonus, CritDamageBonus);
            if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
            {
                DamageBonus += CritDamageBonus;
            }
        }
    }

    return DamageBonus;
}

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState) 
{
    local XComGameState_Unit TargetUnit;
    local float DamageBonusPrc;
    local float CritDamageBonusPrc;

    if (!bPercent)
        return 0;

    TargetUnit = XComGameState_Unit(Target);

    if (TargetUnit == none)
        return 0;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (AbilityState != none)
    {
        if (AllowedAbilities.Length == 0 || AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            ProcessPersistentAttackBonusInfo(SourceUnit, TargetUnit, DamageBonusPrc, CritDamageBonusPrc);
            if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
            {
                DamageBonusPrc += CritDamageBonusPrc;
            }
        }
    }

    return CurrentDamage * (DamageBonusPrc / 100);
}