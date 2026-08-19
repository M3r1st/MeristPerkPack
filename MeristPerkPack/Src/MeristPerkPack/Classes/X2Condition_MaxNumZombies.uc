class X2Condition_MaxNumZombies extends X2Condition;

struct MaxNumZombiesAbilityBonus
{
    var name RequiredAbility;
    var int NumBonus;
};

var int MaxNumZombies;
var array<MaxNumZombiesAbilityBonus> MaxNumZombiesAbilityBonuses;
var name LinkEffectName;

function int GetMaxNumZombies(XComGameState_Unit SourceUnit)
{
    local MaxNumZombiesAbilityBonus AbilityBonus;
    local int MaxNum;

    MaxNum = MaxNumZombies;
    foreach MaxNumZombiesAbilityBonuses(AbilityBonus)
    {
        if (SourceUnit.HasSoldierAbility(AbilityBonus.RequiredAbility, true))
        {
            MaxNum += AbilityBonus.NumBonus;
        }
    }

    return MaxNum;
}

function AddMaxNumZombiesAbilityBonus(name RequiredAbility, int NumBonus)
{
    local MaxNumZombiesAbilityBonus NewBonus;
    NewBonus.RequiredAbility = RequiredAbility;
    NewBonus.NumBonus = NumBonus;
    MaxNumZombiesAbilityBonuses.AddItem(NewBonus);
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
    local XComGameState_Unit SourceUnit;
    local name EffectName;
    local int NumZombies;

    SourceUnit = XComGameState_Unit(kSource);
    if (SourceUnit != none)
    {
        foreach SourceUnit.AppliedEffectNames(EffectName)
        {
            if (EffectName == LinkEffectName)
            {
                NumZombies++;
            }
        }

        if (NumZombies >= GetMaxNumZombies(SourceUnit))
        {
            return 'AA_AbilityUnavailable';
        }
    }

    return 'AA_Success'; 
}
