class X2Effect_Roulette extends X2Effect_Persistent;

struct RouletteRoll
{
    var int Value;
    var int Weight;

    structdefaultproperties
    {
        Value = 100
        Weight = 1
    }
};

var array<name> AllowedAbilities;
var bool bMatchSourceWeapon;

var protected array<RouletteRoll> Rolls;
var protected int TotalWeight;

var localized string RouletteFail;
var localized string RouletteSuccess;

function AddRouletteRoll(int Value, int Weight)
{
    local RouletteRoll NewRoll;

    NewRoll.Value = Value;
    NewRoll.Weight = Weight;
    TotalWeight += Weight;

    Rolls.AddItem(NewRoll);
}

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local XCGS_Effect_Roulette RouletteState;
    local int RandRoll;
    local int CurrentWeight;
    local int i;

    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
        return 0;

    if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    if (NewGameState != none)
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
        {
            if (CurrentDamage > 0)
            {
                RouletteState = XCGS_Effect_Roulette(EffectState);
                RouletteState = XCGS_Effect_Roulette(NewGameState.ModifyStateObject(RouletteState.Class, RouletteState.ObjectID));
                RandRoll = `SYNC_RAND(TotalWeight);
                for (i = 0; i < Rolls.Length; i++)
                {
                    if (CurrentWeight + Rolls[i].Weight > RandRoll)
                    {
                        break;
                    }
                    else
                    {
                        CurrentWeight += Rolls[i].Weight;
                    }
                }

                RouletteState.LastValue = Rolls[i].Value;
                NewGameState.GetContext().PostBuildVisualizationFn.AddItem(Roulette_PostBuildVisualization);
                return CurrentDamage * Rolls[i].Value / 100 - CurrentDamage;
            }
        }
    }

    return 0;
}

static function Roulette_PostBuildVisualization(XComGameState VisualizeGameState)
{
    local XCGS_Effect_Roulette          EffectState;
    local VisualizationActionMetadata   BuildTrack;
    local XComGameStateHistory          History;
    local X2Action_PlaySoundAndFlyOver  FlyOverAction;
    local string                        FlyoverString;
    local EWidgetColor                  FlyoverColor;

    History = `XCOMHISTORY;
    foreach VisualizeGameState.IterateByClassType(class'XCGS_Effect_Roulette', EffectState)
    {
        if (EffectState.LastValue < 100)
        {
            FlyoverString = default.RouletteFail;
            FlyoverColor = eColor_Bad;
        }
        else if (EffectState.LastValue > 100)
        {
            FlyoverString = default.RouletteSuccess;
            FlyoverColor = eColor_Good;
        }

        if (FlyoverString != "")
        {
            BuildTrack.VisualizeActor = History.GetVisualizer(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
            History.GetCurrentAndPreviousGameStatesForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, , VisualizeGameState.HistoryIndex);
            if (BuildTrack.StateObject_NewState == none)
                BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
            else if (BuildTrack.StateObject_OldState == none)
                BuildTrack.StateObject_OldState = BuildTrack.StateObject_NewState;

            FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
            FlyOverAction.SetSoundAndFlyOverParameters(none, FlyoverString, '', FlyoverColor, "");
        }
            

        break;
    }
}

defaultproperties
{
    GameStateEffectClass = class'XCGS_Effect_Roulette'
}