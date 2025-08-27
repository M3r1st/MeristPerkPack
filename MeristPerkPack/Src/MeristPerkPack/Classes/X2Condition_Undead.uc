class X2Condition_Undead extends X2Condition config(GameData_SoldierSkills);

var config array<name> IncludeTypes;
var config array<name> IncludeTemplates;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit == none)
        return 'AA_NotAUnit';

    if (default.IncludeTypes.Length > 0 && default.IncludeTypes.Find(TargetUnit.GetMyTemplateGroupName()) != INDEX_NONE)
        return 'AA_Success';

    if (default.IncludeTemplates.Length > 0 && default.IncludeTemplates.Find(TargetUnit.GetMyTemplateName()) != INDEX_NONE)
        return 'AA_Success';

    if (TargetUnit.AffectedByEffectNames.Find('MZZombify') != INDEX_NONE)
        return 'AA_Success';
    
    return 'AA_UnitIsWrongType';
}