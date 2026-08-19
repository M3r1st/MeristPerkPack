class M31_Helpers extends X2Ability;

static function X2AbilityTemplate CreateWeaponEffectAttack(name DataName, string IconImage, optional X2Effect Effect = none)
{
    local X2AbilityTemplate     Template;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = IconImage;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    Template.bAllowAmmoEffects = false;
    Template.bAllowBonusWeaponEffects = false;
    Template.bAllowFreeFireWeaponUpgrade = false;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    if (Effect != none)
    {
        Template.AddTargetEffect(Effect);
    }

    Template.FrameAbilityCameraType = eCameraFraming_Never;
    Template.bSkipExitCoverWhenFiring = true;
    Template.bSkipFireAction = true;
    Template.bShowActivation = false;
    Template.bUsesFiringCamera = false;

    Template.ConcealmentRule = eConceal_AlwaysEvenWithObjective;

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.MergeVisualizationFn = class'X2Effect_WeaponEffect'.static.FollowUpShot_MergeVisualization;

    Template.BuildInterruptGameStateFn = none;

    Template.bCrossClassEligible = false;

    return Template;
}

static function X2Effect_PersistentStatChange CreateHackDefenseReductionStatusEffect(
    name EffectName,
    int HackDefenseChangeAmount,
    optional X2Condition Condition)
{
    
    local X2Effect_PersistentStatChange HackDefenseReductionEffect;
    HackDefenseReductionEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(HackDefenseChangeAmount, Condition);
    HackDefenseReductionEffect.EffectName = EffectName;
    HackDefenseReductionEffect.DuplicateResponse = eDupe_Allow;
    HackDefenseReductionEffect.IconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
    return HackDefenseReductionEffect;
}

static function X2Effect_PersistentStatChange CreateRoboticDisorientedStatusEffect(optional bool bExcludeFriendlyToSource=false, float DelayVisualizationSec=0.0f)
{
    local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
    local X2Condition_UnitProperty          UnitPropCondition;

    PersistentStatChangeEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(,, false);
    PersistentStatChangeEffect.TargetConditions.Length = 0;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = bExcludeFriendlyToSource;
    UnitPropCondition.ExcludeOrganic = true;
    PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

    return PersistentStatChangeEffect;
}

static function X2Effect_Persistent CreateBleedingStatusEffect(int NumTurns, optional int Damage, optional int DamageSpread, optional float DamageFromHP)
{
    local X2Effect_Persistent           BleedingEffect;
    local X2Effect_ApplyScalingDamage   DamageEffect;

    BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(NumTurns, 0);
    BleedingEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.BleedingFriendlyName, `GetLocalizedString("M31_Bleeding_DebuffText"), "img:///UILibrary_XPACK_Common.UIPerk_bleeding");

    BleedingEffect.ApplyOnTick.Length = 0;
    DamageEffect = new class'X2Effect_ApplyScalingDamage';
    DamageEffect.EffectDamageValue.Damage = Damage;
    DamageEffect.EffectDamageValue.Spread = DamageSpread;
    DamageEffect.DamageFromHP = DamageFromHP;
    DamageEffect.EffectDamageValue.DamageType = 'Bleeding';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.DamageTypes.AddItem('Bleeding');
    DamageEffect.bAllowFreeKill = false;
    DamageEffect.bIgnoreArmor = true;
    DamageEffect.bBypassShields = class'X2StatusEffects'.default.BLEEDING_IGNORES_SHIELDS;
    BleedingEffect.ApplyOnTick.AddItem(DamageEffect);

    return BleedingEffect;
}

static function X2AbilityTemplate CreateAnimSetPassive(name TemplateName, string AnimSetPath)
{
    local X2AbilityTemplate             Template;
    // local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Effect_AdditionalAnimSets   AnimSetEffect;

    Template = class'X2Ability_Extended'.static.Passive(TemplateName, "", false, false, true);

    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;

    AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
    AnimSetEffect.AddAnimSetWithPath(AnimSetPath);
    AnimSetEffect.BuildPersistentEffect(1, true, false);
    Template.AddTargetEffect(AnimSetEffect);

    return Template;
}

static final function int GetActionPoints(const XComGameState_Unit Unit, array<name> AllowedTypes)
{
    local int i, Count;

    for (i = 0; i < Unit.ActionPoints.Length; i++)
    {
        if (AllowedTypes.Find(Unit.ActionPoints[i]) != INDEX_NONE)
        {
            Count++;
        }
    }
    return Count;
}

static function array<X2Effect> CreateRadiationEffects(
    optional int RadiationRadBurnApplyChance = 50, optional int RadiationRadBurnDamage = 3, optional int RadiationRadBurnDamageSpread = 2,
    optional int RadiationBoilingBloodApplyChance = 33, optional int RadiationBoilingBloodDamage = 4, optional int RadiationBoilingBloodDamageSpread = 2,
    optional int RadiationIrradiateApplyChance = 100, optional int RadiationPanicApplyChance = 10)
{
    local array<X2Effect> Effects;
    // 33, 3, 2
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadBurningStatusEffect(RadiationRadBurnApplyChance, RadiationRadBurnDamage, RadiationRadBurnDamageSpread));
    // 25, 4, 2
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadBleedingStatusEffect(RadiationBoilingBloodApplyChance, RadiationBoilingBloodDamage, RadiationBoilingBloodDamageSpread));
    // 75
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadDisorientedStatusEffect(RadiationIrradiateApplyChance, , ,false));
    // 10
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadPanickedStatusEffect(RadiationPanicApplyChance));
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    ////////////////////////////
    /////// This Needs to be here so the Lost can benefit from having Radiation applied on them
    ///////////////////////////
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateLostRadRegenStatusEffect(100));
    ////////////////////////////
    /////// This Needs to be here so the Lost can benefit from having Radiation applied on them
    ///////////////////////////
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    ///////////////////////////
    /////// These apply the stat debuffs for Radiation Burn, and Boiling Blood, they will only activate if said effects are successfully applied
    ///////////////////////////
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateRadBurnDodgeStatusEffect());
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateBoilingBloodMobilityStatusEffect());
    ///////////////////////////
    /////// These apply the stat debuffs for Radiation Burn, and Boiling Blood, they will only activate if said effects are successfully applied
    ///////////////////////////
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    ////////////////////////////
    /////// This applies additional debuffs to robotic units affected by Irradiate
    ///////////////////////////
    Effects.AddItem(class'X2StatusEffects_Radiation'.static.CreateIrradiatedRoboticDebuffStatusEffect());
    ////////////////////////////
    /////// This applies additional debuffs to robotic units affected by Irradiate
    ///////////////////////////
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    //--------------------------------------------------------------------------------------------------------------------------------------------------\\
    return Effects;
}

static function AddRadiationToTarget(out X2AbilityTemplate Template,
    optional int RadiationRadBurnApplyChance = 33, optional int RadiationRadBurnDamage = 3, optional int RadiationRadBurnDamageSpread = 2,
    optional int RadiationBoilingBloodApplyChance = 25, optional int RadiationBoilingBloodDamage = 4, optional int RadiationBoilingBloodDamageSpread = 2,
    optional int RadiationIrradiateApplyChance = 75, optional int RadiationPanicApplyChance = 10)
{
    local array<X2Effect> Effects;
    local X2Effect Effect;
    
    Effects = CreateRadiationEffects(RadiationRadBurnApplyChance, RadiationRadBurnDamage, RadiationRadBurnDamageSpread,
        RadiationBoilingBloodApplyChance, RadiationBoilingBloodDamage, RadiationBoilingBloodDamageSpread,
        RadiationIrradiateApplyChance, RadiationPanicApplyChance);
    
    foreach Effects(Effect)
        Template.AddTargetEffect(Effect);
}

static function AddRadiationToMultiTarget(out X2AbilityTemplate Template,
    optional int RadiationRadBurnApplyChance = 33, optional int RadiationRadBurnDamage = 3, optional int RadiationRadBurnDamageSpread = 2,
    optional int RadiationBoilingBloodApplyChance = 25, optional int RadiationBoilingBloodDamage = 4, optional int RadiationBoilingBloodDamageSpread = 2,
    optional int RadiationIrradiateApplyChance = 75, optional int RadiationPanicApplyChance = 10)
{
    local array<X2Effect> Effects;
    local X2Effect Effect;
    
    Effects = CreateRadiationEffects(RadiationRadBurnApplyChance, RadiationRadBurnDamage, RadiationRadBurnDamageSpread,
        RadiationBoilingBloodApplyChance, RadiationBoilingBloodDamage, RadiationBoilingBloodDamageSpread,
        RadiationIrradiateApplyChance, RadiationPanicApplyChance);
    
    foreach Effects(Effect)
        Template.AddMultiTargetEffect(Effect);
}

static function bool IsUnitInterruptingEnemyTurn(XComGameState_Unit UnitState)
{
    local XComGameState_BattleData BattleState;

    BattleState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    return BattleState.InterruptingGroupRef == UnitState.GetGroupMembership().GetReference();
}

static function bool IsFlanking(XComGameState_Unit Attacker, XComGameState_Unit Target, optional int HistoryIndex = -1)
{
    local GameRulesCache_VisibilityInfo VisInfo;

    if (Attacker.CanFlank() && Target.GetMyTemplate().bCanTakeCover)
    {
        if (HistoryIndex != -1)
        {
            if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo, HistoryIndex))
            {
                if (VisInfo.TargetCover == CT_None || Target.GetCurrentStat(eStat_AlertLevel) == 0 && Target.GetTeam() != eTeam_XCom)
                {
                    return true;
                }
            }
        }
        else
        {
            if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
            {
                if (VisInfo.TargetCover == CT_None || Target.GetCurrentStat(eStat_AlertLevel) == 0 && Target.GetTeam() != eTeam_XCom)
                {
                    return true;
                }
            }
        }
    }

    return false;
}

static function bool AbilityDealsDamage(XComGameState_Ability kAbility, optional XComGameState_Unit SourceUnit, optional XComGameState_Unit TargetUnit, optional bool bMultiTarget)
{
    local X2AbilityTemplate     AbilityTemplate;
    local XComGameState_Item    SourceWeapon;
    local X2GrenadeTemplate     GrenadeTemplate;
    local array<X2Effect>       MultiTargetEffects;
    local X2Effect              Effect;
    local bool                  bCheckConditions;

    AbilityTemplate = kAbility.GetMyTemplate();
    SourceWeapon = kAbility.GetSourceWeapon();
    bCheckConditions = SourceUnit != none && TargetUnit != none;

    if (bMultiTarget)
    {
        if (AbilityTemplate.bUseLaunchedGrenadeEffects)
        {
            if (SourceWeapon != none)
            {
                GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(kAbility));
                MultiTargetEffects = GrenadeTemplate.LaunchedGrenadeEffects;
            }
        }
        else if (AbilityTemplate.bUseThrownGrenadeEffects)
        {
            if (SourceWeapon != none)
            {
                GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());
                MultiTargetEffects = GrenadeTemplate.ThrownGrenadeEffects;
            }
        }
        else
        {
            MultiTargetEffects = AbilityTemplate.AbilityMultiTargetEffects;
        }

        foreach MultiTargetEffects(Effect)
        {
            if (Effect.bAppliesDamage)
            {
                if (bCheckConditions)
                {
                    if (Effect.TargetIsValidForAbility(TargetUnit, SourceUnit, kAbility))
                    {
                        return true;
                    }
                }
                else
                {
                    return true;
                }
            }
        }
    }
    else
    {
        foreach AbilityTemplate.AbilityTargetEffects(Effect)
        {
            if (Effect.bAppliesDamage)
            {
                if (bCheckConditions)
                {
                    if (Effect.TargetIsValidForAbility(TargetUnit, SourceUnit, kAbility))
                    {
                        return true;
                    }
                }
                else
                {
                    return true;
                }
            }
        }
    }

    return false;
}

static function EventListenerReturn TriggerAbilityFlyover_Static(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameState NewGameState;
    local XComGameState_Unit UnitState;
    local XComGameState_Ability AbilityState;
    local XComGameState_Effect EffectState;

    UnitState = XComGameState_Unit(EventSource);
    AbilityState = XComGameState_Ability(EventData);
    EffectState = XComGameState_Effect(CallbackData);
    if (UnitState != none && AbilityState != none)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
        AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
        if (EffectState != none)
            EffectState = XComGameState_Effect(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
        XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = TriggerAbilityFlyover_BuildVisualization;
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
    return ELR_NoInterrupt;
}

static function TriggerAbilityFlyover_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory          History;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState_Unit            UnitState;
    local XComGameState_Effect          EffectState;
    local VisualizationActionMetadata   EmptyTrack;
    local VisualizationActionMetadata   ActionMetadata;
    local X2Action_PlaySoundAndFlyOver  SoundAndFlyOver;
    local X2AbilityTag                  AbilityTag;

    local bool                          bGoodAbility;
    local EWidgetColor                  FlyoverColor;
    local string                        FlyoverText;

    History = `XCOMHISTORY;
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Ability', AbilityState)
    {
        break;
    }
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        break;
    }

    if (AbilityState != none)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
        if (AbilityTemplate != none)
        {
            FlyOverText = AbilityTemplate.LocFlyOverText;
            if (EffectState != none)
            {
                AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
                AbilityTag.ParseObj = EffectState;
                FlyOverText = `XEXPAND.ExpandString(FlyOverText);
                AbilityTag.ParseObj = none;
            }
            else
            {
                AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
                AbilityTag.ParseObj = AbilityState;
                FlyOverText = `XEXPAND.ExpandString(FlyOverText);
                AbilityTag.ParseObj = none;
            }

            foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
            {
                ActionMetadata = EmptyTrack;
                History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
                ActionMetadata.StateObject_NewState = UnitState;
                ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

                bGoodAbility = UnitState.IsFriendlyToLocalPlayer();
                FlyoverColor = bGoodAbility ? eColor_Good : eColor_Bad;

                SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
                SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FlyOverText, '', FlyoverColor, AbilityTemplate.IconImage, `DEFAULTFLYOVERLOOKATTIME, true);
            }
            return;
        }
    }
}

static function bool WasAbilityFree(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner, optional int HistoryIndex = -1)
{
    local XComGameStateHistory      History;
    local XComGameState_Ability     OldAbilityState;
    local XComGameState_Unit        OldAbilityOwner;
    local X2AbilityTemplate         Template;
    local X2AbilityCost             Cost;
    local X2AbilityCost_ActionPoints ActionPointCost;

    History = `XCOMHISTORY;

    Template = AbilityState.GetMyTemplate();

    if (HistoryIndex != -1)
    {
        OldAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityState.ObjectID,, HistoryIndex));
        OldAbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityOwner.ObjectID,, HistoryIndex));
    }
    else
    {
        OldAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityState.ObjectID));
        OldAbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityOwner.ObjectID));
    }

    foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none)
        {
            if (!ActionPointCost.bFreeCost && ActionPointCost.GetPointCost(OldAbilityState, OldAbilityOwner) > 0)
            {
                return false;
            }
        }
    }

    return true;
}

static function int GetNumHitsForAbility(XComGameState_Ability AbilityState)
{
    local X2AbilityTemplate AbilityTemplate;
    local X2AbilityMultiTarget_BurstFire BurstFire;
    local XComGameState_Unit AbilityOwner;

    AbilityTemplate = AbilityState.GetMyTemplate();
    BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
    if (BurstFire != none)
    {
        return 1 + BurstFire.NumExtraShots;
    }
    else if (X2AbilityMultiTarget_RadiusTimesFocus(AbilityTemplate.AbilityMultiTargetStyle) != none)
    {
        AbilityOwner = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        return AbilityOwner.GetTemplarFocusLevel();
    }
    return 1;
}