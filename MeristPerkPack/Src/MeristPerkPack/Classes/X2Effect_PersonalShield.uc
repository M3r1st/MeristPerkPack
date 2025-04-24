class X2Effect_PersonalShield extends X2Effect_EnergyShieldExtended;

struct AdditionalShieldAmountInfo
{
    var name RequiredAbility;
    var int AdditionalAmount;
};

var int ShieldAmountBase;
var array<int> ShieldAmount;
var array<AdditionalShieldAmountInfo> AdditionalShieldAmount;
var bool bGetShieldAmountFromGremlin;
var bool bGetShieldAmountFromArmor;

function AddAdditionalShieldAmount(name RequiredAbility, int Modifier)
{
    local AdditionalShieldAmountInfo ShieldModifier;
    ShieldModifier.RequiredAbility = RequiredAbility;
    ShieldModifier.AdditionalAmount = Modifier;
    AdditionalShieldAmount.AddItem(ShieldModifier);
}

simulated function int GetShieldAmount(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local int Shield;

    Shield = ShieldAmountBase;

    if (bGetShieldAmountFromGremlin)
        Shield += GetShieldAmountFromGremlin(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    if (bGetShieldAmountFromArmor)
        Shield += GetShieldAmountFromArmor(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    Shield += GetAdditionalShieldAmountFromAbilities(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    return Shield;
}

simulated function int GetAdditionalShieldAmountFromAbilities(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit    SourceUnit;
    local AdditionalShieldAmountInfo Info;
    local int                   Shield;

    if (AdditionalShieldAmount.Length == 0)
        return 0;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        foreach AdditionalShieldAmount(Info)
        {
            if (SourceUnit.HasSoldierAbility(Info.RequiredAbility))
            {
                Shield += Info.AdditionalAmount;
            }
        }
    }

    return Shield;
}

simulated function int GetShieldAmountFromGremlin(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Item    SourceItem;
    local X2GremlinTemplate     GremlinTemplate;
    local int                   Shield;

    SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    if (SourceItem == none)
        SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

    if (SourceItem != none)
    {
        GremlinTemplate = X2GremlinTemplate(SourceItem.GetMyTemplate());
        if (GremlinTemplate != none)
        {
            switch (GremlinTemplate.WeaponTech)
            {
                case 'beam':        Shield = ShieldAmount[2]; break;
                case 'magnetic':    Shield = ShieldAmount[1]; break;
                default:            Shield = ShieldAmount[0]; break;
            }
        }
    }

    return Shield;
}

simulated function int GetShieldAmountFromArmor(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit    SourceUnit;
    local X2ArmorTemplate       ArmorTemplate;
    local int Shield;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        ArmorTemplate = X2ArmorTemplate(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());

        if (ArmorTemplate != none)
        {
            switch (ArmorTemplate.ArmorTechCat)
            {
                case 'Powered':     Shield = ShieldAmount[2]; break;
                case 'Plated':      Shield = ShieldAmount[1]; break;
                default:            Shield = ShieldAmount[0]; break;
            }
        }
    }

    return Shield;
}

defaultproperties
{
    EffectName = "M31_PersonalShield"
}