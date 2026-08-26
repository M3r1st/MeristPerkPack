class XCGS_Effect_PersistentAura extends XComGameState_Effect config(Game);

var config bool bLog;
var config bool bLogRelevancy;

function UpdateStats(XComGameState_Unit TargetUnit, XComGameState NewGameState)
{
    local X2Effect_PersistentAuraWithStats  Effect;
    local XComGameState_Effect              SelfObject;

    Effect = X2Effect_PersistentAuraWithStats(GetX2Effect());

    `LOG(GetFuncName() $ " for " $ TargetUnit.GetMyTemplateName() $ " (" $ TargetUnit.ObjectID $ ")", default.bLog, default.Class.Name);

    if (Effect == none)
    {
        `LOG("ERROR: X2Effect is not a child of X2Effect_PersistentAuraWithStats", true, self.Class.Name);
        return;
    }

    if (StatChanges.Length > 0)
    {
        `LOG("UnApplyEffectFromStats", default.bLog, default.Class.Name);
        SelfObject = self;
        TargetUnit.UnApplyEffectFromStats(SelfObject, NewGameState);
        StatChanges.Length = 0;
        if (Effect.UnApplyFromStatsEventName != '')
        {
            `XEVENTMGR.TriggerEvent(Effect.UnApplyFromStatsEventName, TargetUnit, TargetUnit, NewGameState);
        }
    }
    else
    {
        `LOG(GetFuncName(), default.bLog, default.Class.Name);
        SelfObject = self;
        StatChanges = Effect.GetStatChanges(SelfObject, NewGameState);
        if (StatChanges.Length > 0)
        {
            `LOG("ApplyEffectToStats", default.bLog, default.Class.Name);
            TargetUnit.ApplyEffectToStats(SelfObject, NewGameState);
        }
        else
        {
            `LOG("StatChanges not found", default.bLog, default.Class.Name);
        }
    }
}

function bool ShouldUpdateStats(const out XComGameState_Unit TargetUnit, const out XComGameState NewGameState)
{
    // local XComGameStateHistory              History;
    local X2Effect_PersistentAuraWithStats  Effect;
    local XComGameState_Effect              SelfObject;
    // local XComGameState_Effect              EffectState;
    // local StateObjectReference              EffectRef;

    Effect = X2Effect_PersistentAuraWithStats(GetX2Effect());

    `LOG(GetFuncName() $ " for " $ TargetUnit.GetMyTemplateName() $ " (" $ TargetUnit.ObjectID $ ")", default.bLog, default.Class.Name);

    if (Effect == none)
    {
        `LOG("ERROR: X2Effect is not a child of X2Effect_PersistentAuraWithStats", true, self.Class.Name);
        return false;
    }

    if (!bRemoved)
    {
        // Effect is relevant...
        if (Effect.IsEffectCurrentlyRelevant(self, TargetUnit))
        {
            `LOG("Effect is currently relevant", default.bLog, default.Class.Name);
            // ... and was relevant before; no changes needed
            if (StatChanges.Length > 0)
            {
                `LOG("Effect was relevant before", default.bLog, default.Class.Name);
                `LOG(GetFuncName() $ ": false", default.bLog, default.Class.Name);
                return false;
            }
            else // ... but wasn't relevant before; apply stat changes
            {
                `LOG("Effect wasn't relevant before", default.bLog, default.Class.Name);
                // If the modifier is unique, go through all other effects on the unit to see 
                // Code was moved to X2Effect_PersistentAuraWithStats::IsEffectCurrentlyRelevant()
                // if (Effect.IsUniqueModifier())
                // {
                //     `LOG("IsUniqueModifier: true", default.bLog, default.Class.Name);
                //     History = `XCOMHISTORY;

                //     foreach TargetUnit.AffectedByEffects(EffectRef)
                //     {
                //         if (EffectRef.ObjectID != ObjectID)
                //         {
                //             EffectState = XComGameState_Effect(NewGameState.GetGameStateForObjectID(EffectRef.ObjectID));
                //             if (EffectState == none)
                //                 EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
                //             if (EffectState != none)
                //             {
                //                 if (EffectState.GetX2Effect().EffectName == Effect.EffectName && EffectState.StatChanges.Length > 0)
                //                 {
                //                     `LOG(TargetUnit.GetMyTemplateName() $ " is already affected by " $ EffectState.GetX2Effect().EffectName, default.bLog, GetFuncName());
                //                     `LOG(GetFuncName() $ ": false", default.bLog, default.Class.Name);
                //                     return false;
                //                 }
                //             }
                //         }
                //     }
                // }
                SelfObject = self;
                if (Effect.GetStatChanges(SelfObject, NewGameState).Length > 0)
                {
                    `LOG(GetFuncName() $ ": true", default.bLog, default.Class.Name);
                    return true;
                }
                `LOG("StatChanges not found", default.bLog, default.Class.Name);
                `LOG(GetFuncName() $ ": false", default.bLog, default.Class.Name);
                return false;
            }
        }
        else // Effect is not relevant...
        {
            `LOG("Effect is not currently relevant", default.bLog, default.Class.Name);
            // ... but was relevant; unapply from stat changes
            if (StatChanges.Length > 0)
            {
                `LOG("Effect was relevant before", default.bLog, default.Class.Name);
                `LOG(GetFuncName() $ ": true", default.bLog, default.Class.Name);
                return true;
            }
            else // ... and was not relevant before; no changes needed
            {
                `LOG("Effect wasn't relevant before", default.bLog, default.Class.Name);
                `LOG(GetFuncName() $ ": false", default.bLog, default.Class.Name);
                return false;
            }
        }
    }

    return false;
}
