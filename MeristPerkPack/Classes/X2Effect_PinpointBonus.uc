class X2Effect_PinpointBonus extends X2Effect_Persistent;

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target, XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local array<name> AllowedActions;
    local int ActionPoints;
    local float CritDamageModifier;

    if (AbilityState.GetMyTemplateName() == 'M31_Pinpoint')
    {
        if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
        {
            AllowedActions.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
            AllowedActions.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);
            ActionPoints = class'M31_AbilityHelpers'.static.GetActionPoints(SourceUnit, AllowedActions);

            CritDamageModifier = (ActionPoints * `GetConfigInt("M31_Pinpoint_CritDamagePerAction") + `GetConfigInt("M31_Pinpoint_CritDamageBase")) / 100;
            return CurrentDamage * CritDamageModifier;
        }
    }
    return 0;
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local array<name> AllowedActions;
    local int ActionPoints;

    local int HitChanceBonus;
    local int CritChanceBonus;

    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;

    if (AbilityState.GetMyTemplateName() == 'M31_Pinpoint')
    {
        AllowedActions.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
        AllowedActions.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);
        ActionPoints = class'M31_AbilityHelpers'.static.GetActionPoints(Attacker, AllowedActions);

        HitChanceBonus = ActionPoints * `GetConfigInt("M31_Pinpoint_AimPerAction") + `GetConfigInt("M31_Pinpoint_AimBase");
        CritChanceBonus = ActionPoints * `GetConfigInt("M31_Pinpoint_CritPerAction") + `GetConfigInt("M31_Pinpoint_CritBase");

        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = HitChanceBonus;
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritChanceBonus;
        ShotModifiers.AddItem(CritInfo);
    }
}

DefaultProperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "M31_Pinpoint_Bonus"
    bDisplayInSpecialDamageMessageUI = true
}
