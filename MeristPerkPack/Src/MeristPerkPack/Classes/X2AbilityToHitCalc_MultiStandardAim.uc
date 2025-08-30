class X2AbilityToHitCalc_MultiStandardAim extends X2AbilityToHitCalc_StandardAim;

var bool bMultiAllowCrit;
var bool bMultiHitsAreCrits;
var bool bMultiGuaranteedHit;
var bool bMultiIgnoreCoverBonus;
var float MultiFinalMultiplier;

var protected bool bCacheAllowCrit;
var protected bool bCacheHitsAreCrits;
var protected bool bCacheGuaranteedHit;
var protected bool bCacheIgnoreCoverBonus;
var protected float CacheFinalMultiplier;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
    local EAbilityHitResult HitResult;
    local int MultiIndex, CalculatedHitChance;
    local ArmorMitigationResults ArmorMitigated;

    if (bMultiTargetOnly)
    {
        ResultContext.HitResult = eHit_Success;
    }
    else
    {
        InternalRollForAbilityHit(kAbility, kTarget, true, ResultContext, HitResult, ArmorMitigated, CalculatedHitChance);
        ResultContext.HitResult = HitResult;
        ResultContext.ArmorMitigation = ArmorMitigated;
        ResultContext.CalculatedHitChance = CalculatedHitChance;
    }

    bCacheAllowCrit = bAllowCrit;
    bCacheHitsAreCrits = bHitsAreCrits;
    bCacheGuaranteedHit = bGuaranteedHit;
    bCacheIgnoreCoverBonus = bIgnoreCoverBonus;
    CacheFinalMultiplier = FinalMultiplier;

    bAllowCrit = bMultiAllowCrit;
    bHitsAreCrits = bMultiHitsAreCrits;
    bGuaranteedHit = bMultiGuaranteedHit;
    bIgnoreCoverBonus = bMultiIgnoreCoverBonus;
    FinalMultiplier = MultiFinalMultiplier;

    for (MultiIndex = 0; MultiIndex < kTarget.AdditionalTargets.Length; ++MultiIndex)
    {
        if (bOnlyMultiHitWithSuccess && class'XComGameStateContext_Ability'.static.IsHitResultMiss(HitResult))
        {
            ResultContext.MultiTargetHitResults.AddItem(eHit_Miss);
            ResultContext.MultiTargetArmorMitigation.AddItem(ArmorMitigated);
            ResultContext.MultiTargetStatContestResult.AddItem(0);
        }
        else
        {
            kTarget.PrimaryTarget = kTarget.AdditionalTargets[MultiIndex];
            InternalRollForAbilityHit(kAbility, kTarget, false, ResultContext, HitResult, ArmorMitigated, CalculatedHitChance);
            ResultContext.MultiTargetHitResults.AddItem(HitResult);
            ResultContext.MultiTargetArmorMitigation.AddItem(ArmorMitigated);
            ResultContext.MultiTargetStatContestResult.AddItem(0);
        }
    }
    
    bAllowCrit = bCacheAllowCrit;
    bHitsAreCrits = bCacheHitsAreCrits;
    bGuaranteedHit = bCacheGuaranteedHit;
    bIgnoreCoverBonus = bCacheIgnoreCoverBonus;
    FinalMultiplier = CacheFinalMultiplier;
}