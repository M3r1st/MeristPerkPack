class X2Effect_ReloadWeapon extends X2Effect;

var int AmmoToReload;
var bool bSkipClipSizeCheck;
var EInventorySlot SpecificSlot;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        TargetUnit;
    local XComGameState_Item        WeaponState, NewWeaponState;

    TargetUnit = XComGameState_Unit(kNewTargetState);
    if (TargetUnit != none)
    {
        if (SpecificSlot != eInvSlot_Unknown)
        {
            WeaponState = TargetUnit.GetItemInSlot(SpecificSlot, NewGameState);
        }
        else
        {
            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
            if (AbilityState != none)
                WeaponState = AbilityState.GetSourceWeapon();
        }
        
        if (WeaponState != none)
        {
            NewWeaponState = XComGameState_Item(NewGameState.ModifyStateObject(WeaponState.Class, WeaponState.ObjectID));
            if (bSkipClipSizeCheck)
            {
                NewWeaponState.Ammo += AmmoToReload;
            }
            else
            {
                if (NewWeaponState.Ammo < WeaponState.GetClipSize())
                {
                    NewWeaponState.Ammo += Min(AmmoToReload, WeaponState.GetClipSize() - NewWeaponState.Ammo);
                }
            }
        }
    }
}
