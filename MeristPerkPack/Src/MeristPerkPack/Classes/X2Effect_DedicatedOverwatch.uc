class X2Effect_DedicatedOverwatch extends X2Effect_Persistent config(GameData_SoldierSkills);

var config array<name> OverwatchActionPointTypes;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;
    local XComGameState_Unit    TargetState;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'OverrideDamageRemovesReserveActionPoints', OnOverrideDamageRemovesReserveActionPoints, ELD_Immediate,, TargetState,, EffectObj);
}

static function EventListenerReturn OnOverrideDamageRemovesReserveActionPoints(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    local XComLWTuple           Tuple;
    local bool                  bDamageRemovesReserveActionPoints;
    local XComGameState_Unit    UnitState;
    local name                  ActionPointName;
    local bool                  bIsOverwatch;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideDamageRemovesReserveActionPoints');
    
    bDamageRemovesReserveActionPoints = Tuple.Data[0].b;

    if (bDamageRemovesReserveActionPoints)
    {
        UnitState = XComGameState_Unit(EventSource);
        if (UnitState != none)
        {
            foreach UnitState.ReserveActionPoints(ActionPointName)
            {
                if (default.OverwatchActionPointTypes.Find(ActionPointName) != INDEX_NONE)
                {
                    bIsOverwatch = true;
                    break;
                }
            }

            if (bIsOverwatch)
            {
                bDamageRemovesReserveActionPoints = false;
                Tuple.Data[0].b = bDamageRemovesReserveActionPoints;
            }
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    EffectName = M31_DedicatedOverwatch
    DuplicateResponse = eDupe_Ignore
}