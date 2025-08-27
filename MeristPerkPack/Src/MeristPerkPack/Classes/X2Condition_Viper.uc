class X2Condition_Viper extends X2Condition config(GameData_SoldierSkills);

var config array<name> IncludeTypes;
var config array<name> IncludeTemplates;
var bool bExclude;


event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit == none)
        return 'AA_NotAUnit';

    if (default.IncludeTypes.Length > 0 && default.IncludeTypes.Find(TargetUnit.GetMyTemplateGroupName()) != INDEX_NONE)
        return (bExclude ? 'AA_UnitIsWrongType' : 'AA_Success');

    if (default.IncludeTemplates.Length > 0 && default.IncludeTemplates.Find(TargetUnit.GetMyTemplateName()) != INDEX_NONE)
        return (bExclude ? 'AA_UnitIsWrongType' : 'AA_Success');
    
    return (bExclude ? 'AA_Success' : 'AA_UnitIsWrongType');
}

static function X2Condition_Viper NotViperCondition()
{
    local X2Condition_Viper Condition;

    Condition = new class'X2Condition_Viper';
    Condition.bExclude = true;
    
    return Condition;
}