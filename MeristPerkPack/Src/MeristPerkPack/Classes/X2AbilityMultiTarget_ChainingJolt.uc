class X2AbilityMultiTarget_ChainingJolt extends X2AbilityMultiTarget_Chain;

var float fTargetRadius;
var int MaxTargets;

var array<float> arrTargetRadius;
var array<int> arrMaxTargets;

struct AbilityGrantedBonusChainRadius
{
    var name RequiredAbility;
    var float fBonusRadius;
};

struct AbilityGrantedBonusNumTargets
{
    var name RequiredAbility;
    var int BonusNumTargets;
};

var protected array<AbilityGrantedBonusChainRadius> AbilityBonusRadii;
var protected array<AbilityGrantedBonusNumTargets> AbilityBonusNumTargets;

function AddAbilityBonusRadius(name AbilityName, float BonusRadius)
{
    local AbilityGrantedBonusChainRadius Bonus;

    Bonus.RequiredAbility = AbilityName;
    Bonus.fBonusRadius = BonusRadius;
    AbilityBonusRadii.AddItem(Bonus);
}

function AddAbilityBonusNumTargets(name AbilityName, int BonusNumTargets)
{
    local AbilityGrantedBonusNumTargets Bonus;

    Bonus.RequiredAbility = AbilityName;
    Bonus.BonusNumTargets = BonusNumTargets;
    AbilityBonusNumTargets.AddItem(Bonus);
}

// in Units^2
simulated function float GetDistanceBetweenTargets(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit)
{
    local float RadiusInMeters, RadiusInUnits;
    local int Tech, Index;

    if (arrTargetRadius.Length > 0)
    {
        Tech = `GetTechLevel(Ability.GetSourceWeapon().GetMyTemplate());
        Tech = Clamp(Tech, 0, arrTargetRadius.Length - 1);
        RadiusInMeters = arrTargetRadius[Tech];
    }
    else
    {
        RadiusInMeters = fTargetRadius;
    }

    for (Index = 0; Index < AbilityBonusRadii.Length; Index++)
    {
        if (SourceUnit.HasSoldierAbility(AbilityBonusRadii[Index].RequiredAbility, true))
        {
            RadiusInMeters += AbilityBonusRadii[Index].fBonusRadius;
        }
    }

    RadiusInUnits = `METERSTOUNITS(RadiusInMeters);
    RadiusInUnits = Max(0, RadiusInUnits);
    return RadiusInUnits * RadiusInUnits + 1.0;
}

simulated function int GetMaxNumTargets(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit)
{
    local int NumTargets;
    local int Tech, Index;

    if (arrMaxTargets.Length > 0)
    {
        Tech = `GetTechLevel(Ability.GetSourceWeapon().GetMyTemplate());
        Tech = Clamp(Tech, 0, arrMaxTargets.Length - 1);
        NumTargets = arrMaxTargets[Tech];
    }
    else
    {
        NumTargets = MaxTargets;
    }

    for (Index = 0; Index < AbilityBonusRadii.Length; Index++)
    {
        if (SourceUnit.HasSoldierAbility(AbilityBonusNumTargets[Index].RequiredAbility, true))
        {
            NumTargets += AbilityBonusNumTargets[Index].BonusNumTargets;
        }
    }

    NumTargets = Max(0, NumTargets);
    return NumTargets;
}

defaultproperties
{
    bCentered = false
}
