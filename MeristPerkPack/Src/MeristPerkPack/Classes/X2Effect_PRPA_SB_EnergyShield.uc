class X2Effect_PRPA_SB_EnergyShield extends X2Effect_PersonalShield dependson(X2AbilityCooldown_Extended) config(GameData_SoldierSkills);

var config array<AdditionalShieldAmountInfo> AdditionalShieldAmountFromConfig;
var config array<CooldownModifierInfo> EnergyShield_CooldownModifiers;
var privatewrite name EnergyShield_ShieldRemovedEventName;

var name Aegis_RequiredAbility;
var int Aegis_DamageReduction;

var name Holo_RequiredAbility;
var array<int> Holo_AimBonus;
var array<int> Holo_CritBonus;

var name Haste_RequiredAbility;
var array<int> Haste_MobilityBonus;

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    `assert(TargetUnit != none);

    `XEVENTMGR.TriggerEvent(default.EnergyShield_ShieldRemovedEventName, RemovedEffectState, TargetUnit, NewGameState);

    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{

    if (SourceHasSoldierAbility(EffectState.ApplyEffectParameters, Aegis_RequiredAbility))
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                return -1 * CurrentDamage * Aegis_DamageReduction / 100;
            }
        }
    }

    return 0;
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local XComGameState_Unit SourceUnit;
    local int Tech;

    if (SourceHasSoldierAbility(EffectState.ApplyEffectParameters, Holo_RequiredAbility))
    {
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

        if (SourceUnit != none)
        {
            Tech = `GetTechLevel(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());

            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = Holo_AimBonus[Clamp(Tech, 0, Holo_AimBonus.Length - 1)];
            ShotModifiers.AddItem(ShotInfo);

            ShotInfo.ModType = eHit_Crit;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = Holo_CritBonus[Clamp(Tech, 0, Holo_CritBonus.Length - 1)];
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

static function bool SourceHasSoldierAbility(const out EffectAppliedData ApplyEffectParameters, name AbilityName)
{
    local XComGameState_Unit    SourceUnit;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        return SourceUnit.HasSoldierAbility(AbilityName, true);
    }

    return false;
}

simulated function GetAdditionalStatChanges(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit;
    local int Tech;

    if (SourceHasSoldierAbility(ApplyEffectParameters, Haste_RequiredAbility))
    {
        SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
        if (SourceUnit == none)
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
        }

        if (SourceUnit != none)
        {
            Tech = `GetTechLevel(SourceUnit.GetItemInSlot(eInvSlot_Armor).GetMyTemplate());
            Tech = Clamp(Tech, 0, Haste_MobilityBonus.Length - 1);
            super(X2Effect_PersistentStatChange).AddPersistentStatChange(eStat_Mobility, Haste_MobilityBonus[Tech]);
        }
    }
}

defaultproperties
{
    EffectName = M31_PRPA_SB_EnergyShield
    EnergyShield_ShieldRemovedEventName = M31_PRPA_SB_EnergyShield_ShieldRemoved
}