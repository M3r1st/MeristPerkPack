class X2Condition_DisarmWeapon extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;
    local XComGameState_Item WeaponState;
    local X2WeaponTemplate WeaponTemplate;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit == none)
        return 'AA_NotAUnit';

    WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon);
    if (WeaponState == none)
    {
        return 'AA_UnitIsImmune';
    }
    else
    {
        WeaponTemplate = X2WeaponTemplate(WeaponState.GetMyTemplate());

        if (class'X2Effect_DisableWeapon'.default.WeaponsImmuneToDisable.Find(WeaponState.GetMyTemplateName()) != INDEX_NONE || WeaponTemplate.InfiniteAmmo)
            return 'AA_UnitIsImmune';
    }

    return 'AA_Success';
}