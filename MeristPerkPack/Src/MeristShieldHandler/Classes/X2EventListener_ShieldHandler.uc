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
    Template.AddCHEvent('PrePersistentEffectRemoved', OnPrePersistentEffectRemoved, ELD_Immediate, 20);
    Template.AddCHEvent('PostPersistentEffectRemoved', OnPostPersistentEffectRemoved, ELD_Immediate, 20);

    Template.RegisterInTactical = true;

    return Template;
}

static function EventListenerReturn OnUnitTakeEffectDamage(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    TargetUnit, NewTargetState;
    local XComGameState_Effect  EffectState, NewEffectState;
    local ShieldInterface       ShieldInterface;
    local ShieldEffectData      EffectData;
    local int                   DamageRemaining, CurrentDamage;
    local int                   Index, UnitIndex;
    local bool                  bShouldRemove;

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState);
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

            DamageRemaining = NewTargetState.DamageResults[NewTargetState.DamageResults.Length - 1].ShieldHP;
            if (DamageRemaining > 0 && Handler.UnitData[UnitIndex].Effects.Length > 0)
            {
                Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
                for (Index = Handler.UnitData[UnitIndex].Effects.Length - 1; Index >= 0 && DamageRemaining > 0; Index--)
                {
                    EffectData = Handler.UnitData[UnitIndex].Effects[Index];
                    if (EffectData.bShouldRemove)
                    {
                        continue;
                    }
                    CurrentDamage = Min(DamageRemaining, EffectData.Amount);
                    if (CurrentDamage > 0)
                    {
                        EffectState = XComGameState_Effect(NewGameState.GetGameStateForObjectID(EffectData.EffectID));
                        if (EffectState == none)
                        {
                            NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                        }
                        if (EffectState != none && !EffectState.bRemoved)
                        {
                            ShieldInterface = ShieldInterface(NewEffectState.GetX2Effect());
                            if (ShieldInterface != none)
                            {
                                ShieldInterface.ShieldsTakeDamage(CurrentDamage, EffectData, NewEffectState, NewTargetState, NewGameState);
                            }

                            DamageRemaining -= CurrentDamage;
                            EffectData.Amount -= CurrentDamage;

                            if (ShieldInterface != none && ShieldInterface.OverrideShouldRemoveEffect())
                            {
                                bShouldRemove = ShieldInterface.ShouldRemoveEffect(CurrentDamage, EffectData, NewEffectState, NewTargetState, NewGameState);
                            }
                            else
                            {
                                bShouldRemove = EffectData.bRemoveWhenDepleted && (EffectData.Amount <= 0);
                            }

                            EffectData.bShouldRemove = bShouldRemove;
                            Handler.UnitData[UnitIndex].Effects[Index] = EffectData;

                            if (bShouldRemove)
                            {
                                Handler.RequestUpdate(NewGameState);
                            }
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnHandlerUpdate(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory  History;
    local XGS_ShieldHandler     Handler;
    local XComGameState         NewGameState;
    local XComGameStateContext_EffectRemoved EffectRemovedContext;
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

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnPersistentEffectAdded(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState         NewGameState;
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local ShieldInterface       ShieldInterface;
    local int                   Index, Amount;

    NewTargetState = XComGameState_Unit(EventSource);
    NewEffectState = XComGameState_Effect(EventData);

    if (NewTargetState != none && NewEffectState != none)
    {
        // 'PersistentEffectAdded' doesn't pass the NewGameState. Thanks, Firaxis. 
        NewGameState = NewTargetState.GetParentGameState();
        if (NewGameState != none)
        {
            Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState);

            if (Handler != none)
            {
                if (class'XGS_ShieldHandler'.static.IsEffectValidForHandling(NewEffectState))
                {
                    Index = NewEffectState.StatChanges.Find('StatType', eStat_ShieldHP);
                    if (Index != INDEX_NONE)
                    {
                        Amount = NewEffectState.StatChanges[Index].StatAmount;
                        if (Amount > 0 && NewEffectState.StatChanges[Index].ModOp == MODOP_Addition)
                        {
                            Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
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

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnPrePersistentEffectRemoved(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local int                   Index, UnitIndex;

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState);
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
                Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
                Handler.UnitData[UnitIndex].Effects[Index].ShieldCached = NewTargetState.GetCurrentStat(eStat_ShieldHP);
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnPostPersistentEffectRemoved(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XGS_ShieldHandler     Handler;
    local XComGameState_Unit    NewTargetState;
    local XComGameState_Effect  NewEffectState;
    local int                   Index, UnitIndex;
    local int                   NewShieldHP;

    Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState);
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
                Handler = class'XGS_ShieldHandler'.static.GetHandlerState(NewGameState, true);
                NewShieldHP = Handler.UnitData[UnitIndex].Effects[Index].ShieldCached - Handler.UnitData[UnitIndex].Effects[Index].Amount;
                if (NewShieldHP > 0)
                {
                    NewTargetState.SetCurrentStat(eStat_ShieldHP, NewShieldHP);
                }
                Handler.RemoveShieldEffectData(UnitIndex, Index);
            }
        }
    }

    return ELR_NoInterrupt;
}