class X2Effect_WS_Maelstrom extends X2Effect_Persistent;

var array<name> AllowedAbilities;

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
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    local bool bBallista;

    if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (Target == none)
        return;

    bBallista = class'X2Effect_WS_ApplyBoltDamage'.static.IsSourceWeaponBallista(AbilityState);

    if (!Target.CanTakeCover())
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = (bBallista ? `GetConfigInt("M31_PA_WS_Bolt_Maelstrom_CritBonus_Ballista") : `GetConfigInt("M31_PA_WS_Bolt_Maelstrom_CritBonus"));
        ShotModifiers.AddItem(CritInfo);
    }

    if (Target.UnitSize > 1)
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = (bBallista ? `GetConfigInt("M31_PA_WS_Bolt_Maelstrom_AimBonus_Ballista") : `GetConfigInt("M31_PA_WS_Bolt_Maelstrom_AimBonus"));
        ShotModifiers.AddItem(AimInfo);
    }
}

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local X2AbilityTemplate             AbilityTemplate;
    local XCGS_Effect_WS_Maelstrom      MaelstromEffectState;
    local int                           FinalOverflow;

    if (SourceUnit == none)
        return 0;

    if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    AbilityTemplate = AbilityState.GetMyTemplate();
    if (AbilityTemplate == none || X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc) == none || WeaponDamageEffect.bIgnoreBaseDamage)
        return 0;

    MaelstromEffectState = XCGS_Effect_WS_Maelstrom(EffectState);
    if (MaelstromEffectState == none)
        return 0;

    FinalOverflow = MaelstromEffectState.GetFinalOverflow(AbilityTemplate, AbilityState, XComGameState_Unit(Target));

    return CurrentDamage * (FinalOverflow / 100);
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    bDisplayInSpecialDamageMessageUI = true
    GameStateEffectClass = class'XCGS_Effect_WS_Maelstrom'
}