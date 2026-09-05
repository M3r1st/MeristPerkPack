class X2Effect_SK_ZeroIn extends X2Effect_Persistent;

var int CritPerShot;
var int LockedInAimPerShot;
var bool bDontResetOnMovement;
var bool bAllowIncrementWithoutInput;

var name ShotsValueName;
var name TargetValueName;
var name LockedInShotsValueName;

var localized string strFriendlyDesc;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_ZeroIn, ELD_OnStateSubmitted, 99, TargetState,, EffectObj);
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item    SourceWeapon;
    local UnitValue             ShotsValue, TargetValue, LockedInShotsValue;
    local bool                  bValidWeapon;
    local ShotModifierInfo      ShotMod;

    SourceWeapon = AbilityState.GetSourceWeapon();
    if (SourceWeapon != none)
    {
        if (EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
        {
            if (AbilityState.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
                bValidWeapon = true;
        }
        else if (SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
        {
            bValidWeapon = true;
        }
    }

    if (!bIndirectFire && bValidWeapon)
    {
        Attacker.GetUnitValue(ShotsValueName, ShotsValue);
        Attacker.GetUnitValue(TargetValueName, TargetValue);
        Attacker.GetUnitValue(LockedInShotsValueName, LockedInShotsValue);

        if (ShotsValue.fValue > 0)
        {
            ShotMod.ModType = eHit_Crit;
            ShotMod.Reason = FriendlyName;
            ShotMod.Value = ShotsValue.fValue * CritPerShot;
            ShotModifiers.AddItem(ShotMod);

            if (TargetValue.fValue == Target.ObjectID)
            {
                ShotMod.ModType = eHit_Success;
                ShotMod.Reason = FriendlyName;
                ShotMod.Value = LockedInShotsValue.fValue * LockedInAimPerShot;
                ShotModifiers.AddItem(ShotMod);
            }
        }
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue ShotsValue;

    TargetUnit.GetUnitValue(ShotsValueName, ShotsValue);

    return ShotsValue.fValue > 0;
}

static function EventListenerReturn EffectEventListener_ZeroIn(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          EffectState;
    local X2Effect_SK_ZeroIn            Effect;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Item            SourceWeapon;
    local XComGameState                 NewGameState;
    local UnitValue                     ShotsValue, TargetValue, LockedInShotsValue;
    local bool                          bValidWeapon;
    local int                           NumHits;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        EffectState = XComGameState_Effect(CallbackData);
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        if (EffectState != none && SourceUnit != none && AbilityState != none)
        {
            Effect = X2Effect_SK_ZeroIn(EffectState.GetX2Effect());
            if (Effect != none)
            {
                // Do nothing on free non-offensive actions, such as Run and Gun, Fortify, Incoming, etc
                if (AbilityState.GetMyTemplate().Hostility != eHostility_Offensive && class'M31_Helpers'.static.WasAbilityFree(AbilityState, SourceUnit, GameState.HistoryIndex - 1))
                {
                    return ELR_NoInterrupt;
                }

                // If allowed, do nothing on movement
                if (AbilityState.GetMyTemplate().Hostility == eHostility_Movement)
                {
                    if (!Effect.bDontResetOnMovement)
                    {
                        SourceUnit.GetUnitValue(Effect.ShotsValueName, ShotsValue);
                        if (ShotsValue.fValue > 0)
                        {
                            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("ZeroIn Reset");
                            SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
                            SourceUnit.ClearUnitValue(Effect.ShotsValueName);
                            SourceUnit.ClearUnitValue(Effect.TargetValueName);
                            SourceUnit.ClearUnitValue(Effect.LockedInShotsValueName);
                            `TACTICALRULES.SubmitGameState(NewGameState);
                        }
                    }
                    return ELR_NoInterrupt;
                }

                // Requires a weapon match
                SourceWeapon = AbilityState.GetSourceWeapon();
                if (SourceWeapon != none)
                {
                    if (EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
                    {
                        if (AbilityState.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
                            bValidWeapon = true;
                    }
                    else if (SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
                    {
                        bValidWeapon = true;
                    }

                    if (bValidWeapon)
                    {
                        if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
                        {
                            if (Effect.bAllowIncrementWithoutInput || AbilityState.IsAbilityInputTriggered())
                            {
                                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("ZeroIn Increment");
                                SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));

                                NumHits = class'M31_Helpers'.static.GetNumHitsForAbility(AbilityState);

                                SourceUnit.GetUnitValue(Effect.ShotsValueName, ShotsValue);
                                SourceUnit.SetUnitFloatValue(Effect.ShotsValueName, ShotsValue.fValue + NumHits, eCleanup_BeginTactical);

                                SourceUnit.GetUnitValue(Effect.TargetValueName, TargetValue);
                                if (TargetValue.fValue == AbilityContext.InputContext.PrimaryTarget.ObjectID)
                                {
                                    SourceUnit.GetUnitValue(Effect.LockedInShotsValueName, LockedInShotsValue);
                                    SourceUnit.SetUnitFloatValue(Effect.LockedInShotsValueName, LockedInShotsValue.fValue + NumHits, eCleanup_BeginTactical);
                                }
                                else
                                {
                                    SourceUnit.SetUnitFloatValue(Effect.TargetValueName, AbilityContext.InputContext.PrimaryTarget.ObjectID, eCleanup_BeginTactical);
                                    SourceUnit.SetUnitFloatValue(Effect.LockedInShotsValueName, NumHits);
                                }

                                NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                                XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = class'M31_Helpers'.static.TriggerAbilityFlyover_BuildVisualization;
                                `TACTICALRULES.SubmitGameState(NewGameState);
                            }
                        }
                        return ELR_NoInterrupt;
                    }
                }

                if (AbilityState.IsAbilityInputTriggered())
                {
                    SourceUnit.GetUnitValue(Effect.ShotsValueName, ShotsValue);
                    if (ShotsValue.fValue > 0)
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("ZeroIn Reset");
                        SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
                        SourceUnit.ClearUnitValue(Effect.ShotsValueName);
                        SourceUnit.ClearUnitValue(Effect.TargetValueName);
                        SourceUnit.ClearUnitValue(Effect.LockedInShotsValueName);
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }
                    return ELR_NoInterrupt;
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    EffectName = M31_SK_ZeroIn
    DuplicateResponse = eDupe_Ignore

    ShotsValueName = M31_SK_ZeroIn_Shots
    TargetValueName = M31_SK_ZeroIn_Target
    LockedInShotsValueName = M31_SK_ZeroIn_LockedInShots
}