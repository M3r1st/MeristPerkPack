class X2Effect_WS_ApplyBoltDamage extends X2Effect_Shredder;

var bool bRuptureBolt;
var bool bShredBolt;
var bool bMaelstromBolt;
var bool bCritBolt;

function WeaponDamageValue GetBonusEffectDamageValue(
    XComGameState_Ability AbilityState,
    XComGameState_Unit SourceUnit,
    XComGameState_Item SourceWeapon,
    StateObjectReference TargetRef)
{
    local XComGameState_Unit    TargetUnit;
    local WeaponDamageValue     BonusValue;
    local X2WeaponTemplate      SourceWeaponTemplate;
    local float fModifier;
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

        if (bMaelstromBolt)
        {
            TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
            if (TargetUnit != none)
            {
                if (class'X2Helpers_DLC_Day60'.static.IsUnitAlienRuler(TargetUnit))
                    fModifier = `GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamage_RulerMult");
                else if (TargetUnit.IsChosen())
                    fModifier = `GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamage_ChosenMult");
                else
                    fModifier = 1.0;


                if (bBallista)
                    BonusValue.Damage += TargetUnit.GetMaxStat(eStat_HP) * (`GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamagePrc_Ballista") / 100) * fModifier;
                else
                    BonusValue.Damage += TargetUnit.GetMaxStat(eStat_HP) * (`GetConfigFloat("M31_PA_WS_Bolt_Maelstrom_HPToDamagePrc") / 100) * fModifier;         
            }
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