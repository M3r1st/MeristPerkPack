class X2Condition_TooHeavyToPull extends X2Condition config(GameData_SoldierSkills);

var config array<name> ExcludeCharacterTemplates;
var config array<name> ExcludeCharacterGroups;
var config array<name> ExcludeTargetAbilities;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit TargetUnit;
    local name AbilityName;

    TargetUnit = XComGameState_Unit(kTarget);

    if (TargetUnit == none)
        return 'AA_NotAUnit';

    if (default.ExcludeCharacterTemplates.Length > 0 && default.ExcludeCharacterTemplates.Find(TargetUnit.GetMyTemplateName()) != INDEX_NONE)
        return 'AA_UnitIsImmune';

    if (default.ExcludeCharacterGroups.Length > 0 && default.ExcludeCharacterGroups.Find(TargetUnit.GetMyTemplateGroupName()) != INDEX_NONE)
        return 'AA_UnitIsImmune';

    foreach default.ExcludeTargetAbilities(AbilityName)
        if (TargetUnit.HasSoldierAbility(AbilityName, true))
            return 'AA_UnitIsImmune';

    return 'AA_Success';
}