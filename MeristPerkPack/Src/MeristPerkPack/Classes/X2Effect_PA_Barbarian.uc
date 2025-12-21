class X2Effect_PA_Barbarian extends X2Effect_Persistent;

var int AimBonus;
var int CritBonus;

var array<name> CritCategories;

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
    local XComGameState_Item    ItemState;
    local X2WeaponTemplate      WeaponTemplate;

    if (bMelee)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);

        ItemState = Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon);
        WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
        if (WeaponTemplate != none && CritCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
        {
            CritInfo.ModType = eHit_Crit;
            CritInfo.Reason = FriendlyName;
            CritInfo.Value = CritBonus;
            ShotModifiers.AddItem(CritInfo);
        }
    }
}