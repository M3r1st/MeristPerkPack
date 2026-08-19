class X2Condition_SireHasSoldierAbilities extends X2Condition;

var name LinkEffectName;
var array<name> RequiredAbilities;
var bool bRequireAll;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
    local XComGameState_Unit    SireUnit, SourceUnit;
    local XComGameState_Effect  LinkEffectState;
    local name                  AbilityName;

    SourceUnit = XComGameState_Unit(kSource);

    if (SourceUnit != none)
    {
        LinkEffectState = SourceUnit.GetUnitAffectedByEffectState(LinkEffectName);
        if (LinkEffectState == none)
            return 'AA_MissingRequiredEffect';

        SireUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LinkEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
        if (SireUnit == none)
            return 'AA_AbilityUnavailable';

        if (RequiredAbilities.Length == 0)
            return 'AA_Success';

        foreach RequiredAbilities(AbilityName)
        {
            if (bRequireAll)
            {
                if (!SireUnit.HasSoldierAbility(AbilityName, true))
                {
                    return 'AA_AbilityUnavailable';
                }
            }
            else
            {
                if (SireUnit.HasSoldierAbility(AbilityName, true))
                {
                    return 'AA_Success';
                }
            }
        }
    }

    return (bRequireAll ? 'AA_Success' : 'AA_AbilityUnavailable');
}

defaultproperties
{
    bRequireAll = true
}