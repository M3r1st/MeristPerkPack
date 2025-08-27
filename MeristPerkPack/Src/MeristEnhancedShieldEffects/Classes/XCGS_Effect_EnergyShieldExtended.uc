//---------------------------------------------------------------------------------------
//  FILE:    XCGS_Effect_EnergyShieldExtended.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class XCGS_Effect_EnergyShieldExtended extends XComGameState_Effect;

var int LinkedHandlerID;
var int ShieldRemaining;
var int ShieldPriority;

simulated function bool AddLinkedHandlerID()
{
    local XCGS_Effect_EnergyShieldHandler HandlerEffectState;

    `LOG("Trying to attach LinkedHandlerID to " $ GetMyTemplateName() $ " (" $ ObjectID $ ")", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldExtended');

    if (LinkedHandlerID != 0)
        return false;

    foreach `XCOMHISTORY.IterateByClassType(class'XCGS_Effect_EnergyShieldHandler', HandlerEffectState)
    {
        if (HandlerEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
        {
            `LOG("    SUCCESS!", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldExtended');
            LinkedHandlerID = HandlerEffectState.ObjectID;
            return true;
        }
    }
    `LOG("    FAILURE!", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldExtended');

    return false;
}