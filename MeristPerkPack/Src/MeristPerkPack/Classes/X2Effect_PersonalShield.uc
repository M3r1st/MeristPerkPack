class X2Effect_PersonalShield extends X2Effect_EnergyShield implements(ShieldInterface);

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

var int ShieldPriority;
var array<StatChange> AdditionalStatChanges;

var localized string strFriendlyName;
var localized string strFriendlyDesc;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local int ShieldStrength;

    m_aStatChanges.Length = 0;

    ShieldStrength = GetShieldAmount(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
    super(X2Effect_PersistentStatChange).AddPersistentStatChange(eStat_ShieldHP, ShieldStrength);
    GetAdditionalStatChanges(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

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

simulated function int GetShieldAmountPreview(XComGameState_Ability AbilityState)
{
    local XComGameState_Item    SourceWeapon;
    local XComGameState_Unit    SourceUnit;
    local AdditionalShieldAmountInfo Info;
    local int                   Tech;
    local int                   Shield;

    Shield = ShieldAmountBase;

    if (bGetShieldAmountFromWeapon)
    {
        SourceWeapon = AbilityState.GetSourceWeapon();

        if (SourceWeapon != none)
        {
            Tech = `GetTechLevel(SourceWeapon.GetMyTemplate());
            Tech = Clamp(Tech, 0, ShieldAmount.Length - 1);
            Shield += ShieldAmount[Tech];
        }
    }

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    if (SourceUnit != none)
    {
        if (bGetShieldAmountFromArmor)
        {
            Tech = `GetTechLevel(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());
            Tech = Clamp(Tech, 0, ShieldAmount.Length - 1);
            Shield += ShieldAmount[Tech];
        }

        foreach AdditionalShieldAmount(Info)
        {
            if (SourceUnit.HasSoldierAbility(Info.RequiredAbility, true))
            {
                Shield += Info.AdditionalAmount;
            }
        }
    }

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
            if (SourceUnit.HasSoldierAbility(Info.RequiredAbility, true))
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
    local int                   Shield;
    local int                   Tech;

    SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    if (SourceItem == none)
        SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

    if (SourceItem != none)
    {
        Tech = `GetTechLevel(SourceItem.GetMyTemplate());
        Tech = Clamp(Tech, 0, ShieldAmount.Length - 1);
        Shield = ShieldAmount[Tech];
    }

    return Shield;
}

simulated function int GetShieldAmountFromArmor(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit    SourceUnit;
    local int                   Shield;
    local int                   Tech;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        Tech = `GetTechLevel(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());
        Tech = Clamp(Tech, 0, ShieldAmount.Length - 1);
        Shield = ShieldAmount[Tech];
    }

    return Shield;
}

simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, optional EStatModOp InModOp = MODOP_Addition)
{
    local StatChange NewChange;
    
    NewChange.StatType = StatType;
    NewChange.StatAmount = StatAmount;
    NewChange.ModOp = InModOp;

    AdditionalStatChanges.AddItem(NewChange);
}

simulated function GetAdditionalStatChanges(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState);

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect) { return true; }

// Override definition in X2Effect_EnergyShield
function RegisterForEvents(XComGameState_Effect EffectGameState);


// Start ShieldInterface

function ShieldsTakeDamage(int DamageTaken, const out ShieldEffectData CurrentShieldData, XComGameState_Effect kNewEffectState, XComGameState_Unit kTargetUnitState, XComGameState NewGameState);

function bool OverrideShouldRemoveEffect() { return false; }

function bool ShouldRemoveEffect(int DamageTaken, const out ShieldEffectData CurrentShieldData, XComGameState_Effect kNewEffectState, XComGameState_Unit kTargetUnitState, XComGameState NewGameState) { return false; }

function int GetShieldPriority() { return ShieldPriority; }

function bool RemoveWhenDepleted() { return true; }

static function int GetShieldAmountPreviewFromParseObj(Object ParseObj, Object StrategyParseObj, XComGameState GameState,
    optional bool bCheckShooterEffects = true, optional bool bCheckTargetEffects = true, optional bool bCheckMultiTargetEffects = true)
{
    local XComGameState_Effect  EffectState;
    local XComGameState_Ability AbilityState;
    local X2AbilityTemplate     AbilityTemplate;
    local X2Effect_PersonalShield ShieldEffect;
    local int i;

    EffectState = XComGameState_Effect(ParseObj);
    AbilityState = XComGameState_Ability(ParseObj);
    AbilityTemplate = X2AbilityTemplate(ParseObj);

    if (EffectState != none)
    {
        AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    }
    if (AbilityState != none)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
    }

    if (AbilityTemplate != none)
    {
        if (bCheckShooterEffects)
        {
            for (i = 0; i < AbilityTemplate.AbilityShooterEffects.Length; i++)
            {
                ShieldEffect = X2Effect_PersonalShield(AbilityTemplate.AbilityShooterEffects[i]);
                if (ShieldEffect != none)
                {
                    return ShieldEffect.GetShieldAmountPreview(AbilityState);
                }
            }
        }

        if (bCheckTargetEffects)
        {
            for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; i++)
            {
                ShieldEffect = X2Effect_PersonalShield(AbilityTemplate.AbilityTargetEffects[i]);
                if (ShieldEffect != none)
                {
                    return ShieldEffect.GetShieldAmountPreview(AbilityState);
                }
            }
        }

        if (bCheckMultiTargetEffects)
        {
            for (i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; i++)
            {
                ShieldEffect = X2Effect_PersonalShield(AbilityTemplate.AbilityMultiTargetEffects[i]);
                if (ShieldEffect != none)
                {
                    return ShieldEffect.GetShieldAmountPreview(AbilityState);
                }
            }
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = M31_PersonalShield
}