// This is an Unreal Script
class X2StatusEffects_Radiation extends X2StatusEffects config(Radiation);


////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////RAD BURNING/////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name RadBurningName;

var localized string  RadBurningFriendlyName;
var localized string  RadBurningFriendlyDesc;
var localized string  RadBurningEffectAcquiredString;
var localized string  RadBurningEffectTickedString;
var localized string  RadBurningEffectLostString;

var config int        RAD_BURNING_TURNS;

var config string     RadBurnEnteredParticle_Name;
var config name       RadBurnEnteredSocket_Name;
var config name       RadBurnEnteredSocketsArray_Name;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
//////////BOILING BLOOD/////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name RadBleedingName;

var config int        BOILING_BLOOD_TURNS;

var localized string  BoilingBloodFriendlyName;
var localized string  BoilingBloodFriendlyDesc;
var localized string  BoilingBloodEffectAcquiredString;
var localized string  BoilingBloodEffectTickedString;
var localized string  BoilingBloodEffectLostString;

var config array<name> RAD_BLEEDING_EXCLUDED_UNIT_TYPES;

var config string     BoilingBloodEnteredParticle_Name;
var config name       BoilingBloodSocket_Name;
var config name       BoilingBloodSocketsArray_Name;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
/////////////IRRADIATED/////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name RadDisorientedName;

var config int        IRRADIATED_TURNS;
var config int        IRRADIATED_MOBILITY_ADJUST;
var config int        IRRADIATED_AIM_ADJUST;
var config int        IRRADIATED_HIERARCHY_VALUE;

var localized string  IrradiatedFriendlyName;
var localized string  IrradiatedFriendlyDesc;
var localized string  IrradiatedEffectAcquiredString;
var localized string  IrradiatedEffectTickedString;
var localized string  IrradiatedEffectLostString;

var config string     IrradiatedParticle_Name;
var config name       IrradiatedSocket_Name;
var config name       IrradiatedSocketsArray_Name;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////////RAD PANICKED/////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////


var config int        RAD_PANICKED_TURNS;

var config int        RAD_PANICKED_AIM_ADJUST;
var config int        RAD_PANICKED_HIERARCHY_VALUE;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////////LOST RAD REGEN///////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name LostRadRegenName;

var localized string  LostRadRegenFriendlyName;
var localized string  LostRadRegenFriendlyDesc;
var localized string  LostRadRegenEffectAcquiredString;
var localized string  LostRadRegenEffectTickedString;
var localized string  LostRadRegenEffectLostString;

var config int         LOST_REGEN_TURNS;
var config array<name> LOST_REGEN_ALLOWED_UNIT_TYPES;

var config string     LostRadRegenParticle_Name;
var config name       LostRadRegenSocket_Name;
var config name       LostRadRegenSocketsArray_Name;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////////RAD BURN DODGE///////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name RadBurnDodgeName;

var config int        RAD_BURN_DODGE_ADJUST;
var config int        RAD_BURN_DODGE_TURNS;
var config int        RAD_BURN_DEFENSE_ADJUST;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////BOILING BLOOD MOBILITY DEBUFF///
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name BoilingBloodMobilityName;

var config int        BOILING_BLOOD_MOBILITY_TURNS;
var config int        BOILING_BLOOD_MOBILITY_ADJUST;
var config int        BOILING_BLOOD_AIM_ADJUST;

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
/////IRRADIATED ROBOTIC DEBUFFS/////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

var name IrradiatedRoboticDebuffName;

var config int        IRRADIATED_ROBOTIC_DEBUFF_TURNS;
var config int        IRRADIATED_ROBOTIC_DEBUFF_HACK_DEF_ADJUST;
var config int        IRRADIATED_ROBOTIC_DEBUFF_AIM_ADJUST;


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////RAD BURNING/////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////


static function X2Effect_Radiation CreateRadBurningStatusEffect(int Chance, int DamagePerTick, int DamageSpreadPerTick)
{
    local X2Effect_Radiation                RadBurningEffect;
    local X2Condition_UnitProperty          UnitPropCondition;

    RadBurningEffect = new class'X2Effect_Radiation';
    RadBurningEffect.EffectName = default.RadBurningName;
    RadBurningEffect.BuildPersistentEffect(default.RAD_BURNING_TURNS,, false,,eGameRule_PlayerTurnBegin);
    RadBurningEffect.SetDisplayInfo(ePerkBuff_Penalty, default.RadBurningFriendlyName, default.RadBurningFriendlyDesc, "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_RadBurn");
    RadBurningEffect.SetBurnDamage(DamagePerTick, DamageSpreadPerTick, 'Radiation');
    RadBurningEffect.VisualizationFn = RadBurningVisualization;
    RadBurningEffect.EffectTickedVisualizationFn = RadBurningVisualizationTicked;
    RadBurningEffect.EffectRemovedVisualizationFn = RadBurningVisualizationRemoved;
    RadBurningEffect.bRemoveWhenTargetDies = true;
    RadBurningEffect.DamageTypes.AddItem('Radiation');
    RadBurningEffect.DuplicateResponse = eDupe_Refresh;
    RadBurningEffect.bCanTickEveryAction = true;
    RadBurningEffect.ApplyChance = Chance;
    RadBurningEffect.EffectAppliedEventName = class'X2Effect_Radiation'.default.RadBurningEffectAddedEventName;

    if (default.RadBurnEnteredParticle_Name != "")
    {
        RadBurningEffect.VFXTemplateName = default.RadBurnEnteredParticle_Name;
        RadBurningEffect.VFXSocket = default.RadBurnEnteredSocket_Name;
        RadBurningEffect.VFXSocketsArrayName = default.RadBurnEnteredSocketsArray_Name;
    }

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = false;
    UnitPropCondition.FailOnNonUnits = true;
    RadBurningEffect.TargetConditions.AddItem(UnitPropCondition);

    return RadBurningEffect;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////RADIATION BURN VISUALIZATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////

static function RadBurningVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{

    if (EffectApplyResult != 'AA_Success')
        return;
    if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
        return;

    AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.RadBurningFriendlyName, 'RadBurning', eColor_Bad, class'UIUtilities_Image_Radiation'.const.UnitStatus_RadBurning);
    AddEffectMessageToTrack(
        ActionMetadata,
        default.RadBurningEffectAcquiredString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadBurningTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_RadBurn",
        eUIState_Bad);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function RadBurningVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if(UnitState == None || UnitState.IsDead() )
    {
        return;
    }

    AddEffectMessageToTrack(
        ActionMetadata,
        default.RadBurningEffectTickedString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadBurningTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_RadBurn",
        eUIState_Warning);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function RadBurningVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if(UnitState == None || UnitState.IsDead() )
    {
        return;
    }

    AddEffectMessageToTrack(
        ActionMetadata,
        default.RadBurningEffectLostString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadBurningTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_RadBurn",
        eUIState_Good);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////////BOILING BLOOD////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////


static function X2Effect_Radiation CreateRadBleedingStatusEffect(int Chance, int DamagePerTick, int DamageSpreadPerTick)
{
    local X2Effect_Radiation              RadBleedingEffect;
    local X2Condition_UnitProperty        UnitPropCondition;
    local X2Condition_UnitType            UnitTypeCondition;

    RadBleedingEffect = new class'X2Effect_Radiation';
    RadBleedingEffect.EffectName = default.RadBleedingName;
    RadBleedingEffect.BuildPersistentEffect(default.BOILING_BLOOD_TURNS,, false,,eGameRule_PlayerTurnBegin);
    RadBleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, default.BoilingBloodFriendlyName, default.BoilingBloodFriendlyDesc, "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_BoilingBlood");
    RadBleedingEffect.SetBurnDamage(DamagePerTick, DamageSpreadPerTick, 'Radiation');
    RadBleedingEffect.VisualizationFn = RadBleedingVisualization;
    RadBleedingEffect.EffectTickedVisualizationFn = RadBleedingVisualizationTicked;
    RadBleedingEffect.EffectRemovedVisualizationFn = RadBleedingVisualizationRemoved;
    RadBleedingEffect.bRemoveWhenTargetDies = true;
    RadBleedingEffect.DamageTypes.AddItem('Radiation');
    RadBleedingEffect.DuplicateResponse = eDupe_Refresh;
    RadBleedingEffect.bCanTickEveryAction = true;
    RadBleedingEffect.ApplyChance = Chance;
    RadBleedingEffect.EffectAppliedEventName = class'X2Effect_Radiation'.default.RadBleedingEffectAddedEventName;

    if (default.BoilingBloodEnteredParticle_Name != "")
    {
        RadBleedingEffect.VFXTemplateName = default.BoilingBloodEnteredParticle_Name;
        RadBleedingEffect.VFXSocket = default.BoilingBloodSocket_Name;
        RadBleedingEffect.VFXSocketsArrayName = default.BoilingBloodSocketsArray_Name;
    }

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = false;
    UnitPropCondition.FailOnNonUnits = true;
    RadBleedingEffect.TargetConditions.AddItem(UnitPropCondition);

    UnitTypeCondition = new class'X2Condition_UnitType';
    UnitTypeCondition.ExcludeTypes = default.RAD_BLEEDING_EXCLUDED_UNIT_TYPES;
    RadBleedingEffect.TargetConditions.AddItem(UnitTypeCondition);

    return RadBleedingEffect;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////BOILING BLOOD VISUALIZATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////

static function RadBleedingVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{

    if (EffectApplyResult != 'AA_Success')
        return;
    if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
        return;

    AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.BoilingBloodFriendlyName, 'RadBleeding', eColor_Bad, class'UIUtilities_Image_Radiation'.const.UnitStatus_RadBleeding);
    AddEffectMessageToTrack(
        ActionMetadata,
        default.BoilingBloodEffectAcquiredString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadBleedingTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_BoilingBlood",
        eUIState_Bad);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function RadBleedingVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if(UnitState == None || UnitState.IsDead() )
    {
        return;
    }

    AddEffectMessageToTrack(
        ActionMetadata,
        default.BoilingBloodEffectTickedString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadBleedingTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_BoilingBlood",
        eUIState_Warning);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function RadBleedingVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if(UnitState == None || UnitState.IsDead() )
    {
        return;
    }

    AddEffectMessageToTrack(
        ActionMetadata,
        default.BoilingBloodEffectLostString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadBleedingTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_BoilingBlood",
        eUIState_Good);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
/////////////IRRADIATED/////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

static function X2Effect_PersistentStatChange CreateRadDisorientedStatusEffect(int Chance, optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f, optional bool bIsMentalDamage = false)
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Condition_UnitProperty          UnitPropCondition;

    PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
    PersistentStatChangeEffect.EffectName = default.RadDisorientedName;
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
    PersistentStatChangeEffect.BuildPersistentEffect(default.IRRADIATED_TURNS,, false,,eGameRule_PlayerTurnBegin);
    PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.IrradiatedFriendlyName, default.IrradiatedFriendlyDesc, "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_Irradiated");
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.IRRADIATED_MOBILITY_ADJUST);
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.IRRADIATED_AIM_ADJUST);
    PersistentStatChangeEffect.VisualizationFn = RadDisorientedVisualization;
    PersistentStatChangeEffect.EffectTickedVisualizationFn = RadDisorientedVisualizationTicked;
    PersistentStatChangeEffect.EffectRemovedVisualizationFn = RadDisorientedVisualizationRemoved;
    PersistentStatChangeEffect.EffectHierarchyValue = default.IRRADIATED_HIERARCHY_VALUE;
    PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
    PersistentStatChangeEffect.bIsImpairingMomentarily = true;
    PersistentStatChangeEffect.ApplyChance = Chance;
    PersistentStatChangeEffect.DamageTypes.AddItem('Radiation');

    if (default.IrradiatedParticle_Name != "")
    {
        PersistentStatChangeEffect.VFXTemplateName = default.IrradiatedParticle_Name;
        PersistentStatChangeEffect.VFXSocket = default.IrradiatedSocket_Name;
        PersistentStatChangeEffect.VFXSocketsArrayName = default.IrradiatedSocketsArray_Name;
    }

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeRobotic = false;
    UnitPropCondition.FailOnNonUnits = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

    return PersistentStatChangeEffect;
}

static function RadDisorientedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    if (EffectApplyResult != 'AA_Success')
    {
        return;
    }

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    if (UnitState != none && !UnitState.IsRobotic())
    {
        AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.IrradiatedFriendlyName, 'RadDisoriented', eColor_Bad, class'UIUtilities_Image_Radiation'.const.UnitStatus_RadDisoriented);
        AddEffectMessageToTrack(
            ActionMetadata,
            default.IrradiatedEffectAcquiredString,
            VisualizeGameState.GetContext(),
            class'UIEventNoticesTactical_Radiation'.default.RadDisorientedTitle,
            "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_Irradiated",
            eUIState_Bad);
        UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
    }
}

static function RadDisorientedVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
    if (UnitState == none)
        return;

    // dead units should not be reported
    if( !UnitState.IsAlive() )
    {
        return;
    }

    AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.IrradiatedFriendlyName, 'RadDisoriented', eColor_Bad, class'UIUtilities_Image_Radiation'.const.UnitStatus_RadDisoriented);
    AddEffectMessageToTrack(
        ActionMetadata,
        default.IrradiatedEffectTickedString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadDisorientedTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_Irradiated",
        eUIState_Warning);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function RadDisorientedVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
    if (UnitState == none)
        return;

    // dead units should not be reported
    if( !UnitState.IsAlive() )
    {
        return;
    }

    AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.IrradiatedEffectLostString, '', eColor_Good, class'UIUtilities_Image_Radiation'.const.UnitStatus_RadDisoriented, 2.0f);
    AddEffectMessageToTrack(
        ActionMetadata,
        default.IrradiatedEffectLostString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.RadDisorientedTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_Irradiated",
        eUIState_Good);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////////////RAD PANICKED////////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

//Only exists so i can add a chance to apply panic on radiation weapons and stuff
static function X2Effect_Panicked CreateRadPanickedStatusEffect(int Chance)
{
    local X2Effect_Panicked     RadPanickedEffect;

    RadPanickedEffect = new class'X2Effect_Panicked';
    RadPanickedEffect.EffectName = class'X2AbilityTemplateManager'.default.PanickedName;
    RadPanickedEffect.BuildPersistentEffect(default.RAD_PANICKED_TURNS, , , , eGameRule_PlayerTurnBegin);  // Because the effect is removed at Begin turn, we add 1 to duration.
    RadPanickedEffect.AddPersistentStatChange(eStat_Offense, default.RAD_PANICKED_AIM_ADJUST);
    RadPanickedEffect.EffectHierarchyValue = default.RAD_PANICKED_HIERARCHY_VALUE;
    RadPanickedEffect.EffectAppliedEventName = 'PanickedEffectApplied';
    RadPanickedEffect.ApplyChance = Chance;

    return RadPanickedEffect;
}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////LOST RAD REGENERATION////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////


static function X2Effect_Radiation CreateLostRadRegenStatusEffect(int Chance)
{
    local X2Effect_Radiation              LostRadRegenEffect;
    local X2Condition_UnitProperty        UnitPropCondition;
    local X2Condition_UnitType            UnitTypeCondition;

    LostRadRegenEffect = new class'X2Effect_Radiation';
    LostRadRegenEffect.EffectName = default.LostRadRegenName;
    LostRadRegenEffect.BuildPersistentEffect(default.LOST_REGEN_TURNS, false, true,,eGameRule_PlayerTurnBegin);
    LostRadRegenEffect.SetDisplayInfo(ePerkBuff_Bonus, default.LostRadRegenFriendlyName, default.LostRadRegenFriendlyDesc, "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_LostRegeneration");
    LostRadRegenEffect.VisualizationFn = LostRadRegenVisualization;
    LostRadRegenEffect.EffectTickedVisualizationFn = LostRadRegenVisualizationTicked;
    LostRadRegenEffect.EffectRemovedVisualizationFn = LostRadRegenVisualizationRemoved;
    LostRadRegenEffect.bRemoveWhenTargetDies = true;
    LostRadRegenEffect.DamageTypes.AddItem('Radiation');
    LostRadRegenEffect.DuplicateResponse = eDupe_Refresh;
    LostRadRegenEffect.bCanTickEveryAction = true;
    LostRadRegenEffect.ApplyChance = Chance;
    LostRadRegenEffect.EffectAppliedEventName = class'X2Effect_Radiation'.default.LostRadRegenEffectApplied;

    if (default.LostRadRegenParticle_Name != "")
    {
        LostRadRegenEffect.VFXTemplateName = default.LostRadRegenParticle_Name;
        LostRadRegenEffect.VFXSocket = default.LostRadRegenSocket_Name;
        LostRadRegenEffect.VFXSocketsArrayName = default.LostRadRegenSocketsArray_Name;
    }

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = false;
    UnitPropCondition.FailOnNonUnits = true;
    LostRadRegenEffect.TargetConditions.AddItem(UnitPropCondition);

    UnitTypeCondition = new class'X2Condition_UnitType';
    UnitTypeCondition.IncludeTypes = default.LOST_REGEN_ALLOWED_UNIT_TYPES;
    LostRadRegenEffect.TargetConditions.AddItem(UnitTypeCondition);

    return LostRadRegenEffect;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////LOST RAD REGENERATION VISUALIZATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////

static function LostRadRegenVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{

    if (EffectApplyResult != 'AA_Success')
        return;
    if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
        return;

    AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.LostRadRegenFriendlyName, 'LostRadRegen', eColor_Bad, class'UIUtilities_Image_Radiation'.const.UnitStatus_LostRadRegen);
    AddEffectMessageToTrack(
        ActionMetadata,
        default.LostRadRegenEffectAcquiredString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.LostRadRegenTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_LostRegeneration",
        eUIState_Bad);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function LostRadRegenVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if(UnitState == None || UnitState.IsDead() )
    {
        return;
    }

    AddEffectMessageToTrack(
        ActionMetadata,
        default.LostRadRegenEffectTickedString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.LostRadRegenTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_LostRegeneration",
        eUIState_Warning);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function LostRadRegenVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    // dead units should not be reported
    if(UnitState == None || UnitState.IsDead() )
    {
        return;
    }

    AddEffectMessageToTrack(
        ActionMetadata,
        default.LostRadRegenEffectLostString,
        VisualizeGameState.GetContext(),
        class'UIEventNoticesTactical_Radiation'.default.LostRadRegenTitle,
        "img:///WoTC_Radiation_Status_Effect.UI.UIPerk_LostRegenerationn",
        eUIState_Good);
    UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
///////RAD BURN DODGE DEBUFF////////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

static function X2Effect_PersistentStatChange CreateRadBurnDodgeStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f, optional bool bIsMentalDamage = false)
{
    local X2Effect_PersistentStatChange     RadBurnDodgeEffect;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Condition_UnitEffects           UnitEffectConditions;

    RadBurnDodgeEffect = new class'X2Effect_PersistentStatChange';
    RadBurnDodgeEffect.EffectName = default.RadBurnDodgeName;
    RadBurnDodgeEffect.DuplicateResponse = eDupe_Refresh;
    RadBurnDodgeEffect.BuildPersistentEffect(default.RAD_BURN_DODGE_TURNS,, false,,eGameRule_PlayerTurnBegin);
    //RadBurnDodgeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.IrradiatedFriendlyName, default.IrradiatedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
    RadBurnDodgeEffect.AddPersistentStatChange(eStat_Dodge, default.RAD_BURN_DODGE_ADJUST);
    RadBurnDodgeEffect.AddPersistentStatChange(eStat_Defense, default.RAD_BURN_DEFENSE_ADJUST);
    RadBurnDodgeEffect.bRemoveWhenTargetDies = true;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeRobotic = true;
    UnitPropCondition.FailOnNonUnits = true;
    RadBurnDodgeEffect.TargetConditions.AddItem(UnitPropCondition);

    UnitEffectConditions = new class'X2Condition_UnitEffects';
    UnitEffectConditions.AddRequireEffect(class'X2StatusEffects_Radiation'.default.RadBurningName, 'AA_MissingRequiredEffect');
    RadBurnDodgeEffect.TargetConditions.AddItem(UnitEffectConditions);

    return RadBurnDodgeEffect;
}

////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
////BOILING BLOOD MOBILITY DEBUFF///
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

static function X2Effect_PersistentStatChange CreateBoilingBloodMobilityStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f, optional bool bIsMentalDamage = false)
{
    local X2Effect_PersistentStatChange     BoilingBloodMobilityEffect;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Condition_UnitEffects           UnitEffectConditions;

    BoilingBloodMobilityEffect = new class'X2Effect_PersistentStatChange';
    BoilingBloodMobilityEffect.EffectName = default.BoilingBloodMobilityName;
    BoilingBloodMobilityEffect.DuplicateResponse = eDupe_Refresh;
    BoilingBloodMobilityEffect.BuildPersistentEffect(default.BOILING_BLOOD_MOBILITY_TURNS,, false,,eGameRule_PlayerTurnBegin);
    //RadBurnDodgeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.IrradiatedFriendlyName, default.IrradiatedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
    BoilingBloodMobilityEffect.AddPersistentStatChange(eStat_Mobility, default.BOILING_BLOOD_MOBILITY_ADJUST);
    BoilingBloodMobilityEffect.AddPersistentStatChange(eStat_Offense, default.BOILING_BLOOD_AIM_ADJUST);
    BoilingBloodMobilityEffect.bRemoveWhenTargetDies = true;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeRobotic = true;
    UnitPropCondition.FailOnNonUnits = true;
    BoilingBloodMobilityEffect.TargetConditions.AddItem(UnitPropCondition);

    UnitEffectConditions = new class'X2Condition_UnitEffects';
    UnitEffectConditions.AddRequireEffect(class'X2StatusEffects_Radiation'.default.RadBleedingName, 'AA_MissingRequiredEffect');
    BoilingBloodMobilityEffect.TargetConditions.AddItem(UnitEffectConditions);

    return BoilingBloodMobilityEffect;
}


////////////////////////////////////
////////////////////////////////////
////////////////////////////////////
/////IRRADIATED ROBOTIC DEBUFFS/////
////////////////////////////////////
////////////////////////////////////
////////////////////////////////////

static function X2Effect_PersistentStatChange CreateIrradiatedRoboticDebuffStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f, optional bool bIsMentalDamage = false)
{
    local X2Effect_PersistentStatChange     IrradiatedRoboticDebuffEffect;
    local X2Condition_UnitProperty          UnitPropCondition;
    local X2Condition_UnitEffects           UnitEffectConditions;

    IrradiatedRoboticDebuffEffect = new class'X2Effect_PersistentStatChange';
    IrradiatedRoboticDebuffEffect.EffectName = default.IrradiatedRoboticDebuffName;
    IrradiatedRoboticDebuffEffect.DuplicateResponse = eDupe_Refresh;
    IrradiatedRoboticDebuffEffect.BuildPersistentEffect(default.IRRADIATED_ROBOTIC_DEBUFF_TURNS,, false,,eGameRule_PlayerTurnBegin);
    //RadBurnDodgeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.IrradiatedFriendlyName, default.IrradiatedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
    IrradiatedRoboticDebuffEffect.AddPersistentStatChange(eStat_HackDefense, default.IRRADIATED_ROBOTIC_DEBUFF_HACK_DEF_ADJUST);
    IrradiatedRoboticDebuffEffect.AddPersistentStatChange(eStat_Offense, default.IRRADIATED_ROBOTIC_DEBUFF_AIM_ADJUST);
    IrradiatedRoboticDebuffEffect.bRemoveWhenTargetDies = true;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeRobotic = false;
    UnitPropCondition.FailOnNonUnits = true;
    UnitPropCondition.ExcludeOrganic = true;
    IrradiatedRoboticDebuffEffect.TargetConditions.AddItem(UnitPropCondition);

    UnitEffectConditions = new class'X2Condition_UnitEffects';
    UnitEffectConditions.AddRequireEffect(class'X2StatusEffects_Radiation'.default.RadDisorientedName, 'AA_MissingRequiredEffect');
    IrradiatedRoboticDebuffEffect.TargetConditions.AddItem(UnitEffectConditions);

    return IrradiatedRoboticDebuffEffect;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


DefaultProperties
{
    RadBurningName="RadBurning"
    RadBleedingName="RadBleeding"
    RadDisorientedName="RadDisoriented"
    LostRadRegenName="LostRadRegen"
    RadBurnDodgeName="RadBurnDodge"
    BoilingBloodMobilityName="BoilingBloodMobility"
    IrradiatedRoboticDebuffName="IrradiatedRoboticDebuff"
}