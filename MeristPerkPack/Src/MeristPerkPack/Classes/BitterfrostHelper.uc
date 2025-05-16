class BitterfrostHelper extends Object config(MZBitterfrost);

var config int Chill_Turns, BitterChill_Turns, BitterfrostFreeze_MinDuration, BitterfrostFreeze_MaxDuration;
var config float Chill_Mobility, Chill_Dodge, BitterChill_Mobility, BitterChill_Dodge;
var config string ChillParticle_Name;
var config name ChillSocket_Name, ChillSocketsArray_Name;
var localized string ChillEffectName, ChillEffectDesc, BitterChillEffectName, BitterChillEffectDesc;

var config float Blind_VisionMult;

static function ChillVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    if (EffectApplyResult != 'AA_Success')
        return;
    if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
        return;

    class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.ChillEffectName, '', eColor_Bad, "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");
    class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function BChillVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    if (EffectApplyResult != 'AA_Success')
        return;
    if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
        return;

    class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.BitterChillEffectName, '', eColor_Bad, "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");
    class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function X2Effect_PersistentStatChange ChillEffect()
{
    local X2Effect_PersistentStatChange	ChillEffect;

    ChillEffect = new class'X2Effect_PersistentStatChange';
    ChillEffect.BuildPersistentEffect(default.Chill_Turns, false, false, false, eGameRule_PlayerTurnEnd);
    ChillEffect.EffectName = 'MZChill';
    ChillEffect.DuplicateResponse = eDupe_Refresh;
    ChillEffect.bRemoveWhenTargetDies = true;
    ChillEffect.AddPersistentStatChange(eStat_Mobility, default.Chill_Mobility, MODOP_PostMultiplication);
    ChillEffect.AddPersistentStatChange(eStat_Dodge, default.Chill_Dodge, MODOP_PostMultiplication);
    ChillEffect.DamageTypes.AddItem('Frost');
    ChillEffect.SetDisplayInfo(ePerkBuff_Penalty, default.ChillEffectName , default.ChillEffectDesc, "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", true);
    ChillEffect.VisualizationFn = ChillVisualization;
    if (default.ChillParticle_Name != "")
    {
        ChillEffect.VFXTemplateName = default.ChillParticle_Name;
        ChillEffect.VFXSocket = default.ChillSocket_Name;
        ChillEffect.VFXSocketsArrayName = default.ChillSocketsArray_Name;
    }

    return ChillEffect;
}

static function X2Effect_PersistentStatChange BitterChillEffect(optional bool RequireChill = True)
{
    local X2Effect_PersistentStatChange     BitterChillEffect;

    BitterChillEffect = new class'X2Effect_PersistentStatChange';
    BitterChillEffect.BuildPersistentEffect(default.BitterChill_Turns, false, false, false, eGameRule_PlayerTurnEnd);
    BitterChillEffect.EffectName = 'MZBitterChill';
    BitterChillEffect.DuplicateResponse = eDupe_Refresh;
    BitterChillEffect.bRemoveWhenTargetDies = true;
    BitterChillEffect.AddPersistentStatChange(eStat_Mobility, default.BitterChill_Mobility, MODOP_PostMultiplication);
    BitterChillEffect.AddPersistentStatChange(eStat_Dodge, default.BitterChill_Dodge, MODOP_PostMultiplication);
    BitterChillEffect.DamageTypes.AddItem('Frost');
    BitterChillEffect.SetDisplayInfo(ePerkBuff_Penalty, default.BitterChillEffectName , default.BitterChillEffectDesc, "img:///UILibrary_DLC2Images.UIPerk_freezingbreath", true);
    BitterChillEffect.VisualizationFn = BChillVisualization;
    if ( RequireChill )
    {
        BitterChillEffect.TargetConditions.AddItem(new class'MZ_Condition_IsChilled');
    }

    return BitterChillEffect;
}

static function X2Effect_DLC_Day60Freeze FreezeEffect(optional bool bHasChillReq=true)
{
    local X2Condition_UnitEffects           ChillDegreeCondition;
    local X2Effect_DLC_Day60Freeze          FreezeEffect;

    FreezeEffect = class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeEffect(default.BitterfrostFreeze_MinDuration, default.BitterfrostFreeze_MaxDuration);
    FreezeEffect.bApplyRulerModifiers = true;
    if ( bHasChillReq )
    {
        ChillDegreeCondition = new class'X2Condition_UnitEffects';
        ChillDegreeCondition.AddRequireEffect('MZBitterChill', 'AA_MissingRequiredEffect'); // name effect, name reason
        FreezeEffect.TargetConditions.AddItem(ChillDegreeCondition);
    }

    return FreezeEffect;
}

static function X2Effect FreezeCleanse(optional bool bHasChillReq=true)
{
    local X2Condition_UnitEffects           ChillDegreeCondition;
    local X2Effect                          RemoveEffects; 

    RemoveEffects=class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeRemoveEffects();
    if ( bHasChillReq )
    {
        ChillDegreeCondition = new class'X2Condition_UnitEffects';
        ChillDegreeCondition.AddRequireEffect('MZBitterChill', 'AA_MissingRequiredEffect'); // name effect, name reason
        RemoveEffects.TargetConditions.AddItem(ChillDegreeCondition);
    }

    return RemoveEffects;
}


static function X2Effect UnChillEffect()
{
    local X2Effect_RemoveEffectsByDamageType    RemoveEffects;

    RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
    RemoveEffects.DamageTypesToRemove.AddItem('Frost');
    RemoveEffects.EffectNamesToRemove.AddItem('Freeze');

    return RemoveEffects;
}

static function AddBitterfrostToMultiTarget(out X2AbilityTemplate Template)
{
    Template.AddMultiTargetEffect(FreezeCleanse());
    Template.AddMultiTargetEffect(FreezeEffect());
    Template.AddMultiTargetEffect(BitterChillEffect());
    Template.AddMultiTargetEffect(ChillEffect());
}

static function AddBitterfrostToTarget(out X2AbilityTemplate Template)
{
    Template.AddTargetEffect(FreezeCleanse());
    Template.AddTargetEffect(FreezeEffect());
    Template.AddTargetEffect(BitterChillEffect());
    Template.AddTargetEffect(ChillEffect());
}

static function X2Effect_Blind CreateBlindEffect(int NumTurnsBlinded, optional int iChance = 100)
{
    local X2Effect_Blind BlindEffect;

    BlindEffect = class'X2Effect_Blind'.static.CreateBlindEffect(NumTurnsBlinded, default.Blind_VisionMult);
    BlindEffect.ApplyChance = iChance;
    BlindEffect.AddPersistentStatChange(eStat_DetectionRadius, default.Blind_VisionMult, MODOP_PostMultiplication);
    BlindEffect.DamageTypes.AddItem('Blind');
    BlindEffect.EffectAppliedEventName = 'UnitBlinded';

    return BlindEffect;
}