class X2AbilityCost_Ammo_Extended extends X2AbilityCost_Ammo;

var int iAmmoMax;

simulated function int CalcAmmoCost(XComGameState_Ability Ability, XComGameState_Item ItemState, XComGameState_BaseObject TargetState)
{
    if (bConsumeAllAmmo)
    {
        if (ItemState.Ammo > 0)
            return Min(ItemState.Ammo, iAmmoMax);
        return 1;
    }

    return iAmmo;
}