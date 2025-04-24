//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_MeristPerkPack.uc
//  AUTHOR:  Iridar / Enhanced Mod Project Template --  26/02/2024
//  PURPOSE: Contains various DLC hooks, with examples on using the most popular ones.
//           Delete this file if you do not end up using it, as every class
//           that extends X2DownloadableContentInfo adds a tiny performance cost.
//---------------------------------------------------------------------------------------

class X2DLCInfo_MeristPerkPack extends X2DownloadableContentInfo;

var privatewrite config bool bLWOTC;
var privatewrite name SuppressingFireActionPoint;
var config(GameData_SoldierSkills) array<name> Botnet2_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> Aim_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> AddImpairingAttack;
var config(GameData_SoldierSkills) array<name> AttackGrenades;
var config(GameData_SoldierSkills) array<name> SuppressingFire_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> ImprovedSuppression_AllowedAbilities;
var config(GameData_SoldierSkills) bool bImprovedSuppression_ApplyToRobotic;
var config(GameData_SoldierSkills) bool bUpdateTemplarShield;
var config(TooManyTooltips) bool bEnableTooManyTooltips;
var config(TooManyTooltips) array<name> TooManyTooltips_AbilitiesToPatch;

//=======================================================================================
//                           ON POST TEMPLATES CREATED (OPTC)
//---------------------------------------------------------------------------------------

// Purpose: patching templates.
// Runs: every time the game starts, after creating templates.

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager AbilityTemplateManager;
    local name AbilityName;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach default.Botnet2_AllowedAbilities(AbilityName)
    {
        AddBotnetEffectToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }

    PatchCombatPresence(AbilityTemplateManager.FindAbilityTemplate('CombatPresence'));

    foreach default.AddImpairingAttack(AbilityName)
    {
        AddImparingAttackToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }

    foreach default.Aim_AllowedAbilities(AbilityName)
    {
        AddSharpshooterAimToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }

    foreach default.SuppressingFire_AllowedAbilities(AbilityName)
    {
        AddSuppressingFireToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }

    foreach default.ImprovedSuppression_AllowedAbilities(AbilityName)
    {
        AddImprovedSuppressionToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }

    if (default.bUpdateTemplarShield)
    {
        PatchTemplarShield(AbilityTemplateManager.FindAbilityTemplate('IRI_TemplarShield'));
    }

    if (default.bEnableTooManyTooltips)
    {
        foreach default.TooManyTooltips_AbilitiesToPatch(AbilityName)
        {
            ChangeEffectDisplayInfo(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
        }
    }

    AddEffectsToGrenades();
}

static function AddBotnetEffectToAbility(X2AbilityTemplate Template)
{
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2Condition_UnitEffectsOnSource       EffectCondition;
    local X2Effect_PersistentStatChange         HackDefenseEffect;
    
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeOrganic = true;
    UnitPropertyCondition.IncludeWeakAgainstTechLikeRobot = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;

    EffectCondition = new class'X2Condition_UnitEffectsOnSource';
    EffectCondition.AddRequireEffect('M31_Botnet_Valid', 'AA_MissingRequiredEffect');

    HackDefenseEffect = class'M31_AbilityHelpers'.static.CreateHackDefenseReductionStatusEffect(
        'M31_Botnet_HackEffect',
        `GetConfigInt("M31_Botnet_HackDefenseChange") * -1,
        UnitPropertyCondition);
    HackDefenseEffect.TargetConditions.AddItem(EffectCondition);

    Template.AddTargetEffect(HackDefenseEffect);
}

static function PatchCombatPresence(X2AbilityTemplate Template)
{
    local X2AbilityCooldown_Extended Cooldown; 

    if (Template != none)
    {
        Cooldown = new class'X2AbilityCooldown_Extended';
        Cooldown.iNumTurns = Template.AbilityCooldown.iNumTurns;
        Cooldown.AddCooldownModifier('M31_BattalionCommander', -1 * `GetConfigInt("M31_BattlePresence_CooldownReduction"));
        Template.AbilityCooldown = Cooldown;
    }
}

static function AddImparingAttackToAbility(X2AbilityTemplate Template)
{
    local X2Effect_ApplyWeaponDamage DamageEffect;
    local int i;

    if (Template != none)
    {
        for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
        {
            DamageEffect = X2Effect_ApplyWeaponDamage(Template.AbilityTargetEffects[i]);
            if (DamageEffect != none)
            {
                break;
            }
        }
        if (i != Template.AbilityTargetEffects.Length)
        {
            i++;
        }
        Template.AbilityTargetEffects.InsertItem(i, class'M31_AbilityHelpers'.static.CreateImpairingEffect());
    }
}

static function AddSharpshooterAimToAbility(X2AbilityTemplate Template)
{
    local int i;

    if (Template != none)
    {
        for (i = Template.AbilityTargetEffects.Length - 1; i >= 0; i--)
        {
            if (Template.AbilityTargetEffects[i].IsA('X2Effect_SharpshooterAim'))
            {
                Template.AbilityTargetEffects.Remove(i, 1);
            }
        }

        Template.AddTargetEffect(class'X2Effect_SharpshooterAim_LW'.static.SharpshooterAimEffect());
    }
}

static function AddSuppressingFireToAbility(X2AbilityTemplate Template)
{
    local X2AbilityCost                     AbilityCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityTrigger_EventListener    Trigger;

    if (Template != none)
    {
        foreach Template.AbilityCosts(AbilityCost)
        {
            ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
            if (ActionPointCost != none)
            {
                ActionPointCost.AllowedTypes.AddItem(class'X2DLCInfo_MeristPerkPack'.default.SuppressingFireActionPoint);
            }
        }

        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.EventID = 'M31_SuppressingFire_Suppress';
        Trigger.ListenerData.Filter = eFilter_Unit;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
        Trigger.ListenerData.Priority = 60;
        Template.AbilityTriggers.AddItem(Trigger);
    }
}

static function AddImprovedSuppressionToAbility(X2AbilityTemplate Template)
{
    local X2Effect_Persistent               DisorientedEffect;
    local X2Effect_Persistent               RobotocDisorientedEffect;
    local X2Condition_AbilityProperty       AbilityCondition;

    if (Template != none)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_ImprovedSuppression');

        DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
        DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
        Template.AddTargetEffect(DisorientedEffect);

        if (default.bImprovedSuppression_ApplyToRobotic)
        {
            RobotocDisorientedEffect = class'M31_AbilityHelpers'.static.CreateRoboticDisorientedStatusEffect();
            RobotocDisorientedEffect.TargetConditions.AddItem(AbilityCondition);
            Template.AddTargetEffect(RobotocDisorientedEffect);
        }
    }
}

static function X2Effect_ImmediateAbilityActivation CreateImpairingEffect()
{
    local X2Effect_ImmediateAbilityActivation   ImpairingAbilityEffect;
    local X2Condition_AbilityProperty           AbilityCondition;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

    ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
    ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
    ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
    ImpairingAbilityEffect.AbilityName = class'X2Ability_Impairing'.default.ImpairingAbilityName;
    ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
    ImpairingAbilityEffect.VisualizationFn = class'X2Ability_Impairing'.static.ImpairingAbilityEffectTriggeredVisualization;
    ImpairingAbilityEffect.TargetConditions.AddItem(AbilityCondition);

    return ImpairingAbilityEffect;
}

static function PatchTemplarShield(X2AbilityTemplate Template)
{
    local X2Effect_MeristTemplarShieldAnimations    AnimSetEffect;
    local X2Effect_MeristTemplarShield              ShieldEffect;
    local int i;

    if (Template != none)
    {
        for (i = Template.AbilityTargetEffects.Length - 1; i >= 0; i--)
        {
            if (Template.AbilityTargetEffects[i].IsA('X2Effect_TemplarShieldAnimations'))
            {
                Template.AbilityTargetEffects.Remove(i, 1);

                AnimSetEffect = new class'X2Effect_MeristTemplarShieldAnimations';
                AnimSetEffect.BuildPersistentEffect(1, false, true,, eGameRule_PlayerTurnBegin);
                AnimSetEffect.AddAnimSetWithPath("IRIParryReworkAnims.Anims.AS_BallisticShield");
                AnimSetEffect.AddAnimSetWithPath("IRIParryReworkAnims.Anims.AS_TemplarShield");
                Template.AbilityTargetEffects.InsertItem(i, AnimSetEffect);
            }
            else if (Template.AbilityTargetEffects[i].IsA('X2Effect_TemplarShield'))
            {
                Template.AbilityTargetEffects.Remove(i, 1);

                ShieldEffect = new class'X2Effect_MeristTemplarShield';
                ShieldEffect.ShieldPriority = 100;
                ShieldEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
                // ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
                Template.AbilityTargetEffects.InsertItem(i, ShieldEffect);
            }
        }
    }
}

static function ChangeEffectDisplayInfo(X2AbilityTemplate Template)
{
    local X2Effect                          Effect;
    local X2Effect_Persistent               PersistentEffect;
    local bool bAlreadyHasDisplayInfo;

    if (Template != none)
    {
        foreach Template.AbilityTargetEffects(Effect)
        {
            PersistentEffect = X2Effect_Persistent(Effect);
            if (PersistentEffect != none)
            {
                if (bAlreadyHasDisplayInfo)
                {
                    PersistentEffect.bDisplayInUI = false;
                }
                else
                {
                    if (PersistentEffect.bDisplayInUI)
                    {
                        if (PersistentEffect.bInfiniteDuration)
                            PersistentEffect.BuffCategory = ePerkBuff_Passive;
                        PersistentEffect.AbilitySourceName = Template.AbilitySourceName;
                        bAlreadyHasDisplayInfo = true;
                    }
                }
            }
        }
    }
}

static function AddEffectsToGrenades()
{
    local X2ItemTemplateManager         ItemManager;
    local array<name>                   TemplateNames;
    local array<X2DataTemplate>         TemplateAllDifficulties;
    local X2DataTemplate                Template;
    local X2GrenadeTemplate             GrenadeTemplate;
    local X2Condition_AbilityProperty   AbilityCondition;
    local name                          TemplateName;

    local X2Condition_UnitProperty      FriendCondition;
    local X2Condition_UnitProperty      EnemyCondition;
    local X2Condition_UnitProperty      OrganicCondition;
    local X2Condition_UnitProperty      RobotCondition;

    local X2Effect_Persistent           DisorientedEffect;
    local X2Effect_Persistent           RobotocDisorientedEffect;
    local X2Effect_Stunned              StunnedEffect;
    local X2Effect_Persistent           BleedingEffect;

    FriendCondition = new class'X2Condition_UnitProperty';
    FriendCondition.ExcludeFriendlyToSource = false;
    FriendCondition.ExcludeHostileToSource = true;

    EnemyCondition = new class'X2Condition_UnitProperty';
    EnemyCondition.ExcludeFriendlyToSource = true;
    EnemyCondition.ExcludeHostileToSource = false;

    OrganicCondition = new class'X2Condition_UnitProperty';
    OrganicCondition.ExcludeRobotic = true;
    OrganicCondition.ExcludeOrganic = false;
    OrganicCondition.IncludeWeakAgainstTechLikeRobot = false;

    RobotCondition = new class'X2Condition_UnitProperty';
    RobotCondition.ExcludeRobotic = false;
    RobotCondition.ExcludeOrganic = true;
    RobotCondition.IncludeWeakAgainstTechLikeRobot = true;

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
    DisorientedEffect.bRemoveWhenSourceDies = false;

    RobotocDisorientedEffect = class'M31_AbilityHelpers'.static.CreateRoboticDisorientedStatusEffect();
    RobotocDisorientedEffect.bRemoveWhenSourceDies = false;

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(
        `GetConfigInt("M31_ConcussiveGrenades_StunChance"), `GetConfigInt("M31_ConcussiveGrenades_StunDuration"));
    StunnedEffect.bRemoveWhenSourceDies = false;
    // StunnedEffect.TargetConditions.AddItem(OrganicCondition);

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_ConcussiveGrenades');
    DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
    RobotocDisorientedEffect.TargetConditions.AddItem(AbilityCondition);
    StunnedEffect.TargetConditions.AddItem(AbilityCondition);

    BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(
        `GetConfigInt("M31_PipeBombs_BleedDuration"), `GetConfigInt("M31_PipeBombs_BleedDamage"));
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PipeBombs');
    BleedingEffect.TargetConditions.AddItem(AbilityCondition);

    ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
    ItemManager.GetTemplateNames(TemplateNames);
    foreach TemplateNames(TemplateName)
    {
        ItemManager.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
        
        foreach TemplateAllDifficulties(Template)
        {
            GrenadeTemplate = X2GrenadeTemplate(Template);
            if (GrenadeTemplate != none)
            {
                if ((GrenadeTemplate.BaseDamage.Damage > 0 
                    && (GrenadeTemplate.ThrownGrenadeEffects.Length > 0 || GrenadeTemplate.LaunchedGrenadeEffects.Length > 0))
                    || default.AttackGrenades.find(TemplateName) != INDEX_NONE)
                {
                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(DisorientedEffect);
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(DisorientedEffect);
                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(RobotocDisorientedEffect);
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(RobotocDisorientedEffect);
                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(StunnedEffect);
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(StunnedEffect);
                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(BleedingEffect);
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(BleedingEffect);
                }
            }
        }
    }
}


//======================================================================================
//                            HIGHLANDER DLC HOOKS
//
// These hooks will run only if Highlander is active.
//---------------------------------------------------------------------------------------

// Purpose: making changes right before creating templates. Can also be used as a way
// to run code that needs to run as early as possible.
// Runs: every time the game starts, before creating templates.

static function OnPreCreateTemplates()
{
    default.bLWOTC = IsModActive('LongWarOfTheChosen');
} 

// Purpose: using dynamic values in ability localization.
// Runs: every time a localized string is expanded. 
// This can happen during template creation or dynamically as needed. 

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local WeaponDamageValue Damage;

    switch (InString)
    {
        case "BoundWeaponName_M31":
            OutString = GetBoundWeaponName(ParseObj, StrategyParseOb, GameState);
            return true;
    
        case "SelfCooldown_M31":
            OutString = GetSelfCooldown(ParseObj, StrategyParseOb, GameState);
            return true;
        case "SelfCharges_M31":
            OutString = GetSelfCharges(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_SharpshooterAim_AimBonus":
        case "M31_SharpshooterAim_CritBonus":
        case "M31_AlphaStrike_Radius":
        case "M31_AlphaStrike_Charges":
        case "M31_Bandit_AmmoToReload":
        case "M31_Botnet_HackDefenseChange":
        case "M31_Botnet_Duration":
        case "M31_BattlePresence_CooldownReduction":
        case "M31_Dervish_CooldownReduction":
        case "M31_Duskborn_AimBonus":
        case "M31_Duskborn_CritBonus":
        case "M31_Duskborn_Duration":
        case "M31_Escalation_CritBonus":
        case "M31_Escalation_CritDamageBonus":
        case "M31_Escalation_CritDamageBonusFactor":
        case "M31_Escalation_Duration":
        case "M31_Frostbane_CritBonus":
        case "M31_Frostbane_CritBonusPerTier":
        case "M31_Frostbane_PiercingBonus":
        case "M31_Frostbane_PiercingBonusPerTier":
        case "M31_Meld_Duration":
        case "M31_PerfectHandling_BaseRange":
        case "M31_Pinpoint_AimPerAction":
        case "M31_Pinpoint_AimBase":
        case "M31_Pinpoint_CritPerAction":
        case "M31_Pinpoint_CritBase":
        case "M31_SolidSnake_BaseRange":
        case "M31_SolidSnake_DodgeIgnore":
        case "M31_Sparkfire_AmmoCost":
        case "M31_SuperheavyOrdnance_ChargeBonus":
        case "M31_SuperheavyOrdnance_RangeBonus":
        case "M31_Warbringer_ChargeBonus":
        case "M31_Warbringer_RadiusBonus":
        case "M31_ConcussiveGrenades_StunDuration":
        case "M31_PipeBombs_BleedDuration":
        case "M31_AcidRounds_ShredBonus":
        case "M31_BleedingRounds_BleedDuration":
        case "M31_Bloodlet_BleedDuration":
        case "M31_ThermalShock_Duration":
        case "M31_ThermalShock_AimPenalty":
        case "M31_ThermalShock_AimPenalty_Immune":
        case "M31_ThermalShock_DefensePenalty":
        case "M31_ThermalShock_DefensePenalty_Immune":

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
        
        case "M31_PA_Entwine_DefenseBonus":
        case "M31_PA_Entwine_AimBonus":
        case "M31_PA_Entwine_BindDamageBonus":
        case "M31_PA_Salamander_RadiusBonus":
        case "M31_PA_Slither_MobilityBonus":
        case "M31_PA_Slither_DefenseBonus":
        case "M31_PA_Slither_DodgeBonus":
        case "M31_PA_Slither_Duration":
        case "M31_PA_Sidewinder_Cooldown":
        case "M31_PA_ViperBite_Rupture":
        case "M31_PA_ViperBite_AimBonus":
        case "M31_PA_ViperBite_CritBonus":
        case "M31_PA_ViperSpit_Range":
        case "M31_PA_Poison_MobilityPenalty":
        case "M31_PA_Poison_AimPenalty":
        case "M31_PA_Poison_Duration":
        case "M31_PA_EnhancedPoison_MobilityPenalty":
        case "M31_PA_EnhancedPoison_AimPenalty":
        case "M31_PA_EnhancedPoison_Duration":
        case "M31_PA_HardenedShield_ShieldAmount":
        case "M31_PA_HardenedShield_CritResistance":
        case "M31_PA_Counterattack_Dodge":
        case "M31_PA_Counterattack_Dodge_ReductionPerHit":
        case "M31_PA_PersonalShield_Duration":
        case "M31_PA_CripplingBlow_AimPenalty":
        case "M31_PA_CripplingBlow_DefensePenalty":
        case "M31_PA_CripplingBlow_DodgePenalty":
        case "M31_PA_CripplingBlow_MobilityPenalty":
        case "M31_PA_CripplingBlow_Duration":

        case "M31_PA_Poison_MobilityPenalty":
        case "M31_PA_Poison_AimPenalty":
        case "M31_PA_Poison_Duration":
        case "M31_PA_EnhancedPoison_MobilityPenalty":
        case "M31_PA_EnhancedPoison_AimPenalty":
        case "M31_PA_EnhancedPoison_Duration":
            OutString = ColorText_Gold(`GetConfigInt(InString));
            return true;

        case "M31_ConcussiveGrenades_StunChance":
        case "M31_DeathAdder_HPToDamage":
        case "M31_DeathAdder_MaxDamageBonus":
        case "M31_Pinpoint_CritDamagePerAction":
        case "M31_Pinpoint_CritDamageBase":
        case "M31_CA_ChaosDriver_BonusPerCharge":
        case "M31_CA_ChaosDriver_PenaltyPerCharge":
        case "M31_CA_CollectBounty_DamagePrc":
        case "M31_PA_Rattle_PanicChance":
        case "M31_PA_Aegis_DamageReduction":
            OutString = ColorText_Gold(`GetConfigInt(InString) $ "%");
            return true;

        case "M31_PipeBombs_BleedDamage":
        case "M31_Sparkfire_BurnDamage":
        case "M31_AcidRounds_BurnDamage":
        case "M31_BleedingRounds_BleedDamage":
        case "M31_Bloodlet_BleedDamage":
            OutString = GetOutStringFromRank(`GetConfigInt(InString), `GetConfigInt(InString $ "_Spread"), 0, ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_Poison_DamagePerTurn":
        case "M31_PA_EnhancedPoison_DamagePerTurn":
            OutString = GetOutStringFromRank(`GetConfigInt(InString), `GetConfigInt(InString $ "_Spread"), `GetConfigFloat("M31_PA_ViperPoison_DamageBonusPerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_PoisonSpit_Damage":
        case "M31_PA_FrostSpit_Damage":
        case "M31_PA_FrostBreath_Damage":
            Damage = `GetConfigDamage(InString);
            OutString = GetOutStringFromRank(Damage.Damage, Damage.Spread, `GetConfigFloat("M31_PA_ViperSpit_DamageBonusPerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_Lockjaw_Damage":
        case "M31_PA_ViperBite_Damage":
            Damage = `GetConfigDamage(InString);
            OutString = GetOutStringFromRank(Damage.Damage, Damage.Spread, `GetConfigFloat("M31_PA_ViperBite_DamageBonusPerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_Lockjaw_CritDamage":
            Damage = `GetConfigDamage("M31_PA_Lockjaw_Damage");
            OutString = GetOutStringFromRank(Damage.Crit, 0, `GetConfigFloat("M31_PA_ViperBite_CritDamageBonusPerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_ViperBite_CritDamage":
            Damage = `GetConfigDamage("M31_PA_ViperBite_Damage");
            OutString = GetOutStringFromRank(Damage.Crit, 0, `GetConfigFloat("M31_PA_ViperBite_CritDamageBonusPerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_FrostbiteSpit_CritBonus":
            OutString = GetOutStringFromRank(`GetConfigInt(InString), 0, `GetConfigFloat(InString $ "PerRank"), ParseObj, StrategyParseOb, GameState) $ ColorText_Gold("%");
            return true;

        case "M31_PA_FrostbiteSpit_CritDamageBonus":
            OutString = GetOutStringFromRank(`GetConfigFloat(InString), 0, `GetConfigFloat(InString $ "PerRank"), ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_PersonalShield_ShieldAmount":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState, eInvSlot_Armor);
            return true;

        case "M31_HunkerDown_DefenseBonus":
            OutString = ColorText_Gold(class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DEFENSE);
            return true;
        case "M31_HunkerDown_DodgeBonus":
            OutString = ColorText_Gold(class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DODGE);
            return true;
            
        default:
            return false;
    }

    return false;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: to reduce the displayed number of decimals after the dot.
// Credit: originally created by Pavonis for LW2 rocket scatter text.

static private function string TruncateFloat(float fValue)
{
    local string TempString;
    local string FloatString;
    local int i;
    local float TestFloat;
    local float TempFloat;
    local int places;

    TempFloat = fValue;
    
    places = 2;
    
    for (i=0; i < places; i++)
    {
        TempFloat *= 10.0;
    }
    
    TempFloat = Round(TempFloat);
    for (i=0; i < places; i++)
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
        FloatString $= "0";
    }

    return FloatString;
}

// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: get the name of the weapon to which the ability is bound.
// Typical use case: dynamic localization for an ability that can be assigned
// to different inventory slots for a soldier class.

static private function string GetBoundWeaponName(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate		AbilityTemplate;
    local X2ItemTemplate		ItemTemplate;
    local XComGameState_Effect	EffectState;
    local XComGameState_Ability	AbilityState;
    local XComGameState_Item	ItemState;

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
                ItemTemplate = ItemState.GetMyTemplate();
        }
    }

    if (ItemTemplate != none)
    {
        return ItemTemplate.GetItemAbilityDescName();
    }
    
    return `GetLocalizedString("M31_DefaultWeapon");
}


// Purpose: helper function for GetBoundWeaponName().
// Use: no need to use manually.

static private function X2ItemTemplate GetItemBoundToAbilityFromUnit(XComGameState_Unit UnitState, name AbilityName, XComGameState GameState)
{
    local SCATProgression		Progression;
    local XComGameState_Item	ItemState;
    local EInventorySlot		Slot;

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


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case:

static private function string GetSelfCooldown(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate			AbilityTemplate;
    local XComGameState_Ability		AbilityState;

    AbilityTemplate = X2AbilityTemplate(ParseObj);
    if (AbilityTemplate == none)
    {
        AbilityState = XComGameState_Ability(ParseObj);
        if (AbilityState != none)
            AbilityTemplate = AbilityState.GetMyTemplate();
    }
    if (AbilityTemplate != none)
    {
        if (AbilityTemplate.AbilityCooldown != none)
        {
            return ColorText_Gold(AbilityTemplate.AbilityCooldown.iNumTurns);
        }
    }
    return ColorText_Grey("?");
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function string GetSelfCharges(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate			AbilityTemplate;
    local XComGameState_Ability		AbilityState;

    AbilityTemplate = X2AbilityTemplate(ParseObj);
    if (AbilityTemplate == none)
    {
        AbilityState = XComGameState_Ability(ParseObj);
        if (AbilityState != none)
            AbilityTemplate = AbilityState.GetMyTemplate();
    }
    if (AbilityTemplate != none)
    {
        if (AbilityTemplate.AbilityCharges != none)
        {
            return ColorText_Gold(AbilityTemplate.AbilityCharges.InitialCharges);
        }
    }
    return ColorText_Grey("?");
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function string GetTagValueFromItemTech(string Tag, Object ParseObj, Object StrategyParseObj, XComGameState GameState, optional EInventorySlot Slot = eInvSlot_Unknown)
{
    local X2ItemTemplate        ItemTemplate;
    local XComGameState_Effect	EffectState;
    local XComGameState_Ability	AbilityState;
    local XComGameState_Unit	UnitState;
    local bool          bStrategy;
    local int           i, Index;
    local array<int>    Array;
    local string        s;
    local string        OutString;

    if (StrategyParseObj != none && X2AbilityTemplate(ParseObj) != none)
    {
        bStrategy = true;
        if (Slot != eInvSlot_Unknown)
            ItemTemplate = XComGameState_Unit(StrategyParseObj).GetItemInSlot(Slot).GetMyTemplate();
        else
            ItemTemplate = GetBoundWeaponTemplate(ParseObj, StrategyParseObj, GameState);
    }
    else
    {
        bStrategy = false;
        EffectState = XComGameState_Effect(ParseObj);
        AbilityState = XComGameState_Ability(ParseObj);
        if (EffectState != none)
            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

        if (AbilityState != none)
        {
            UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

            if (UnitState != none)
            {
                if (Slot != eInvSlot_Unknown)
                    ItemTemplate = UnitState.GetItemInSlot(Slot).GetMyTemplate();
                else
                    ItemTemplate = GetBoundWeaponTemplate(ParseObj, StrategyParseObj, GameState);
            }
        }
    }

    Array = `GetConfigArrayInt(Tag);

    if (ItemTemplate != none)
        Index = GetItemTech(ItemTemplate);
    else
        Index = -2;

    if (!bStrategy && 0 <= Index && Index < Array.Length)
    {
        OutString = ColorText_Gold(Array[Index]);
    }
    else
    {
        for (i = 0; i < Array.Length; i++)
        {
            if (i == Index)
                s = ColorText_Gold(Array[i]);
            else
                s = ColorText_Grey(Array[i]);
            
            if (i + 1 == Array.Length)
                OutString = OutString $ s;
            else
                OutString = OutString $ s $ ColorText_Grey(" / ");
        }
    }
    
    if (OutString != "")
        return OutString;
    
    return ColorText_Grey("?");
}


// Purpose: helper function for GetTagValueFromItemTech().
// Use: get the template of the weapon to which the ability is bound.
// Typical use case:

static private function X2ItemTemplate GetBoundWeaponTemplate(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate		AbilityTemplate;
    local X2ItemTemplate		ItemTemplate;
    local XComGameState_Effect	EffectState;
    local XComGameState_Ability	AbilityState;
    local XComGameState_Item	ItemState;

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
            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

        if (AbilityState != none)
        {
            ItemState = AbilityState.GetSourceWeapon();

            if (ItemState != none)
                ItemTemplate = ItemState.GetMyTemplate();
        }
    }
    
    return ItemTemplate;
}


// Purpose: helper function for GetTagValueFromItemTech().
// Use:
// Typical use case:

static private function int GetItemTech(X2ItemTemplate ItemTemplate)
{
    local X2WeaponTemplate      WeaponTemplate;
    local X2ArmorTemplate       ArmorTemplate;
    local X2GremlinTemplate     GremlinTemplate;
    local int Index;

    Index = -1;
    if (ItemTemplate != none)
    {

        WeaponTemplate = X2WeaponTemplate(ItemTemplate);
        ArmorTemplate = X2ArmorTemplate(ItemTemplate);
        GremlinTemplate = X2GremlinTemplate(ItemTemplate);

        if (WeaponTemplate != none)
        {
            switch (WeaponTemplate.WeaponTech)
            {
                case 'beam':            Index = 4;  break;
                case 'coilgun_lw':      Index = 3;  break;
                case 'magnetic':        Index = 2;  break;
                case 'laser_lw':        Index = 1;  break;
                case 'conventional':    Index = 0;  break;
                default:                Index = -1; break;
            }
        }
        else if (ArmorTemplate != none)
        {
            switch (ArmorTemplate.ArmorTechCat)
            {
                case 'Powered':         Index = 2;  break;
                case 'Plated':          Index = 1;  break;
                case 'Conventional':    Index = 0;  break;
                default:                Index = -1; break;
            }
        }
        else if (GremlinTemplate != none)
        {
            switch (GremlinTemplate.WeaponTech)
            {
                case 'beam':            Index = 2;  break;
                case 'magnetic':        Index = 1;  break;
                case 'conventional':    Index = 0;  break;
                default:                Index = -1; break;
            }
        }
    }
    return Index;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function string GetOutStringFromRank(float Base, float Spread, float PerRank, Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect	EffectState;
    local XComGameState_Ability	AbilityState;
    local XComGameState_Unit	UnitState;
    local bool          bStrategy;
    local int           Rank;
    local int           MaxRank;
    local string        OutString;
    local string        s;
    local string        BaseString;
    local string        PerRankString;

    if (StrategyParseObj != none && X2AbilityTemplate(ParseObj) != none)
    {
        bStrategy = true;
        UnitState = XComGameState_Unit(StrategyParseObj);
    }
    else
    {
        bStrategy = false;
        EffectState = XComGameState_Effect(ParseObj);
        AbilityState = XComGameState_Ability(ParseObj);
        if (EffectState != none)
        {
            AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
            if (AbilityState == none)
                AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
        }

        if (AbilityState != none)
        {
            UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
            if (UnitState == none)
                UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        }
    }
    if (UnitState != none)
    {
        Rank = UnitState.GetSoldierRank();
        if (UnitState.GetSoldierClassTemplate() != none)
            MaxRank = UnitState.GetSoldierClassTemplate().GetMaxConfiguredRank();

        if (Spread == 0)
        {
            BaseString = ColorText_Gold(int(Base + PerRank * Rank));
        }
        else
        {
            BaseString = ColorText_Gold(int(Base - Spread + PerRank * Rank) $ " - " $ int(Base + Spread + PerRank * Rank));
        }
        OutString = BaseString;
        if (bStrategy && PerRank != 0 && Rank < MaxRank)
        {
            if (PerRank > 0)
            {
                s = "+";
            }
            else if (PerRank < 0)
            {
                s = "-";
            }
            
            PerRankString = ColorText_Grey("(", true) $ s $ TruncateFloat(PerRank) $ " " $ `GetLocalizedString("M31_PerRank") $ ")" $ ColorText_Close();
            OutString = OutString $ " " $ PerRankString;
        }
        return OutString;
    }
    
    return ColorText_Grey("?");
}

// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: apply HTML hex color to a string. 
// Tip: hex color codes can be acquired at https://htmlcolorcodes.com/

static private function string ColorText_Gold(coerce string strInput, optional bool bOpen = false)
{
    // #ffd700
    return ColorText_Internal("#ffd700", strInput, bOpen);
}

static private function string ColorText_Grey(coerce string strInput, optional bool bOpen = false)
{
    // #909497
    return ColorText_Internal("#909497", strInput, bOpen);
}

static private function string ColorText_Teal(coerce string strInput, optional bool bOpen = false)
{
    // #1abc9c
    return ColorText_Internal("#1abc9c", strInput, bOpen);
}
 
static private function string ColorText_Internal(string strHexCode, coerce string strInput, optional bool bOpen = false)
{
    local string OutString;

    OutString = "<font color='" $ strHexCode $ "'>" $ strInput;
    if (!bOpen)
        OutString = OutString $ "</font>";

    return OutString;
}

static private function string ColorText_Close()
{
    return "</font>";
}



//=======================================================================================
//                                    EMPT HELPERS
//---------------------------------------------------------------------------------------

// Purpose: checks if the mod with the specified modname is active.
// Tip: modname is the name of the .XComMod file without the extension.
// Use: Use from anywhere, but preferably cache the check into a global config bool var
// and then check the var. Explained in detail here:
// https://www.reddit.com/r/xcom2mods/wiki/index/good_coding_practices#wiki_1._assign_the_default_value_of_a_config_var_from_anywhere_in_the_code

static final function bool IsModActive(const name ModName)
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
    {
        if (EventManager.GetDLCNames(Index) == ModName) 
        {
            return true;
        }
    }
    return false;
}

//---------------------------------------------------------------------------------------

defaultproperties
{
    SuppressingFireActionPoint = "M31_SuppressingFire"
}