class X2Effect_AdvancedOptics extends X2Effect_ModifyRangePenalties;

var privatewrite array<name> PistolCatergories;
var array<name> AllowedEffects;

var int DefenseIgnorePrc;


function bool AllowReactionFireCrit(XComGameState_Unit UnitState, XComGameState_Unit TargetState) 
{ 
    return ValidateEffects(TargetState);
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee, bool bFlanking, bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item    SourceWeapon;
    local X2WeaponTemplate      WeaponTemplate;
    local ShotModifierInfo      AimInfo;
    local int                   AimBonus;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return;

    if (!ValidateEffects(Target))
        return;

    SourceWeapon = AbilityState.GetSourceWeapon();
    
    if (SourceWeapon != none)
    {
        WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

        if (PistolCatergories.Find(WeaponTemplate.WeaponCat) == INDEX_NONE || !Attacker.HasSoldierAbility('Magnum_LW', true))
        {
            super.GetToHitModifiers(EffectState, Attacker, Target, AbilityState, ToHitType, bMelee, bFlanking, bIndirectFire, ShotModifiers);
        }
    }
    

    AimBonus = int(Target.GetBaseStat(eStat_Defense) * DefenseIgnorePrc / 100.0);
    AimBonus = Max(0, AimBonus);

    if (AimBonus > 0)
    {
        AimInfo.ModType = eHit_Success;
        if (bShowNamedModifier)
            AimInfo.Reason = FriendlyName;
        else
            AimInfo.Reason = class'XLocalizedData'.default.DefenseStat;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);
    }
}

protected function bool ValidateEffects(XComGameState_Unit UnitState)
{
    local name Effect;

    if (UnitState == none)
        return false;

    foreach AllowedEffects(Effect)
    {
        if (UnitState.AffectedByEffectNames.Find(Effect) != INDEX_NONE)
        {
            return true;
        }
    }
    
    return false;
}

defaultproperties
{
    PistolCatergories[0] = pistol
    PistolCatergories[1] = sidearm
    PistolCatergories[2] = PA_PistolCat
    PistolCatergories[3] = PA_MutonDevastatorLanceGunCat
}