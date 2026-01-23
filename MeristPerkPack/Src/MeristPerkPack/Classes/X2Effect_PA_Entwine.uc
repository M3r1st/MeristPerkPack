class X2Effect_PA_Entwine extends X2Effect_Persistent;

var int BindDefenseBonus;
var int BindDodgeBonus;
var int GrabAimBonus;
var int BindDamageBonus;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo  DefenseInfo, DodgeInfo;

    if (Target.IsUnitAffectedByEffectName(class'X2AbilityTemplateManager'.default.BoundName))
    {
        DefenseInfo.ModType = eHit_Success;
        DefenseInfo.Reason = FriendlyName;
        DefenseInfo.Value = -1 * BindDefenseBonus;
        ShotModifiers.AddItem(DefenseInfo);

        DodgeInfo.ModType = eHit_Graze;
        DodgeInfo.Reason = FriendlyName;
        DodgeInfo.Value = BindDodgeBonus;
        ShotModifiers.AddItem(DodgeInfo);
    }
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ModInfo;

    if (class'X2AbilitySet_ViperBindAndPull'.default.GetOverHere_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        ModInfo.ModType = eHit_Success;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = GrabAimBonus;
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
        if (class'X2AbilitySet_ViperBindAndPull'.default.Bind_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE
            || class'X2AbilitySet_ViperBindAndPull'.default.BindCrush_Abilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            if (CurrentDamage > 0)
            {
                return BindDamageBonus;
            }
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = M31_PA_Entwine
}