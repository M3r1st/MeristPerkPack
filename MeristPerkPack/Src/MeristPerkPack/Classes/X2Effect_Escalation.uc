class X2Effect_Escalation extends X2Effect_Persistent;

var int CritBonus;
var int CritDamageBonus;
var int CritDamageBonusFactor;

var private int ShotCounter;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameStateHistory		History;
    local XComGameState_Ability		SourceAbility;
    local XComGameState_Item		SourceWeapon;
    local ShotModifierInfo			ShotMod;

    if (Attacker == none)
        return;

    History = `XCOMHISTORY;

    SourceAbility = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    SourceWeapon = AbilityState.GetSourceWeapon();
    if (Attacker.FindAbility(SourceAbility.GetMyTemplateName(), SourceWeapon.GetReference()).ObjectID == 0)
        return;

    ShotMod.ModType = eHit_Crit;
    ShotMod.Value = ShotCounter * CritBonus;
    ShotMod.Reason = FriendlyName;

    ShotModifiers.AddItem(ShotMod);	
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
    local XComGameStateHistory							History;
    local XComGameState_Ability							SourceAbility;
    local XComGameState_Item							SourceWeapon;
    local X2AbilityTemplate								Template;
    local XCGS_Effect_HackBreakdown						HackBreakdown;
    local int											CritChance;
    local X2Effect_ApplyWeaponDamage					DamageEffect;

    if (Attacker == none)
        return 0;

    History = `XCOMHISTORY;

    SourceAbility = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    SourceWeapon = AbilityState.GetSourceWeapon();

    if (Attacker.FindAbility(SourceAbility.GetMyTemplateName(), SourceWeapon.GetReference()).ObjectID == 0)
        return 0;

    if (AppliedData.AbilityResultContext.HitResult != eHit_Crit)
        return 0;

    Template = AbilityState.GetMyTemplate();
    if (Template == none || Template.AbilityToHitCalc == none)
        return 0;

    HackBreakdown = XCGS_Effect_HackBreakdown(EffectState);
    if (HackBreakdown == none)
        return 0;

    CritChance = HackBreakdown.GetUncappedHitChance(Template, AbilityState, XComGameState_Unit(TargetDamageable), eHit_Crit);

    CritChance = CritChance - 100;

    if (NewGameState != none)
    {
        DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
        if (DamageEffect == none || DamageEffect.bIgnoreBaseDamage)
        {
            return 0;
        }
        if (AbilityState.SourceWeapon == SourceWeapon.GetReference() && AppliedData.AbilityResultContext.HitResult == eHit_Crit)
        {
            ShotCounter += 1;
        }
    }
    
    if (CritChance < 0) 
        return 0;

    return CritDamageBonus * (CritChance / CritDamageBonusFactor);
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "M31_Escalation"
    bDisplayInSpecialDamageMessageUI = true
    GameStateEffectClass = class'XCGS_Effect_HackBreakdown'
}