class XGS_ShieldHandler extends XComGameState_BaseObject config(Game);

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

struct UnitShieldData
{
    var int UnitID;
    var array<ShieldEffectData> Effects;
};

var bool bRequiresUpdate;
var privatewrite name UpdateEventName;

var array<UnitShieldData> UnitData;

var config bool bLog;

static function InitializeShieldHandler(XComGameState StartGameState)
{
    `LOG(GetFuncName(), default.bLog, default.Class.Name);
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

    `LOG("Updating data for UnitID #" $ UnitID $ ", EffectID #" $ EffectID, default.bLog, default.Class.Name);

    Index = UnitData.Find('UnitID', UnitID);
    if (Index != INDEX_NONE)
    {
        EffectIndex = UnitData[Index].Effects.Find('EffectID', EffectID);
        if (EffectIndex != INDEX_NONE)
        {
            `LOG("EffectID #" $ UnitID $ " was found; updating existing entry", default.bLog, default.Class.Name);
            UnitData[Index].Effects[EffectIndex].Amount = Amount;
            UnitData[Index].Effects[EffectIndex].Priority = Priority;
        }
        else
        {
            `LOG("EffectID #" $ EffectID $ " was not found; creating a new entry", default.bLog, default.Class.Name);
            NewEffectData.EffectID = EffectID;
            NewEffectData.Amount = Amount;
            NewEffectData.Priority = Priority;
            NewEffectData.bRemoveWhenDepleted = bRemoveWhenDepleted;

            UnitData[Index].Effects.AddItem(NewEffectData);
        }
        // TODO: Maybe replace with binary insertion
        UnitData[Index].Effects.Sort(SortEffectData);
    }
    else
    {
        `LOG("UnitID #" $ UnitID $ " was not found; creating a new entry", default.bLog, default.Class.Name);
        NewEffectData.EffectID = EffectID;
        NewEffectData.Amount = Amount;
        NewEffectData.Priority = Priority;
        NewEffectData.bRemoveWhenDepleted = bRemoveWhenDepleted;

        NewUnitData.UnitID = UnitID;
        NewUnitData.Effects.AddItem(NewEffectData);

        UnitData.AddItem(NewUnitData);
    }
}

function bool RemoveShieldEffectData(int UnitID, int EffectID)
{
    local int Index, EffectIndex;

    Index = UnitData.Find('UnitID', UnitID);
    if (Index != INDEX_NONE)
    {
        EffectIndex = UnitData[Index].Effects.Find('EffectID', EffectID);
        if (EffectIndex != INDEX_NONE)
        {
            `LOG("Removing EffectID #" $ EffectID $ " from UnitID #" $ UnitID, default.bLog, default.Class.Name);
            LogEffectData(UnitID, EffectID);
            UnitData[Index].Effects.Remove(EffectIndex, 1);
            return true;
        }
    }

    return false;
}

delegate int SortEffectData(ShieldEffectData A, ShieldEffectData B)
{
    if (A.Priority > B.Priority)
        return -1;
    else if (A.Priority < B.Priority)
        return 1;

    if (A.EffectID > B.EffectID)
        return -1;
    else if (A.EffectID < B.EffectID)
        return 1;
    else
        return 0;
}

static function bool IsEffectValidForHandling(XComGameState_Effect EffectState)
{
    local X2Effect_Persistent PersistentEffect;
    local ShieldInterface ShieldInterface;

    PersistentEffect = EffectState.GetX2Effect();
    ShieldInterface = ShieldInterface(PersistentEffect);

    if (ShieldInterface != none)
    {
        return true;
    }

    // if (ClassIsChildOf(class'X2Effect_EnergyShield', PersistentEffect.Class))
    // {
    //     return true;
    // }

    return false;
}

function RequestUpdate(XComGameState GameState)
{
    if (!bRequiresUpdate)
    {
        bRequiresUpdate = true;
        `XEVENTMGR.TriggerEvent(default.UpdateEventName, none, none, GameState);
    }
}

function LogEffectData(int UnitID, optional int EffectID = -1)
{
    local int Index, EffectIndex;
    local ShieldEffectData EffectData;

    if (!default.bLog)
        return;

    // `LOG("=====================================================================",, default.Class.Name);
    Index = UnitData.Find('UnitID', UnitID);
    if (Index == INDEX_NONE)
    {
        `LOG("UnitID #" $ UnitID $ " has no shield effects to handle!",, default.Class.Name);
    }
    else
    {
        if (EffectID > 0)
        {
            EffectIndex = UnitData[Index].Effects.Find('EffectID', EffectID);
            if (EffectIndex == INDEX_NONE)
            {
                `LOG("UnitID #" $ UnitID $ " has no shield effect with EffectID #" $ EffectID $ "!",, default.Class.Name);
            }
            else
            {
                EffectData = UnitData[Index].Effects[EffectIndex];
                `LOG(EffectData.EffectID
                    @ EffectData.Amount
                    @ EffectData.Priority
                    @ EffectData.ShieldCached
                    @ EffectData.bRemoveWhenDepleted
                    @ EffectData.bShouldRemove
                    @ EffectData.bCleansed
                    @ EffectData.bPurge,, default.Class.Name);
            }
        }
        else
        {
            `LOG("UnitID #" $ UnitID $ " has " $ EffectIndex < UnitData[Index].Effects.Length $ " handled shield effects:",, default.Class.Name);
            for (EffectIndex = 0; EffectIndex < UnitData[Index].Effects.Length; EffectIndex++)
            {
                EffectData = UnitData[Index].Effects[EffectIndex];
                `LOG(EffectData.EffectID
                    @ EffectData.Amount
                    @ EffectData.Priority
                    @ EffectData.ShieldCached
                    @ EffectData.bRemoveWhenDepleted
                    @ EffectData.bShouldRemove
                    @ EffectData.bCleansed
                    @ EffectData.bPurge,, default.Class.Name);
            }
        }
    }
    // `LOG("---------------------------------------------------------------------",, default.Class.Name);
}

function ShieldEffectData GetEffectData(int UnitID, int EffectID)
{
    local ShieldEffectData EffectData;
    local int Index, EffectIndex;

    Index = UnitData.Find('UnitID', UnitID);
    if (Index != INDEX_NONE)
    {
        EffectIndex = UnitData[Index].Effects.Find('EffectID', EffectID);
        if (EffectIndex != INDEX_NONE)
        {
            EffectData = UnitData[Index].Effects[EffectIndex];
        }
    }

    return EffectData;
}


defaultproperties
{
    bTacticalTransient = true
}