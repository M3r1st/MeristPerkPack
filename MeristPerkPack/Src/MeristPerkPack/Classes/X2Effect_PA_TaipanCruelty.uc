class X2Effect_PA_TaipanCruelty extends X2Effect_Persistent;

var int DamageBonusPrc;
var name EventName;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Unit TargetUnit;
    local X2AbilityTemplate AbilityTemplate;
    local bool bDealsDamage;

    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

    if (TargetUnit == none)
        return false;

    AbilityTemplate = kAbility.GetMyTemplate();
    bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(kAbility.GetSourceWeapon(), kAbility);
    if (AbilityTemplate.Hostility == eHostility_Offensive && bDealsDamage)
    {
        if (AbilityContext.ResultContext.HitResult == eHit_Crit)
        {
            `XEVENTMGR.TriggerEvent(EventName, kAbility, SourceUnit, NewGameState);
        }
    }
    return false;
}

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    TargetUnit = XComGameState_Unit(Target);

    if (TargetUnit == none)
        return 0;

    if (TargetUnit.IsStunned() || TargetUnit.IsPanicked())
        return CurrentDamage * DamageBonusPrc / 100;

    return 0;
}

defaultproperties
{
    EventName = M31_PA_TaipanCruelty
    bDisplayInSpecialDamageMessageUI = true
    DuplicateResponse = eDupe_Ignore
}
