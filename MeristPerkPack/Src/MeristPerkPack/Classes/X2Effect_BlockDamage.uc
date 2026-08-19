class X2Effect_BlockDamage extends X2Effect_Persistent;

var bool bBlockDOT;
var bool bDontRemoveOnDOT;
var name RemoveEffectEventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', OnUnitTakeEffectDamage, ELD_Immediate, 50, TargetState);
    EventMgr.RegisterForEvent(EffectObj, RemoveEffectEventName, EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, 50, TargetState);
}

static function EventListenerReturn OnUnitTakeEffectDamage(Object EventData, Object EventSource, XComGameState NewGameState, name Event, Object CallbackData)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(EventSource);
    UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(UnitState.ObjectID));

    if (UnitState != none && UnitState.DamageResults.Length > 0)
    {
        UnitState.Shredded -= UnitState.DamageResults[UnitState.DamageResults.Length - 1].Shred;
        UnitState.DamageResults[UnitState.DamageResults.Length - 1].Shred = 0;
    }

    return ELR_NoInterrupt;
}

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local bool bIsDOT;
    if (IsEffectCurrentlyRelevant(EffectState, Target))
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                bIsDOT = AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE;
                if (bIsDOT && !bBlockDOT)
                {
                    return 0;
                }
        
                if (NewGameState != none)
                {
                    if (!bIsDOT || !bDontRemoveOnDOT)
                    {
                        `XEVENTMGR.TriggerEvent(RemoveEffectEventName, Target, Target, NewGameState);
                    }
                }
                return -1 * CurrentDamage;
            }
        }
    }

    return 0;
}

static function OnEffectRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

    if (XGUnit(ActionMetadata.VisualizeActor).IsAlive())
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
    }
}

defaultproperties
{
    EffectName = M31_BlockDamage
    DuplicateResponse = eDupe_Refresh
    bDisplayInSpecialDamageMessageUI = true

    RemoveEffectEventName = M31_BlockDamage_RemoveEffect

    EffectRemovedVisualizationFn = OnEffectRemoved_BuildVisualization
}