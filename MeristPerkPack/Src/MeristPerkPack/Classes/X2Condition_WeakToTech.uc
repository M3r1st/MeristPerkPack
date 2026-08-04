class X2Condition_WeakToTech extends X2Condition;

var bool bRequireNotWeak;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
    local XComGameState_Unit    TargetUnit;
    local X2CharacterTemplate   CharacterTemplate;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit != none)
    {
        CharacterTemplate = TargetUnit.GetMyTemplate();
        if (CharacterTemplate.bIsRobotic || CharacterTemplate.bWeakAgainstTechLikeRobot)
        {
            return (bRequireNotWeak ? 'AA_UnitIsRobotic' : 'AA_Success');
        }
        else
        {
            return (bRequireNotWeak ? 'AA_Success' : 'AA_UnitIsOrganic'); 
        }
    }
    else return 'AA_NotAUnit';
}
