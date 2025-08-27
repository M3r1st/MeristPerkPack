class X2Effect_ApplyDamage_NoPreview extends X2Effect_ApplyWeaponDamage;

simulated function GetDamagePreview(StateObjectReference TargetRef, XComGameState_Ability AbilityState, bool bAsPrimaryTarget, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local WeaponDamageValue EmptyDamageValue;
    
    MinDamagePreview = EmptyDamageValue;
    MaxDamagePreview = EmptyDamageValue;
}