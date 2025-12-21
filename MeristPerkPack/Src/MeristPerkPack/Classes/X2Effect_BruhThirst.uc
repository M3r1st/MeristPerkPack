class X2Effect_BruhThirst extends X2Effect_BloodThirst config(GameData_SoldierSkills);

var bool bIncreaseOnlyOnMiss;
var config bool bUseFocusUI;
var localized string strSpecialDamageName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_BruhThirst, ELD_OnStateSubmitted,, TargetState,, EffectObj);

    if (TargetState.HasSoldierAbility('M31_ENEMY_BruhThirstForAll', true))
    {
        EventMgr.RegisterForEvent(EffectObj, 'M31_WeAreBruhthers', EffectEventListener_WeAreBruhthers, ELD_Immediate,,,, EffectObj);
    }

    if (bUseFocusUI && TargetState.GetTemplarFocusEffectState() == none)
    {
        EventMgr.RegisterForEvent(EffectObj, 'OverrideUnitFocusUI', OnOverrideFocus, ELD_Immediate,, TargetState,, EffectObj);
    }
}

static function EventListenerReturn OnOverrideFocus(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComLWTuple               Tuple;
    local XComGameState_Unit        UnitState;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;
    local X2Effect_BruhThirst       BloodThirstEffect;
    local int                       Count, MaxCount, MaxCountForUI;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideUnitFocusUI');

    UnitState = XComGameState_Unit(EventSource);

    if (UnitState != none && UnitState.GetTemplarFocusEffectState() == none)
    {
        BloodThirstEffectState = XCGS_Effect_BloodThirst(CallbackData);
        BloodThirstEffect = X2Effect_BruhThirst(BloodThirstEffectState.GetX2Effect());

        if (BloodThirstEffectState == none || BloodThirstEffect == none)
            return ELR_NoInterrupt;

        Count = BloodThirstEffectState.GetTotalStacksRemaining();
        MaxCount = BloodThirstEffect.GetMaxStackCount(UnitState);

        MaxCountForUI = (MaxCount > 0 ? MaxCount : 8);
        MaxCountForUI = Max(MaxCountForUI, Count);

        Tuple.Data[0].b = true;
        Tuple.Data[1].i = Count;
        Tuple.Data[2].i = MaxCountForUI;
        Tuple.Data[3].s = "0x" $ GetFocusIconColor(Count, MaxCount);
        Tuple.Data[4].s = "";
        Tuple.Data[5].s = (Count == 0 ? default.strFriendlyDesc_NoStacks : Repl(default.strFriendlyDesc, "[X]", Count));
        Tuple.Data[6].s = default.strFriendlyName;
    }

    return ELR_NoInterrupt;
}

static function string GetFocusIconColor(int Count, int MaxCount)
{
    return "85FF3F";
}

static function EventListenerReturn EffectEventListener_BruhThirst(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XCGS_Effect_BloodThirst       EffectState;
    local X2Effect_BruhThirst           Effect;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState                 NewGameState;
    local int                           MaxCountPerTurn;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XCGS_Effect_BloodThirst(CallbackData);
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        if (EffectState != none && SourceUnit != none && AbilityState != none)
        {
            Effect = X2Effect_BruhThirst(EffectState.GetX2Effect());
            if (Effect != none)
            {
                MaxCountPerTurn = Effect.GetMaxStackCountPerTurn(SourceUnit);
                if (MaxCountPerTurn <= 0 || EffectState.iStacksThisTurn < MaxCountPerTurn)
                {
                    if (Effect.IsAbilityRelevant(AbilityState, EffectState, SourceUnit, AbilityContext))
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                        EffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                        EffectState.AddStacks(, SourceUnit);

                        // Add source unit and effect's source ability state to NewGameState for visualization purposes
                        NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID);
                        NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                        XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = BruhThirst_BuildVisualization;

                        `XEVENTMGR.TriggerEvent('M31_WeAreBruhthers', SourceUnit, SourceUnit, NewGameState);

                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function EventListenerReturn EffectEventListener_WeAreBruhthers(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
    local XCGS_Effect_BloodThirst   EffectState, NewEffectState;
    local X2Effect_BruhThirst       Effect;
    local XComGameState_Unit        SourceUnit, EffectUnitState;
    local bool                      bNewUnitState;
    local bool                      bValid;
    local int                       MaxCountPerTurn;

    EffectState = XCGS_Effect_BloodThirst(CallbackData);
    SourceUnit = XComGameState_Unit(EventSource);

    bNewUnitState = true;
    EffectUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    if (EffectUnitState == none)
    {
        bNewUnitState = false;
        EffectUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    }

    if (EffectState != none && SourceUnit != none && EffectUnitState != none)
    {
        if (SourceUnit.ObjectID != EffectUnitState.ObjectID
            && EffectUnitState.IsFriendlyUnit(SourceUnit)
            && (EffectUnitState.GetTeam() == eTeam_XCom || EffectUnitState.GetCurrentStat(eStat_AlertLevel) == `ALERT_LEVEL_RED))
        {
            Effect = X2Effect_BruhThirst(EffectState.GetX2Effect());
            if (Effect != none)
            {
                MaxCountPerTurn = Effect.GetMaxStackCountPerTurn(EffectUnitState);
                NewEffectState = XCGS_Effect_BloodThirst(NewGameState.GetGameStateForObjectID(EffectState.ObjectID));
                if (NewEffectState == none)
                {
                    if (MaxCountPerTurn <= 0 || EffectState.iStacksThisTurn < MaxCountPerTurn)
                    {
                        NewEffectState = XCGS_Effect_BloodThirst(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
                        NewEffectState.AddStacks(, EffectUnitState);
                        bValid = true;
                    }
                }
                else
                {
                    if (MaxCountPerTurn <= 0 || NewEffectState.iStacksThisTurn < MaxCountPerTurn)
                    {
                        NewEffectState.AddStacks(, EffectUnitState);
                        bValid = true;
                    }
                }
                // Add the unit to NewGameState for visualization purposes
                if (bValid && !bNewUnitState)
                {
                    EffectUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(EffectUnitState.Class, EffectUnitState.ObjectID));
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

static function BruhThirst_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState_Unit            UnitState;
    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   ActionMetadata;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;

    History = `XCOMHISTORY;
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Ability', AbilityState)
    {
        break;
    }
    if (AbilityState != none)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
        if (AbilityTemplate != none)
        {
            foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
            {
                ActionMetadata = EmptyTrack;
                History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
                ActionMetadata.StateObject_NewState = UnitState;
                ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

                SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
                SoundAndFlyOver.SetSoundAndFlyOverParameters(None, abilityTemplate.LocFlyOverText, '', eColor_Bad, AbilityTemplate.IconImage, `DEFAULTFLYOVERLOOKATTIME, true);
            }
            return;
        }
    }
}

function bool IsAbilityRelevant(
    XComGameState_Ability AbilityState,
    XCGS_Effect_BloodThirst EffectState,
    XComGameState_Unit SourceUnit,
    XComGameStateContext_Ability AbilityContext)
{

    local X2AbilityTemplate AbilityTemplate;
    local bool bDealsDamage;

    if (IncludeAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();

        bDealsDamage = AbilityTemplate.TargetEffectsDealDamage(AbilityState.GetSourceWeapon(), AbilityState);
        if (AbilityTemplate.Hostility != eHostility_Offensive || !bDealsDamage || AbilityTemplate.bIsASuppressionEffect)
        {
            return false;
        }
    }

    if (bMatchSourceWeapon)
    {
        if (AbilityState.SourceWeapon.ObjectID > 0)
        {
            if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    if (bIncreaseOnlyOnHit)
    {
        if (!AbilityContext.IsResultContextHit())
        {
            return false;
        }
    }
    if (bIncreaseOnlyOnMiss)
    {
        if (!AbilityContext.IsResultContextMiss())
        {
            return false;
        }
    }

    return true;
}

function float GetPreDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local XComGameState_Item        EffectSourceWeapon;
    local XCGS_Effect_BloodThirst   BloodThirstEffectState;

    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return 0;
        
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);
            EffectSourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
            if (BloodThirstEffectState != none)
            {
                return BloodThirstEffectState.GetTotalStacksRemaining() * GetDamagePerStack(Attacker, EffectSourceWeapon);
            }
        }
    }

    return 0;
}

event string GetSpecialDamageMessageName()
{
	return default.strSpecialDamageName;
}

defaultproperties
{
    EffectName = M31_BruhThirst

    bDisplayInSpecialDamageMessageUI = true
}