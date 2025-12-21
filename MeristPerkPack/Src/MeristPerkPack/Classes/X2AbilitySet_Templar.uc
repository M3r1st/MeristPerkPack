class X2AbilitySet_Templar extends X2Ability_Extended config(GameData_SoldierSkills);

var config array<name> Loophole_AllowedAbilities;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Loophole());
        Templates.AddItem(LoopholeTrigger());

    return Templates;
}

static function X2AbilityTemplate Loophole()
{
    local X2AbilityTemplate Template;

    Template = Passive('M31_TM_Loophole', "", false, true);

    Template.AdditionalAbilities.AddItem('M31_TM_Loophole_Trigger');

    return Template;
}

static function X2AbilityTemplate LoopholeTrigger()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Effect_ModifyTemplarFocus       FocusEffect;

    Template = SelfTargetTrigger('M31_TM_Loophole_Trigger', "");
    
    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'KillMail';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = AbilityTriggerEventListener_Loophole;
    Trigger.ListenerData.Priority = 30;
    Template.AbilityTriggers.AddItem(Trigger);

    FocusEffect = new class'X2Effect_ModifyTemplarFocus';
    FocusEffect.TargetConditions.AddItem(new class'X2Condition_GhostShooter');
    Template.AddShooterEffect(FocusEffect);

    AddUnitValueCondition(Template, 'M31_TM_Loophole', `GetConfigInt("M31_TM_Loophole_ActivationsPerTurn"));

    Template.bShowActivation = true;

    return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_Loophole(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability             AbilityState;
    local XComGameState_Ability             KillingAbilityState;
    local XComGameStateContext_Ability      AbilityContext;
    local XComGameState_Unit                SourceUnit;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(CallbackData);
        KillingAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

        if (SourceUnit != none && AbilityState != none && KillingAbilityState != none)
        {
            if (default.Loophole_AllowedAbilities.Find(KillingAbilityState.GetMyTemplateName()) != INDEX_NONE)
            {
                return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
            }
        }
    }

    return ELR_NoInterrupt;
}
