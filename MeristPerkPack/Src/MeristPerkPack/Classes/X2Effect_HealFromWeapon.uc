class X2Effect_HealFromWeapon extends X2Effect_Heal;

var array<int> HealAmount;
var name DamageTag;

simulated function int GetHealAmount(const out EffectAppliedData ApplyEffectParameters)
{
    local XComGameState_Ability AbilityState;
    local XComGameState_Item    SourceWeapon;
    local X2WeaponTemplate      WeaponTemplate;
    local int                   Index;
    local int                   Tech;

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    if (AbilityState != none)
    {
        SourceWeapon = AbilityState.GetSourceWeapon();
        if (SourceWeapon != none)
        {
            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            if (WeaponTemplate != none)
            {
                if (HealAmount.Length > 0)
                {
                    Tech = `GetTechLevel(AbilityState.GetSourceWeapon().GetMyTemplate());
                    Tech = Clamp(Tech, 0, HealAmount.Length - 1);
                    return HealAmount[Tech];
                }
                else if (DamageTag != '')
                {
                    Index = WeaponTemplate.ExtraDamage.Find('Tag', DamageTag);
                    return WeaponTemplate.ExtraDamage[Index].Damage;
                }
            }
        }
    }

    return 0;
}