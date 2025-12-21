class X2Effect_VileMixSource extends X2Effect_Persistent;

var int DOTDamageBonus;
var bool bMatchSourceWeapon;

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (!bMatchSourceWeapon || AbilityState.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
            {
                if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
                {
                    return DOTDamageBonus;
                }
            }
        }
    }

    return 0;
}
