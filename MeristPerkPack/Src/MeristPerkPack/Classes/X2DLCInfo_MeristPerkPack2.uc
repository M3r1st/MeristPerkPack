class X2DLCInfo_MeristPerkPack2 extends X2DownloadableContentInfo dependson(X2DLCInfo_MeristPerkPack) config(GameData_SoldierSkills);

struct TextColorByClass
{
    var name ClassName;
    var string strColor;
};

var config array<TextColorByClass> SpecialColors;
var config string DefaultSpecialColor;

var config array<name> CBAC_AllowedTypes;

var localized array<name>   AbilitiesToLocalize;
var localized array<string> LocalizedAbilityNames;
var localized array<name>   AbilitiesToHide;
var localized array<string> RankNames;

var localized string strDefaultWeapon;
var localized string strPerRank;
var localized string strFreeAction;

var privatewrite config array<string> Aim_Abilities;
var privatewrite config array<string> ControlledDetonation_Abilities;
var privatewrite config array<string> OffensiveProtocols_Abilities;
var privatewrite config array<string> LetItGo_Abilities;
var privatewrite config array<string> MarauderElite_Abilities;
var privatewrite config array<string> Reposition_Abilities;
var privatewrite config array<string> TraverseFirePlus_Abilities;
var privatewrite config array<string> Serpentine_Abilities;

//=======================================================================================
//                                      OPTC
//---------------------------------------------------------------------------------------

static event OnPostTemplatesCreated()
{
    CacheLocalizedAbilityLists();
}

static function CacheLocalizedAbilityLists()
{
    local X2DataTemplate            IterateTemplate;
    local array<X2DataTemplate>     DataTemplates;
    local X2DataTemplate            DataTemplate;
    local X2AbilityTemplate         Template;
    local int                       Index;
    local string                    OutString;

    local X2AbilityTemplateManager          AbilityMgr;

    AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach AbilityMgr.IterateTemplates(IterateTemplate)
    {
        if (!ClassIsChildOf(IterateTemplate.Class, class'X2AbilityTemplate')) continue;

        AbilityMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);

        foreach DataTemplates(DataTemplate)
        {
            Template = X2AbilityTemplate(DataTemplate);

            if (default.AbilitiesToHide.Find(Template.DataName) != INDEX_NONE)
                continue;

            Index = default.AbilitiesToLocalize.Find(Template.DataName);
            if (Index == INDEX_NONE)
                OutString = Template.LocFriendlyName;
            else
                OutString = default.LocalizedAbilityNames[Index];

            if (class'X2AbilitySet_Merist'.default.Aim_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.Aim_Abilities.AddItem(OutString);

            if (class'X2Effect_ControlledDetonation'.default.ControlledDetonation_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.ControlledDetonation_Abilities.AddItem(OutString);

            if (class'X2AbilitySet_Gremlin'.default.OffensiveProtocols.Find(Template.DataName) != INDEX_NONE)
                default.OffensiveProtocols_Abilities.AddItem(OutString);

            if (class'X2AbilitySet_Psionics'.default.LetItGo_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.LetItGo_Abilities.AddItem(OutString);

            if (class'X2AbilitySet_Merist'.default.MarauderElite_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.MarauderElite_Abilities.AddItem(OutString);

            if (class'X2AbilitySet_Merist'.default.Reposition_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.Reposition_Abilities.AddItem(OutString);

            if (class'X2AbilitySet_Merist'.default.TraverseFirePlus_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.TraverseFirePlus_Abilities.AddItem(OutString);

            if (class'X2AbilitySet_PA_Viper'.default.Serpentine_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.Serpentine_Abilities.AddItem(OutString);
        }
    }
    default.Aim_Abilities.Sort(SortStrings);
    default.ControlledDetonation_Abilities.Sort(SortStrings);
    default.OffensiveProtocols_Abilities.Sort(SortStrings);
    default.LetItGo_Abilities.Sort(SortStrings);
    default.MarauderElite_Abilities.Sort(SortStrings);
    default.Reposition_Abilities.Sort(SortStrings);
    default.TraverseFirePlus_Abilities.Sort(SortStrings);
    default.Serpentine_Abilities.Sort(SortStrings);
}

delegate int SortStrings(string A, string B)
{
    local int Index;

    for (Index = 0; Index < Min(Len(A), Len(B)); Index++)
    {
        if (A > B)
            return -1;
        else if (A < B)
            return 1;
    }

    if (Len(A) > Len(B))
        return -1;
    else if (Len(A) < Len(B))
        return 1;
    else
        return 0;
}

//=======================================================================================
//                                  TAG HANDLER
//---------------------------------------------------------------------------------------

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);

    switch (InString)
    {
        case "M31_BoundWeaponName":
            OutString = GetBoundWeaponName(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_FriendlyName":
            OutString = GetAbilityFriendlyName(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_SelfCooldown":
            OutString = GetSelfCooldown(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_SelfCharges":
            OutString = GetSelfCharges(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_FreeAction":
            OutString = ColorText_Green(default.strFreeAction);
            return true;

        case "M31_AutoFont":
            OutString = ColorText_Auto("", true, UnitState);
            return true;
        case "M31_FontAbility":
            OutString = ColorText_LimeGreen("", true);
            return true;
        case "M31_FontGold":
            OutString = ColorText_Gold("", true);
            return true;

        case "M31_EffectTurnsTicked":
            OutString = string(GetEffectTurnsTicked(ParseObj, StrategyParseOb, GameState));
            return true;

        case "M31_EffectDamageOnTick":
            OutString = GetEffectDamageOnTickString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_EffectSourceFullName":
            OutString = GetEffectSourceFullName(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_AcidRounds_BurnDuration":
        case "M31_AcidRounds_ShredBonus":
        case "M31_AdvancedAidProtocol_CritResistance":
        case "M31_AdvancedAidProtocol_DodgeBonus":
        case "M31_AlphaStrike_Charges":
        case "M31_AlphaStrike_Radius":
        case "M31_Assassin_ActivationsPerTurn":
        case "M31_AssaultShot_Cooldown":
        case "M31_AssaultShot_Range":
        case "M31_Bandit_AmmoToReload":
        case "M31_BattlePresence_CooldownReduction":
        case "M31_BleedingRounds_BleedDuration":
        case "M31_Bloodlet_BleedDuration":
        case "M31_BloodThirst_DamagePerStack":
        case "M31_BloodThirst_MaxStacks":
        case "M31_BloodThirst_MaxStacksPerTurn":
        case "M31_BloodThirst_StackDuration":
        case "M31_BombAndRun_ActivationsPerTurn":
        case "M31_Botnet_Duration":
        case "M31_Botnet_HackDefenseChange":
        case "M31_BurstFire_Cooldown":
        case "M31_BurstFire_NumShots":
        case "M31_CallForFire_Radius":
        case "M31_ChasingCoveringFire_ActivationsPerTargetPerTurn":
        case "M31_CombatAdvance_Cooldown":
        case "M31_ConcussiveGrenades_StunDuration":
        case "M31_Dervish_CooldownReduction":
        case "M31_DetonationShot_AmmoCost":
        case "M31_DisarmingShot_AimPenalty":
        case "M31_DisarmingShot_AmmoCost":
        case "M31_DisarmingShot_CritPenalty":
        case "M31_DisarmingShot_Duration":
        case "M31_Duskborn_AimBonus":
        case "M31_Duskborn_CritBonus":
        case "M31_Duskborn_Duration":
        case "M31_EnemyUnknown_AimBonus":
        case "M31_EnemyUnknown_CritBonus":
        case "M31_EnemyUnknown_CritDamageBonus":
        case "M31_EnemyUnknown_DamageBonus":
        case "M31_EnemyUnknown_DefenseBonus":
        case "M31_EnemyUnknown_DodgeBonus":
        case "M31_EnemyUnknown_MobilityBonus":
        case "M31_EnhancedLowProfile_AimBonus":
        case "M31_EnhancedLowProfile_CritBonus":
        case "M31_Escalation_CritBonus":
        case "M31_Escalation_CritDamageBonus":
        case "M31_Escalation_CritDamageBonusFactor":
        case "M31_Escalation_CritDamageBonusMinCrit":
        case "M31_Escalation_Duration":
        case "M31_Frostbane_CritBonus":
        case "M31_Frostbane_CritBonusPerTier":
        case "M31_Frostbane_PiercingBonus":
        case "M31_Frostbane_PiercingBonusPerTier":
        case "M31_FutureWarfare_ActivationsPerTurn":
        case "M31_FutureWarfare_CooldownReduction":
        case "M31_HypothermiaRounds_Duration":
        case "M31_LowProfileNest_AimBonus":
        case "M31_LowProfileNest_CritBonus":
        case "M31_Maim_AmmoCost":
        case "M31_Malevolence_AcidBurning_ShredBonus":
        case "M31_Malevolence_Bleeding_CritBonus":
        case "M31_Malevolence_Bleeding_CritDamageBonus":
        case "M31_Malevolence_Burning_DebuffDuration":
        case "M31_Malevolence_Burning_DOTDamageBonus":
        case "M31_Malevolence_Frost_AimPenalty":
        case "M31_Malevolence_Frost_DebuffDuration":
        case "M31_Malevolence_Frost_DefensePenalty":
        case "M31_Malevolence_Poisoned_CritPenalty":
        case "M31_Malevolence_Poisoned_DebuffDuration":
        case "M31_Malevolence_Poisoned_GrazePenalty":
        case "M31_Malevolence_Radiation_DebuffDuration":
        case "M31_ManualOverride_CooldownReduction":
        case "M31_Meld_Duration":
        case "M31_OverchargedBlast_AmmoCost":
        case "M31_OverchargedBlast_Rupture":
        case "M31_OverchargedBlast_Shred":
        case "M31_Overpower_Shred":
        case "M31_Overpower_StunDuration":
        case "M31_PerfectHandling_BaseRange":
        case "M31_Pinpoint_AimBase":
        case "M31_Pinpoint_AimPerAction":
        case "M31_Pinpoint_CritBase":
        case "M31_Pinpoint_CritPerAction":
        case "M31_PipeBombs_BleedDuration":
        case "M31_PriorityFocus_DamageBonus":
        case "M31_RepositionPlus_ActivationsPerTurn":
        case "M31_SaltInTheWound_DamageBonus":
        case "M31_SawedOffRange_LastIndex":
        case "M31_SawedOffRange_NewLastIndex":
        case "M31_SawedOffReload_AmmoPerUse":
        case "M31_SawedOffReload_BaseLimit":
        case "M31_SawedOffReload_PumpAction_BonusCharges":
        case "M31_SawedOffReload_PumpAction_BonusLimit":
        case "M31_SawedOffSweeper_MaxAmmo":
        case "M31_SawedOffSweeper_MinAmmo":
        case "M31_Shadowstrike_AimBonus":
        case "M31_Shadowstrike_CritBonus":
        case "M31_SharpshooterAim_AimBonus":
        case "M31_SharpshooterAim_CritBonus":
        case "M31_ShotgunWedding_AmmoCost":
        case "M31_ShotgunWedding_AmmoCostPerShot":
        case "M31_ShotgunWedding_Length":
        case "M31_ShotgunWedding_MaxNumShots":
        case "M31_ShotgunWedding_Width":
        case "M31_Skykeeper_AimBonus_Flying":
        case "M31_Skykeeper_AimBonus_NoCover":
        case "M31_SniperElite_AimBonus":
        case "M31_SniperElite_CritBonus":
        case "M31_SolidSnake_BaseRange":
        case "M31_SolidSnake_DodgeIgnore":
        case "M31_Sparkfire_AmmoCost":
        case "M31_SuperheavyOrdnance_ChargeBonus":
        case "M31_SuperheavyOrdnance_RangeBonus":
        case "M31_TargetingAid_AimBonus":
        case "M31_TargetingAid_CritBonus":
        case "M31_ThermalShock_AimPenalty_Immune":
        case "M31_ThermalShock_AimPenalty":
        case "M31_ThermalShock_DefensePenalty_Immune":
        case "M31_ThermalShock_DefensePenalty":
        case "M31_ThermalShock_Duration":
        case "M31_TrackingFire_CooldownReduction":
        case "M31_TroubleShooter_Duration":
        case "M31_TroubleShooter_HackDefenseReduction":
        case "M31_Unload_AimPenalty":
        case "M31_Unload_MaxShots":
        case "M31_Warbringer_ChargeBonus":
        case "M31_Warbringer_RadiusBonus":
        case "M31_WatchfulEye_ActivationsPerTurn":
        case "M31_WatchfulEye_AttacksPerTurn":
        case "M31_ZoneOfControl_AimPenalty":
        case "M31_ZoneOfControl_MobilityPenalty":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_SawedOffReload_Limit":
            OutString = ColorText_Auto(`GetConfigInt("M31_SawedOffReload_BaseLimit") - `GetConfigInt("M31_SawedOffReload_AmmoPerUse") + 1,, UnitState);
            return true;

        case "M31_ShotgunWedding_ActivationAmmoCost":
            OutString = ColorText_Auto(`GetConfigInt("M31_ShotgunWedding_AmmoCost") + `GetConfigInt("M31_ShotgunWedding_AmmoCostPerShot"),, UnitState);
            return true;

        case "M31_AdvancedOptics_DefenseReduction":
        case "M31_AdvancedOptics_PenaltyModifier":
        case "M31_ConcussiveGrenades_StunChance":
        case "M31_CovertParkour_DetectionReduction":
        case "M31_DeathAdder_HPToDamage":
        case "M31_DeathAdder_MaxDamageBonus":
        case "M31_Malevolence_Radiation_DamageReductionPrc":
        case "M31_OnTheMove_MobilityPenaltyPrc":
        case "M31_Pinpoint_CritDamageBase":
        case "M31_Pinpoint_CritDamagePerAction":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_SawedOffSweeper_Length":
        case "M31_SawedOffSweeper_LengthPerAmmo":
        case "M31_SawedOffSweeper_Width":
        case "M31_SawedOffSweeper_WidthPerAmmo":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)) $ "m",, UnitState);
            return true;

        case "M31_ZoneOfControl_Radius":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)),, UnitState);
            return true;

        case "M31_BloodThirst_bIncreaseOnlyOnHit":
        case "M31_BloodThirst_bMatchSourceWeapon":
        case "M31_BloodThirst_bRefreshDuration":
        case "M31_Frostbane_bMatchSourceWeapon":
        case "M31_ImprovedSuppression_bApplyToRobotic":
        case "M31_OverchargedBlast_bGuaranteedCrit":
        case "M31_RepositionPlus_bApplyToUnflankable":
        case "M31_SawedOffSweeper_bHipfire":
        case "M31_TrackingFire_bAllowResetFromBladestorm":
        case "M31_TrackingFire_bIsReactionFire":
        case "M31_TroubleShooter_bAllowStack":
        case "M31_Unload_bAllowCrit":
        case "M31_Unload_bOnlyOnHit":
        case "M31_WatchfulEye_bUniqueTarget":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_Bandit_AmmoReloaded":
            OutString = class'X2Effect_Bandit'.static.GetFlyoverOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_BloodThirst_BuffText":
            OutString = class'X2Effect_BloodThirst'.static.GetFriendlyDescOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_AcidRounds_BurnDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateAcidRoundsBurningEffect());
            return true;
        case "M31_BleedingRounds_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateBleedingRoundsBleedingEffect());
            return true;
        case "M31_Bloodlet_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateBloodletBleedingEffect());
            return true;
        case "M31_PipeBombs_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreatePipeBombsBleedingEffect());
            return true;
        case "M31_Sparkfire_BurnDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateSparkfireBurningEffect());
            return true;

        case "M31_HypothermiaRounds_PrcChance":
        case "M31_Shiver2_PrcChance":
        case "M31_ShiverCrit2_PrcChance":
            OutString = GetOutStringWithRank(`GetConfigInt(InString), `GetConfigFloat(InString $ "PerRank"), ParseObj, StrategyParseOb, GameState, "%", true, 0, 100);
            return true;

        case "M31_SawedOffReload_Charges":
        case "M31_KeenEdge_DamageBonus":
        case "M31_KeenEdge_PierceBonus":
        case "M31_Stiletto_PierceBonus":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_StaticGrenades_Mk1_Damage":
        case "M31_StaticGrenades_Mk2_Damage":
            OutString = ColorText_Auto(GetDamageRangeString(`GetConfigDamage(InString)),, UnitState);
            return true;

        case "M31_HunkerDown_DefenseBonus":
            OutString = ColorText_Auto(class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DEFENSE,, UnitState);
            return true;
        case "M31_HunkerDown_DodgeBonus":
            OutString = ColorText_Auto(class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DODGE,, UnitState);
            return true;
    }

    if (GetLocalizedListOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetPistolOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetGremlinOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetViperOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetMutonOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetTaipanOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetWinterSentinelOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetChosenArsenalOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetPsiOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetBerserkerOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetShieldbearerOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    if (GetSkirmisherOutStrings(InString, OutString, ParseObj, StrategyParseOb, GameState))
        return true;

    return false;
}

static function bool GetLocalizedListOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    switch (InString)
    {
        case "M31_Aim_Abilities":
            OutString = GetAbilityListString(default.Aim_Abilities);
            return true;

        case "M31_ControlledDetonation_Abilities":
            OutString = GetAbilityListString(default.ControlledDetonation_Abilities);
            return true;

        case "M31_OffensiveProtocols":
            OutString = GetAbilityListString(default.OffensiveProtocols_Abilities);
            return true;

        case "M31_LetItGo_Abilities":
            OutString = GetAbilityListString(default.LetItGo_Abilities);
            return true;

        case "M31_MarauderElite_Abilities":
            OutString = GetAbilityListString(default.MarauderElite_Abilities);
            return true;
        
        case "M31_Reposition_Abilities":
            OutString = GetAbilityListString(default.Reposition_Abilities);
            return true;

        case "M31_TraverseFirePlus_Abilities":
            OutString = GetAbilityListString(default.TraverseFirePlus_Abilities);
            return true;

        case "M31_PA_Serpentine_Abilities":
            OutString = GetAbilityListString(default.Serpentine_Abilities);
            return true;        

        default:
            return false;
    }

    return false;
}

static function bool GetPistolOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_ClutchShot_AmmoCost":
        case "M31_ClutchShotReset_CooldownReduction":
        case "M31_ClutchShotReset_ActivationsPerTurn":
        case "M31_PistolAvenger_ActivationsPerTurn":
        case "M31_PistolDetonationShot_AmmoCost":
        case "M31_PistolDisarmingShot_AmmoCost":
        case "M31_PistolMaim_AmmoCost":
        case "M31_ReflexShot_Radius":
        case "M31_ReflexShot_ActivationsPerTurn":
        case "M31_PistolRouletteShot_AmmoCost":
        case "M31_SleightOfHand_AimPerStack":
        case "M31_SleightOfHand_CritPerStack":
        case "M31_SleightOfHand_StackDecay":
        case "M31_SleightOfHand_MaxStacks":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PistolRouletteShot_MinDamagePrc":
        case "M31_PistolRouletteShot_MaxDamagePrc":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_ClutchShotReset_bReduceAll":
        case "M31_PistolAvenger_bReactionFire":
        case "M31_PistolAvenger_bIgnoreCoverBonus":
        case "M31_ReflexShot_bReactionFire":
        case "M31_SleightOfHand_bMatchSourceWeapon":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_SleightOfHand_BuffText":
            OutString = class'X2Effect_SleightOfHand'.static.GetFriendlyDescOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetGremlinOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);

    switch (InString)
    {
        case "M31_SP_Capacitors_BonusNumTargets":
        case "M31_SP_VoltaicArc_Radius":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_SP_StormGenerator_BonusRadius":
            ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)) $ "m",, UnitState);
            return true;

        case "M31_SP_ChainingJolt_bOverrideCombatProtocol":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_SP_ChainingJolt_Radius":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState,,, "m");
            return true;
        case "M31_SP_ChainingJolt_MaxTargets":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState);
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetViperOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit    UnitState;
    local WeaponDamageValue     Damage;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_PA_AngryBite_AimBonus":
        case "M31_PA_AngryBite_Cooldown":
        case "M31_PA_AngryBite_CritBonus":
        case "M31_PA_Coil_DefenseBonus":
        case "M31_PA_Coil_DodgeBonus":
        case "M31_PA_Entwine_AimBonus":
        case "M31_PA_Entwine_BindDamageBonus":
        case "M31_PA_Entwine_DefenseBonus":
        case "M31_PA_Entwine_DodgeBonus":
        case "M31_PA_GetOverHere_MaxRange":
        case "M31_PA_GetOverHere_MinRange":
        case "M31_PA_GetOverHereAlly_MaxRange":
        case "M31_PA_GetOverHereAlly_MinRange":
        case "M31_PA_IronskinBite_Duration":
        case "M31_PA_IronskinBite_ShieldAmount":
        case "M31_PA_IronskinBite_ShieldPriority":
        case "M31_PA_Lockjaw_Cooldown":
        case "M31_PA_Lockjaw_StunDuration":
        case "M31_PA_MemeBite_E":
        case "M31_PA_NeuroPoison_CooldownReduction":
        case "M31_PA_Rattle_ActivationsPerTurn":
        case "M31_PA_Rattle_MaxTargets":
        case "M31_PA_RegenBite_EnhDuration":
        case "M31_PA_RegenBite_EnhHealPerTurn":
        case "M31_PA_Salamander_RadiusBonus":
        case "M31_PA_Serpentine_ActivationsPerTurn":
        case "M31_PA_Sidewinder_Cooldown":
        case "M31_PA_Slither_DefenseBonus":
        case "M31_PA_Slither_DodgeBonus":
        case "M31_PA_Slither_Duration":
        case "M31_PA_Slither_MobilityBonus":
        case "M31_PA_ViperBite_AimBonus":
        case "M31_PA_ViperBite_CritBonus":
        case "M31_PA_ViperBite_Rupture":
        case "M31_PA_ViperSpit_Range":

        case "M31_PA_Poison_AimPenalty":
        case "M31_PA_Poison_Duration":
        case "M31_PA_Poison_MobilityPenalty":

        case "M31_PA_EnhancedPoison_AimPenalty":
        case "M31_PA_EnhancedPoison_Duration":
        case "M31_PA_EnhancedPoison_MobilityPenalty":

        case "M31_ENEMY_Lockjaw_Cooldown":
        case "M31_ENEMY_Sidewinder_Cooldown":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PA_Rattle_PanicChance":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PA_AngryBite_bAllowCrit":
        case "M31_PA_AngryBite_bCooldownOnlyOnHit":
        case "M31_PA_AngryBite_bHasCooldown":
        case "M31_PA_FrostBreath_bDealsDamage":
        case "M31_PA_Lockjaw_bAllowCrit":
        case "M31_PA_MalevolentFocus_bOnlyForReaction":
        case "M31_PA_PoisonSpit_bAppliesPoisonToWorld":
        case "M31_PA_PoisonSpit_bDealsDamage":
        case "M31_PA_RegenBite_bProvidesPoisonImmunity":
        case "M31_PA_RegenBite_bRemovePoison":
        case "M31_PA_RegenBite_bStabilize":
        case "M31_PA_Sidewinder_bAllowWhileBurning":
        case "M31_PA_Sidewinder_bAllowWhileDisoriented":
        case "M31_PA_Sidewinder_bOnlyOnEnemyTurn":
        case "M31_PA_Spit_bRequireVisibility":
        case "M31_PA_VeryAngryBite_bAllowCrit":
        case "M31_PA_VeryAngryBite_bAllowMovementActionPoint":
        case "M31_PA_VeryAngryBite_bFreeAction":
        case "M31_PA_VeryAngryBite_bIsReactonFire":
        case "M31_PA_ViperBite_bAllowCrit":
        case "M31_PA_ViperBite_bCanTargetVipers":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_PA_FrostBreath_Radius":
        case "M31_PA_FrostSpit_Radius":
        case "M31_PA_PoisonSpit_Radius":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)) $ "m",, UnitState);
            return true;

        case "M31_PA_AngryBite_Damage":
        case "M31_PA_FrostBreath_Damage":
        case "M31_PA_FrostSpit_Damage":
        case "M31_PA_Lockjaw_Damage":
        case "M31_PA_PoisonSpit_Damage":
        case "M31_PA_VeryAngryBite_Damage":
        case "M31_PA_ViperBite_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_Poison_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PA_Viper'.static.CreatePoisonedEffect());
            return true;
        case "M31_PA_EnhancedPoison_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PA_Viper'.static.CreateEnhancedPoisonedEffect());
            return true;

        case "M31_PA_RegenBite_HealPerTurn":
            OutString = GetAltValueOutStringWithAbility(`GetConfigInt('M31_PA_RegenBite_HealPerTurn'), `GetConfigInt('M31_PA_RegenBite_EnhHealPerTurn'),
                class'X2AbilitySet_PA_Viper'.default.EnhancedPoisonAbilityName, ParseObj, StrategyParseOb, GameState);
            return true;
        case "M31_PA_RegenBite_Duration":
            OutString = GetAltValueOutStringWithAbility(`GetConfigInt('M31_PA_RegenBite_Duration'), `GetConfigInt('M31_PA_RegenBite_EnhDuration'),
                class'X2AbilitySet_PA_Viper'.default.EnhancedPoisonAbilityName, ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_Lockjaw_CritDamage":
            Damage = `GetConfigDamage("M31_PA_Lockjaw_Damage");
            OutString = GetOutStringWithRank(Damage.Crit, `GetConfigFloat("M31_PA_Lockjaw_CritDamagePerRank"), ParseObj, StrategyParseOb, GameState);
            return true;
        case "M31_PA_ViperBite_CritDamage":
            Damage = `GetConfigDamage("M31_PA_ViperBite_Damage");
            OutString = GetOutStringWithRank(Damage.Crit, `GetConfigFloat("M31_PA_ViperBite_CritDamagePerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_FrostbiteSpit_CritBonus":
            OutString = GetOutStringWithRank(`GetConfigInt(InString), `GetConfigFloat(InString $ "PerRank"), ParseObj, StrategyParseOb, GameState, "%");
            return true;
        case "M31_PA_FrostbiteSpit_CritDamageBonus":
            OutString = GetOutStringWithRank(`GetConfigFloat(InString), `GetConfigFloat(InString $ "PerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_BindCrush_Damage":
            OutString = ColorText_Auto(GetDamageRangeString(`GetConfigDamage(InString)),, UnitState);
            return true;

        case "M31_PA_RushAndBind_Damage":
        case "M31_PA_WS_RushAndBind_Damage":
            OutString = GetExtraDamageOutString(ParseObj, StrategyParseOb, GameState, 'Crush');
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetTaipanOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;
    local WeaponDamageValue Damage;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_PA_VeryAngryBite_AimBonus":
        case "M31_PA_VeryAngryBite_CritBonus":
        case "M31_PA_VeryAngryBite_BleedDuration":
        case "M31_PA_CrystallineCornea_AimBonus":
        case "M31_PA_CrystallineCornea_FlankAimBonus":
        case "M31_PA_MalevolentFocus_CritBonus":
        case "M31_PA_TaipanBloodThirst_DamagePerStack":
        case "M31_PA_TaipanBloodThirst_MaxStacks":
        case "M31_PA_TaipanBloodThirst_MaxStacksPerTurn":
        case "M31_PA_TaipanBloodThirst_StackDuration":
        case "M31_PA_TaipanBloodHunter_BonusDuration":
        case "M31_PA_TaipanBloodHunter_BonusMaxCount":
        case "M31_PA_TaipanBloodHunter_BonusMaxCountPerTurn":
        case "M31_PA_TaipanBloodHunter_DamageModifierPrc":
        case "M31_PA_TaipanBloodHunter_CritBonusPerStack":
        case "M31_PA_TaipanAmbush_ActivationsPerTurn":
        case "M31_PA_TaipanReturnFire_ActivationsPerTurn":
        case "M31_PA_TaipanWatchThemRun_ActivationsPerTurn":
        case "M31_PA_TaipanBite_AimBonus":
        case "M31_PA_TaipanBite_CritBonus":
        case "M31_PA_TaipanBite_Cooldown":
        case "M31_PA_TaipanBite_Rupture":
        case "M31_PA_TaipanBite_BleedDuration":
        case "M31_PA_TaipanDeadlyBite_AimBonus":
        case "M31_PA_TaipanDeadlyBite_CritBonus":
        case "M31_PA_TaipanDeadlyBite_ActivationsPerTurn":
        case "M31_PA_TaipanVengeance_AimBonus":
        case "M31_PA_TaipanVengeance_AimBonusHit":
        case "M31_PA_TaipanVengeance_CritBonus":
        case "M31_PA_TaipanVengeance_CritBonusHit":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PA_TaipanVengeance_AllyBonusModifierPrc":
        case "M31_PA_TaipanCruelty_BaseChance":
        case "M31_PA_TaipanCruelty_DamageBonusPrc":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PA_TaipanBloodThirst_bRefreshDuration":
        case "M31_PA_TaipanBloodThirst_bMatchSourceWeapon":
        case "M31_PA_TaipanBloodThirst_bIncreaseOnlyOnHit":
        case "M31_PA_TaipanBite_bAllowCrit":
        case "M31_PA_TaipanDeadlyBite_bExclusiveMark":
        case "M31_PA_TaipanCruelty_bGuaranteed":
        case "M31_PA_TaipanVengeance_bTreatBondmateAsSelf":
        case "M31_PA_TaipanVengeance_bRequireVisibility":
        case "M31_PA_TaipanVengeance_bAnyHostileAction":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_PA_VeryAngryBite_Damage":
        case "M31_PA_TaipanBite_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState);
            return true;
        case "M31_PA_TaipanDeadlyBite_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PA_Taipan'.static.CreateTaipanDeadlyBiteDamageEffect());
            return true;

        case "M31_PA_VeryAngryBite_CritDamage":
            Damage = `GetConfigDamage("M31_PA_VeryAngryBite_Damage");
            OutString = GetOutStringWithRank(Damage.Crit, `GetConfigFloat("M31_PA_VeryAngryBite_CritDamagePerRank"), ParseObj, StrategyParseOb, GameState);
            return true;
        case "M31_PA_TaipanBite_CritDamage":
            Damage = `GetConfigDamage("M31_PA_TaipanBite_Damage");
            OutString = GetOutStringWithRank(Damage.Crit, `GetConfigFloat("M31_PA_TaipanBite_CritDamagePerRank"), ParseObj, StrategyParseOb, GameState);
            return true;
        case "M31_PA_TaipanDeadlyBite_CritDamage":
            Damage = `GetConfigDamage("M31_PA_TaipanBite_Damage");
            OutString = GetOutStringWithRank(Damage.Crit, `GetConfigFloat("M31_PA_TaipanDeadlyBite_CritDamagePerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_VeryAngryBite_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PA_Taipan'.static.CreateVeryAngryBiteBleedingEffect());
            return true;
        case "M31_PA_TaipanBite_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PA_Taipan'.static.CreateTaipanBiteBleedingEffect());
            return true;

        case "M31_PA_TaipanBloodThirst_BuffText":
            OutString = class'X2Effect_PA_TaipanBloodThirst'.static.GetFriendlyDescOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetMutonOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;
    local float fValue;
    local int Value;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_PA_HardenedShield_ShieldAmount":
        case "M31_PA_HardenedShield_CritResistance":
        case "M31_PA_Counterattack_Dodge":
        case "M31_PA_Counterattack_Dodge_ReductionPerHit":
        case "M31_PA_PersonalShield_ShieldPriority":
        case "M31_PA_PersonalShield_Duration":
        case "M31_PA_CripplingBlow_AimPenalty":
        case "M31_PA_CripplingBlow_DefensePenalty":
        case "M31_PA_CripplingBlow_DodgePenalty":
        case "M31_PA_CripplingBlow_MobilityPenalty":
        case "M31_PA_CripplingBlow_Duration":
        case "M31_PA_Barbarian_AimBonus":
        case "M31_PA_Barbarian_CritBonus":
        case "M31_PA_MutonBullRush_AimBonus":
        case "M31_PA_MutonBullRush_CritBonus":
        case "M31_PA_MutonBullRush_StunDuration":
        case "M31_PA_StayFrosty_Radius":
        case "M31_PA_StayFrosty_ActivationsPerTurn":

        case "M31_PA_HunterMark_DefenseBonus":
        case "M31_PA_HunterMark_DefenseBonusPerTurn":
        case "M31_PA_HunterMark_DodgeBonus":
        case "M31_PA_HunterMark_DodgeBonusPerTurn":
        case "M31_PA_HunterMark_AimBonus":
        case "M31_PA_HunterMark_AimBonusPerTurn":
        case "M31_PA_HunterMark_CritBonus":
        case "M31_PA_HunterMark_CritBonusPerTurn":
        case "M31_PA_HunterWatchfulEye_ActivationsPerTurn":
        case "M31_PA_HunterDedication_DefenseBonus":
        case "M31_PA_HunterDedication_DodgeBonus":
        case "M31_PA_HunterDedication_MobilityBonus":
        case "M31_PA_HunterDedication_Duration":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PA_Aegis_DamageReduction":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PA_PersonalShield_bAllowWhileDisoriented":
        case "M31_PA_BayonetCharge_bAllowWhileDisoriented":
        case "M31_PA_Counterattack_bOnlyOnEnemyTurn":
        case "M31_PA_CripplingBlow_bInfiniteDuration":
        case "M31_PA_CripplingBlow_bAllowStack":
        case "M31_PA_StayFrosty_bReactionFire":
        case "M31_PA_HunterDedication_bExcludeFlanking":
        case "M31_PA_HunterDedication_bExcludeMelee":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_PA_PersonalShield_ShieldAmount":
            if (XComGameState_Ability(ParseObj) != none && StrategyParseOb == none)
            {
                Value = class'X2DLCInfo_MeristEnhancedShieldEffects'.static.GetShieldAmountPreview(ParseObj, StrategyParseOb, GameState);
                OutString = ColorText_Auto(Value,, UnitState);
            }
            else
            {
                OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState, eInvSlot_Armor);
            }
            return true;

        case "M31_PA_HarrierBullRush_AimBonus":
        case "M31_PA_HarrierBullRush_CritBonus":
        case "M31_PA_HarrierBullRush_StunDuration":
        case "M31_PA_HarrierPunch_AimBonus":
        case "M31_PA_HarrierPunch_CritBonus":
        case "M31_PA_HarrierVileMix_DOTDamageBonus":
        case "M31_PA_HarrierVileMix_DOTDamageBonus_Debuff":
        case "M31_PA_HarrierVileMix_Duration":
        case "M31_PA_HarrierPoisonGrenade_AmmoCost":
        case "M31_PA_HarrierPoisonGrenade_CooldownReductionEOG":
        case "M31_PA_HarrierFireGrenade_AmmoCost":
        case "M31_PA_HarrierFireGrenade_CooldownReductionEOG":
        case "M31_PA_HarrierRadGrenade_AmmoCost":
        case "M31_PA_HarrierRadGrenade_CooldownReductionEOG":
        case "M31_PA_HarrierFuseGrenade_AmmoCost":
        case "M31_PA_HarrierFuseGrenade_CooldownReductionEOG":
        case "M31_PA_HarrierCyclic_AimPenalty":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PA_HarrierPoisonGrenade_BaseRadiusModifer":
        case "M31_PA_HarrierFireGrenade_BaseRadiusModifer":
        case "M31_PA_HarrierRadGrenade_BaseRadiusModifer":
        case "M31_PA_HarrierFuseGrenade_BaseRadiusModifer":
            fValue = `GetConfigFloat(InString);
            if (fValue >= 0)
                OutString = "+" $ ColorText_Auto(TruncateFloat(fValue,, false) $ "m",, UnitState);
            else
                OutString = "-" $ ColorText_Auto(TruncateFloat(-1 * fValue,, false) $ "m",, UnitState);
            return true;

        case "M31_PA_HarrierBlasterMaster_Damage":
            OutString = ColorText_Auto(GetDamageRangeString(class'X2Item_DefaultGrenades'.default.MUTON_GRENADE_BASEDAMAGE),, UnitState);
            return true;
        case "M31_PA_HarrierBlasterMaster_EnvDamage":
            OutString = ColorText_Auto(class'X2Item_DefaultGrenades'.default.ALIENGRENADE_IENVIRONMENTDAMAGE,, UnitState);
            return true;
        case "M31_PA_HarrierBlasterMaster_Shred":
            OutString = ColorText_Auto(class'X2Item_DefaultGrenades'.default.MUTON_GRENADE_BASEDAMAGE.Shred,, UnitState);
            return true;
        case "M31_PA_HarrierBlasterMaster_Radius":
            OutString = ColorText_Auto(GetLocalizedTemplateProperty('MutonGrenade', class'X2GrenadeTemplate', 'iRadius') $ "m",, UnitState);
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetWinterSentinelOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_PA_WS_Ballista":
            OutString = ColorText_LimeGreen(`GetLocalizedString(InString));
            return true;

        case "M31_PA_WS_Thrill_BuffText":
            OutString = class'X2Effect_WS_Thrill'.static.GetFriendlyDescOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_AlloyedCores_Range":
        case "M31_PA_WS_AlloyedCores_CritBonus":
        case "M31_PA_WS_AlloyedCores_PierceBonus":
        case "M31_PA_WS_ChillingMist_Duration":
        case "M31_PA_WS_Entwine_DodgeBonus":
        case "M31_PA_WS_Entwine_BindDamageBonus":
        case "M31_PA_WS_Fracture_AimBonus":
        case "M31_PA_WS_Fracture_ShredBonus":
        case "M31_PA_WS_GlacialArmor_ArmorBonus":
        case "M31_PA_WS_GlacialArmor_DodgeBonus":
        case "M31_PA_WS_GlacialArmor_DamageReduction":
        case "M31_PA_WS_GlacialArmor_ActivationsPerTurn":
        case "M31_PA_WS_HeavyOrdnance_BonusCharges":
        case "M31_PA_WS_Hide_PaddingHP":
        case "M31_PA_WS_Hide_DamageReduction":
        case "M31_PA_WS_Indomitable_DamageReduction":
        case "M31_PA_WS_Indomitable_HPBonus":
        case "M31_PA_WS_Indomitable_MobilityBonus":
        case "M31_PA_WS_Indomitable_DodgeBonus":
        case "M31_PA_WS_Indomitable_WillBonus":
        case "M31_PA_WS_Indomitable_DefenseBonus":
        case "M31_PA_WS_Indomitable_ArmorBonus":
        case "M31_PA_WS_MetabolicBoost_DodgeBonus":
        case "M31_PA_WS_MetabolicBoost_DefenseBonus":
        case "M31_PA_WS_MetabolicBoost_Heal":
        case "M31_PA_WS_MetabolicBoost_MaxHeal":
        case "M31_PA_WS_MetabolicBoost_Charges":
        case "M31_PA_WS_NorthernWinds_Radius":
        case "M31_PA_WS_RagingSerpent_StunDuration":
        case "M31_PA_WS_RagingSerpent_AimBonus":
        case "M31_PA_WS_RagingSerpent_CritBonus":
        case "M31_PA_WS_ReinforcedScales_CritResistance":
        case "M31_PA_WS_ReinforcedScales_DamageReduction":
        case "M31_PA_WS_StupidSexySnake_Radius":
        case "M31_PA_WS_StupidSexySnake_AimBonus":
        case "M31_PA_WS_StupidSexySnake_CritBonus":
        case "M31_PA_WS_StupidSexySnake_DodgeBonus":
        case "M31_PA_WS_RebelYell_Radius":
        case "M31_PA_WS_RebelYell_AimBonus_Alt":
        case "M31_PA_WS_RebelYell_MobilityBonus_Alt":
        case "M31_PA_WS_RebelYell_DodgeBonus_Alt":
        case "M31_PA_WS_RebelYell_WillBonus_Alt":
        case "M31_PA_WS_RebelYell_DefenseBonus_Alt":
        case "M31_PA_WS_RebelYell_AimBonus":
        case "M31_PA_WS_RebelYell_MobilityBonus":
        case "M31_PA_WS_RebelYell_DodgeBonus":
        case "M31_PA_WS_RebelYell_WillBonus":
        case "M31_PA_WS_RebelYell_DefenseBonus":
        case "M31_PA_WS_RebelYell_Duration":
        case "M31_PA_WS_RebelYell_Charges":
        case "M31_PA_WS_ThrillOfTheHunt_MaxStacks":
        case "M31_PA_WS_ThrillOfTheHunt_AimPerStack":
        case "M31_PA_WS_ThrillOfTheHunt_CritPerStack":
        case "M31_PA_WS_Vigilance_SightRangeBonus":
        case "M31_PA_WS_WinterWarfare_ChargeBonus":
        case "M31_PA_WS_WinterWarfare_RadiusBonus":

        case "M31_PA_WS_Bolt_Maelstrom_Charges":
        case "M31_PA_WS_Bolt_Maelstrom_AimBonus_Ballista":
        case "M31_PA_WS_Bolt_Maelstrom_CritBonus_Ballista":
        case "M31_PA_WS_Bolt_Frost_Charges":
        case "M31_PA_WS_Bolt_Shred_Charges":
        case "M31_PA_WS_Bolt_Shred_ShredBonus_Ballista":
        case "M31_PA_WS_Bolt_Rupture_Charges":
        case "M31_PA_WS_Bolt_Rupture_RuptureBonus_Ballista":
        case "M31_PA_WS_Bolt_Rupture_CritBonus_Ballista":
        case "M31_PA_WS_Bolt_Stun_Charges":
        case "M31_PA_WS_Bolt_Stun_StunDuration_Ballista":
        case "M31_PA_WS_Bolt_Stun_StunDurationLarge_Ballista":
        case "M31_PA_WS_Bolt_Stun_MobilityPenalty_Ballista":
        case "M31_PA_WS_Bolt_Stun_BleedDamage_Ballista":
        case "M31_PA_WS_Bolt_Stun_DebuffDuration_Ballista":
        case "M31_PA_WS_Bolt_Crit_Charges":
        case "M31_PA_WS_Bolt_Crit_CritBonus_Ballista":
        case "M31_PA_WS_Bolt_Fire_Charges":
        case "M31_PA_WS_Bolt_Psi_Charges":
        case "M31_PA_WS_Bolt_Psi_EnvDamage":
        case "M31_PA_WS_Bolt_Poison_Charges":
        case "M31_PA_WS_Bolt_Rad_Charges":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PA_WS_Vigilance_SightRangeBonus_Tiles":
            OutString = ColorText_Auto(int(`GetConfigInt("M31_PA_WS_Vigilance_SightRangeBonus") / 1.5 + 0.1),, UnitState);
            return true;

        case "M31_PA_WS_Bolt_Maelstrom_AimBonus":
        case "M31_PA_WS_Bolt_Maelstrom_CritBonus":
        case "M31_PA_WS_Bolt_Shred_ShredBonus":
        case "M31_PA_WS_Bolt_Rupture_RuptureBonus":
        case "M31_PA_WS_Bolt_Rupture_CritBonus":
        case "M31_PA_WS_Bolt_Stun_Charges":
        case "M31_PA_WS_Bolt_Stun_StunDuration":
        case "M31_PA_WS_Bolt_Stun_MobilityPenalty":
        case "M31_PA_WS_Bolt_Stun_BleedDamage":
        case "M31_PA_WS_Bolt_Stun_DebuffDuration":
        case "M31_PA_WS_Bolt_Crit_CritBonus":
            OutString = class'X2AbilitySet_PA_WinterSentinel'.static.GetWinterSentinelBallistaBonusString(InString, 'Int', ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_Bolt_Frost_Radius":
        case "M31_PA_WS_Bolt_Fire_Radius":
        case "M31_PA_WS_Bolt_Psi_Radius":
        case "M31_PA_WS_Bolt_Poison_Radius":
        case "M31_PA_WS_Bolt_Rad_Radius":
            OutString = class'X2AbilitySet_PA_WinterSentinel'.static.GetWinterSentinelBallistaBonusString(InString, 'Float', ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_Bolt_Crit_BasePrcCritDamageBonus":
        case "M31_PA_WS_Bolt_Fire_BurnChance":
            OutString = class'X2AbilitySet_PA_WinterSentinel'.static.GetWinterSentinelBallistaBonusString(InString, 'Percent', ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_RagingSerpent_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_DragonSlayer_DamageBonusPrc_Unflankable":
        case "M31_PA_WS_DragonSlayer_DamageBonusPrc_Large":
        case "M31_PA_WS_GlacialArmor_DamageReduction_Prc":
        case "M31_PA_WS_Bolt_Maelstrom_MaxDamageBonus":

        case "M31_PA_WS_Bolt_Crit_BasePrcCritDamageBonus_Ballista":
        case "M31_PA_WS_Bolt_Fire_BurnChance_Ballista":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PA_WS_Bolt_Frost_Radius_Ballista":
        case "M31_PA_WS_Bolt_Fire_Radius_Ballista":
        case "M31_PA_WS_Bolt_Psi_Radius_Ballista":
        case "M31_PA_WS_Bolt_Poison_Radius_Ballista":
        case "M31_PA_WS_Bolt_Rad_Radius_Ballista":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)) $ "m",, UnitState);
            return true;

        case "M31_PA_WS_NorthernWinds_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_Dominance_bAllowWhileDisoriented":
        case "M31_PA_WS_Dominance_bAllowWhileBurning":
        case "M31_PA_WS_Fracture_bAppliesAgainstFlanked":
        case "M31_PA_WS_GlacialArmor_bAllowWhileBurning":
        case "M31_PA_WS_NorthernWinds_bAllowWhileConcealed":
        case "M31_PA_WS_NorthernWinds_bAllowWhileBurning":
        case "M31_PA_WS_NorthernWinds_bRequireVisibility":
        case "M31_PA_WS_RebelYell_bAppliesToPanicked":
        case "M31_PA_WS_RebelYell_bClearsPanic":
        case "M31_PA_WS_RebelYell_bAppliesToMindControlled":
        case "M31_PA_WS_RebelYell_bClearsMindControl":
        case "M31_PA_WS_RebelYell_bAppliesToStunned":
        case "M31_PA_WS_RebelYell_bClearsStun":
        case "M31_PA_WS_RagingSerpent_bAllowWhileDisoriented":
        case "M31_PA_WS_RagingSerpent_bAllowWhileBurning":
        case "M31_PA_WS_ThrillOfTheHunt_bExcludeRobotic":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetChosenArsenalOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    switch (InString)
    {
        case "M31_CA_BlindSpot_CritBonus":
        case "M31_CA_BlindSpot_CritDamageBonus":
        case "M31_CA_ChaosDriver_Duration":
        case "M31_CA_ChaosDriver_InitialCharges":
        case "M31_CA_ChaosDriver_MaxCharges":
        case "M31_CA_KillingSpree_DamageBonus":
        case "M31_CA_KillingSpree_CritBonus":
        case "M31_CA_KillingSpree_Duration":
        case "M31_CA_MarkForDeath_Duration":
        case "M31_CA_MistTrail_AimBonus":
        case "M31_CA_MistTrail_LOSModifier":
        case "M31_CA_MistTrail_Duration":
        case "M31_CA_PhantomStride_CooldownReduction":
            OutString = ColorText_Gold(`GetConfigInt(InString));
            return true;

        case "M31_CA_ChaosDriver_BonusPerCharge":
        case "M31_CA_ChaosDriver_PenaltyPerCharge":
        case "M31_CA_CollectBounty_DamagePrc":
            OutString = ColorText_Gold(`GetConfigInt(InString) $ "%");
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetPsiOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_PsionicReaper_DamagePsiFactor":
        case "M31_PsionicReaper_PiercePsiFactor":
        case "M31_PA_PsionicReaper_DamagePsiFactor":
        case "M31_PA_PsionicReaper_PiercePsiFactor":
        case "M31_Psi_NullWard_Radius":
        case "M31_Psi_NullWard_ShieldPriority":
        case "M31_Psi_NullWard_Duration":
        case "M31_Psi_TeleportAlly_Range":
        case "M31_Psi_GreatestChampion_CooldownReduction":
        case "M31_Psi_GreatestChampion_DefensePenalty":
        case "M31_Psi_Blend_Duration":
        case "M31_Psi_Cryotherapy_Range":
        case "M31_Psi_Cryotherapy_Charges":
        case "M31_Psi_MassCryotherapy_Radius":
        case "M31_Psi_MassCryotherapy_Charges":
        case "M31_Psi_MassCryotherapy_ChargeCost":
        case "M31_Psi_SummonSpectralZombie_Charges":
        case "M31_Psi_SummonSpectralCreature_Charges":
        case "M31_Psi_SummonSpectralLancer_Charges":
        case "M31_Psi_SummonRange":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_Psi_Compulsion_BaseChance":
        case "M31_Psi_GreatestChampion_DamageBonusPrc":
        case "M31_Psi_GreatestChampion_DRBonusPrc":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_Psi_Meltdown_bApplyRadiation":
        case "M31_Psi_TeleportAlly_bRequireVisibility":
        case "M31_Psi_Blend_bRemoveWhenSourceImpaired":
        case "M31_Psi_Stealth_bRemoveWhenSourceImpaired":
        case "M31_Psi_Cryotherapy_bSharedCooldown":
        case "M31_Psi_Cryotherapy_bStabilize":
        case "M31_Psi_MassCryotherapy_bApplyToSelf":
        case "M31_Psi_MassCryotherapy_bStabilize":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_Psi_NullWard_ShieldAmount":
        case "M31_Psi_Cryotherapy_HealAmount":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState,, true);
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetBerserkerOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        // case "":
        //     OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
        //     return true;

        // case "":
        //     OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
        //     return true;

        // case "":
        //     OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
        //     return true;

        // case "":
        //     OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState,, true);
        //     return true;

        default:
            return false;
    }

    return false;
}

static function bool GetShieldbearerOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit        UnitState;
    local XComGameState_Ability     AbilityState;
    local int                       Value;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_PRPA_SB_EnergyShield_Duration":
        case "M31_PRPA_SB_EnergyShield_ShieldPriority":
        case "M31_PRPA_SB_HealingShield_HealAmount":
        case "M31_PRPA_SB_HealingShield_MaxHealAmount":
        case "M31_PRPA_SB_ImprovedShield_CooldownReduction":
        case "M31_PRPA_SB_ImprovedShield_RadiusBonus":
        case "M31_PRPA_SB_ImprovedShield_ShieldBonus":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_PRPA_SB_AegisShield_DamageReduction":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PRPA_SB_HoloShield_AimBonus":
        case "M31_PRPA_SB_HoloShield_CritBonus":
        case "M31_PRPA_SB_HasteShield_MobilityBonus":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState, eInvSlot_Armor);
            return true;

        case "M31_PRPA_SB_EnergyShield_Radius":
            AbilityState = XComGameState_Ability(ParseObj);
            if (AbilityState != none && StrategyParseOb == none)
            {
                Value = int(`UNITSTOTILES(AbilityState.GetAbilityRadius()));
                OutString = ColorText_Auto(Value,, UnitState);
            }
            else
            {
                OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            }
            return true;

        case "M31_PRPA_SB_EnergyShield_ShieldAmount":
            AbilityState = XComGameState_Ability(ParseObj);
            if (AbilityState != none && StrategyParseOb == none)
            {
                Value = class'X2DLCInfo_MeristEnhancedShieldEffects'.static.GetShieldAmountPreview(ParseObj, StrategyParseOb, GameState);
                OutString = ColorText_Auto(Value,, UnitState);
            }
            else
            {
                OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState, eInvSlot_Armor);
            }
            return true;

        default:
            return false;
    }

    return false;
}

static function bool GetSkirmisherOutStrings(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XComGameState_Unit UnitState;
    local int Index;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);
    switch (InString)
    {
        case "M31_ForwardOperator_ActivationsPerTurn":
        case "M31_SK_BloodThirst_DamagePerStack":
        case "M31_SK_BloodThirst_MaxStacks":
        case "M31_SK_BloodThirst_MaxStacksPerTurn":
        case "M31_SK_BloodThirst_StackDuration":
        case "M31_SK_ZeroIn_CritPerShot":
        case "M31_SK_ZeroIn_LockedInAimPerShot":
        case "M31_SK_Pinions_Range":
        case "M31_SK_Pinions_NumTargets":
        case "M31_SK_Pinions_EnvDamage":
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_SK_DeepPockets_NumSlots":
            Index = class'OrdnanceInventorySlot'.default.AbilityUnlocksSlot.Find('AbilityName', 'M31_SK_DeepPockets');
            if (Index != INDEX_NONE)
            {
                OutString = ColorText_Auto(class'OrdnanceInventorySlot'.default.AbilityUnlocksSlot[Index].NumSlots,, UnitState);
            }
            return true;

        case "M31_SK_BloodThirst_bRefreshDuration":
        case "M31_SK_BloodThirst_bMatchSourceWeapon":
        case "M31_SK_BloodThirst_bIncreaseOnlyOnHit":
        case "M31_SK_ZeroIn_bDontResetOnMovement":
        case "M31_SK_ZeroIn_bAllowIncrementWithoutInput":
        case "M31_SK_Pinions_bExplosiveDamage":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_SK_Pinions_Radius":
        case "M31_SK_Pinions_AreaRadius":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)) $ "m",, UnitState);
            return true;

        case "M31_SK_Pinions_Damage":
            OutString = ColorText_Auto(GetDamageRangeString(`GetConfigDamage(InString)),, UnitState);
            return true;

        case "M31_SK_Pinions_Shred":
            OutString = ColorText_Auto(`GetConfigDamage("M31_SK_Pinions_Damage").Shred,, UnitState);
            return true;

        default:
            return false;
    }

    return false;
}

static function string GetSelfCooldown(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate     AbilityTemplate;
    local XComGameState_Unit    SourceUnit;
    local string                OutString;

    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);
    AbilityTemplate = GetAbilityTemplateFromParseObj(ParseObj, StrategyParseObj, GameState);

    if (AbilityTemplate != none)
    {
        if (AbilityTemplate.AbilityCooldown != none)
        {
            OutString = ColorText_Auto(AbilityTemplate.AbilityCooldown.iNumTurns,, SourceUnit);
        }
        else
        {
            OutString = ColorText_Auto("0",, SourceUnit);
        }
    }
    return OutString;
}

static function string GetSelfCharges(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate     AbilityTemplate;
    local XComGameState_Unit    SourceUnit;
    local string                OutString;

    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);
    AbilityTemplate = GetAbilityTemplateFromParseObj(ParseObj, StrategyParseObj, GameState);

    if (AbilityTemplate != none)
    {
        if (AbilityTemplate.AbilityCharges != none)
        {
            OutString = ColorText_Auto(AbilityTemplate.AbilityCharges.InitialCharges,, SourceUnit);
        }
        else
        {
            OutString = ColorText_Auto("0",, SourceUnit);
        }
    }
    return OutString;
}

// Strategy ability localization
// Tactical source localization
static function string GetDamageOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState, optional X2Effect Effect)
{
    local XComGameState_Effect          EffectState;
    local XComGameState_Ability         AbilityState;
    local X2AbilityTemplate             AbilityTemplate;
    local X2Effect                      ApplyOnTickEffect, TargetEffect;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_Persistent           PersistentEffect;

    // Effect passed directly
    // X2Effect_ApplyWeaponDamage -> GetDamageEffectOutString()
    // X2Effect_Persistent -> PersistentEffect.ApplyOnTick -> GetDamageEffectOutString()
    if (Effect != none)
    {
        DamageEffect = X2Effect_ApplyWeaponDamage(Effect);
        PersistentEffect = X2Effect_Persistent(Effect);
        if (DamageEffect != none)
        {
            return GetDamageEffectOutString(ParseObj, StrategyParseObj, GameState, DamageEffect);
        }
        else if (PersistentEffect != none)
        {
            foreach PersistentEffect.ApplyOnTick(ApplyOnTickEffect)
            {
                DamageEffect = X2Effect_ApplyWeaponDamage(ApplyOnTickEffect);
                if (DamageEffect != none)
                {
                    return GetDamageEffectOutString(ParseObj, StrategyParseObj, GameState, DamageEffect);
                }
            }
        }
        return "";
    }

    // ParseObj: XComGameState_Effect (EffectState)
    // StrategyParseObj: none
    if (StrategyParseObj == none)
    {
        AbilityState = XComGameState_Ability(ParseObj);
        EffectState = XComGameState_Effect(ParseObj);
        if (EffectState != none)
        {
            PersistentEffect = EffectState.GetX2Effect();
            if (PersistentEffect != none)
            {
                foreach PersistentEffect.ApplyOnTick(ApplyOnTickEffect)
                {
                    DamageEffect = X2Effect_ApplyWeaponDamage(ApplyOnTickEffect);
                    if (DamageEffect != none)
                    {
                        return GetDamageEffectOutString(ParseObj, StrategyParseObj, GameState, DamageEffect);
                    }
                }
            }
            return "";
        }
        else if (AbilityState != none)
        {
            AbilityTemplate = AbilityState.GetMyTemplate();
        }
        else
        {
            return "";
        }
    }

    if (AbilityTemplate == none)
    {
        AbilityTemplate = X2AbilityTemplate(ParseObj);
    }

    if (AbilityTemplate != none)
    {
        foreach AbilityTemplate.AbilityTargetEffects(TargetEffect)
        {
            DamageEffect = X2Effect_ApplyWeaponDamage(TargetEffect);
            if (DamageEffect != none)
            {
                return GetDamageEffectOutString(ParseObj, StrategyParseObj, GameState, DamageEffect);
            }
        }

        foreach AbilityTemplate.AbilityMultiTargetEffects(TargetEffect)
        {
            DamageEffect = X2Effect_ApplyWeaponDamage(TargetEffect);
            if (DamageEffect != none)
            {
                return GetDamageEffectOutString(ParseObj, StrategyParseObj, GameState, DamageEffect);
            }
        }
    }

    return "";
}

static function string GetEffectDamageOnTickString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect          EffectState;
    local X2Effect_Persistent           PersistentEffect;
    local X2Effect                      ApplyOnTickEffect;
    local X2Effect_ApplyWeaponDamage    DamageEffect;

    EffectState = XComGameState_Effect(ParseObj);

    if (EffectState != none)
    {
        PersistentEffect = EffectState.GetX2Effect();
        if (PersistentEffect != none)
        {
            foreach PersistentEffect.ApplyOnTick(ApplyOnTickEffect)
            {
                DamageEffect = X2Effect_ApplyWeaponDamage(ApplyOnTickEffect);
                if (DamageEffect != none)
                {
                    return GetDamageEffectOutString(ParseObj, StrategyParseObj, GameState, DamageEffect);
                }
            }
        }
    }

    return "?";
}

static function string GetDamageEffectOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState, X2Effect Effect)
{
    local XComGameStateHistory          History;
    local XComGameState_Effect          EffectState;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Unit            SourceUnit;
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Effect_ApplyScalingDamage   ScalingDamageEffect;
    local WeaponDamageValue             Damage;
    local int                           Rank, MaxRank;
    local string                        OutString;
    local StateObjectReference          EmptyRef;

    DamageEffect = X2Effect_ApplyWeaponDamage(Effect);
    if (DamageEffect != none)
    {
        ScalingDamageEffect = X2Effect_ApplyScalingDamage(Effect);
        if (ScalingDamageEffect != none)
        {
            History = `XCOMHISTORY;

            if (StrategyParseObj == none)
            {
                // Option 1: EffectState in ParseObj
                // Option 2: AbilityState in ParseObj
                // Option 3: AbilityTemplate in ParseObj (Armory)
                EffectState = XComGameState_Effect(ParseObj);
                AbilityState = XComGameState_Ability(ParseObj);
                // AbilityTemplate = X2AbilityTemplate(ParseObj);
                if (EffectState != none)
                {
                    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
                    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

                    // Not a clean solution, but we need a way to differentiate between a debuff on the target and the passive effect on the source
                    if (EffectState.GetX2Effect().BuffCategory != ePerkBuff_Passive)
                    {
                        // This is an actual debuff
                        // Return the calculated damage value
                        Damage = ScalingDamageEffect.GetBonusEffectDamageValue(AbilityState, SourceUnit, AbilityState.GetSourceWeapon(), EffectState.ApplyEffectParameters.TargetStateObjectRef);
                        OutString = GetDamageRangeString(Damage);
                        return OutString;
                    }
                }
                else if (AbilityState != none)
                {
                    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
                    // AbilityTemplate = AbilityState.GetMyTemplate();
                }
            }
            else
            {
                // Option 1: UnitState in StrategyParseObj, AbilityTemplate in ParseObj
                SourceUnit = XComGameState_Unit(StrategyParseObj);
                // AbilityTemplate = X2AbilityTemplate(ParseObj);
            }

            if (SourceUnit != none)
            {
                // Get the unit's current and max rank
                Rank = SourceUnit.GetSoldierRank();
                if (SourceUnit.GetSoldierClassTemplate() != none)
                {
                    MaxRank = SourceUnit.GetSoldierClassTemplate().GetMaxConfiguredRank();
                }
            }
            // Get the full damage value with no target
            Damage = ScalingDamageEffect.GetBonusEffectDamageValue(none, SourceUnit, none, EmptyRef);
            // Is there a flat damage value?
            if (Damage.Damage > 0 || SourceUnit != none && ScalingDamageEffect.DamagePerRank > 0)
            {
                // This value includes additional damage from rank
                OutString = GetDamageRangeString(Damage);
                OutString = ColorText_Auto(OutString,, SourceUnit);
                // Damage scales with rank
                if (SourceUnit != none && ScalingDamageEffect.DamagePerRank > 0)
                {
                    // Only show in strategy and only if the rank is below max
                    if (StrategyParseObj != none && Rank < MaxRank)
                    {
                        Damage = DamageEffect.EffectDamageValue;
                        OutString $= ColorText_Grey(" (" $ GetDamageRangeString(Damage)
                            $ " + " $  TruncateFloat(ScalingDamageEffect.DamagePerRank,, false) @ default.strPerRank $ ")");
                    }
                }
            }
            // Damage scales with the target's HP
            if (ScalingDamageEffect.DamageFromHP  > 0)
            {
                if (OutString != "")
                {
                    OutString $= " + ";
                }
                OutString $= ColorText_Auto(TruncateFloat(ScalingDamageEffect.DamageFromHP) $ "%",, SourceUnit);
            }
            return OutString;
        }
        else
        {
            SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);
            Damage = DamageEffect.EffectDamageValue;
            OutString = ColorText_Auto(GetDamageRangeString(Damage),, SourceUnit);
            return OutString;
        }
    }

    return "";
}

static function string GetTagValueFromItemTech(string Tag, Object ParseObj, Object StrategyParseObj, XComGameState GameState,
    optional EInventorySlot Slot = eInvSlot_Unknown, optional bool bSquash = true, optional string Suffix)
{
    local XComGameState_Unit    SourceUnit;
    local X2ItemTemplate        ItemTemplate;
    local bool                  bStrategy;
    local int                   i, Index;
    local array<float>          Array, NewArray;
    local string                OutString;
    local string                LeftString, MidString, RightString;

    bStrategy = StrategyParseObj != none;
    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);

    if (Slot != eInvSlot_Unknown)
    {
        ItemTemplate = SourceUnit.GetItemInSlot(Slot).GetMyTemplate();
    }
    else
    {
        ItemTemplate = GetItemTemplateFromParseObj(ParseObj, StrategyParseObj, GameState);
    }

    Array = `GetConfigArrayFloat(Tag);

    if (Array.Length == 0)
        return "";

    Index = -1;
    if (ItemTemplate != none)
    {
        Index = `GetTechLevel(ItemTemplate);
        if (Index != -1)
            Index = Clamp(Index, 0, Array.Length - 1);
    }

    if (!bStrategy)
    {
        if (0 <= Index && Index < Array.Length)
        {
            OutString = ColorText_Auto(TruncateFloat(Array[Index]) $ Suffix,, SourceUnit);
        }
    }
    else
    {
        if (bSquash)
        {
            for (i = 0; i < Array.Length; i++)
            {
                if (Index > i && Array[i] == Array[Index])
                {
                    Index = i;
                }
                if (NewArray.Length == 0 || NewArray[NewArray.Length - 1] != Array[i])
                {
                    NewArray.AddItem(Array[i]);
                }
            }
            Array = NewArray;
        }
        if (Index == -1)
        {
            for (i = 0; i < Array.Length; i++)
            {
                OutString $= TruncateFloat(Array[i]) $ Suffix;
                if (i < Array.Length - 1)
                {
                    OutString = OutString $ " / ";
                }
            }
        }
        else
        {
            for (i = 0; i < Index; i++)
            {
                LeftString $= TruncateFloat(Array[i]) $ Suffix;
                if (i < Array.Length - 1)
                {
                    LeftString = LeftString $ " / ";
                }
            }
            MidString = TruncateFloat(Array[i]) $ Suffix;
            for (i = Index + 1; i < Array.Length; i++)
            {
                RightString $= " / " $ TruncateFloat(Array[i]) $ Suffix;
            }

            if (LeftString != "")
                OutString $= ColorText_Grey(LeftString);
            OutString $= ColorText_Auto(MidString,, SourceUnit);
            if (RightString != "")
                OutString $= ColorText_Grey(RightString);
        }
    }
    
    if (OutString != "")
        return OutString;
    
    return "";
}

static function string GetTagValueFromRank(string Tag, Object ParseObj, Object StrategyParseObj, XComGameState GameState, optional bool bSquash = true, optional bool bShowRank = true)
{
    local XComGameState_Unit    SourceUnit;
    local bool          bStrategy;
    local int           i, Index;
    local array<int>    Array, NewArray, RankArray;
    local string        RankString, OutString;

    bStrategy = StrategyParseObj != none;
    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);

    Array = `GetConfigArrayInt(Tag);

    if (Array.Length == 0)
        return "";

    Index = -1;
    if (SourceUnit != none)
    {
        Index = SourceUnit.GetSoldierRank();
        Index = Clamp(Index, 0, Array.Length - 1);
    }

    if (!bStrategy)
    {
        OutString = ColorText_Auto(Array[Index],, SourceUnit);
    }
    else
    {
        if (bSquash)
        {
            for (i = 0; i < Array.Length; i++)
            {
                if (Index > i && Array[i] == Array[Index])
                {
                    Index = i;
                }
                if (NewArray.Length == 0 || NewArray[NewArray.Length - 1] != Array[i])
                {
                    NewArray.AddItem(Array[i]);
                    RankArray.AddItem(i);
                }
            }
            Array = NewArray;
        }
        if (Array.Length == 1)
        {
            if (Index == 0)
                OutString = ColorText_Auto(Array[Index],, SourceUnit);
            else
                OutString = ColorText_Grey(Array[Index]);
        }
        else
        {
            for (i = 0; i < Array.Length; i++)
            {
                if (bShowRank)
                {
                    RankString = default.RankNames[(bSquash ? RankArray[i] : i)];
                }
                
                if (RankString != "")
                {
                    RankString = "(" $ RankString $ ")";
                    if (i == 0)
                    {
                        if (i == Index)
                            OutString = ColorText_Auto(Array[i],, SourceUnit) @ ColorText_Grey(RankString, true);
                        else
                            OutString = ColorText_Grey(Array[i] @ RankString, true);
                    }
                    else if (i < Array.Length - 1)
                    {
                        if (i == Index)
                            OutString = OutString $ ColorText_Close() $ ColorText_Auto(Array[i],, SourceUnit) @ ColorText_Grey(RankString, true);
                        else
                            OutString = OutString $ string(Array[i]) @ RankString;
                    }
                    else
                    {
                        if (i == Index)
                            OutString = OutString $ ColorText_Close() $ ColorText_Auto(Array[i],, SourceUnit) @ ColorText_Grey(RankString);
                        else
                            OutString = OutString $ string(Array[i]) @ RankString $ ColorText_Close();
                    }
                }
                else
                {
                    if (i == 0)
                    {
                        if (i == Index)
                            OutString = ColorText_Auto(Array[i],, SourceUnit) $ ColorText_Grey("", true);
                        else
                            OutString = ColorText_Grey(Array[i], true);
                    }
                    else if (i < Array.Length - 1)
                    {
                        if (i == Index)
                            OutString = OutString $ ColorText_Close() $ ColorText_Auto(Array[i],, SourceUnit) $ ColorText_Grey("", true);
                        else
                            OutString = OutString $ string(Array[i]);
                    }
                    else
                    {
                        if (i == Index)
                            OutString = OutString $ ColorText_Close() $ ColorText_Auto(Array[i],, SourceUnit);
                        else
                            OutString = OutString $ string(Array[i]) $ ColorText_Close();
                    }
                }

                if (i < Array.Length - 1)
                    OutString = OutString $ " / ";
            }
        }
    }
    
    if (OutString != "")
        return OutString;
    
    return "";
}

static function string GetOutStringWithRank(int BaseValue, float PerRankValue, Object ParseObj, Object StrategyParseObj, XComGameState GameState,
    optional string Suffix, optional bool bClamp, optional int ClampMin, optional int ClampMax)
{
    local XComGameState_Unit SourceUnit;
    local bool bStrategy;
    local string OutString;
    local int Rank, MaxRank, FullValue;

    bStrategy = StrategyParseObj != none;
    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);

    if (SourceUnit == none)
    {
        return "";
    }

    Rank = SourceUnit.GetSoldierRank();
    if (SourceUnit.GetSoldierClassTemplate() != none)
    {
        MaxRank = SourceUnit.GetSoldierClassTemplate().GetMaxConfiguredRank();
    }

    FullValue = BaseValue + Rank * PerRankValue;

    if (bClamp)
    {
        FullValue = Clamp(FullValue, ClampMin, ClampMax);
    }

    OutString $= ColorText_Auto(FullValue $ Suffix,, SourceUnit);
    
    if (bStrategy && PerRankValue != 0 && Rank < MaxRank)
    {
        OutString $= ColorText_Grey(" (" $ BaseValue $ Suffix $ " + " $  TruncateFloat(PerRankValue) $ Suffix @ default.strPerRank $ ")");
    }
    
    return OutString;
}

static function string GetExtraDamageOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState, name Tag)
{
    local XComGameState_Unit    SourceUnit;
    local X2WeaponTemplate      WeaponTemplate;
    local WeaponDamageValue     Damage;
    local int                   Index;

    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);
    WeaponTemplate = X2WeaponTemplate(GetItemTemplateFromParseObj(ParseObj, StrategyParseObj, GameState));

    Index = WeaponTemplate.ExtraDamage.Find('Tag', Tag);

    if (Index != INDEX_NONE)
    {
        Damage = WeaponTemplate.ExtraDamage[Index];
        return ColorText_Auto(GetDamageRangeString(Damage),, SourceUnit);
    }

    return "";
}

static function string GetAltValueOutStringWithAbility(int Value, int AltValue, name RequiredAbility, Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Unit SourceUnit;

    if (Value != AltValue)
    {
        if (StrategyParseObj == none)
        {
            SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);
            if (SourceUnit != none && SourceUnit.HasSoldierAbility(RequiredAbility, true))
            {
                return ColorText_Auto(AltValue,, SourceUnit) $ ColorText_Green("*");
            }
        }
    }

    return ColorText_Auto(Value,, SourceUnit);
}

static function int GetEffectTurnsTicked(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect EffectState;

    EffectState = XComGameState_Effect(ParseObj);
    if (EffectState != none)
    {
        return EffectState.FullTurnsTicked;
    }
    return -1;
}

static function string GetEffectSourceFullName(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect  EffectState;
    local XComGameState_Unit    SourceUnit;

    EffectState = XComGameState_Effect(ParseObj);
    if (EffectState != none)
    {
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
        if (SourceUnit != none)
        {
            return SourceUnit.GetFullName();
        }
    }
    return "";
}

static function XComGameState_Unit GetSourceUnitFromParseObj(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect      EffectState;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        SourceUnit;

    if (StrategyParseObj != none)
    {
        SourceUnit = XComGameState_Unit(StrategyParseObj);
    }
    else
    {
        EffectState = XComGameState_Effect(ParseObj);
        AbilityState = XComGameState_Ability(ParseObj);
        if (EffectState != none)
        {
            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
        }
        if (AbilityState != none)
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        }
    }

    return SourceUnit;
}

static function X2AbilityTemplate GetAbilityTemplateFromParseObj(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect      EffectState;
    local XComGameState_Ability     AbilityState;
    local X2AbilityTemplate         AbilityTemplate;

    EffectState = XComGameState_Effect(ParseObj);
    AbilityState = XComGameState_Ability(ParseObj);
    AbilityTemplate = X2AbilityTemplate(ParseObj);

    if (EffectState != none)
    {
        AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    }
    if (AbilityState != none)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
    }

    return AbilityTemplate;
}

static function X2ItemTemplate GetItemTemplateFromParseObj(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate         AbilityTemplate;
    local X2ItemTemplate            ItemTemplate;
    local XComGameState_Effect      EffectState;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Item        ItemState;

    AbilityTemplate = X2AbilityTemplate(ParseObj);
    if (StrategyParseObj != none && AbilityTemplate != none)
    {
        ItemTemplate = GetItemBoundToAbilityFromUnit(XComGameState_Unit(StrategyParseObj), AbilityTemplate.DataName, GameState);
    }
    else
    {
        EffectState = XComGameState_Effect(ParseObj);
        AbilityState = XComGameState_Ability(ParseObj);
        if (EffectState != none)
        {
            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
        }
        if (AbilityState != none)
        {
            ItemState = AbilityState.GetSourceWeapon();
            if (ItemState != none)
            {
                ItemTemplate = ItemState.GetMyTemplate();
            }
        }
    }
    return ItemTemplate;
}

static function string GetBoundWeaponName(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2ItemTemplate ItemTemplate;

    ItemTemplate = GetItemTemplateFromParseObj(ParseObj, StrategyParseObj, GameState);
    if (ItemTemplate != none)
    {
        return ItemTemplate.GetItemAbilityDescName();
    }

    return default.strDefaultWeapon;
}

static function X2ItemTemplate GetItemBoundToAbilityFromUnit(XComGameState_Unit UnitState, name AbilityName, XComGameState GameState)
{
    local SCATProgression       Progression;
    local EInventorySlot        Slot;
    local XComGameState_Item    ItemState;

    if (UnitState == none)
        return none;

    Progression = UnitState.GetSCATProgressionForAbility(AbilityName);
    if (Progression.iRank == INDEX_NONE || Progression.iBranch == INDEX_NONE)
        return none;

    Slot = UnitState.AbilityTree[Progression.iRank].Abilities[Progression.iBranch].ApplyToWeaponSlot;
    if (Slot == eInvSlot_Unknown)
        return none;

    ItemState = UnitState.GetItemInSlot(Slot, GameState);
    if (ItemState != none)
    {
        return ItemState.GetMyTemplate();
    }

    return none;
}

static function string GetAbilityFriendlyName(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate AbilityTemplate;

    AbilityTemplate = GetAbilityTemplateFromParseObj(ParseObj, StrategyParseObj, GameState);
    if (AbilityTemplate != none)
    {
        return ColorText_LimeGreen(AbilityTemplate.LocFriendlyName);
    }

    return "";
}

static function string GetLocalizedTemplateProperty(name TemplateName, class TemplateClass, name PropertyName)
{
    local X2ItemTemplate            ItemTemplate;
    local X2WeaponTemplate          WeaponTemplate;
    local X2AbilityTemplate         AbilityTemplate;
    local X2CharacterTemplate       CharTemplate;

    local X2ItemTemplateManager         ItemMgr;
    local X2AbilityTemplateManager      AbilityMgr;
    local X2CharacterTemplateManager    CharMgr;

    if (ClassIsChildOf(TemplateClass, class'X2ItemTemplate'))
    {
        ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
        ItemTemplate = ItemMgr.FindItemTemplate(TemplateName);
        if (ItemTemplate != none)
        {
            WeaponTemplate = X2WeaponTemplate(ItemTemplate);
            if (WeaponTemplate != none)
            {
                switch (PropertyName)
                {
                    case 'iEnvironmentDamage':
                        return string(WeaponTemplate.iEnvironmentDamage);
                    case 'iRange':
                        return string(WeaponTemplate.iRange);
                    case 'iRadius':
                        return string(WeaponTemplate.iRadius);
                    case 'iClipSize':
                        return string(WeaponTemplate.iClipSize);
                    case 'BaseDamage':
                        return GetDamageRangeString(WeaponTemplate.BaseDamage);
                    case 'BaseDamage_Damage':
                        return string(WeaponTemplate.BaseDamage.Damage);
                    case 'BaseDamage_Spread':
                        return string(WeaponTemplate.BaseDamage.Spread);
                    case 'BaseDamage_PlusOne':
                        return string(WeaponTemplate.BaseDamage.PlusOne);
                    case 'BaseDamage_Crit':
                        return string(WeaponTemplate.BaseDamage.Crit);
                    case 'BaseDamage_Pierce':
                        return string(WeaponTemplate.BaseDamage.Pierce);
                    case 'BaseDamage_Rupture':
                        return string(WeaponTemplate.BaseDamage.Rupture);
                    case 'BaseDamage_Shred':
                        return string(WeaponTemplate.BaseDamage.Shred);
                }
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2AbilityTemplate'))
    {
        AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
        AbilityTemplate = AbilityMgr.FindAbilityTemplate(TemplateName);
        if (AbilityTemplate != none)
        {

        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2CharacterTemplate'))
    {
        CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
        CharTemplate = CharMgr.FindCharacterTemplate(TemplateName);
        if (CharTemplate != none)
        {

        }
    }

    return "";
}

//=======================================================================================
//                                  PARSER HELPERS
//---------------------------------------------------------------------------------------

static function string TruncateFloat(float fValue, optional int Places = 2, optional bool bCanBeInteger = true)
{
    local string TempString;
    local string FloatString;
    local int i;
    local float TestFloat;
    local float TempFloat;

    TempFloat = fValue;
    
    for (i = 0; i < Places; i++)
    {
        TempFloat *= 10.0;
    }
    
    TempFloat = Round(TempFloat);
    for (i = 0; i < Places; i++)
    {
        TempFloat /= 10.0;
    }

    TempString = string(TempFloat);
    for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
    {
        FloatString = Left(TempString, i);
        TestFloat = float(FloatString);
        if (TempFloat ~= TestFloat)
        {
            break;
        }
    }

    if (Right(FloatString, 1) == ".")
    {
        if (bCanBeInteger)
        {
            FloatString -= ".";
        }
        else
        {
            FloatString $= "0";
        }
    }

    return FloatString;
}

static function string GetDamageRangeString(WeaponDamageValue Damage)
{
    local int       MinDamage, MaxDamage;
    local string    OutString;

    MinDamage = Damage.Damage - Damage.Spread + (Damage.PlusOne >= 100 ? 1 : 0);
    MaxDamage = Damage.Damage + Damage.Spread + (Damage.PlusOne > 0 ? 1 : 0);

    if (MinDamage < MaxDamage)
        OutString = string(MinDamage) $ " - " $ string(MaxDamage);
    else
        OutString = string(MaxDamage);

    return OutString;
}

static function string GetAbilityListString(const array<string> AbilityNames)
{
    local string OutString;
    local int Index;
    
    for (Index = 0; Index < AbilityNames.Length; Index++)
    {
        OutString $= ColorText_LimeGreen(AbilityNames[Index]);
        if (Index < AbilityNames.Length - 1)
            OutString $= " - ";
    }
    return OutString;
}

//=======================================================================================
//                              COLOR TEXT HELPERS
//---------------------------------------------------------------------------------------

static function string ColorText_Auto(coerce string strInput, optional bool bOpen = false, optional XComGameState_Unit SourceUnit = none)
{
    local int Index;

    if (SourceUnit != none)
    {
        Index = default.SpecialColors.Find('ClassName', SourceUnit.GetSoldierClassTemplateName());
        if (Index != INDEX_NONE)
        {
            return ColorText_Internal(default.SpecialColors[Index].strColor, strInput, bOpen);
        }
    }

    if (default.DefaultSpecialColor != "")
    {
        return ColorText_Internal(default.DefaultSpecialColor, strInput, bOpen);
    }

    return strInput;
}

static function string ColorText_Gold(coerce string strInput, optional bool bOpen = false)
{
    // #ffd700
    return ColorText_Internal("#ffd700", strInput, bOpen);
}

static function string ColorText_Grey(coerce string strInput, optional bool bOpen = false)
{
    // #909497
    return ColorText_Internal("#909497", strInput, bOpen);
}

static function string ColorText_Cyan(coerce string strInput, optional bool bOpen = false)
{
    // #00ffff
    return ColorText_Internal("#00ffff", strInput, bOpen);
}

static function string ColorText_Green(coerce string strInput, optional bool bOpen = false)
{
    // #3cdc3c
    return ColorText_Internal("#3cdc3c", strInput, bOpen);
}

static function string ColorText_LimeGreen(coerce string strInput, optional bool bOpen = false)
{
    // #0bff9b
    return ColorText_Internal("#0bff9b", strInput, bOpen);
}

static function string ColorText_LightSeaGreen(coerce string strInput, optional bool bOpen = false)
{
    // #1abc9c
    return ColorText_Internal("#1abc9c", strInput, bOpen);
}

static function string ColorText_Internal(string strHexCode, coerce string strInput, optional bool bOpen = false)
{
    local string OutString;

    OutString = "<font color='" $ strHexCode $ "'>" $ strInput;
    if (!bOpen)
        OutString = OutString $ "</font>";

    return OutString;
}

static function string ColorText_Close()
{
    return "</font>";
}