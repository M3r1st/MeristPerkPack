class X2EventListener_GlobalListeners extends X2EventListener config(Game);

var config bool bLog;
var config int EventPriority_OnPostMissionUpdateSoldierHealing;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateTacticalListeners());
    Templates.AddItem(CreateStrategyListeners());

    return Templates;
}

static function CHEventListenerTemplate CreateTacticalListeners()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'M31_TacticalListeners');
    Template.AddCHEvent('RetainConcealmentOnActivation', OnRetainConcealmentOnActivation, ELD_Immediate);
    Template.AddCHEvent('KilledbyExplosion', OnKilledbyExplosion, ELD_Immediate);
    Template.AddCHEvent('OverrideDamageRemovesReserveActionPoints', OnOverrideDamageRemovesReserveActionPoints, ELD_Immediate);
    Template.AddCHEvent('UnitBleedingOut', OnUnitBleedingOut, ELD_Immediate);

    Template.RegisterInTactical = true;

    return Template;
}

static function CHEventListenerTemplate CreateStrategyListeners()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'M31_StrategyListeners');

    Template.AddCHEvent('PostMissionUpdateSoldierHealing', OnPostMissionUpdateSoldierHealing, ELD_Immediate, default.EventPriority_OnPostMissionUpdateSoldierHealing);

    Template.RegisterInStrategy = true;

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

static function EventListenerReturn OnUnitBleedingOut(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit Unit;

    Unit = XComGameState_Unit(EventData);
    if (Unit != none)
    {
        if (Unit.IsBleedingOut() && Unit.GetBleedingOutTurnsRemaining() > 0)
        {
            Unit = XComGameState_Unit(NewGameState.ModifyStateObject(Unit.Class, Unit.ObjectID));
            Unit.SetUnitFloatValue(class'X2Effect_HealOnMissionEnd'.default.BleedoutValueName, 1, eCleanup_BeginTactical);
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn OnPostMissionUpdateSoldierHealing(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComGameState_Unit    Unit;
    local UnitValue             UnitVal;
    local int AmountToHeal, CurrentHP, MaxHP;

    `LOG(GetFuncName(), default.bLog, GetFuncName());

    Unit = XComGameState_Unit(EventSource);

    if (Unit != none && Unit.GetUnitValue(class'X2Effect_HealOnMissionEnd'.default.HealValueName, UnitVal))
    {
        AmountToHeal = int(UnitVal.fValue);
        if (AmountToHeal > 0)
        {
            `LOG(Unit.GetFullName() $ " can be healed for " $ AmountToHeal $ " HP", default.bLog, GetFuncName());
            Unit = XComGameState_Unit(NewGameState.ModifyStateObject(Unit.Class, Unit.ObjectID));
            if (class'X2Effect_HealOnMissionEnd'.static.IsEffectValidForTarget(Unit))
            {
                `LOG("The healing is valid for the target", default.bLog, GetFuncName());
                `LOG("Previous LowestHP = " $ Unit.LowestHP, default.bLog, GetFuncName());
                Unit.LowestHP = Min(Unit.HighestHP, Unit.LowestHP + AmountToHeal);
                `LOG("New LowestHP = " $ Unit.LowestHP, default.bLog, GetFuncName());

                CurrentHP = Unit.GetCurrentStat(eStat_HP);
                MaxHP = Unit.GetMaxStat(eStat_HP);
                if (CurrentHP < MaxHP)
                {
                    `LOG("Previous HP = " $ Unit.GetCurrentStat(eStat_HP), default.bLog, GetFuncName());
                    Unit.ModifyCurrentStat(eStat_HP, Min(MaxHP - CurrentHP, AmountToHeal));
                    `LOG("New HP = " $ Unit.GetCurrentStat(eStat_HP), default.bLog, GetFuncName());
                }
            }
        }
        `LOG("Clearing the value", default.bLog, GetFuncName());
        Unit.ClearUnitValue(class'X2Effect_HealOnMissionEnd'.default.HealValueName);
    }

    return ELR_NoInterrupt;
}