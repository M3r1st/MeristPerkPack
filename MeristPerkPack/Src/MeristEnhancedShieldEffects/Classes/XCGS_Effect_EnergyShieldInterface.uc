class XCGS_Effect_EnergyShieldInterface extends XComGameState_Effect;

var array<StateObjectReference> ShieldEffectRefs;
var array<name> ShieldEffectNames;
var array<int> ShieldEffectPriorities;

function LogShieldEffectStates(XComGameState GameState)
{
    local StateObjectReference EffectRef;
    local XCGS_Effect_EnergyShieldExtended EffectState;
    `LOG("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');
    foreach ShieldEffectRefs(EffectRef)
    {
        EffectState = XCGS_Effect_EnergyShieldExtended(GameState.GetGameStateForObjectID(EffectRef.ObjectID));

        `LOG(EffectState.GetX2Effect().EffectName $
        " --- Remaining Shields: " $ EffectState.ShieldRemaining $
            " --- Priority: " $ EffectState.ShieldPriority,
            class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');
    }
}

function EventListenerReturn ShieldsTakeDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameState_Unit                UnitState, PrevUnitState;
    local XCGS_Effect_EnergyShieldExtended  ShieldEffectState;
    local X2Effect_EnergyShieldExtended     ShieldEffect;
    local XComGameState                     NewGameState;
    local int ShieldDamageRemaining;
    local int i, x;
    local bool bShouldSubmitState;
    
    UnitState = XComGameState_Unit(EventSource);
    PrevUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ObjectID, , GameState.HistoryIndex - 1));
    ShieldDamageRemaining = PrevUnitState.GetCurrentStat(eStat_ShieldHP) - UnitState.GetCurrentStat(eStat_ShieldHP);
    `LOG("Total damage to shields: " $ ShieldDamageRemaining, class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');

    for (i = ShieldEffectRefs.Length - 1; i >= 0 && ShieldDamageRemaining > 0; i--)
    {
        bShouldSubmitState = true;
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
        ShieldEffectState = XCGS_Effect_EnergyShieldExtended(NewGameState.ModifyStateObject(class'XCGS_Effect_EnergyShieldExtended', ShieldEffectRefs[i].ObjectID));
        `LOG("Damaging " $ ShieldEffectState.GetX2Effect().EffectName $ ":",
            class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');

        x = Min(ShieldDamageRemaining, ShieldEffectState.ShieldRemaining);
        ShieldDamageRemaining -= x;
        ShieldEffectState.ShieldRemaining -= x;
        `LOG("    Remaining shield: " $ ShieldEffectState.ShieldRemaining,
            class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');
        `LOG("    Remaining damage: " $ ShieldDamageRemaining,
            class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');

        ShieldEffect = X2Effect_EnergyShieldExtended(ShieldEffectState.GetX2Effect());
        if (ShieldEffect.ShieldsTakeDamageFn != none)
            ShieldEffect.ShieldsTakeDamageFn(ShieldEffect, ShieldEffectState, NewGameState, UnitState, x);
    }
    if (bShouldSubmitState)
    {
        LogShieldEffectStates(NewGameState);
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
    return ELR_NoInterrupt;
}

function EventListenerReturn RemoveDepletedShields(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XCGS_Effect_EnergyShieldExtended  ShieldEffectState;
    local XComGameStateContext_EffectRemoved EffectRemovedContext;
    local XComGameState NewGameState;
    local int i;
    local bool bAtLeastOneRemoved;
    
    `LOG("Removing depleted shields.", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');
    for (i = ShieldEffectRefs.Length - 1; i >= 0; i--)
    {
        ShieldEffectState = XCGS_Effect_EnergyShieldExtended(`XCOMHISTORY.GetGameStateForObjectID(ShieldEffectRefs[i].ObjectID));
            
        if (!ShieldEffectState.bRemoved && ShieldEffectState.ShieldRemaining == 0)
        {
            `LOG(ShieldEffectState.GetX2Effect().EffectName $ " ---- Shield Depleted. Removing the effect.",
                class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');
            if (!bAtLeastOneRemoved)
            {
                EffectRemovedContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(ShieldEffectState);
                NewGameState = `XCOMHISTORY.CreateNewGameState(true, EffectRemovedContext);
                EffectRemovedContext.RemovedEffects.Length = 0;

                bAtLeastOneRemoved = true;
            }
            ShieldEffectState.RemoveEffect(NewGameState, GameState);
            EffectRemovedContext.RemovedEffects.AddItem(ShieldEffectState.GetReference());
        }
    }
    if (bAtLeastOneRemoved)
    {
        LogShieldEffectStates(NewGameState);
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
    else
    {
        `LOG("No shields were depleted.", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldInterface');
    }
    return ELR_NoInterrupt;
}

simulated function bool AddShieldEffectRefToInterface(
    XCGS_Effect_EnergyShieldExtended EffectState)
{
    local int i;

    if (EffectState == none)
        return false;

    i = 0;
    while (i < ShieldEffectPriorities.Length && EffectState.ShieldPriority < ShieldEffectPriorities[i])
        i++;

    ShieldEffectRefs.InsertItem(i, EffectState.GetReference());
    ShieldEffectNames.InsertItem(i, EffectState.GetMyTemplateName());
    ShieldEffectPriorities.InsertItem(i, EffectState.ShieldPriority);
    return true;
}

simulated function bool RemoveShieldEffectRefFromInterface(
    XCGS_Effect_EnergyShieldExtended RemovedEffectState)
{
    local int i;

    if (RemovedEffectState == none)
        return false;

    for (i = 0; i < ShieldEffectRefs.Length; i++)
    {
        if (ShieldEffectRefs[i].ObjectID == RemovedEffectState.ObjectID)
        {
            ShieldEffectRefs.Remove(i, 1);
            ShieldEffectNames.Remove(i, 1);
            ShieldEffectPriorities.Remove(i, 1);
            return true;
        }
    }
    return false;
}