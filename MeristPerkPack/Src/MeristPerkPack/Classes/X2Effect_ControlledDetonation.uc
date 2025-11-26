class X2Effect_ControlledDetonation extends X2Effect_Persistent config(GameData_SoldierSkills);

var config array<name> ControlledDetonation_AllowedAbilities;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager    EventMgr;
    local Object            EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'KilledbyExplosion', OnKilledbyExplosion, ELD_Immediate,,,, EffectObj);
}

static function EventListenerReturn OnKilledByExplosion(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple                   Tuple;
    local bool                          bKilledbyExplosion;
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          EffectState;
    local XComGameState_Item            SourceWeapon;
    local X2WeaponTemplate              WeaponTemplate;
    local bool                          bIsGrenade;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideKilledbyExplosion');

    bKilledbyExplosion = Tuple.Data[0].b;

    if (bKilledbyExplosion)
    {
        History = `XCOMHISTORY;

        AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
        EffectState = XComGameState_Effect(CallbackData);
        if (AbilityContext != none && EffectState != none && Tuple.Data[1].i > 0
            && Tuple.Data[1].i == EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
        {
            SourceWeapon = XComGameState_Item(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
            if (SourceWeapon == none)
                SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));

            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            if (WeaponTemplate != none)
            {
                bIsGrenade = X2GrenadeTemplate(WeaponTemplate) != none || X2GrenadeLauncherTemplate(WeaponTemplate) != none;
            }
            if (bIsGrenade || default.ControlledDetonation_AllowedAbilities.Find(AbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE)
            {
                bKilledbyExplosion = false;
                Tuple.Data[0].b = bKilledbyExplosion;
            }
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    EffectName = M31_ControlledDetonation
    DuplicateResponse = eDupe_Ignore
}