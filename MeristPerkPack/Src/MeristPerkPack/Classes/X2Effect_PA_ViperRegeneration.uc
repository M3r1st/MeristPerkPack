class X2Effect_PA_ViperRegeneration extends X2Effect_Regeneration;

var int BonusDuration;
var int BonusHealAmount;

var array<name> EffectNamesToRemove;
var array<name> DamageTypesToRemove;
var array<name> ImmuneTypes;

var array<name> BonusEffectNamesToRemove;
var array<name> BonusDamageTypesToRemove;
var array<name> BonusImmuneTypes;

var localized string strFriendlyDesc;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    OldTargetState;
    local StateObjectReference  EffectRef;
    local XComGameState_Effect  EffectState;
    local X2Effect_Persistent   PersistentEffect;

    History = `XCOMHISTORY;

    if (EffectSourceHasBonusEffects(ApplyEffectParameters))
    {
        NewEffectState.iTurnsRemaining += BonusDuration;
    }

    OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (OldTargetState != none)
    {
        foreach OldTargetState.AffectedByEffects(EffectRef)
        {
            EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
            if (EffectState != none && !EffectState.bRemoved)
            {
                PersistentEffect = EffectState.GetX2Effect();
                if (ShouldRemoveEffect(EffectState, PersistentEffect))
                {
                    EffectState.RemoveEffect(NewGameState, NewGameState, true);
                }
            }
        }
    }

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function bool EffectSourceHasBonusEffects(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameState_Unit SourceUnit;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if (SourceUnit != none)
    {
        return SourceUnit.HasSoldierAbility(class'X2AbilitySet_PA_Viper'.default.EnhancedPoisonAbilityName, true);
    }

    return false;
}


simulated function bool ShouldRemoveEffect(XComGameState_Effect EffectState, X2Effect_Persistent PersistentEffect)
{
    local name DamageType;

    if (EffectSourceHasBonusEffects(EffectState.ApplyEffectParameters))
    {
        foreach PersistentEffect.DamageTypes(DamageType)
        {
            if (DamageTypesToRemove.Find(DamageType) != INDEX_NONE || DamageTypesToRemove.Find(DamageType) != INDEX_NONE)
                return true;
        }

        return EffectNamesToRemove.Find(PersistentEffect.EffectName) != INDEX_NONE || BonusEffectNamesToRemove.Find(PersistentEffect.EffectName) != INDEX_NONE;
    }

    foreach PersistentEffect.DamageTypes(DamageType)
    {
        if (BonusDamageTypesToRemove.Find(DamageType) != INDEX_NONE)
            return true;
    }

    return BonusEffectNamesToRemove.Find(PersistentEffect.EffectName) != INDEX_NONE;
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
    if (EffectSourceHasBonusEffects(EffectState.ApplyEffectParameters))
    {
        return ImmuneTypes.Find(DamageType) != INDEX_NONE || BonusImmuneTypes.Find(DamageType) != INDEX_NONE;
    }

    return ImmuneTypes.Find(DamageType) != INDEX_NONE;
}

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
    return true;
}

function bool ViperRegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    OldTargetState, NewTargetState;
    local UnitValue             HealthRegenerated;
    local int                   AmountToHeal, Healed;

    History = `XCOMHISTORY;

    OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (OldTargetState != none)
    {
        if (OldTargetState.IsDead())
            return false;

        AmountToHeal = HealAmount;
        if (EffectSourceHasBonusEffects(ApplyEffectParameters))
        {
            AmountToHeal += BonusHealAmount;
        }

        if (HealthRegeneratedName != '' && MaxHealAmount > 0)
        {
            OldTargetState.GetUnitValue(HealthRegeneratedName, HealthRegenerated);

            // If the unit has already been healed the maximum number of times, do not regen
            if (HealthRegenerated.fValue >= MaxHealAmount)
            {
                return false;
            }
            else
            {
                // Ensure the unit is not healed for more than the maximum allowed amount
                AmountToHeal = Min(AmountToHeal, (MaxHealAmount - HealthRegenerated.fValue));
            }
        }

        NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
        NewTargetState.ModifyCurrentStat(estat_HP, AmountToHeal);

        if (EventToTriggerOnHeal != '')
        {
            `XEVENTMGR.TriggerEvent(EventToTriggerOnHeal, NewTargetState, NewTargetState, NewGameState);
        }

        // If this health regen is being tracked, save how much the unit was healed
        if (HealthRegeneratedName != '')
        {
            Healed = NewTargetState.GetCurrentStat(eStat_HP) - OldTargetState.GetCurrentStat(eStat_HP);
            if (Healed > 0)
            {
                NewTargetState.SetUnitFloatValue(HealthRegeneratedName, HealthRegenerated.fValue + Healed, eCleanup_BeginTactical);
                
            }
        }
    }

    return false;
}

defaultproperties
{
    EffectName = M31_PA_ViperRegeneration
    DuplicateResponse = eDupe_Refresh
    EffectTickedFn = ViperRegenerationTicked
    bTickWhenApplied = true
}