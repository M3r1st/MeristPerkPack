class X2Effect_PA_TaipanBloodThirst extends X2Effect_BloodThirst;

simulated function int GetStackDuration(XComGameState_Unit SourceUnit)
{
    if (SourceUnit.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
        return iStackDuration + `GetConfigInt("M31_PA_TaipanBloodHunter_BonusDuration");
    else
        return iStackDuration;
}

simulated function int GetMaxStackCount(XComGameState_Unit SourceUnit)
{
    if (SourceUnit.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
        return iStackDuration + `GetConfigInt("M31_PA_TaipanBloodHunter_BonusMaxCount");
    else
        return iStackDuration;
}

simulated function int GetMaxStackCountPerTurn(XComGameState_Unit SourceUnit)
{
    if (SourceUnit.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
        return iStackDuration + `GetConfigInt("M31_PA_TaipanBloodHunter_BonusMaxCountPerTurn");
    else
        return iStackDuration;
}

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local XComGameState_Item        SourceWeapon;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local int Index;
    local int iDamagePerStack;
    local int DamageBonus;

    DamageBonus = super.GetPreDefaultAttackingDamageModifier_CH(EffectState, Attacker, TargetDamageable, AbilityState, AppliedData, CurrentDamage, WeaponDamageEffect, NewGameState);

    if (DamageBonus > 0)
        return DamageBonus;

    if (!Attacker.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
        return 0;

    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
        return 0;

    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;
    
    iDamagePerStack = iDefaultDamagePerStack;

    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    if (SourceWeapon != none)
    {
        for (Index = 0; Index < DamagePerStack.Length; Index++)
        {
            if (DamagePerStack[Index].ItemTemplate == SourceWeapon.GetMyTemplateName())
            {
                iDamagePerStack = DamagePerStack[Index].iDamagePerStack;
                break;
            }
        }
    }

    BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

    if (BloodThirstEffectState == none)
        return 0;

    DamageBonus = BloodThirstEffectState.GetTotalStacksRemaining() * iDamagePerStack;
    
    return DamageBonus * `GetConfigInt("M31_PA_TaipanBloodHunter_DamageModifierPrc") / 100;
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
    local XCGS_Effect_BloodThirst BloodThirstEffectState;
    local ShotModifierInfo CritInfo;
    local int Count;

    if (Attacker.HasSoldierAbility('M31_PA_TaipanBloodHunter', true))
    {
        BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);

        if (BloodThirstEffectState != none)
        {
            Count = BloodThirstEffectState.GetTotalStacksRemaining();
            if (Count != 0)
            {
                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = FriendlyName;
                CritInfo.Value = Count * `GetConfigInt("M31_PA_TaipanBloodHunter_CritBonusPerStack");
                ShotModifiers.AddItem(CritInfo);
            }
        }
    }
}