class X2EventListener_Tactical extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateRetainConcealmentListeners());

    return Templates;
}

static function CHEventListenerTemplate CreateRetainConcealmentListeners()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'M31_TacticalListeners');
    Template.AddCHEvent('RetainConcealmentOnActivation', OnRetainConcealmentOnActivation, ELD_Immediate);
    Template.AddCHEvent('KilledbyExplosion', OnKilledbyExplosion, ELD_Immediate);
    Template.AddCHEvent('OverrideDamageRemovesReserveActionPoints', OnOverrideDamageRemovesReserveActionPoints, ELD_Immediate);

    Template.RegisterInTactical = true;

    return Template;
}

static function EventListenerReturn OnRetainConcealmentOnActivation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComLWTuple                   Tuple;
    local bool                          bRetainConcealmentOnActivation;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            UnitState;
    local UnitValue                     UnitValue;
    local XComGameState                 NewGameState;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'RetainConcealmentOnActivation');

    bRetainConcealmentOnActivation = Tuple.Data[0].b;

    if (!bRetainConcealmentOnActivation)
    {
        AbilityContext = XComGameStateContext_Ability(EventSource);
        if (AbilityContext != none)
        {
            UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
            if (UnitState != none)
            {
                if (UnitState.GetUnitValue('M31_Assassin_Activated', UnitValue) && int(UnitValue.fValue) == 1)
                {
                    bRetainConcealmentOnActivation = true;
                    Tuple.Data[0].b = bRetainConcealmentOnActivation;

                    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                    UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.GetReference().ObjectID));
                    UnitState.ClearUnitValue('M31_Assassin_Activated');
                    `TACTICALRULES.SubmitGameState(NewGameState);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnKilledByExplosion(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple                   Tuple;
    local bool                          bKilledbyExplosion;
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            Killer;
    local XComGameState_Unit            Target;
    local XComGameState_Item            SourceWeapon;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideKilledbyExplosion');

    bKilledbyExplosion = Tuple.Data[0].b;

    if (bKilledbyExplosion)
    {
        History = `XCOMHISTORY;
        
        AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
        Target = XComGameState_Unit(EventSource);
        Killer = XComGameState_Unit(NewGameState.GetGameStateForObjectID(Tuple.Data[1].i));
        if (Killer == none)
            Killer = XComGameState_Unit(History.GetGameStateForObjectID(Tuple.Data[1].i));

        if (AbilityContext != none && Target != none && Killer != none)
        {
            SourceWeapon = XComGameState_Item(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
            if (SourceWeapon == none)
                SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));

            if (SourceWeapon != none)
            {
                if (class'X2DLCInfo_MeristPerkPack'.default.EMPGrenades.Find(SourceWeapon.GetMyTemplateName()) != INDEX_NONE
                    && Killer.HasSoldierAbility('M31_EMPBomber', true))
                {
                    bKilledbyExplosion = false;
                    Tuple.Data[0].b = bKilledbyExplosion;
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnOverrideDamageRemovesReserveActionPoints(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackObject)
{
    local XComLWTuple           Tuple;
    local bool                  bDamageRemovesReserveActionPoints;
    local XComGameState_Unit    UnitState;
    local name                  ActionPointName;
    local bool                  bIsOverwatch;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideDamageRemovesReserveActionPoints');
    
    bDamageRemovesReserveActionPoints = Tuple.Data[0].b;

    if (bDamageRemovesReserveActionPoints)
    {
        UnitState = XComGameState_Unit(EventSource);
        if (UnitState != none)
        {
            foreach UnitState.ReserveActionPoints(ActionPointName)
            {
                if (ActionPointName == class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint
                    || ActionPointName == class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint
                    || ActionPointName == class'X2AbilitySet_Merist'.default.SniperOverwatchActionPoint)
                {
                    bIsOverwatch = true;
                    break;
                }
            }

            if (bIsOverwatch
                && (UnitState.HasSoldierAbility('M31_PA_TaipanVengeance', true)
                || UnitState.HasSoldierAbility('M31_DedicatedOverwatch', true)))
            {
                bDamageRemovesReserveActionPoints = false;
                Tuple.Data[0].b = bDamageRemovesReserveActionPoints;
            }
        }
    }

    return ELR_NoInterrupt;
}