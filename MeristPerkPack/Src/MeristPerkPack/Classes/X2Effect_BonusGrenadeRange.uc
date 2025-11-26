class X2Effect_BonusGrenadeRange extends X2Effect_Persistent;

var int BonusRange;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager    EventMgr;
    local Object            EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'OnGetItemRange', OnGetItemRange, ELD_Immediate,,,, EffectObj);
}

static function EventListenerReturn OnGetItemRange(
    Object EventData,
    Object EventSource,
    XComGameState NewGameState,
    Name InEventID,
    Object CallbackData)
{
    local XComLWTuple                   Tuple;
    local XComGameState_Item            ItemState;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_BonusGrenadeRange    Effect;
    local XComGameState_Item            SourceWeapon;
    local X2WeaponTemplate              WeaponTemplate;
    local bool                          bIsGrenade;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'GetItemRange');

    ItemState = XComGameState_Item(EventSource);
    EffectState = XComGameState_Effect(CallbackData);
    AbilityState = XComGameState_Ability(Tuple.Data[2].o);

    if (ItemState != none && EffectState != none && AbilityState != none)
    {
        if (ItemState.OwnerStateObject == EffectState.ApplyEffectParameters.TargetStateObjectRef)
        {
            SourceWeapon = AbilityState.GetSourceWeapon();
            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            Effect = X2Effect_BonusGrenadeRange(EffectState.GetX2Effect());
            if (WeaponTemplate != none && Effect != none)
            {
                bIsGrenade = X2GrenadeTemplate(WeaponTemplate) != none
                    || X2GrenadeLauncherTemplate(WeaponTemplate) != none
                    || WeaponTemplate.DataName == 'Battlescanner';
                if (bIsGrenade)
                {
                    Tuple.Data[1].i += Effect.BonusRange;
                }
            }
        }
    }

    return ELR_NoInterrupt;
}