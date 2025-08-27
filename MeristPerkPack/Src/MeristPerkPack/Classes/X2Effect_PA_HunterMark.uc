class X2Effect_PA_HunterMark extends X2Effect_Persistent;

var int DefenseBonus;
var int DefenseBonusPerTurn;
var int DodgeBonus;
var int DodgeBonusPerTurn;
var int AimBonus;
var int AimBonusPerTurn;
var int CritBonus;
var int CritBonusPerTurn;

var int MaxTurns;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    local int Counter;

    if (Attacker.ObjectID == EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
    {
        if (MaxTurns != 0)
            Counter = Min(EffectState.FullTurnsTicked, MaxTurns);
        else
            Counter = EffectState.FullTurnsTicked;

        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus + AimBonusPerTurn * Counter;
        ShotModifiers.AddItem(AimInfo);

        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus + CritBonusPerTurn * Counter;
        ShotModifiers.AddItem(CritInfo);
    }
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo DefenseInfo;
    local ShotModifierInfo DodgeInfo;
    local int Counter;

    if (Target.ObjectID == EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
    {
        if (MaxTurns != 0)
            Counter = Min(EffectState.FullTurnsTicked, MaxTurns);
        else
            Counter = EffectState.FullTurnsTicked;

        DefenseInfo.ModType = eHit_Success;
        DefenseInfo.Reason = FriendlyName;
        DefenseInfo.Value = -1 * (DefenseBonus + DefenseBonusPerTurn * Counter);
        ShotModifiers.AddItem(DefenseInfo);

        DodgeInfo.ModType = eHit_Graze;
        DodgeInfo.Reason = FriendlyName;
        DodgeInfo.Value = DodgeBonus + DodgeBonusPerTurn * Counter;
        ShotModifiers.AddItem(DodgeInfo);
    }
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameStateContext_Ability      Context;
    local X2AbilityTemplate                 AbilityTemplate;

    if (EffectApplyResult != 'AA_Success')
        return;

    if (XComGameState_Unit(ActionMetadata.StateObject_NewState) == none)
      return;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

    if (Context != none)
    {
        AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

        if (AbilityTemplate != none)
        {
            class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(
                ActionMetadata,
                VisualizeGameState.GetContext(),
                AbilityTemplate.LocFlyOverText,
                '',
                eColor_Bad,
                AbilityTemplate.IconImage);
            // class'UIUtilities_Image'.const.UnitStatus_Marked
        }
    }
}

defaultproperties
{
    bUniqueTarget = true
    bRemoveWhenTargetDies = true
    DuplicateResponse = eDupe_Refresh
    EffectName = M31_PA_HunterMark
}