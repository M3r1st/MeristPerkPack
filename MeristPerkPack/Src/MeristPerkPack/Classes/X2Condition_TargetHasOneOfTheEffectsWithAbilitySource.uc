class X2Condition_TargetHasOneOfTheEffectsWithAbilitySource extends X2Condition_TargetHasOneOfTheEffects;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    TargetUnit;
    local StateObjectReference  EffectRef;
    local XComGameState_Effect  EffectState;
    local X2Effect_Persistent   EffectTemplate;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit != none)
    {
        History = `XCOMHISTORY;

        foreach TargetUnit.AffectedByEffects(EffectRef)
        {
            EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
            EffectTemplate = EffectState.GetX2Effect();
            if (EffectNames.Find(EffectTemplate.EffectName) != INDEX_NONE
                && EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == kSource.ObjectID)
            {
                return 'AA_Success';
            }
        }
        return 'AA_MissingRequiredEffect';
    }
    else return 'AA_NotAUnit';
}
