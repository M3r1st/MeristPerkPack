class X2Effect_MarkForDeath extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager		EventMgr;
	local XComGameState_Unit	SourceUnitState;
	local Object				EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'M31_CA_MarkForDeath_Refund', AbilityTriggerEventListener_RemoveMark, ELD_OnStateSubmitted, 30, SourceUnitState,, EffectObj);
}

static function EventListenerReturn AbilityTriggerEventListener_RemoveMark(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Effect EffectState;

    EffectState = XComGameState_Effect(CallbackData);
	EffectState.RemoveEffect(GameState, GameState, true);

	return ELR_NoInterrupt;
}