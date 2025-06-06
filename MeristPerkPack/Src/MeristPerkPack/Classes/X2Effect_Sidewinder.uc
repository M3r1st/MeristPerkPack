class X2Effect_Sidewinder extends X2Effect_Persistent;

var bool bDisableForFriendlyFire;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
    local X2AbilityTemplate                 AbilityTemplate;
    local X2AbilityToHitCalc_StandardAim    StandardAimHitCalc;
    local bool bDealsDamage;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
        return false;

    if (bDisableForFriendlyFire && Attacker.GetTeam() == TargetUnit.GetTeam())
        return false;

    AbilityTemplate = AbilityState.GetMyTemplate();
    if (AbilityTemplate == none)
        return false;

    bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);

    if (AbilityTemplate.Hostility == eHostility_Offensive && !AbilityTemplate.bIsASuppressionEffect && bDealsDamage)
    {
        StandardAimHitCalc = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
        if (StandardAimHitCalc != none && StandardAimHitCalc.bReactionFire == true)
        {
            return false;
        }
        if (TargetUnit.IsAbleToAct())
        {
            if (!TargetUnit.IsUnitAffectedByEffectName(class'X2AbilityTemplateManager'.default.BoundName) &&
                !TargetUnit.IsUnitAffectedByEffectName(class'X2AbilitySet_PlayableAliens'.default.SidewinderCooldownEffectName))
            {
                `LOG("Sidewinder activated. Current turn: " $ `TACTICALRULES.GetUnitActionTeam(), true, 'Merist_X2Effect_Sidewinder');
                NewHitResult = eHit_Miss;
                `XEVENTMGR.TriggerEvent(class'X2AbilitySet_PlayableAliens'.default.SidewinderEventName, TargetUnit, TargetUnit);
                return true;
            }
        }
    }

    return false;
}

DefaultProperties
{
    EffectName = "M31_Sidewinder"
    DuplicateResponse = eDupe_Ignore
}