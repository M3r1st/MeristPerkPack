class X2Effect_FrostbiteSpit extends X2Effect_Persistent;

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
    local int CritBonus;

    if (Attacker != none)
    {
        Rank = Attacker.GetSoldierRank();
    }

    if (AbilityState != none && IsFrostSpit(AbilityState.GetMyTemplateName()))
    {
        CritBonus = `GetConfigInt("M31_PA_FrostbiteSpit_CritBonus") + `GetConfigInt("M31_PA_FrostbiteSpit_CritBonusPerRank") * Rank;
        if (CritBonus != 0)
        {
            CritInfo.ModType = eHit_Crit;
            CritInfo.Reason = FriendlyName;
            CritInfo.Value = CritBonus;
            ShotModifiers.AddItem(CritInfo);
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
    local int Rank;
    local float DamageBonus;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (Attacker != none)
    {
        Rank = Attacker.GetSoldierRank();
    }

    if (AbilityState != none && IsFrostSpit(AbilityState.GetMyTemplateName()))
    {
        if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
        {
            DamageBonus = `GetConfigFloat("M31_PA_FrostbiteSpit_CritDamageBonus") + `GetConfigFloat("M31_PA_FrostbiteSpit_CritDamageBonusPerRank") * Rank;
        }
    }

    return DamageBonus;
}

private function bool IsFrostSpit(name AbilityName)
{
    return class'X2AbilitySet_PlayableAliens'.default.FrostbiteSpit_AllowedAbilities.Find(AbilityName) != INDEX_NONE;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bDisplayInSpecialDamageMessageUI = true
}