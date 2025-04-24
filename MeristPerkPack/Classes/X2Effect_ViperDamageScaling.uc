class X2Effect_ViperDamageScaling extends X2Effect_Persistent;

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target, XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local int Rank;
    local float DamageBonus;
    local name AbilityName;
    local bool bSpit, bBind, bBite;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (SourceUnit != none)
    {
        Rank = SourceUnit.GetSoldierRank();
    }

    if (AbilityState != none)
    {
        AbilityName = AbilityState.GetMyTemplateName();
        bSpit = IsSpit(AbilityName);
        bBind = IsBind(AbilityName);
        bBite = IsBite(AbilityName);

        // `LOG(AbilityName $ " : " $ bSpit $ bBind $ bBite);

        if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        {
            if (bSpit || bBind || bBite)
            {
                DamageBonus = `GetConfigFloat("M31_PA_ViperPoison_DamageBonusPerRank") * Rank;
            }
        }
        else
        {
            if (bSpit)
            {
                DamageBonus = `GetConfigFloat("M31_PA_ViperSpit_DamageBonusPerRank") * Rank;
            }
            else if (bBind)
            {
                DamageBonus = `GetConfigFloat("M31_PA_ViperBind_DamageBonusPerRank") * Rank;
            }
            else if (bBite)
            {
                if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
                {
                    DamageBonus = `GetConfigFloat("M31_PA_ViperBite_DamageBonusPerRank") * Rank
                        + `GetConfigFloat("M31_PA_ViperBite_CritDamageBonusPerRank") * Rank;
                }
                else
                {
                    DamageBonus = `GetConfigFloat("M31_PA_ViperBite_DamageBonusPerRank") * Rank;
                }
            }
        }
    }

    return DamageBonus;
}

private function bool IsSpit(name AbilityName)
{
    return class'X2AbilitySet_PlayableAliens'.default.bViperScaling_ApplyToSpit &&
        class'X2AbilitySet_PlayableAliens'.default.ViperSpit_Abilities.Find(AbilityName) != INDEX_NONE;
}

private function bool IsBind(name AbilityName)
{
    return class'X2AbilitySet_PlayableAliens'.default.bViperScaling_ApplyToBind &&
        class'X2AbilitySet_PlayableAliens'.default.Bind_Abilities.Find(AbilityName) != INDEX_NONE
        || class'X2AbilitySet_PlayableAliens'.default.bViperScaling_ApplyToBindSustained &&
        class'X2AbilitySet_PlayableAliens'.default.BindSustained_Abilities.Find(AbilityName) != INDEX_NONE;
}

private function bool IsBite(name AbilityName)
{
    return class'X2AbilitySet_PlayableAliens'.default.bViperScaling_ApplyToBite &&
        class'X2AbilitySet_PlayableAliens'.default.ViperBite_Abilities.Find(AbilityName) != INDEX_NONE;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
}