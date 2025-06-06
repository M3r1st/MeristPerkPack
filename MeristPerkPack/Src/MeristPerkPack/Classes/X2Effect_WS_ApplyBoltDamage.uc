class X2Effect_WS_ApplyBoltDamage extends X2Effect_Shredder;

var bool bRuptureBolt;
var bool bShredBolt;
var bool bCritBolt;

function WeaponDamageValue GetBonusEffectDamageValue(
    XComGameState_Ability AbilityState,
    XComGameState_Unit SourceUnit,
    XComGameState_Item SourceWeapon,
    StateObjectReference TargetRef)
{
    local WeaponDamageValue     BonusValue;
    local X2WeaponTemplate      SourceWeaponTemplate;
    local bool bBallista;

    BonusValue = super.GetBonusEffectDamageValue(AbilityState, SourceUnit, SourceWeapon, TargetRef);

    bBallista = IsSourceWeaponBallista(AbilityState);

    SourceWeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

    if (SourceWeapon != none && SourceUnit != none)
    {
        if (bRuptureBolt)
        {
            if (bBallista)
                BonusValue.Rupture += `GetConfigInt("M31_PA_WS_Bolt_Rupture_RuptureBonus_Ballista");
            else
                BonusValue.Rupture += `GetConfigInt("M31_PA_WS_Bolt_Rupture_RuptureBonus");
        }

        if (bShredBolt)
        {
            if (bBallista)
                BonusValue.Shred += `GetConfigInt("M31_PA_WS_Bolt_Shred_ShredBonus_Ballista");
            else
                BonusValue.Shred += `GetConfigInt("M31_PA_WS_Bolt_Shred_ShredBonus");
        }

        if (bCritBolt)
        {
            if (bBallista)
                BonusValue.Crit += SourceWeaponTemplate.BaseDamage.Crit * `GetConfigInt("M31_PA_WS_Bolt_Crit_BasePrcCritDamageBonus_Ballista") / 100;
            else
                BonusValue.Crit += SourceWeaponTemplate.BaseDamage.Crit * `GetConfigInt("M31_PA_WS_Bolt_Crit_BasePrcCritDamageBonus") / 100;
        }
    }

    return BonusValue;
}

static final function bool IsSourceWeaponBallista(const XComGameState_Ability AbilityState)
{
    local name ItemTemplateName;

    if (AbilityState == none)
        return false;

    ItemTemplateName = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID)).GetMyTemplateName();

    return class'X2AbilitySet_WinterSentinel'.default.Ballista_Categories.Find(ItemTemplateName) != INDEX_NONE;
}