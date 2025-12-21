class X2Condition_UnitValueOnSource extends X2Condition_UnitValue;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit UnitState;
    local name RetCode;
    local int Check, i;
    local UnitValue Value;

    RetCode = 'AA_Success';
    UnitState = XComGameState_Unit(kSource);
    if (UnitState != none)
    {
        for (i = 0; (i < m_aCheckValues.Length) && (RetCode == 'AA_Success'); ++i)
        {
            if (UnitState.GetUnitValue(m_aCheckValues[i].UnitValue, Value))
                Check = Value.fValue;
            else
                Check = 0;
            RetCode = PerformValueCheck(Check, m_aCheckValues[i].ConfigValue);

            if( RetCode != 'AA_Success' && m_aCheckValues[i].OptionalOverrideFalureCode != '' )
            {
                RetCode = m_aCheckValues[i].OptionalOverrideFalureCode;
            }
        }
    }
    return RetCode;
}

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    return 'AA_Success';
}