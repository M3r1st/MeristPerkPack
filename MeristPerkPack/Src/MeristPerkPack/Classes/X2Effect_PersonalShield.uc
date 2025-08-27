class X2Effect_PersonalShield extends X2Effect_EnergyShieldExtended;

struct AdditionalShieldAmountInfo
{
    var name RequiredAbility;
    var int AdditionalAmount;
};

var int ShieldAmountBase;
var array<int> ShieldAmount;
var array<AdditionalShieldAmountInfo> AdditionalShieldAmount;
var bool bGetShieldAmountFromWeapon;
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

    if (bGetShieldAmountFromWeapon)
        Shield += GetShieldAmountFromWeapon(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    if (bGetShieldAmountFromArmor)
        Shield += GetShieldAmountFromArmor(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    Shield += GetAdditionalShieldAmountFromAbilities(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    return Shield;
}

simulated function int GetAdditionalShieldAmountFromAbilities(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;
    local AdditionalShieldAmountInfo Info;
    local int Shield;

    if (AdditionalShieldAmount.Length == 0)
        return 0;

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

simulated function int GetShieldAmountFromWeapon(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Item    SourceItem;
    local int Shield;
    local int Tier;

    SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    if (SourceItem == none)
        SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

    if (SourceItem != none)
    {
        Tier = class'X2DLCInfo_MeristPerkPack'.static.GetItemTech(SourceItem.GetMyTemplate());
        Tier = Clamp(Tier, 0, ShieldAmount.Length);
        Shield = ShieldAmount[Tier];
    }

    return Shield;
}

simulated function int GetShieldAmountFromArmor(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;
    local int Shield;
    local int Tier;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        Tier = class'X2DLCInfo_MeristPerkPack'.static.GetItemTech(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());
        Tier = Clamp(Tier, 0, ShieldAmount.Length);
        Shield = ShieldAmount[Tier];
    }

    return Shield;
}

defaultproperties
{
    EffectName = "M31_PersonalShield"
}