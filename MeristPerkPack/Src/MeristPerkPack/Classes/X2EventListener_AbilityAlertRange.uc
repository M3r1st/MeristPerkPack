class X2EventListener_AbilityAlertRange extends X2EventListener config(GameData_SoldierSkills);

var config array<name> OverrideSoundRange_Abilities;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateOverrideSoundRangeListeners());

    return Templates;
}

static function CHEventListenerTemplate CreateOverrideSoundRangeListeners()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'M31_OverrideSoundRangeListener');
    Template.AddCHEvent('OverrideSoundRange', OnOverrideSoundRange, ELD_Immediate);

    Template.RegisterInTactical = true;

	return Template;
}

static function EventListenerReturn OnOverrideSoundRange(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComGameState_Ability ActivatedAbilityState;
    local int SoundRange;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
        return ELR_NoInterrupt;

    if (Tuple.Id != 'OverrideSoundRange')
        return ELR_NoInterrupt;

    ActivatedAbilityState = XComGameState_Ability(Tuple.Data[2].o);
    if (ActivatedAbilityState == None)
    {
        `REDSCREEN("Invalid ability state passed to OnOverrideSoundRange");
        return ELR_NoInterrupt;
    }

    SoundRange = Tuple.Data[3].i;
    
    ModifySoundRange(ActivatedAbilityState, SoundRange);

    Tuple.Data[3].i = SoundRange;

    return ELR_NoInterrupt;
}

static function ModifySoundRange(XComGameState_Ability AbilityState, out int SoundRange)
{
    local X2AbilityMultiTarget_Radius RadiusMultiTarget;
    if (default.OverrideSoundRange_Abilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return;

    RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);

    if (RadiusMultiTarget == none)
        return;

    SoundRange = RadiusMultiTarget.fTargetRadius;
}