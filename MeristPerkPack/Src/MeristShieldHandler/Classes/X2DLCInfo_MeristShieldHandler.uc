class X2DLCInfo_MeristShieldHandler extends X2DownloadableContentInfo;

static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{
    class'XGS_ShieldHandler'.static.InitializeShieldHandler(StartGameState);
}