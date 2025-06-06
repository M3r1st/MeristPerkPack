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
var config(GameData_SoldierSkills) array<name> GrenadeAbilities;
var config(GameData_SoldierSkills) array<name> SuppressingFire_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> ImprovedSuppression_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> RapidDumping_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> ShadowstepAid_AllowedAbilities;
var config(GameData_SoldierSkills) array<name> ShadowstepAid_AllowedMultiTargetAbilities;
var config(GameData_SoldierSkills) bool bUpdateTemplarShield;
var config(TooManyTooltips) bool bEnableTooManyTooltips;
var config(TooManyTooltips) array<name> TooManyTooltips_AbilitiesToPatch;

struct TextColorByClass
{
    var name ClassName;
    var string strColor;
};

var config(GameData_SoldierSkills) array<TextColorByClass> SpecialColors;
var config(GameData_SoldierSkills) string DefaultSpecialColor;

var privatewrite config array<string> RapidDumping_Abilities;
var privatewrite config array<string> FutureWarfare_Abilities;

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

    foreach default.RapidDumping_AllowedAbilities(AbilityName)
    {
        AddRapidDumpingToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }

    foreach default.ShadowstepAid_AllowedAbilities(AbilityName)
    {
        AddShadowstepAidToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName), false);
    }

    foreach default.ShadowstepAid_AllowedMultiTargetAbilities(AbilityName)
    {
        AddShadowstepAidToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName), true);
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

    GetLocalizedAbilityLists();
}

static function GetLocalizedAbilityLists()
{
    local X2DataTemplate            IterateTemplate;
    local array<X2DataTemplate>     DataTemplates;
    local X2DataTemplate            DataTemplate;
    local X2AbilityTemplate         Template;

    local X2AbilityTemplateManager          AbilityMgr;

    AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach AbilityMgr.IterateTemplates(IterateTemplate)
    {
        if (!ClassIsChildOf(IterateTemplate.Class, class'X2AbilityTemplate')) continue;

        AbilityMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);

        foreach DataTemplates(DataTemplate)
        {
            Template = X2AbilityTemplate(DataTemplate);

            if (default.RapidDumping_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.RapidDumping_Abilities.AddItem(ColorText_LightSeaGreen(Template.LocFriendlyName));

            if (class'X2AbilitySet_Merist'.default.FutureWarfare_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
                default.FutureWarfare_Abilities.AddItem(ColorText_LightSeaGreen(Template.LocFriendlyName));
        }
    }
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

        if (`GetConfigBool("M31_ImprovedSuppression_bApplyToRobotic"))
        {
            RobotocDisorientedEffect = class'M31_AbilityHelpers'.static.CreateRoboticDisorientedStatusEffect();
            RobotocDisorientedEffect.TargetConditions.AddItem(AbilityCondition);
            Template.AddTargetEffect(RobotocDisorientedEffect);
        }
    }
}

static function AddRapidDumpingToAbility(X2AbilityTemplate Template)
{
    local X2AbilityCost                     AbilityCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;

    if (Template != none)
    {
        foreach Template.AbilityCosts(AbilityCost)
        {
            ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
            if (ActionPointCost != none)
            {
                ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_RapidDumping');
            }
        }
    }
}

static function AddShadowstepAidToAbility(X2AbilityTemplate Template, bool bAddToMultiTarget)
{
    local X2Effect_Persistent               ShadowstepEffect;
    local X2Effect_GrantActionPoints        ActionPointEffect;
    local X2Condition_AbilityProperty       AbilityCondition;
    local X2Condition_UnitProperty          TargetCondition;

    if (Template != none)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_ShadowstepAid');

        TargetCondition = new class'X2Condition_UnitProperty';
        TargetCondition.ExcludeHostileToSource = true;
        TargetCondition.ExcludeFriendlyToSource = false;
        TargetCondition.RequireSquadmates = true;
        TargetCondition.FailOnNonUnits = true;
        TargetCondition.ExcludeDead = true;
        TargetCondition.ExcludeUnableToAct = true;

        ShadowstepEffect = new class'X2Effect_Persistent';
        ShadowstepEffect.EffectName = 'Shadowstep';
        ShadowstepEffect.DuplicateResponse = eDupe_Ignore;
        ShadowstepEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
        ShadowstepEffect.SetDisplayInfo(ePerkBuff_Bonus, `GetLocalizedString("M31_ShadowstepAid_FriendlyName"), `GetLocalizedString("M31_ShadowstepAid_BuffText"), "img:///UILibrary_PerkIcons.UIPerk_shadowstep", true,, Template.AbilitySourceName);
        ShadowstepEffect.TargetConditions.AddItem(AbilityCondition);

        ActionPointEffect = new class'X2Effect_GrantActionPoints';
        ActionPointEffect.NumActionPoints = 1;
        ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
        ActionPointEffect.TargetConditions.AddItem(TargetCondition);
        ActionPointEffect.TargetConditions.AddItem(AbilityCondition);
        ActionPointEffect.TargetConditions.AddItem(new class'X2Condition_ItsOwnTurn');

        if (bAddToMultiTarget)
        {
            Template.AddMultiTargetEffect(ShadowstepEffect);
            Template.AddMultiTargetEffect(ActionPointEffect);
        }
        else
        {
            Template.AddTargetEffect(ShadowstepEffect);
            Template.AddTargetEffect(ActionPointEffect);
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
    local MZ_Effect_Hypothermia         HypothermiaEffect;

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

    BleedingEffect = class'X2AbilitySet_Merist'.static.CreatePipeBombsBleedingEffect();
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PipeBombs');
    BleedingEffect.TargetConditions.AddItem(AbilityCondition);

    HypothermiaEffect = class'X2AbilitySet_WinterSentinel'.static.GetChillingMistHypothermiaEffect();
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_PA_WS_ChillingMist');
    HypothermiaEffect.TargetConditions.AddItem(AbilityCondition);

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
                if (class'X2AbilitySet_WinterSentinel'.default.FrostGrenades.Find(GrenadeTemplate.DataName) != INDEX_NONE)
                {
                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(HypothermiaEffect);
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(HypothermiaEffect);
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
    local XComGameState_Unit UnitState;
    local int ShieldRemaining;
    local int ShieldPriority;

    UnitState = GetSourceUnitFromParseObj(ParseObj, StrategyParseOb, GameState);

    switch (InString)
    {
        case "M31_BoundWeaponName":
            OutString = GetBoundWeaponName(ParseObj, StrategyParseOb, GameState);
            return true;
    
        case "M31_SelfCooldown":
            OutString = GetSelfCooldown(ParseObj, StrategyParseOb, GameState);
            return true;
        case "M31_SelfCharges":
            OutString = GetSelfCharges(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_FreeAction":
            OutString = ColorText_Green(`GetLocalizedString(InString));
            return true;

        case "M31_ShieldRemaining":
            GetShieldEffectValues(ParseObj, StrategyParseOb, GameState, ShieldRemaining, ShieldPriority);
            OutString = ColorText_Auto(ShieldRemaining,, UnitState);
            return true;
        case "M31_ShieldPriority":
            GetShieldEffectValues(ParseObj, StrategyParseOb, GameState, ShieldRemaining, ShieldPriority);
            OutString = ColorText_Auto(ShieldPriority,, UnitState);
            return true;
            
        case "M31_SharpshooterAim_AimBonus":
        case "M31_SharpshooterAim_CritBonus":
        case "M31_AlphaStrike_Radius":
        case "M31_AlphaStrike_Charges":
        case "M31_Assassin_ActivationsPerTurn":
        case "M31_Bandit_AmmoToReload":
        case "M31_BloodThirst_MaxStacks":
        case "M31_BloodThirst_MaxStacksPerTurn":
        case "M31_BloodThirst_StackDuration":
        case "M31_Botnet_HackDefenseChange":
        case "M31_Botnet_Duration":
        case "M31_BattlePresence_CooldownReduction":
        case "M31_Dervish_CooldownReduction":
        case "M31_Duskborn_AimBonus":
        case "M31_Duskborn_CritBonus":
        case "M31_Duskborn_Duration":
        case "M31_EnemyUnknown_AimBonus":
        case "M31_EnemyUnknown_CritBonus":
        case "M31_EnemyUnknown_DamageBonus":
        case "M31_EnemyUnknown_CritDamageBonus":
        case "M31_EnemyUnknown_MobilityBonus":
        case "M31_EnemyUnknown_DodgeBonus":
        case "M31_EnemyUnknown_DefenseBonus":
        case "M31_EnergyShield_Radius":
        case "M31_EnergyShield_Duration":
        case "M31_EnergyShield_ShieldPriority":
        case "M31_EnhancedLowProfile_CritBonus":
        case "M31_EnhancedLowProfile_AimBonus":
        case "M31_Escalation_CritBonus":
        case "M31_Escalation_CritDamageBonus":
        case "M31_Escalation_CritDamageBonusFactor":
        case "M31_Escalation_Duration":
        case "M31_Frostbane_CritBonus":
        case "M31_Frostbane_CritBonusPerTier":
        case "M31_Frostbane_PiercingBonus":
        case "M31_Frostbane_PiercingBonusPerTier":
        case "M31_FutureWarfare_ActivationsPerTurn":
        case "M31_FutureWarfare_CooldownReduction":
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
        case "M31_TrackingFire_CooldownReduction":
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
        
        case "M31_PA_Coil_DefenseBonus":
        case "M31_PA_Coil_DodgeBonus":
        case "M31_PA_Entwine_DefenseBonus":
        case "M31_PA_Entwine_AimBonus":
        case "M31_PA_Entwine_BindDamageBonus":
        case "M31_PA_Salamander_RadiusBonus":
        case "M31_PA_Slither_MobilityBonus":
        case "M31_PA_Slither_DefenseBonus":
        case "M31_PA_Slither_DodgeBonus":
        case "M31_PA_Slither_Duration":
        case "M31_PA_Sidewinder_Cooldown":
        case "M31_PA_Lockjaw_Cooldown":
        case "M31_PA_ViperBite_Rupture":
        case "M31_PA_ViperBite_AimBonus":
        case "M31_PA_ViperBite_CritBonus":
        case "M31_PA_AngryBite_AimBonus":
        case "M31_PA_AngryBite_CritBonus":
        case "M31_PA_AngryBite_Cooldown":
        case "M31_PA_VeryAngryBite_AimBonus":
        case "M31_PA_VeryAngryBite_CritBonus":
        case "M31_PA_VeryAngryBite_BleedDuration":
        case "M31_PA_IronskinBite_ShieldAmount":
        case "M31_PA_IronskinBite_ShieldPriority":
        case "M31_PA_IronskinBite_Duration":
        case "M31_PA_CrystallineCornea_AimBonus":
        case "M31_PA_CrystallineCornea_FlankAimBonus":
        case "M31_PA_MalevolentFocus_CritBonus":
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
        case "M31_PA_PersonalShield_ShieldPriority":
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
            OutString = ColorText_Auto(`GetConfigInt(InString),, UnitState);
            return true;

        case "M31_ConcussiveGrenades_StunChance":
        case "M31_DeathAdder_HPToDamage":
        case "M31_DeathAdder_MaxDamageBonus":
        case "M31_Pinpoint_CritDamagePerAction":
        case "M31_Pinpoint_CritDamageBase":
        case "M31_PA_Rattle_PanicChance":
        case "M31_PA_Aegis_DamageReduction":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PA_Coil_NoCoverModifier":
        case "M31_PA_Coil_LowCoverModifier":
        case "M31_PA_Coil_HighCoverModifier":
        case "M31_PA_PoisonSpit_Radius":
        case "M31_PA_FrostSpit_Radius":
        case "M31_PA_FrostBreath_Radius":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)),, UnitState);
            return true;

        case "M31_BloodThirst_bRefreshDuration":
        case "M31_BloodThirst_bApplyToAnyMelee":
        case "M31_BloodThirst_bIncreaseOnlyOnHit":
        case "M31_Frostbane_bCheckSourceWeapon":
        case "M31_TrackingFire_bIsReactionFire":
        case "M31_TrackingFire_bAllowResetFromBladestorm":
        case "M31_ImprovedSuppression_bApplyToRobotic":

        case "M31_PA_Coil_Hunker_bAllowDeepCover":
        case "M31_PA_Lockjaw_bAllowCrit":
        case "M31_PA_ViperBite_bAllowCrit":
        case "M31_PA_AngryBite_bAllowCrit":
        case "M31_PA_AngryBite_bHasCooldown":
        case "M31_PA_AngryBite_bCooldownOnlyOnHit":
        case "M31_PA_VeryAngryBite_bFreeAction":
        case "M31_PA_VeryAngryBite_bAllowMovementActionPoint":
        case "M31_PA_VeryAngryBite_bAllowCrit":
        case "M31_PA_VeryAngryBite_bIsReactonFire":
        case "M31_PA_MalevolentFocus_bOnlyForReaction":
        case "M31_PA_Spit_bRequireVisibility":
        case "M31_PA_PoisonSpit_bDealsDamage":
        case "M31_PA_PoisonSpit_bAppliesPoisonToWorld":
        case "M31_PA_FrostBreath_bDealsDamage":
        case "M31_PA_PersonalShield_bAllowWhileDisoriented":
        case "M31_PA_BayonetCharge_bAllowWhileDisoriented":
        case "M31_PA_Counterattack_bOnlyOnEnemyTurn":
        case "M31_PA_CripplingBlow_bInfiniteDuration":
        case "M31_PA_CripplingBlow_bAllowStack":
        case "M31_PA_Sidewinder_bOnlyOnEnemyTurn":
        case "M31_PA_Sidewinder_bAllowWhileDisoriented":
        case "M31_PA_Sidewinder_bAllowWhileBurning":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;

        case "M31_BloodThirst_BuffText":
            OutString = GetBloodThirstOutString(ParseObj, StrategyParseOb, GameState);
            return true;

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

        case "M31_PA_PoisonSpit_Damage":
        case "M31_PA_FrostSpit_Damage":
        case "M31_PA_FrostBreath_Damage":
        case "M31_PA_ViperBite_Damage":
        case "M31_PA_VeryAngryBite_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState);
            return true;
        
        case "M31_PA_Lockjaw_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState,,, class'X2AbilitySet_PlayableAliens'.static.CreateLockjawDamageEffect());
            return true;

        case "M31_PA_AngryBite_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState,,, class'X2AbilitySet_PlayableAliens'.static.CreateAngryBiteDamageEffect());
            return true;

        case "M31_PA_VeryAngryBite_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PlayableAliens'.static.CreateVeryAngryBiteBleedingEffect(), true);
            return true;

        case "M31_PA_VeryAngryBite_BleedDamage_Debuff":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_PlayableAliens'.static.CreateVeryAngryBiteBleedingEffect());
            return true;

        case "M31_PipeBombs_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreatePipeBombsBleedingEffect());
            return true;

        case "M31_Sparkfire_BurnDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateSparkfireBurningEffect());
            return true;

        case "M31_AcidRounds_BurnDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateAcidRoundsBurningEffect());
            return true;

        case "M31_BleedingRounds_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateBleedingRoundsBleedingEffect(), true);
            return true;
        case "M31_BleedingRounds_BleedDamage_Debuff":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateBleedingRoundsBleedingEffect());
            return true;

        case "M31_Bloodlet_BleedDamage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateBloodletBleedingEffect(), true);
            return true;
        case "M31_Bloodlet_BleedDamage_Debuff":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'X2AbilitySet_Merist'.static.CreateBloodletBleedingEffect());
            return true;

        case "M31_PA_Poison_DamagePerTurn":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'M31_AbilityHelpers'.static.CreatePoisonedEffect(), true);
            return true;
        case "M31_PA_Poison_DamagePerTurn_Debuff":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'M31_AbilityHelpers'.static.CreatePoisonedEffect());
            return true;

        case "M31_PA_EnhancedPoison_DamagePerTurn":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'M31_AbilityHelpers'.static.CreateEnhancedPoisonedEffect(), true);
            return true;
        case "M31_PA_EnhancedPoison_DamagePerTurn_Debuff":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState, class'M31_AbilityHelpers'.static.CreateEnhancedPoisonedEffect());
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

        case "M31_PA_PersonalShield_ShieldAmount":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState, eInvSlot_Armor);
            return true;
    
        case "M31_EnergyShield_ShieldAmount":
            OutString = GetTagValueFromItemTech(InString, ParseObj, StrategyParseOb, GameState, eInvSlot_Armor);
            return true;

        // WINTER SENTINEL

        case "M31_PA_WS_AlloyedCores_Range":
        case "M31_PA_WS_AlloyedCores_CritBonus":
        case "M31_PA_WS_AlloyedCores_PierceBonus":
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
            OutString = GetWinterSentinelBallistaBonusString(InString, 'Int', ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_Bolt_Frost_Radius":
        case "M31_PA_WS_Bolt_Fire_Radius":
        case "M31_PA_WS_Bolt_Psi_Radius":
        case "M31_PA_WS_Bolt_Poison_Radius":
        case "M31_PA_WS_Bolt_Rad_Radius":
            OutString = GetWinterSentinelBallistaBonusString(InString, 'Float', ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_Bolt_Crit_BasePrcCritDamageBonus":
        case "M31_PA_WS_Bolt_Fire_BurnChance":
            OutString = GetWinterSentinelBallistaBonusString(InString, 'Percent', ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_RagingSerpent_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState);
            return true;

        case "M31_PA_WS_DragonSlayer_DamageBonusPrc_Unflankable":
        case "M31_PA_WS_DragonSlayer_DamageBonusPrc_Large":
        case "M31_PA_WS_GlacialArmor_DamageReduction_Prc":

        case "M31_PA_WS_Bolt_Crit_BasePrcCritDamageBonus_Ballista":
        case "M31_PA_WS_Bolt_Fire_BurnChance_Ballista":
            OutString = ColorText_Auto(`GetConfigInt(InString) $ "%",, UnitState);
            return true;

        case "M31_PA_WS_Bolt_Frost_Radius_Ballista":
        case "M31_PA_WS_Bolt_Fire_Radius_Ballista":
        case "M31_PA_WS_Bolt_Psi_Radius_Ballista":
        case "M31_PA_WS_Bolt_Poison_Radius_Ballista":
        case "M31_PA_WS_Bolt_Rad_Radius_Ballista":
            OutString = ColorText_Auto(TruncateFloat(`GetConfigFloat(InString)),, UnitState);
            return true;

        case "M31_PA_WS_NorthernWinds_Damage":
            OutString = GetDamageOutString(ParseObj, StrategyParseOb, GameState,,, class'X2AbilitySet_WinterSentinel'.static.GetNorthernWindsDamageEffect());
            return true;

        case "M31_PA_WS_Dominance_bAllowWhileDisoriented":
        case "M31_PA_WS_Dominance_bAllowWhileBurning":
        case "M31_PA_WS_Fracture_bAppliesAgainstFlanked":
        case "M31_PA_WS_GlacialArmor_bAllowWhileBurning":
        case "M31_PA_WS_NorthernWinds_bAllowWhileConcealed":
        case "M31_PA_WS_NorthernWinds_bAllowWhileBurning":
        case "M31_PA_WS_NorthernWinds_bRequireVisibility":
        case "M31_PA_WS_Bolt_Stun_bCanStunLargeUnits":
        case "M31_PA_WS_RebelYell_bClearsPanic":
        case "M31_PA_WS_RebelYell_bClearsMindControl":
        case "M31_PA_WS_RagingSerpent_bAllowWhileDisoriented":
        case "M31_PA_WS_RagingSerpent_bAllowWhileBurning":
            OutString = ColorText_Auto(`GetConfigBool(InString),, UnitState);
            return true;
            
        case "M31_HunkerDown_DefenseBonus":
            OutString = ColorText_Auto(class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DEFENSE,, UnitState);
            return true;
        case "M31_HunkerDown_DodgeBonus":
            OutString = ColorText_Auto(class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DODGE,, UnitState);
            return true;

        case "M31_RapidDumping_Abilities":
            OutString = GetStringFromLocalizedList(default.RapidDumping_Abilities);
            return true;

        case "M31_FutureWarfare_Abilities":
            OutString = GetStringFromLocalizedList(default.FutureWarfare_Abilities);
            return true;

        default:
            return false;
    }

    return false;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:

static private function string GetStringFromLocalizedList(const array<string> LocalizedList)
{
    local string OutString;
    local int Index;
    
    for (Index = 0; Index < LocalizedList.Length; Index++)
    {
        OutString $= LocalizedList[Index];
        if (Index != LocalizedList.Length - 1)
            OutString $= ", ";
    }
    return OutString;
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
    local X2AbilityTemplate     AbilityTemplate;
    local X2ItemTemplate        ItemTemplate;
    local XComGameState_Effect  EffectState;
    local XComGameState_Ability AbilityState;
    local XComGameState_Item    ItemState;

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
    local SCATProgression           Progression;
    local XComGameState_Item        ItemState;
    local EInventorySlot            Slot;

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

static private function string GetWinterSentinelBallistaBonusString(string InString, name Type, Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Unit    SourceUnit;
    local X2AbilityTemplate     AbilityTemplate;
    local X2ItemTemplate        ItemTemplate;
    local XComGameState_Effect  EffectState;
    local XComGameState_Ability AbilityState;
    local XComGameState_Item    ItemState;
    local string                OutString;
    local string                BallistaSuffix;

    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);

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

    BallistaSuffix = "_Ballista";
    if (class'X2AbilitySet_WinterSentinel'.default.Ballista_Categories.Find(ItemTemplate.DataName) != INDEX_NONE)
    {
        switch (Type)
        {
            case 'Int':
                OutString = string(`GetConfigInt(InString $ BallistaSuffix));
                break;
            case 'Float':
                OutString = TruncateFloat(`GetConfigFloat(InString $ BallistaSuffix));
                break;
            case 'Percent':
                OutString = string(`GetConfigInt(InString $ BallistaSuffix)) $ "%";
                break;
        }
        OutString = ColorText_Green("?") $ ColorText_Auto(OutString,, SourceUnit);
    }
    else
    {
        switch (Type)
        {
            case 'Int':
                OutString = string(`GetConfigInt(InString));
                break;
            case 'Float':
                OutString = TruncateFloat(`GetConfigFloat(InString));
                break;
            case 'Percent':
                OutString = string(`GetConfigInt(InString)) $ "%";
                break;
        }
        OutString = ColorText_Auto(OutString,, SourceUnit);
    }

    return OutString;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case:

static private function XComGameState_Unit GetSourceUnitFromParseObj(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
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
            if (AbilityState == none)
                AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
        }

        if (AbilityState != none)
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
            if (SourceUnit == none)
                SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        }
    }
    return SourceUnit;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case:

static private function string GetSelfCooldown(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Ability     AbilityState;
    local X2AbilityTemplate         AbilityTemplate;
    local XComGameState_Unit        SourceUnit;

    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);

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
            return ColorText_Auto(AbilityTemplate.AbilityCooldown.iNumTurns,, SourceUnit);
        }
        else
        {
            return ColorText_Auto("0",, SourceUnit);
        }
    }
    return ColorText_Grey("?");
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function string GetSelfCharges(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local X2AbilityTemplate         AbilityTemplate;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        SourceUnit;

    SourceUnit = GetSourceUnitFromParseObj(ParseObj, StrategyParseObj, GameState);

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
            return ColorText_Auto(AbilityTemplate.AbilityCharges.InitialCharges,, SourceUnit);
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
    local string        OutString;

    if (StrategyParseObj != none)
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
        OutString = ColorText_Auto(Array[Index],, UnitState);
    }
    else
    {
        if (Array.Length == 1)
        {
            if (Index == 0)
                OutString = ColorText_Auto(Array[Index],, UnitState);
            else
                OutString = ColorText_Grey(Array[Index]);
        }
        else
        {
            for (i = 0; i < Array.Length; i++)
            {
                if (i == 0)
                {
                    if (i == Index)
                        OutString = ColorText_Auto(Array[i],, UnitState) $ ColorText_Grey("", true);
                    else
                        OutString = ColorText_Grey(Array[i], true);
                }
                else if (i < Array.Length - 1)
                {
                    if (i == Index)
                        OutString = OutString $ ColorText_Close() $ ColorText_Auto(Array[i],, UnitState) $ ColorText_Grey("", true);
                    else
                        OutString = OutString $ string(Array[i]);
                }
                else
                {
                    if (i == Index)
                        OutString = OutString $ ColorText_Close() $ ColorText_Auto(Array[i],, UnitState);
                    else
                        OutString = OutString $ string(Array[i]) $ ColorText_Close();
                }
                if (i < Array.Length - 1)
                    OutString = OutString $ " / ";
            }
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
    local X2AbilityTemplate     AbilityTemplate;
    local X2ItemTemplate        ItemTemplate;
    local XComGameState_Effect  EffectState;
    local XComGameState_Ability AbilityState;
    local XComGameState_Item    ItemState;

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

static private function string GetBloodThirstOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
    local XComGameState_Effect              EffectState;
    local XCGS_Effect_BloodThirst           BloodThirstEffectState;
    local X2Effect_BloodThirst              BloodThirstEffect;
    local string OutString;
    local int Index;
    local int iCount;
    local bool bFirst;

    EffectState = XComGameState_Effect(ParseObj);
    if (EffectState != none)
    {
        BloodThirstEffectState = XCGS_Effect_BloodThirst(EffectState);
        if (BloodThirstEffectState != none)
        {
            iCount = BloodThirstEffectState.GetTotalStacksRemaining();
            if (iCount == 0)
                return `GetLocalizedString("M31_BloodThirst_BuffText_NoStacks");
            else
                OutString = `GetLocalizedString("M31_BloodThirst_BuffText_Stacks") $ " " $ iCount $ " " $ `GetLocalizedString("M31_BloodThirst_BuffText_Stacks2") $ "<br><br>";

            BloodThirstEffect = X2Effect_BloodThirst(BloodThirstEffectState.GetX2Effect());

            bFirst = true;
            for (Index = 0; Index < BloodThirstEffect.iMaxStacks; Index++)
            {
                if (BloodThirstEffectState.arrStacksRemaining[Index] > 0)
                {
                    if (bFirst)
                        bFirst = false;
                    else
                        OutString $= "<br>";
                        
                    OutString $= BloodThirstEffectState.arrStacksRemaining[Index] $ " ";
                    
                    if (Index == 0)
                        OutString $= `GetLocalizedString("M31_BloodThirst_BuffText_StacksHelpFirst");
                    else
                        OutString $= `GetLocalizedString("M31_BloodThirst_BuffText_StacksHelp") $ " " $ Index + 1 $ " " $ `GetLocalizedString("M31_Turns") $ ".";
                }
            }
            return OutString;
        }
    }
    return "?";
}

// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function GetShieldEffectValues(Object ParseObj, Object StrategyParseObj, XComGameState GameState, out int ShieldRemaining, out int ShieldPriority)
{
    local XComGameState_Effect                  EffectState;
    local XCGS_Effect_EnergyShieldExtended      ShieldEffectState;

    EffectState = XComGameState_Effect(ParseObj);
    if (EffectState != none)
    {
        ShieldEffectState = XCGS_Effect_EnergyShieldExtended(EffectState);
        if (ShieldEffectState != none)
        {
            ShieldRemaining = ShieldEffectState.ShieldRemaining;
            ShieldPriority = ShieldEffectState.ShieldPriority;
        }
    }
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function string GetOutStringWithRank(int BaseValue, float PerRankValue, Object ParseObj, Object StrategyParseObj, XComGameState GameState, optional string strExtra)
{
    local XComGameState_Effect      EffectState;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        SourceUnit;
    local bool          bStrategy;
    local string        OutString;
    local int           iRank;
    local int           iMaxRank;

    if (StrategyParseObj != none)
    {
        bStrategy = true;
        SourceUnit = XComGameState_Unit(StrategyParseObj);
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
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
            if (SourceUnit == none)
                SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
        }
    }
    if (SourceUnit != none)
    {
        iRank = SourceUnit.GetSoldierRank();
        if (SourceUnit.GetSoldierClassTemplate() != none)
            iMaxRank = SourceUnit.GetSoldierClassTemplate().GetMaxConfiguredRank();
    }

    OutString $= ColorText_Auto(BaseValue $ strExtra,, SourceUnit);
    
    if (bStrategy && PerRankValue != 0 && iRank < iMaxRank)
        OutString $= ColorText_Grey(" ( " $ BaseValue $ " + " $  TruncateFloat(PerRankValue) $ strExtra $ " " $ `GetLocalizedString("M31_PerRank") $ ")");
    
    return OutString;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use:
// Typical use case: 

static private function string GetDamageOutString(Object ParseObj, Object StrategyParseObj, XComGameState GameState, optional X2Effect_Persistent EffectToProcess, optional bool bNoTarget, optional X2Effect_ApplyWeaponDamage DamageEffect)
{
    local XComGameState_Effect      EffectState;
    local XComGameState_Ability     AbilityState;
    local X2AbilityTemplate         AbilityTemplate;
    local XComGameState_Unit        SourceUnit;
    local XComGameState_Unit        TargetUnit;
    local X2Effect                  Effect;
    local bool          bStrategy;
    local string        OutString;

    if (StrategyParseObj != none)
    {
        bStrategy = true;
        SourceUnit = XComGameState_Unit(StrategyParseObj);
        AbilityTemplate = X2AbilityTemplate(ParseObj);
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

            TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            if (TargetUnit == none)
                TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        }

        if (AbilityState != none)
        {
            SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
            if (SourceUnit == none)
                SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

            AbilityTemplate = AbilityState.GetMyTemplate();
        }
    }

    if (EffectToProcess != none)
    {
        foreach EffectToProcess.ApplyOnTick(Effect)
            if (ProcessDamageEffect(OutString, bStrategy, Effect, SourceUnit, (bNoTarget ? none : TargetUnit)))
                return OutString;
    }
    else
    {
        if (DamageEffect != none)
            if (ProcessDamageEffect(OutString, bStrategy, DamageEffect, SourceUnit, none))
                return OutString;

        foreach AbilityTemplate.AbilityTargetEffects(Effect)
            if (ProcessDamageEffect(OutString, bStrategy, Effect, SourceUnit, TargetUnit))
                return OutString;

        foreach AbilityTemplate.AbilityMultiTargetEffects(Effect)
            if (ProcessDamageEffect(OutString, bStrategy, Effect, SourceUnit, TargetUnit))
                return OutString;
    }
    
    return ColorText_Grey("?");
}

// Purpose: helper function for GetDamageOutString().
// Use:
// Typical use case: 

static private function bool ProcessDamageEffect(out string OutString, bool bStrategy, X2Effect Effect, optional XComGameState_Unit SourceUnit, optional XComGameState_Unit TargetUnit)
{
    local WeaponDamageValue Damage;
    local int           iRank;
    local int           iMaxRank;
    local int           iDamageLow;
    local int           iDamageHigh;
    local int           iDamageLowBase;
    local int           iDamageHighBase;
    local float         fDamagePrc;
    local bool          bNeedsPlus;

    local X2Effect_ApplyDamageFromHPWithRank    DamageEffectHPRank;
    local X2Effect_ApplyDamageFromHP            DamageEffectHP;
    local X2Effect_ApplyDamageWithRank          DamageEffectRank;
    local X2Effect_ApplyWeaponDamage            DamageEffect;

    if (SourceUnit != none)
    {
        iRank = SourceUnit.GetSoldierRank();
        if (SourceUnit.GetSoldierClassTemplate() != none)
            iMaxRank = SourceUnit.GetSoldierClassTemplate().GetMaxConfiguredRank();
    }

    DamageEffectHPRank = X2Effect_ApplyDamageFromHPWithRank(Effect);
    DamageEffectHP = X2Effect_ApplyDamageFromHP(Effect);
    DamageEffectRank = X2Effect_ApplyDamageWithRank(Effect);
    DamageEffect = X2Effect_ApplyWeaponDamage(Effect);
    if (DamageEffectHPRank != none)
    {
        if (bStrategy || TargetUnit == none)
        {
            DamageEffectHPRank.GetDamageBrackets(SourceUnit, none, iDamageLow, iDamageHigh, iDamageLowBase, iDamageHighBase);
            DamageEffectHPRank.GetDamagePrc(SourceUnit, none, fDamagePrc);
            if (iDamageLow != 0 || iDamageHigh != 0 || DamageEffectHPRank.fBaseDmgPerRank != 0)
            {
                bNeedsPlus = true;
                if (iDamageLow < iDamageHigh)
                    OutString $= ColorText_Auto(iDamageLow $ " - " $ iDamageHigh,, SourceUnit);
                else
                    OutString $= ColorText_Auto(iDamageLow,, SourceUnit);
                
                if (bStrategy && DamageEffectHPRank.fBaseDmgPerRank > 0 && iRank < iMaxRank)
                {
                    if (iDamageLowBase < iDamageHighBase)
                        OutString $= ColorText_Grey(" (" $ iDamageLowBase $ "-" $ iDamageHighBase
                            $ " + " $  TruncateFloat(DamageEffectHPRank.fBaseDmgPerRank)
                            $ " " $ `GetLocalizedString("M31_PerRank") $ ")");
                    else
                        OutString $= ColorText_Grey(" (" $ iDamageLowBase
                            $ " + " $  TruncateFloat(DamageEffectHPRank.fBaseDmgPerRank)
                            $ " " $ `GetLocalizedString("M31_PerRank") $ ")");
                }
            }
            if (fDamagePrc != 0 || DamageEffectHPRank.fPrcDmgPerRank != 0)
            {
                if (bNeedsPlus)
                    OutString $= " + ";

                OutString $= ColorText_Auto(TruncateFloat(fDamagePrc) $ "%",, SourceUnit);
                if (bStrategy && DamageEffectHPRank.fPrcDmgPerRank > 0 && iRank < iMaxRank)
                {
                    OutString $= ColorText_Grey(" (" $ DamageEffectHPRank.fPrcDmg $ "%"
                        $ " + " $  TruncateFloat(DamageEffectHPRank.fPrcDmgPerRank) $ "% "
                        $ `GetLocalizedString("M31_PerRank") $ ")");
                }
            }
        }
        else
        {
            DamageEffectHPRank.GetDamageBrackets(SourceUnit, TargetUnit, iDamageLow, iDamageHigh);
            iDamageLow = Min(iDamageLow, DamageEffectHPRank.iMinDamage);
            iDamageHigh = Min(iDamageHigh, DamageEffectHPRank.iMinDamage);
            
            if (iDamageLow < iDamageHigh)
                OutString $= ColorText_Auto(iDamageLow $ " - " $ iDamageHigh,, SourceUnit);
            else
                OutString $= ColorText_Auto(iDamageLow,, SourceUnit);
        }
        return true;
    }
    else if (DamageEffectHP != none)
    {
        if (bStrategy || TargetUnit == none)
        {
            DamageEffectHP.GetDamageBrackets(SourceUnit, none, iDamageLow, iDamageHigh);
            fDamagePrc = DamageEffectHP.fPrcDmg;
            if (iDamageLow != 0 || iDamageHigh != 0)
            {
                bNeedsPlus = true;
                if (iDamageLow < iDamageHigh)
                    OutString $= ColorText_Auto(iDamageLow $ " - " $ iDamageHigh,, SourceUnit);
                else
                    OutString $= ColorText_Auto(iDamageLow,, SourceUnit);
            }
            if (fDamagePrc != 0)
            {
                if (bNeedsPlus)
                    OutString $= " + ";

                OutString $= ColorText_Auto(TruncateFloat(fDamagePrc) $ "%",, SourceUnit);
            }
        }
        else
        {
            DamageEffectHP.GetDamageBrackets(SourceUnit, TargetUnit, iDamageLow, iDamageHigh);
            iDamageLow = Min(iDamageLow, DamageEffectHPRank.iMinDamage);
            iDamageHigh = Min(iDamageHigh, DamageEffectHPRank.iMinDamage);
            if (iDamageLow < iDamageHigh)
                OutString $= ColorText_Auto(iDamageLow $ " - " $ iDamageHigh,, SourceUnit);
            else
                OutString $= ColorText_Auto(iDamageLow,, SourceUnit);
        }
        return true;
    }
    else if (DamageEffectRank != none)
    {

        DamageEffectRank.GetDamageBrackets(SourceUnit, iDamageLow, iDamageHigh, iDamageLowBase, iDamageHighBase);
        if (iDamageLow != 0 || iDamageHigh != 0 || DamageEffectRank.fDamagePerRank != 0)
        {
            if (iDamageLow < iDamageHigh)
                OutString $= ColorText_Auto(iDamageLow $ " - " $ iDamageHigh,, SourceUnit);
            else
                OutString $= ColorText_Auto(iDamageLow,, SourceUnit);
            
            if (bStrategy && DamageEffectRank.fDamagePerRank != 0 && iRank < iMaxRank)
            {
                if (iDamageLowBase < iDamageHighBase)
                    OutString $= ColorText_Grey(" (" $ iDamageLowBase $ "-" $ iDamageHighBase $ " + " $  TruncateFloat(DamageEffectRank.fDamagePerRank)
                        $ " " $ `GetLocalizedString("M31_PerRank") $ ")");
                else
                    OutString $= ColorText_Grey(" (" $ iDamageLowBase $ " + " $  TruncateFloat(DamageEffectRank.fDamagePerRank)
                        $ " " $ `GetLocalizedString("M31_PerRank") $ ")");
            }
            return true;
        }
        else
        {
            return false;
        }
    }
    else if (DamageEffect != none)
    {
        Damage = DamageEffect.EffectDamageValue;
        iDamageLow = Damage.Damage - Damage.Spread + (Damage.PlusOne == 100 ? 1 : 0);
        iDamageHigh = Damage.Damage + Damage.Spread + (Damage.PlusOne > 0 ? 1 : 0);
        if (iDamageLow < iDamageHigh)
            OutString $= ColorText_Auto(iDamageLow $ " - " $ iDamageHigh,, SourceUnit);
        else
            OutString $= ColorText_Auto(iDamageLow,, SourceUnit);
        return true;
    }
    return false;
}


// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: apply HTML hex color to a string. 
// Tip: hex color codes can be acquired at https://htmlcolorcodes.com/

static private function string ColorText_Auto(coerce string strInput, optional bool bOpen = false, optional XComGameState_Unit SourceUnit = none)
{
    local name ClassName;
    local int Index;

    if (SourceUnit != none)
    {
        ClassName = SourceUnit.GetSoldierClassTemplateName();

        for (Index = 0; Index < default.SpecialColors.Length; Index++)
            if (default.SpecialColors[Index].ClassName == ClassName)
                break;

        if (Index < default.SpecialColors.Length)
            return ColorText_Internal(default.SpecialColors[Index].strColor, strInput, bOpen);
    }

    return ColorText_Internal(default.DefaultSpecialColor, strInput, bOpen);
}

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

static private function string ColorText_Cyan(coerce string strInput, optional bool bOpen = false)
{
    // #00ffff
    return ColorText_Internal("#00ffff", strInput, bOpen);
}

static private function string ColorText_Green(coerce string strInput, optional bool bOpen = false)
{
    // #3ccc2f
    return ColorText_Internal("#3ccc2f", strInput, bOpen);
}

static private function string ColorText_LightSeaGreen(coerce string strInput, optional bool bOpen = false)
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
    // DefaultSpecialColor = "#ffd700"
}

