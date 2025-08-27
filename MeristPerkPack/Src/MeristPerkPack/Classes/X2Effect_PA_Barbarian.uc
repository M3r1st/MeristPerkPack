class X2Effect_PA_Barbarian extends X2Effect_Persistent;

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo      AimInfo;
    local ShotModifierInfo      CritInfo;
    local XComGameState_Item    InventoryItem;
    local X2WeaponTemplate      WeaponTemplate;

    if (bMelee)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = `GetConfigInt("M31_PA_Barbarian_AimBonus");
        ShotModifiers.AddItem(AimInfo);

        InventoryItem = Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon);

        WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
        if (WeaponTemplate != none && class'X2AbilitySet_PA_Muton'.default.Barbarian_RifleCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
        {
            CritInfo.ModType = eHit_Crit;
            CritInfo.Reason = FriendlyName;
            CritInfo.Value = `GetConfigInt("M31_PA_Barbarian_CritBonus");
            ShotModifiers.AddItem(CritInfo);
        }
    }
}