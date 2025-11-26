class X2Effect_EMPBomber extends X2Effect_Persistent;

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
    local XComGameState_Ability         AbilityState;
    local XComGameState_Item            SourceWeapon;
    local X2WeaponTemplate              WeaponTemplate;
    local bool                          bIsEMPGrenade;

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
                AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
                if (X2GrenadeLauncherTemplate(WeaponTemplate) != none && AbilityState != none)
                {
                    WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
                }
                
                if (X2GrenadeTemplate(WeaponTemplate) != none)
                {
                    bIsEMPGrenade = class'X2DLCInfo_MeristPerkPack'.default.EMPGrenades.Find(WeaponTemplate.DataName) != INDEX_NONE;
                }
            }
            if (bIsEMPGrenade)
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
    EffectName = M31_EMPBomber
    DuplicateResponse = eDupe_Ignore
}