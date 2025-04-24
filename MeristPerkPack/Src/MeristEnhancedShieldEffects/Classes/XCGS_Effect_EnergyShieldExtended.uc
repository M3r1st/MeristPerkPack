class XCGS_Effect_EnergyShieldExtended extends XComGameState_Effect;

var StateObjectReference LinkedInterfaceEffectRef;
var int ShieldRemaining;
var int ShieldPriority;

simulated function bool AddLinkedInterfaceEffectRef()
{
    local XCGS_Effect_EnergyShieldInterface InterfaceEffectState;

    `LOG("Trying to attach LinkedInterfaceEffectRef.", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldExtended');

    if (LinkedInterfaceEffectRef.ObjectID != 0)
        return false;

    foreach `XCOMHISTORY.IterateByClassType(class'XCGS_Effect_EnergyShieldInterface', InterfaceEffectState)
    {
        if (InterfaceEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
        {
            `LOG("    SUCCESS!", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldExtended');
            LinkedInterfaceEffectRef = InterfaceEffectState.GetReference();
            return true;
        }
    }

    return false;
}