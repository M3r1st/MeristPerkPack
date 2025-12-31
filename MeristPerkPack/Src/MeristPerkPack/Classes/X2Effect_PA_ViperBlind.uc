class X2Effect_PA_ViperBlind extends X2Effect_Blind;

var int BonusDuration;

static function X2Effect_PA_ViperBlind CreateViperBlindEffect(int NumTurns, float SightRadiusMult, int Chance)
{
    local X2Effect_PA_ViperBlind Effect;

    Effect = new class'X2Effect_PA_ViperBlind';
    Effect.EffectName = class'X2AbilityTemplateManager'.default.BlindedName;
    Effect.AddPersistentStatChange(eStat_SightRadius, SightRadiusMult, MODOP_PostMultiplication);
    Effect.AddPersistentStatChange(eStat_DetectionRadius, SightRadiusMult, MODOP_PostMultiplication);
    Effect.ApplyChance = Chance;
    Effect.DamageTypes.AddItem('Blind');
    Effect.DamageTypes.AddItem('Poison');
    Effect.EffectAppliedEventName = 'UnitBlinded';
    Effect.BuildPersistentEffect(NumTurns, false, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Penalty, default.BlindName, default.BlindDesc, default.BlindStatusIcon);

    if (class'X2StatusEffects'.default.BlindedParticle_Name != "")
    {
        Effect.VFXTemplateName = class'X2StatusEffects'.default.BlindedParticle_Name;
        Effect.VFXSocket = class'X2StatusEffects'.default.BlindedSocket_Name;
        Effect.VFXSocketsArrayName = class'X2StatusEffects'.default.BlindedSocketsArray_Name;
    }

    return Effect;
}

function int GetStartingNumTurns(const out EffectAppliedData ApplyEffectParameters)
{
    local int NumTurns;

    NumTurns = super.GetStartingNumTurns(ApplyEffectParameters);
    if (EffectSourceHasBonusEffects(ApplyEffectParameters))
    {
        NumTurns += BonusDuration;
    }

    return NumTurns;
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