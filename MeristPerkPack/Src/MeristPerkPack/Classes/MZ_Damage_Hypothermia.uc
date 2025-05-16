class MZ_Damage_Hypothermia extends X2Effect_ApplyWeaponDamage;

var int Damage, TierDamage, Spread;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
    local XComGameState_Unit            TargetState;
    local XComGameStateHistory          History;
    local XComGameState_BaseObject      Target;
    local WeaponDamageValue             MineDamage;

    History = `XCOMHISTORY;
    Target = History.GetGameStateForObjectID( TargetRef.ObjectID );

    TargetState = XComGameState_Unit(Target);
    MineDamage.DamageType = 'Frost';

    if (TargetState != none)
    {
        if ( TargetState.AffectedByEffectNames.Find('Freeze') != INDEX_NONE )
        {
            MineDamage.Damage = 2 * TierDamage + Damage;
        }
        else if ( TargetState.AffectedByEffectNames.Find('MZBitterChill') != INDEX_NONE )
        {
            MineDamage.Damage = TierDamage + Damage;
        }
        else if ( TargetState.AffectedByEffectNames.Find('MZChill') != INDEX_NONE || TargetState.AffectedByEffectNames.Find('Chilled') != INDEX_NONE)
        {
            MineDamage.Damage = Damage;
        }
        else
        {
            MineDamage.Damage = 1;
        }
    }
    else
    {
        MineDamage.Damage = 0;
    }

    if ( MineDamage.Damage >= Damage )
    {
        MineDamage.Spread = Spread;
    }

    return MineDamage;
}

DefaultProperties
{
    bExplosiveDamage = false
    bIgnoreBaseDamage = true
}