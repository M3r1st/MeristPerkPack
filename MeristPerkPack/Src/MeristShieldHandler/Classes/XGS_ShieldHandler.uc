class XGS_ShieldHandler extends XComGameState_BaseObject;

struct UnitShieldData
{
    var int UnitID;
    var array<ShieldEffectData> Effects;
};

struct ShieldEffectData
{
    var int EffectID;
    var int Amount;
    var int Priority;
    var int ShieldCached;
    var bool bRemoveWhenDepleted;
    var bool bShouldRemove;
    var bool bCleansed;
    var bool bPurge;

    structdefaultproperties
    {
        Priority = 50
        bRemoveWhenDepleted = true
    }
};

var bool bRequiresUpdate;
var privatewrite name UpdateEventName;

var array<UnitShieldData> UnitData;

static function InitializeShieldHandler(XComGameState StartGameState)
{
    StartGameState.CreateNewStateObject(class'XGS_ShieldHandler');
}

static function XGS_ShieldHandler GetHandlerState(optional XComGameState GameState, optional bool bNewGameState)
{
    local XComGameStateHistory  History;
    local XGS_ShieldHandler     Handler;

    History = `XCOMHISTORY;

    if (GameState != none)
    {
        foreach GameState.IterateByClassType(class'XGS_ShieldHandler', Handler)
        {
            return Handler;
        }

        Handler = XGS_ShieldHandler(History.GetSingleGameStateObjectForClass(class'XGS_ShieldHandler', true));
        if (Handler != none && bNewGameState)
        {
            Handler = XGS_ShieldHandler(GameState.ModifyStateObject(Handler.Class, Handler.ObjectID));
        }
    }
    else
    {
        Handler = XGS_ShieldHandler(History.GetSingleGameStateObjectForClass(class'XGS_ShieldHandler', true));
    }

    return Handler;
}

function UpdateShieldEffectData(int UnitID, int EffectID, optional int Amount, optional int Priority = 50, optional bool bRemoveWhenDepleted = true)
{
    local UnitShieldData    NewUnitData;
    local ShieldEffectData  NewEffectData;
    local int               Index, EffectIndex;

    Index = UnitData.Find('UnitID', UnitID);

    if (Index != INDEX_NONE)
    {
        EffectIndex = UnitData[Index].Effects.Find('EffectID', EffectID);
        if (EffectIndex != INDEX_NONE)
        {
            UnitData[Index].Effects[EffectIndex].Amount = Amount;
            UnitData[Index].Effects[EffectIndex].Priority = Priority;
        }
        else
        {
            NewEffectData.EffectID = EffectID;
            NewEffectData.Amount = Amount;
            NewEffectData.Priority = Priority;
            NewEffectData.bRemoveWhenDepleted = bRemoveWhenDepleted;

            UnitData[Index].Effects.AddItem(NewEffectData);
        }
    }
    else
    {
        NewEffectData.EffectID = EffectID;
        NewEffectData.Amount = Amount;
        NewEffectData.Priority = Priority;
        NewEffectData.bRemoveWhenDepleted = bRemoveWhenDepleted;

        NewUnitData.UnitID = UnitID;
        NewUnitData.Effects.AddItem(NewEffectData);

        UnitData.AddItem(NewUnitData);
    }
}

static function IsEffectValidForHandling(XComGameState_Effect EffectState)
{
    local X2Effect_Persistent PersistentEffect;
    local ShieldInterface ShieldInterface;

    PersistentEffect = X2Effect_Persistent(EffectState.GetX2Effect());
    ShieldInterface = ShieldInterface(PersistentEffect);

    if (ShieldInterface != none)
    {
        return ShieldInterface.CanBeHandled();
    }
    
    if (ClassIsChildOf(class'X2Effect_EnergyShield', PersistentEffect.Class))
    {
        return true;
    }

    return false;
}

defaultproperties
{
    bTacticalTransient = true
}