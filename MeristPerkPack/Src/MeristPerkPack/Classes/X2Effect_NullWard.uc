class X2Effect_NullWard extends X2Effect_PersonalShield;

var int ShieldAmountPsiFactor;
var bool ShieldAmountPsiFactor_bCeiling;
var name ShieldAmountDamageTag;

simulated function int GetShieldAmount(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local int Shield;

    Shield = super.GetShieldAmount(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    Shield += GetAdditionalShieldAmountFromPsi(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    Shield += GetAdditionalShieldAmountFromDamageTag(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    return Shield;
}

simulated function int GetAdditionalShieldAmountFromPsi(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;

    if (ShieldAmountPsiFactor == 0)
        return 0;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        if (ShieldAmountPsiFactor_bCeiling)
            return FCeil(SourceUnit.GetCurrentStat(eStat_PsiOffense) / ShieldAmountPsiFactor);
        else
            return int(SourceUnit.GetCurrentStat(eStat_PsiOffense) / ShieldAmountPsiFactor);
    }

    return 0;
}


simulated function int GetAdditionalShieldAmountFromDamageTag(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Item    SourceItem;
    local X2WeaponTemplate      WeaponTemplate;
    local int Index;

    if (ShieldAmountDamageTag == '')
        return 0;

    SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

    if (SourceItem != none)
    {
        WeaponTemplate = X2WeaponTemplate(SourceItem.GetMyTemplate());
        if (WeaponTemplate != none)
        {
            Index = WeaponTemplate.ExtraDamage.Find('Tag', ShieldAmountDamageTag);
            if (Index != INDEX_NONE)
                return WeaponTemplate.ExtraDamage[Index].Damage;
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = "M31_Psi_NullWard"
}