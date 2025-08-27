//---------------------------------------------------------------------------------------
//  FILE:    XCGS_Effect_EnergyShieldHandler.uc
//  AUTHOR:  Merist
//---------------------------------------------------------------------------------------
class XCGS_Effect_EnergyShieldHandler extends XComGameState_Effect;

struct ShieldEffectInfo
{
    var int EffectID;
    var name EffectName;
    var int ShieldPriority;
};

var array<ShieldEffectInfo> LinkedShieldEffects;

function LogShieldEffectStates(XComGameState GameState)
{
    local XCGS_Effect_EnergyShieldExtended  EffectState;
    local ShieldEffectInfo                  ShieldEffect;
    `LOG("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
    foreach LinkedShieldEffects(ShieldEffect)
    {
        EffectState = XCGS_Effect_EnergyShieldExtended(GameState.GetGameStateForObjectID(ShieldEffect.EffectID));

        if (EffectState != none)
        {
            `LOG(ShieldEffect.EffectName $ " --- Remaining Shields: " $ EffectState.ShieldRemaining $ " --- Priority: " $ EffectState.ShieldPriority, class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
        }
        else
        {
            `LOG("Error: effect with ID " $ ShieldEffect.EffectID $ " is not a shield effect", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
        }
    }
}

function EventListenerReturn ShieldsTakeDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameState_Unit                UnitState;
    local XComGameState_Unit                OldUnitState;
    local XCGS_Effect_EnergyShieldExtended  ShieldEffectState;
    local X2Effect_EnergyShieldExtended     ShieldEffect;
    local XComGameState                     NewGameState;
    local int ShieldDamageRemaining;
    local bool bShouldSubmitState;
    local int Index, x;
    
    UnitState = XComGameState_Unit(EventSource);
    OldUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ObjectID,, GameState.HistoryIndex - 1));
    ShieldDamageRemaining = OldUnitState.GetCurrentStat(eStat_ShieldHP) - UnitState.GetCurrentStat(eStat_ShieldHP);

    `LOG("Total damage to shields: " $ ShieldDamageRemaining, class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');

    for (Index = LinkedShieldEffects.Length - 1; Index >= 0 && ShieldDamageRemaining > 0; Index--)
    {
        bShouldSubmitState = true;
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
        ShieldEffectState = XCGS_Effect_EnergyShieldExtended(NewGameState.ModifyStateObject(class'XCGS_Effect_EnergyShieldExtended', LinkedShieldEffects[Index].EffectID));
        
        x = Min(ShieldDamageRemaining, ShieldEffectState.ShieldRemaining);
        ShieldDamageRemaining -= x;
        ShieldEffectState.ShieldRemaining -= x;

        `LOG("Damaging " $ ShieldEffectState.GetX2Effect().EffectName $ ":", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
        `LOG("    Remaining shield: " $ ShieldEffectState.ShieldRemaining, class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
        `LOG("    Remaining damage: " $ ShieldDamageRemaining,class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');

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
    local XCGS_Effect_EnergyShieldExtended      ShieldEffectState;
    local XComGameStateContext_EffectRemoved    EffectRemovedContext;
    local XComGameState                         NewGameState;
    local bool bAtLeastOneRemoved;
    local int Index;
    
    `LOG("Removing depleted shields", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
    for (Index = LinkedShieldEffects.Length - 1; Index >= 0; Index--)
    {
        ShieldEffectState = XCGS_Effect_EnergyShieldExtended(`XCOMHISTORY.GetGameStateForObjectID(LinkedShieldEffects[Index].EffectID));
        
        if (!ShieldEffectState.bRemoved && ShieldEffectState.ShieldRemaining == 0)
        {
            `LOG(ShieldEffectState.GetX2Effect().EffectName $ " ---- Shield Depleted", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
            if (!bAtLeastOneRemoved)
            {
                EffectRemovedContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(ShieldEffectState);
                NewGameState = `XCOMHISTORY.CreateNewGameState(true, EffectRemovedContext);
                ShieldEffectState.RemoveEffect(NewGameState, GameState);

                bAtLeastOneRemoved = true;
            }
            else
            {
                ShieldEffectState.RemoveEffect(NewGameState, GameState);
                EffectRemovedContext.RemovedEffects.AddItem(ShieldEffectState.GetReference());
            }
        }
    }
    if (bAtLeastOneRemoved)
    {
        LogShieldEffectStates(NewGameState);
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
    else
    {
        `LOG("No shields were depleted", class'X2DLCInfo_MeristEnhancedShieldEffects'.default.bLog, 'XCGS_Effect_EnergyShieldHandler');
    }
    return ELR_NoInterrupt;
}

simulated function bool AddShieldEffectToHandler(XCGS_Effect_EnergyShieldExtended EffectState)
{
    local ShieldEffectInfo NewEffectInfo;
    local int Index;

    if (EffectState == none)
        return false;

    for (Index = 0; Index < LinkedShieldEffects.Length && EffectState.ShieldPriority <= LinkedShieldEffects[Index].ShieldPriority; Index++)

    NewEffectInfo.EffectID = EffectState.ObjectID;
    NewEffectInfo.EffectName = EffectState.GetMyTemplateName();
    NewEffectInfo.ShieldPriority = EffectState.ShieldPriority;

    LinkedShieldEffects.InsertItem(Index, NewEffectInfo);

    return true;
}

simulated function bool RemoveShieldEffectFromHandler(XCGS_Effect_EnergyShieldExtended RemovedEffectState)
{
    local int Index;

    if (RemovedEffectState == none)
        return false;

    Index = LinkedShieldEffects.Find('EffectID', RemovedEffectState.ObjectID);
    if (Index != INDEX_NONE)
    {
        LinkedShieldEffects.Remove(Index, 1);
        return true;
    }

    return false;
}