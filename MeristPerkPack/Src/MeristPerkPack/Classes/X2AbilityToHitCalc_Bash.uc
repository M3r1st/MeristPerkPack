class X2AbilityToHitCalc_Bash extends X2AbilityToHitCalc_DeadEye;

var int BaseValue;
var array<int> PrimaryWeights;
var array<int> PrimaryCritWeights;
var array<int> SecondaryWeights;
var array<int> SecondaryCritWeights;
var ECharStatType DefenderStat;
var float DefenderStatWeight;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
    local int MultiTargetIndex;
    local ArmorMitigationResults NoArmor;

    ResultContext.HitResult = eHit_Success;
    ResultContext.StatContestResult = RollForEffectTier(kAbility, kTarget.PrimaryTarget, false);

    for (MultiTargetIndex = 0; MultiTargetIndex < kTarget.AdditionalTargets.Length; MultiTargetIndex++)
    {
        ResultContext.MultiTargetHitResults.AddItem(ResultContext.HitResult);
        ResultContext.MultiTargetArmorMitigation.AddItem(NoArmor);
        ResultContext.MultiTargetStatContestResult.AddItem(RollForEffectTier(kAbility, kTarget.AdditionalTargets[MultiTargetIndex], true));
    }
}

function int RollForEffectTier(XComGameState_Ability kAbility, StateObjectReference TargetRef, bool bMultiTarget)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    TargetState;
    local XComGameState_Effect  EffectState;
    local array<int>            Weights;
    local int                   TotalWeight, CurrentWeight;
    local int                   DefScore, RandRoll;
    local int                   i;

    History = `XCOMHISTORY;
    TargetState = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));

    EffectState = TargetState.GetUnitAffectedByEffectState(class'X2AbilitySet_PA_Berserker'.default.SmashCallbackEffectName);
    if (EffectState != none)
    {
        if (EffectState.ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
        {
            Weights = PrimaryCritWeights;
        }
        else
        {
            Weights = PrimaryWeights;
        }
    }
    else
    {
        EffectState = TargetState.GetUnitAffectedByEffectState(class'X2AbilitySet_PA_Berserker'.default.AftershockCallbackEffectName);
        if (EffectState != none)
        {
            if (EffectState.ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
            {
                Weights = SecondaryCritWeights;
            }
            else
            {
                Weights = SecondaryWeights;
            }
        }
    }

    if (Weights.Length > 0)
    {
        DefScore = BaseValue + TargetState.GetCurrentStat(DefenderStat) * DefenderStatWeight;
        for (i = 0; i < Weights.Length; i++)
        {
            TotalWeight += Weights[i];
        }
        CurrentWeight = TotalWeight;
        RandRoll = `SYNC_RAND(DefScore);
        for (i = Weights.Length - 1; i >= 0; i--)
        {
            CurrentWeight -= Weights[i];
            if (CurrentWeight <= RandRoll)
            {
                return i + 1;
            }
        }
    }

    return 0;
}

defaultproperties
{
    BaseValue = 50
    DefenderStat = eStat_Will
    DefenderStatWeight = 1.0f
}