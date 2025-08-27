class X2Effect_PA_TaipanWatchThemRun extends X2Effect_Persistent;

var name EventName;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Unit                TargetUnit;
    local XComGameState_Ability             AbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local GameRulesCache_VisibilityInfo     VisInfo;
    local bool bFlanking;

    if (class'M31_AbilityHelpers'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
        return false;

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

    if (AbilityState != none && TargetUnit != none)
    {
        if (kAbility.IsAbilityInputTriggered())
        {
            AbilityTemplate = kAbility.GetMyTemplate();
            StandardAim = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
            if (StandardAim != none)
            {
                if (!StandardAim.bIndirectFire && !StandardAim.bReactionFire && !StandardAim.bMeleeAttack)
                {
                    if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
                    {
                        if (SourceUnit.CanFlank() && TargetUnit.GetMyTemplate().bCanTakeCover
                            && (VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0 && TargetUnit.GetTeam() != eTeam_XCom))
                            bFlanking = true;
                    }
                }
                if (AbilityTemplate.IsMelee() || bFlanking)
                {
                    // SourceUnit.SetUnitFloatValue(CounterName, iUsesThisTurn + 1.0, eCleanup_BeginTurn);
                    `XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
                }
            }
        }
    }

    return false;
}

defaultproperties
{
    EventName = M31_PA_TaipanWatchThemRun

    EffectName = M31_PA_TaipanWatchThemRun
    DuplicateResponse = eDupe_Ignore

}