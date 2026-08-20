class X2DLCInfo_MeristShieldHandler extends X2DownloadableContentInfo;

static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{
    class'XGS_ShieldHandler'.static.InitializeShieldHandler(StartGameState);
}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XGS_ShieldHandler     Handler;
    local ShieldEffectData      EffectData;
    local XComGameState_Effect  EffectState;

    switch (InString)
    {
        case "M31_ShieldRemaining":
            EffectState = XComGameState_Effect(ParseObj);
            if (EffectState != none)
            {
                Handler = class'XGS_ShieldHandler'.static.GetHandlerState(GameState);
                if (Handler != none)
                {
                    EffectData = Handler.GetEffectData(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID, EffectState.ObjectID);
                    OutString = string(EffectData.Amount);
                }
            }
            return true;

        case "M31_ShieldPriority":
            EffectState = XComGameState_Effect(ParseObj);
            if (EffectState != none)
            {
                Handler = class'XGS_ShieldHandler'.static.GetHandlerState(GameState);
                if (Handler != none)
                {
                    EffectData = Handler.GetEffectData(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID, EffectState.ObjectID);
                    OutString = string(EffectData.Priority);
                }
            }
            return true;
    }

    return false;
}