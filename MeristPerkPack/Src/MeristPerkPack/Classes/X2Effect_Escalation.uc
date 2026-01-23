class X2Effect_Escalation extends X2Effect_Persistent;

var int CritBonus;
var int CritDamageBonus;
var int CritDamageBonusFactor;
var int CritDamageBonusMinCrit;
var bool bMatchSourceWeapon;

function GetToHitModifiers(
    XComGameState_Effect
    EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local XCGS_Effect_HackBreakdown     HackBreakdown;
    local ShotModifierInfo              CritMod;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    HackBreakdown = XCGS_Effect_HackBreakdown(EffectState);
    if (HackBreakdown != none)
    {
        CritMod.ModType = eHit_Crit;
        CritMod.Value = HackBreakdown.Counter * CritBonus;
        CritMod.Reason = FriendlyName;

        ShotModifiers.AddItem(CritMod);
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
    local X2AbilityTemplate             AbilityTemplate;
    local XCGS_Effect_HackBreakdown     HackBreakdown;
    local int                           CritChance;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
        if (AbilityTemplate.AbilityToHitCalc != none)
        {
            HackBreakdown = XCGS_Effect_HackBreakdown(EffectState);
            if (HackBreakdown == none)
                return 0;

            CritChance = HackBreakdown.GetUncappedHitChance(AbilityTemplate, AbilityState, XComGameState_Unit(TargetDamageable), eHit_Crit);
            CritChance = Max(0, CritChance - CritDamageBonusMinCrit);
            if (NewGameState != none)
            {
                HackBreakdown = XCGS_Effect_HackBreakdown(NewGameState.ModifyStateObject(HackBreakdown.Class, HackBreakdown.ObjectID));
                HackBreakdown.Counter += 1;
            }
        }
        if (CurrentDamage > 0)
        {
            return CritDamageBonus * (CritChance / CritDamageBonusFactor);
        }
    }

    return 0;
}

defaultproperties
{
    bMatchSourceWeapon = true
    EffectName = M31_Escalation
    DuplicateResponse = eDupe_Refresh
    bDisplayInSpecialDamageMessageUI = true
    GameStateEffectClass = class'XCGS_Effect_HackBreakdown'
}