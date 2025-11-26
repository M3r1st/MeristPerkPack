class X2Condition_CanBeHealed extends X2Condition;

var bool bExcludeFullHealth;
var array<name> EffectDamageTypes;
var array<name> EffectNames;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
    local XComGameState_Unit    TargetUnit;
    local name                  DamageType;
    local name                  EffectName;
    local bool                  bAfflicted;
    
    TargetUnit = XComGameState_Unit(kTarget);
    
    if (TargetUnit != none)
    {
        if (TargetUnit.GetCurrentStat(eStat_HP) == 0)
        {
            return 'AA_UnitIsDead';
        }

        foreach EffectDamageTypes(DamageType)
        {
            if (TargetUnit.IsUnitAffectedByDamageType(DamageType))
            {
                bAfflicted = true;
                break;
            }
        }

        if (!bAfflicted)
        {
            foreach EffectNames(EffectName)
            {
                if (TargetUnit.IsUnitAffectedByEffectName(EffectName))
                {
                    bAfflicted = true;
                    break;
                }
            }
        }

        if (!bAfflicted && bExcludeFullHealth && TargetUnit.GetCurrentStat(eStat_HP) == TargetUnit.GetMaxStat(eStat_HP))
        {
            return 'AA_UnitIsNotInjured';
        }
        
        return (bAfflicted ? 'AA_Success' : 'AA_MissingRequiredEffect');
    }
    else return 'AA_NotAUnit';
}

defaultproperties
{
    bExcludeFullHealth = true
}
