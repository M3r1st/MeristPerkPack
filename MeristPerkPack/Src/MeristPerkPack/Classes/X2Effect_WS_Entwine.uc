class X2Effect_WS_Entwine extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo	ModInfo;

    if (Target.IsUnitAffectedByEffectName(class'X2AbilityTemplateManager'.default.BoundName))
    {
        ModInfo.ModType = eHit_Graze;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = -1 * `GetConfigInt("M31_PA_WS_Entwine_DodgeBonus");
        ShotModifiers.AddItem(ModInfo);
    }
}

function int GetAttackingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    optional XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(TargetDamageable);

    if (TargetUnit != none)
    {
        if (class'X2AbilitySet_PlayableAliens'.default.Bind_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE
            || class'X2AbilitySet_PlayableAliens'.default.BindSustained_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            if (CurrentDamage > 0)
            {
                return `GetConfigInt("M31_PA_WS_Entwine_BindDamageBonus");
            }
        }
    }

    return 0;
}