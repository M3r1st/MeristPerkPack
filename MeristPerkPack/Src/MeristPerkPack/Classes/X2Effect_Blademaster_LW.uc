class X2Effect_Blademaster_LW extends X2Effect_Persistent;

var bool bMatchSourceWeapon;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimInfo;

    if (bMelee && (!bMatchSourceWeapon || EffectState.ApplyEffectParameters.ItemStateObjectRef == AbilityState.SourceWeapon))
    {
        AimInfo.ModType = eHit_Crit;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = class'X2Ability_RangerAbilitySet'.default.BLADEMASTER_AIM;
        ShotModifiers.AddItem(AimInfo);
    }
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    if (AbilityState.IsMeleeAbility() && (!bMatchSourceWeapon || EffectState.ApplyEffectParameters.ItemStateObjectRef == AbilityState.SourceWeapon))
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                // remove from DOT effects
                if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
                    return 0;
                
                return class'X2Ability_RangerAbilitySet'.default.BLADEMASTER_DMG;
            }

        }
    }
    return 0;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Blademaster_LW"
}