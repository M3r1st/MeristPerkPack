class X2AbilityToHitCalc_Aftershock extends X2AbilityToHitCalc_StandardAim;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
    local EAbilityHitResult HitResult;
    local int MultiIndex, CalculatedHitChance;
    local ArmorMitigationResults ArmorMitigated, NoArmor;

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

    for (MultiIndex = 0; MultiIndex < kTarget.AdditionalTargets.Length; ++MultiIndex)
    {
        if (bOnlyMultiHitWithSuccess && class'XComGameStateContext_Ability'.static.IsHitResultMiss(HitResult))
        {
            ResultContext.MultiTargetHitResults.AddItem(eHit_Miss);
            ResultContext.MultiTargetArmorMitigation.AddItem(NoArmor);
            ResultContext.MultiTargetStatContestResult.AddItem(0);
        }
        else
        {
            ResultContext.MultiTargetHitResults.AddItem(eHit_Success);
            ResultContext.MultiTargetArmorMitigation.AddItem(NoArmor);
            ResultContext.MultiTargetStatContestResult.AddItem(0);
        }
    }
}

defaultproperties
{
    bOnlyMultiHitWithSuccess = false
}