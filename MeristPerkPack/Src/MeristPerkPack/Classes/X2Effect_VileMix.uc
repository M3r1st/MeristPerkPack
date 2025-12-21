class X2Effect_VileMix extends X2Effect_Persistent;

var int DOTDamageBonus;

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
            if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
            {
                return DOTDamageBonus;
            }
        }
    }

    return 0;
}

static function X2Effect_VileMix HarrierVileMixEffect()
{
    local X2Effect_VileMix Effect;
    local X2Condition_AbilityProperty AbilityCondition;

    Effect = new class'X2Effect_VileMix';
    Effect.DOTDamageBonus = `GetConfigInt("M31_PA_HarrierVileMix_DOTDamageBonus_Debuff");
    Effect.BuildPersistentEffect(`GetConfigInt("M31_PA_HarrierVileMix_Duration"), false, false, false, eGameRule_PlayerTurnEnd);
    Effect.SetDisplayInfo(ePerkBuff_Penalty,
        `GetLocalizedString("M31_PA_HarrierVileMix_FriendlyName"),
        `GetLocalizedString("M31_PA_HarrierVileMix_DebuffText"),
        "img:///UILibrary_PerkIcons.UIPerk_andromedon_acidblob", true, , 'eAbilitySource_Perk');
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_HarrierVileMix');
    Effect.TargetConditions.AddItem(AbilityCondition);

    return Effect;
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
}