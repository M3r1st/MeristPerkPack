class X2EventListener_ShieldHandler extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateTacticalListeners());

    return Templates;
}

static function CHEventListenerTemplate CreateTacticalListeners()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MeristShieldHandlerListeners');

    Template.AddCHEvent('UnitTakeEffectDamage', OnUnitTakeEffectDamage, ELD_Immediate, 10);
    Template.AddCHEvent(class'XGS_ShieldHandler'.default.UpdateEventName, OnHandlerUpdate, ELD_OnStateSubmitted, 50);

    Template.AddCHEvent('PersistentEffectAdded', OnPersistentEffectAdded, ELD_Immediate, 20);
    Template.AddCHEvent('A', OnPrePersistentEffectRemoved, ELD_Immediate, 20);
    Template.AddCHEvent('B', OnPostPersistentEffectRemoved, ELD_Immediate, 20);

    Template.RegisterInTactical = true;

    return Template;
}

static function EventListenerReturn OnUnitTakeEffectDamage(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory  History;
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    TargetUnit, NewTargetState;
    local XComGameState_Effect  EffectState, NewEffectState;
    local ShieldInterface       ShieldInterface;
    local int                   DamageRemaining, CurrentDamage;
    local int                   Index, UnitIndex;
    local bool                  bShouldRemove;

    History = `XCOMHISTORY;

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
    TargetUnit = XComGameState_Unit(EventSource);

    if (Handler != none && TargetUnit != none)
    {
        UnitIndex = Handler.UnitData.Find('UnitID', TargetUnit.ObjectID);
        if (UnitIndex != INDEX_NONE && Handler.UnitData[UnitIndex].Effects.Length > 0)
        {
            NewTargetState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(TargetUnit.ObjectID));
            if (NewTargetState == none)
            {
                // How did we get here?
                NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
            }

            DamageRemaining = NewTargetState.DamageResults[NewTargetState.DamageResults.Length - 1].DamageAbsorbedByShield;
            if (DamageRemaining > 0)
            {
                for (Index = Handler.UnitData[UnitIndex].Effects.Length - 1; Index >= 0 && DamageRemaining > 0; Index--)
                {
                    CurrentDamage = Min(DamageRemaining, Handler.UnitData[UnitIndex].Effects[Index].Amount);
                    if (DamageCurrent > 0)
                    {
                        EffectState = XComGameState_Effect(NewGameState.GetGameStateForObjectID(Handler.UnitData[UnitIndex].Effects[Index].EffectID));
                        if (EffectState == none)
                        {
                            NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                        }
                        if (EffectState != none)
                        {
                            ShieldInterface = ShieldInterface(NewEffectState.GetX2Effect());
                            if (ShieldInterface != none)
                            {
                                ShieldInterface.ShieldsTakeDamage(x, Handler.UnitData[UnitIndex].Effects[Index], NewEffectState, NewTargetState, NewGameState);
                            }

                            DamageRemaining -= CurrentDamage;
                            Handler.UnitData[UnitIndex].Effects[Index].Amount -= CurrentDamage;

                            if (ShieldInterface != none && ShieldInterface.OverrideShouldRemoveEffect())
                            {
                                bShouldRemove = ShieldInterface.ShouldRemoveEffect(x, Handler.UnitData[UnitIndex].Effects[Index], NewEffectState, NewTargetState, NewGameState);
                            }
                            else
                            {
                                bShouldRemove = Handler.UnitData[UnitIndex].Effects[Index].bRemoveWhenDepleted && (Handler.UnitData[UnitIndex].Effects[Index].Amount <= 0);
                            }

                            Handler.UnitData[UnitIndex].Effects[Index].bShouldRemove = bShouldRemove;

                            if (bShouldRemove)
                            {
                                if (!Handler.bRequiresUpdate)
                                {
                                    Handler.bRequiresUpdate = true;
                                    `XEVENTMGR.TriggerEvent(class'XGS_ShieldHandler'.default.UpdateEventName, none, none, NewGameState);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

static function EventListenerReturn OnHandlerUpdate(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory  History;
    local XGS_ShieldHandler     Handler;
    local XComGameState         NewGameState;
    local XComGameStateContext_EffectRemoved EffectRemovedContext;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local int                   Index, UnitIndex;
    local bool                  bCleansed, bPurge;

    History = `XCOMHISTORY;

    EffectRemovedContext = XComGameStateContext_EffectRemoved(class'XComGameStateContext'.static.CreateXComGameStateContext());
    NewGameState = History.CreateNewGameState(true, EffectRemovedContext);

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
    Handler.bRequiresUpdate = false;

    for (UnitIndex = Handler.UnitData.Length - 1; UnitIndex >= 0; UnitIndex--)
    {
        NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Handler.UnitData[UnitIndex].UnitID));
        for (Index = Handler.UnitData[UnitIndex].Effects.Length - 1; Index >= 0; Index--)
        {
            if (Handler.UnitData[UnitIndex].Effects[Index].bShouldRemove)
            {
                NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', Handler.UnitData[UnitIndex].Effects[Index].EffectID));
                if (NewEffectState != none && !NewEffectState.bRemoved)
                {
                    bCleansed = Handler.UnitData[UnitIndex].Effects[Index].bCleansed;
                    bPurge = Handler.UnitData[UnitIndex].Effects[Index].bPurge;

                    NewEffectState.RemoveEffect(NewGameState, GameState, bCleansed, bPurge);
                }
            }
        }
    }

    `TACTICALRULES.SubmitGameState(NewGameState);
}

static function EventListenerReturn OnPersistentEffectAdded(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState         NewGameState;
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local ShieldInterface       ShieldInterface;
    local int                   Index, Amount;

    // 'PersistentEffectAdded' doesn't pass the NewGameState. Thanks, Firaxis. 
    NewGameState = NewTargetState.GetParentGameState();
    if (NewGameState != none)
    {
        Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
        NewTargetState = XComGameState_Unit(EventSource);
        NewEffectState = XComGameState_Effect(EventData);

        if (Handler != none && NewTargetState != none && NewEffectState != none)
        {
            if (class'XGS_ShieldHandler'.static.IsEffectValidForHandling(NewEffectState))
            {
                Index = NewEffectState.StatChanges.Find('StatType', eStat_ShieldHP);
                if (Index != INDEX_NONE)
                {
                    Amount = NewEffectState.StatChanges[Index].StatAmount;
                    if (Amount > 0 && NewEffectState.StatChanges[Index].ModOp == MODOP_Addition)
                    {
                        ShieldInterface = ShieldInterface(NewEffectState.GetX2Effect());
                        if (ShieldInterface != none)
                        {
                            Handler.UpdateShieldEffectData(NewTargetState.ObjectID, NewEffectState.ObjectID, Amount, ShieldInterface.GetShieldPriority(), ShieldInterface.RemoveWhenDepleted());
                        }
                        else
                        {
                            Handler.UpdateShieldEffectData(NewTargetState.ObjectID, NewEffectState.ObjectID, Amount);
                        }
                    }
                }
            }
        }
    }
}

static function EventListenerReturn OnPrePersistentEffectRemoved(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local int                   Index, UnitIndex;

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
    NewTargetState = XComGameState_Unit(EventSource);
    NewEffectState = XComGameState_Effect(EventData);

    if (Handler != none && NewTargetState != none && NewEffectState != none)
    {
        UnitIndex = Handler.UnitData.Find('UnitID', NewTargetState.ObjectID);
        if (UnitIndex != INDEX_NONE)
        {
            Index = Handler.UnitData[UnitIndex].Effects.Find('EffectID', NewEffectState.ObjectID);
            if (Index != INDEX_NONE)
            {
                Handler.UnitData[UnitIndex].Effects[Index].ShieldCached = NewTargetState.GetCurrentStat(eStat_ShieldHP);
            }
        }
    }
}

static function EventListenerReturn OnPostPersistentEffectRemoved(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local int                   Index, UnitIndex;
    local int                   NewShieldHP;

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
    NewTargetState = XComGameState_Unit(EventSource);
    NewEffectState = XComGameState_Effect(EventData);

    if (Handler != none && NewTargetState != none && NewEffectState != none)
    {
        UnitIndex = Handler.UnitData.Find('UnitID', NewTargetState.ObjectID);
        if (UnitIndex != INDEX_NONE)
        {
            Index = Handler.UnitData[UnitIndex].Effects.Find('EffectID', NewEffectState.ObjectID);
            if (Index != INDEX_NONE)
            {
                NewShieldHP = Handler.UnitData[UnitIndex].Effects[Index].ShieldCached - Handler.UnitData[UnitIndex].Effects[Index].Amount;
                if (NewShieldHP > 0)
                {
                    NewTargetState.SetCurrentStat(eStat_ShieldHP, NewShieldHP);
                }
                Handler.UnitData[UnitIndex].Effects.Remove(Index, 1);
            }
        }
    }
}