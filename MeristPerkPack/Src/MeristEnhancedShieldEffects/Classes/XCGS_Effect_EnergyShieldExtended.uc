//---------------------------------------------------------------------------------------
//  FILE:    XCGS_Effect_EnergyShieldExtended.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class XCGS_Effect_EnergyShieldExtended extends XComGameState_Effect;

var int HandlerID;
var int ShieldRemaining;
var int ShieldPriority;

simulated function bool SetHandlerID(XComGameState NewGameState)
{
    local XCGS_Effect_EnergyShieldHandler   HandlerEffectState;
    local XCGS_Effect_EnergyShieldExtended  NewEffectState;
    
    `LOG(GetX2Effect().EffectName $ " (" $ ObjectID $ ")", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, GetFuncName());

    if (HandlerID != 0)
    {
        `LOG("HandlerID is already set", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, GetFuncName());
        return false;
    }
        
    NewEffectState = XCGS_Effect_EnergyShieldExtended(NewGameState.ModifyStateObject(Class, ObjectID));

    foreach `XCOMHISTORY.IterateByClassType(class'XCGS_Effect_EnergyShieldHandler', HandlerEffectState)
    {
        if (HandlerEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
        {
            `LOG("    New HandlerID: " $ HandlerEffectState.ObjectID, class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, GetFuncName());
            NewEffectState.HandlerID = HandlerEffectState.ObjectID;
            return true;
        }
    }
    `LOG("    Error! Handler not found!", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, GetFuncName());

    return false;
}