class X2AbilityToHitCalc_Weight extends X2AbilityToHitCalc;

// Ordered array
var protected array<int> Weights;
var protected int TotalWeight;

function AddNextWeight(int Weight = 1)
{
    Weights.AddItem(Weight);
    TotalWeight += Weight;
}

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
    local ArmorMitigationResults NoArmor;
    local int RandRoll, i, MultiIndex, CurrentWeight;

    ResultContext.HitResult = eHit_Success;

    RandRoll = `SYNC_RAND(TotalWeight);

    CurrentWeight = 0;
    for (i = 0; i < Weights.Length; i++)
    {
        CurrentWeight += Weights[i];
        if (CurrentWeight > RandRoll)
            break;
    }
    ResultContext.StatContestResult = i + 1;

    for (MultiIndex = 0; MultiIndex < kTarget.AdditionalTargets.Length; ++MultiIndex)
    {
        ResultContext.MultiTargetHitResults.AddItem(eHit_Success);
        ResultContext.MultiTargetArmorMitigation.AddItem(NoArmor);

        CurrentWeight = 0;
        for (i = 0; i < Weights.Length; i++)
        {
            CurrentWeight += Weights[i];
            if (CurrentWeight > RandRoll)
                break;
        }
        ResultContext.MultiTargetStatContestResult.AddItem(i + 1);
    }
}

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog = false)
{
    return 100;
}

function int GetShotBreakdown(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog = false)
{
    m_ShotBreakdown.HideShotBreakdown = true;
    return 100;
}