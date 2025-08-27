//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SaltInTheWound.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class X2Effect_SaltInTheWound extends X2Effect_Persistent;

var int DamageBonus;

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

    Target = XComGameState_Unit(TargetDamageable);

    if (Target == none)
        return 0;

    if (!ValidateEffects(Target))
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            return DamageBonus;
        }
    }

    return 0;
}

protected function bool ValidateEffects(XComGameState_Unit UnitState)
{
    local StateObjectReference  EffectRef;
    local X2Effect_Persistent   PersistentEffect;
    local X2Effect              OnTickEffect;

    if (UnitState == none)
        return false;

    foreach UnitState.AffectedByEffects(EffectRef)
    {
        PersistentEffect = XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(EffectRef.ObjectID)).GetX2Effect();
        if (PersistentEffect != none)
        {
            foreach PersistentEffect.ApplyOnTick(OnTickEffect)
            {
                if (X2Effect_ApplyWeaponDamage(OnTickEffect) != none)
                    return true;
            }
        }
    }
    
    return false;
}