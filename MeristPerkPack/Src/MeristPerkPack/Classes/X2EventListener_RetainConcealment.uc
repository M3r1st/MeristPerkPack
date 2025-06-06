class X2EventListener_RetainConcealment extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateRetainConcealmentListeners());

    return Templates;
}

static function CHEventListenerTemplate CreateRetainConcealmentListeners()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'M31_RetainConcealmentOnActivation');
    Template.AddCHEvent('RetainConcealmentOnActivation', OnRetainConcealmentOnActivation, ELD_Immediate);

    Template.RegisterInTactical = true;

    return Template;
}

static function EventListenerReturn OnRetainConcealmentOnActivation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComGameStateContext_Ability AbilityContext;
    local XComGameState_Unit UnitState;
    local bool bRetainConcealment;

    Tuple = XComLWTuple(EventData);
    AbilityContext = XComGameStateContext_Ability(EventSource);
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
    bRetainConcealment = Tuple.Data[0].b;

    if (!bRetainConcealment)
    {
        bRetainConcealment = ValidateRetainConcealment(UnitState);
        // `LOG("ValidateRetainConcealment: " $ bRetainConcealment, true,'M31_RetainConcealmentOnActivation');
        Tuple.Data[0].b = bRetainConcealment;
        EventSource = Tuple;
    }

    return ELR_NoInterrupt;
}

static function bool ValidateRetainConcealment(XComGameState_Unit UnitState)
{
    local UnitValue UnitValue;
    local int iCounter;

    UnitState.GetUnitValue('M31_Assassin_Activated', UnitValue);
    iCounter = int(UnitValue.fValue);

    return iCounter == 1;
}