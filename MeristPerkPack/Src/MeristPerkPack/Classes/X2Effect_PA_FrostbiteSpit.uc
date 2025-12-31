class X2Effect_PA_FrostbiteSpit extends X2Effect_Persistent;

var int CritBonus;
var int CritBonusPerRank;
var float CritDamageBonus;
var float CritDamageBonusPerRank;

function bool AllowCritOverride()
{
    return true;
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
    local ShotModifierInfo CritInfo;
    local int Rank;
    local int Bonus;

    if (Attacker != none)
    {
        Rank = Attacker.GetSoldierRank();
    }

    if (AbilityState != none && IsFrostSpit(AbilityState.GetMyTemplateName()))
    {
        Bonus = CritBonus + CritBonusPerRank * Rank;

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Bonus;
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
    local int Rank;
    local int DamageBonus;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (Attacker != none)
            {
                Rank = Attacker.GetSoldierRank();
            }

            if (AbilityState != none && IsFrostSpit(AbilityState.GetMyTemplateName()))
            {
                if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
                {
                    DamageBonus = CritDamageBonus + CritDamageBonusPerRank * Rank;
                    return DamageBonus;
                }
            }
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
    if (AbilityState != none && IsFrostSpit(AbilityState.GetMyTemplateName()))
    {
        return `GetConfigInt("M31_PA_FrostbiteSpit_PierceBonus");
    }

    return 0;
}

static function bool IsFrostSpit(name AbilityName)
{
    return class'X2AbilitySet_PA_Viper'.default.FrostbiteSpit_AllowedAbilities.Find(AbilityName) != INDEX_NONE;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bDisplayInSpecialDamageMessageUI = false
}