class MZ_Effect_Hypothermia extends X2Effect_Persistent config(MZBitterfrost);

var privatewrite name HyptothermiaEffectAddedEventName;
var config bool Hypothermia_Ignores_Shield, Hypothermia_Ignores_Armour;
var config int Damage, TierDamage, Spread;

var localized string HypothermiaEffectName;
var localized string HypothermiaEffectDesc;
var localized string HypothermiaTitle;

var localized string HypothermiaEffectAcquiredString;
var localized string HypothermiaEffectTickedString;
var localized string HypothermiaEffectLostString;

static function MZ_Effect_Hypothermia CreateHypothermiaEffect(int Turns) //, int DamagePerTick, int DamageSpreadPerTick)
{
    local MZ_Effect_Hypothermia BurningEffect;
    local X2Condition_UnitProperty UnitPropCondition;

    BurningEffect = new class'MZ_Effect_Hypothermia';
    BurningEffect.BuildPersistentEffect(Turns,, false,,eGameRule_PlayerTurnBegin);
    BurningEffect.SetDisplayInfo(ePerkBuff_Penalty, default.HypothermiaEffectName, default.HypothermiaEffectDesc, "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");
    BurningEffect.SetBurnDamage();

    BurningEffect.VisualizationFn = HypothermiaVisualization;
    BurningEffect.EffectTickedVisualizationFn = HypothermiaVisualizationTicked;
    BurningEffect.EffectRemovedVisualizationFn = HypothermiaVisualizationRemoved;

    BurningEffect.bRemoveWhenTargetDies = true;
    BurningEffect.DamageTypes.AddItem('Frost');
    BurningEffect.DuplicateResponse = eDupe_Refresh;
    BurningEffect.bCanTickEveryAction = true;
    BurningEffect.EffectAppliedEventName = default.HyptothermiaEffectAddedEventName;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = false;
    BurningEffect.TargetConditions.AddItem(UnitPropCondition);

    return BurningEffect;
}

simulated function SetBurnDamage()
{
    local MZ_Damage_Hypothermia BurnDamage;

    BurnDamage = new class'MZ_Damage_Hypothermia';
    BurnDamage.bAllowFreeKill = false;
    BurnDamage.bIgnoreArmor = default.Hypothermia_Ignores_Armour;
    BurnDamage.bBypassShields = default.Hypothermia_Ignores_Shield; //Issue #89

    BurnDamage.Damage = default.Damage;
    BurnDamage.TierDamage = default.TierDamage;
    BurnDamage.Spread = default.Spread;
    BurnDamage.EffectDamageValue.DamageType = 'Frost';
    BurnDamage.bIgnoreBaseDamage = true;
    BurnDamage.DamageTag = self.Name;

    ApplyOnTick.AddItem(BurnDamage);
}

static function HypothermiaVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    if (EffectApplyResult !=  'AA_Success')
        return;
    if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
        return;

    class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.HypothermiaEffectName, '', eColor_Bad, default.StatusIcon);
    class'X2StatusEffects'.static.AddEffectMessageToTrack(
        ActionMetadata,
        default.HypothermiaEffectAcquiredString,
        VisualizeGameState.GetContext(),
        default.HypothermiaTitle,
        default.StatusIcon,
        eUIState_Bad);
    class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function HypothermiaVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if (UnitState == none || UnitState.IsDead())
    {
        return;
    }

    class'X2StatusEffects'.static.AddEffectMessageToTrack(
        ActionMetadata,
        default.HypothermiaEffectTickedString,
        VisualizeGameState.GetContext(),
        default.HypothermiaTitle,
        default.StatusIcon,
        eUIState_Warning);
    class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function HypothermiaVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if (UnitState == none || UnitState.IsDead())
    {
        return;
    }

    class'X2StatusEffects'.static.AddEffectMessageToTrack(
        ActionMetadata,
        default.HypothermiaEffectLostString,
        VisualizeGameState.GetContext(),
        default.HypothermiaTitle,
        default.StatusIcon,
        eUIState_Good);
    class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    bCanTickEveryAction = true
    EffectName = MZHypothermia

    HyptothermiaEffectAddedEventName = HypothermiaEffectAdded
}