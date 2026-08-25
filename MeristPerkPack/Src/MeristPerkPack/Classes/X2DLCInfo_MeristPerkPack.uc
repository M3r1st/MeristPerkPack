class X2DLCInfo_MeristPerkPack extends X2DownloadableContentInfo config(GameData_SoldierSkills);

struct ItemTech
{
    var name Tech;
    var int Tier;
};

var config array<ItemTech> GremlinTiers;
var config array<ItemTech> WeaponTiers;
var config array<ItemTech> ArmorTiers;

var privatewrite config array<name> CachedActiveMods;
var privatewrite config bool bLWOTC;

var config array<name> BoltCasterTemplates;
var config array<name> PistolCategories;
var config array<name> AttackGrenades;
var config array<name> SmokeGrenades;
var config array<name> GrenadeAbilities;
var config array<name> EMPGrenades;
var config array<name> EMPGrenades_AdditionalEffectsToRemove;

var config bool bUpdateTemplarShield;

struct ConditionalEarnedAbility
{
    var name RequiredAbility;
    var X2Condition_ValidWeapon WeaponCondition;
    var SoldierClassAbilityType AbilityToAdd;
    var bool bAllowDuplicate;
};

struct CanAddItemOverrideInfo
{
    struct CanAddItemOverrideWeaponCatInfo
    {
        var name WeaponCat;
        var EInventorySlot Slot;
    };

    var name AbilityName;
    var array<CanAddItemOverrideWeaponCatInfo> WeaponCategoriesToUnlock;
};

var privatewrite config array<ConditionalEarnedAbility> ConditionalEarnedAbilities;
var config array<CanAddItemOverrideInfo> arrCanAddItemOverride;

//=======================================================================================
//                                  CHL HOOKS
//---------------------------------------------------------------------------------------

static function ModifyEarnedSoldierAbilities(out array<SoldierClassAbilityType> EarnedAbilities, XComGameState_Unit UnitState)
{
    local ConditionalEarnedAbility  AbilityData;
    local int                       Index, i;
    local bool                      bDuplicate;

    foreach default.ConditionalEarnedAbilities(AbilityData)
    {
        bDuplicate = false;

        Index = EarnedAbilities.Find('AbilityName', AbilityData.RequiredAbility);
        if (Index != INDEX_NONE)
        {
            if (AbilityData.WeaponCondition != none)
            {
                if (!AbilityData.WeaponCondition.CanEverBeValid(UnitState, false))
                {
                    continue;
                }
            }

            if (AbilityData.bAllowDuplicate)
            {
                EarnedAbilities.AddItem(AbilityData.AbilityToAdd);
            }
            else
            {
                for (i = 0; i < EarnedAbilities.Length; i++)
                {
                    if (EarnedAbilities[i] == AbilityData.AbilityToAdd)
                    {
                        bDuplicate = true;
                        break;
                    }
                }
                if (!bDuplicate)
                {
                    EarnedAbilities.AddItem(AbilityData.AbilityToAdd);
                }
            }
        }
    }
}

static function AddConditionalEarnedAbility(name RequiredAbility, name AbilityName, EInventorySlot ApplyToWeaponSlot, optional X2Condition_ValidWeapon WeaponCondition, optional bool bAllowDuplicate)
{
    local ConditionalEarnedAbility NewAbilityData;

    NewAbilityData.RequiredAbility = RequiredAbility;
    NewAbilityData.AbilityToAdd.AbilityName = AbilityName;
    NewAbilityData.AbilityToAdd.ApplyToWeaponSlot = ApplyToWeaponSlot;
    NewAbilityData.WeaponCondition = WeaponCondition;
    NewAbilityData.bAllowDuplicate = bAllowDuplicate;

    default.ConditionalEarnedAbilities.AddItem(NewAbilityData);
}

static function bool CanAddItemToInventory_CH_Improved(
    out int bCanAddItem,
    const EInventorySlot Slot,
    const X2ItemTemplate ItemTemplate,
    int Quantity,
    XComGameState_Unit UnitState,
    optional XComGameState CheckGameState,
    optional out string DisabledReason,
    optional XComGameState_Item ItemState)
{
    local bool OverrideNormalBehavior;
    local bool DoNotOverrideNormalBehavior;

    OverrideNormalBehavior = CheckGameState != none;
    DoNotOverrideNormalBehavior = CheckGameState == none;

    if (DisabledReason != "")
        return DoNotOverrideNormalBehavior;

    if (CanAddItemOverrideCheck(UnitState, ItemState, Slot))
    {
        if (CheckGameState != none && UnitState.GetItemInSlot(Slot, CheckGameState) == none)
        {
            bCanAddItem = 1;
        }
        DisabledReason = "";
        return OverrideNormalBehavior;
    }
    
    return DoNotOverrideNormalBehavior;
}

static function bool CanAddItemOverrideCheck(XComGameState_Unit UnitState, XComGameState_Item ItemState, EInventorySlot Slot)
{
    local CanAddItemOverrideInfo            OverrideInfo;
    local CanAddItemOverrideWeaponCatInfo   OverrideWeaponCatInfo;
    local X2WeaponTemplate                  WeaponTemplate;

    WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());

    if (UnitState.GetSoldierClassTemplate().IsWeaponAllowedByClass_CH(WeaponTemplate, Slot))
        return false;

    foreach default.arrCanAddItemOverride(OverrideInfo)
    {
        if (UnitState.HasSoldierAbility(OverrideInfo.AbilityName, true))
        {
            foreach OverrideInfo.WeaponCategoriesToUnlock(OverrideWeaponCatInfo)
            {
                if (WeaponTemplate.WeaponCat == OverrideWeaponCatInfo.WeaponCat && Slot == OverrideWeaponCatInfo.Slot)
                {
                    return true;
                }
            }
        }
    }
    return false;
}

//=======================================================================================
//                              ABILITY HELPERS
//---------------------------------------------------------------------------------------

static function int GetTechLevel(X2ItemTemplate ItemTemplate)
{
    local X2GremlinTemplate     GremlinTemplate;
    local X2WeaponTemplate      WeaponTemplate;
    local X2ArmorTemplate       ArmorTemplate;
    local int Index;

    if (ItemTemplate != none)
    {
        GremlinTemplate = X2GremlinTemplate(ItemTemplate);
        WeaponTemplate = X2WeaponTemplate(ItemTemplate);
        ArmorTemplate = X2ArmorTemplate(ItemTemplate);

        if (GremlinTemplate != none)
        {
            Index = default.GremlinTiers.Find('Tech', GremlinTemplate.WeaponTech);
            if (Index != INDEX_NONE)
            {
                return default.GremlinTiers[Index].Tier;
            }
        }
        else if (WeaponTemplate != none)
        {
            Index = default.WeaponTiers.Find('Tech', WeaponTemplate.WeaponTech);
            if (Index != INDEX_NONE)
            {
                return default.WeaponTiers[Index].Tier;
            }
        }
        else if (ArmorTemplate != none)
        {
            Index = default.ArmorTiers.Find('Tech', ArmorTemplate.ArmorTechCat);
            if (Index != INDEX_NONE)
            {
                return default.ArmorTiers[Index].Tier;
            }
        }
    }

    return -1;
}

//=======================================================================================
//                                                                                       
//---------------------------------------------------------------------------------------

static function OnPreCreateTemplates()
{
    CacheActiveMods();
    default.bLWOTC = IsModActive('LongWarOfTheChosen');
}

//=======================================================================================
//                                      OPTC
//---------------------------------------------------------------------------------------

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager  AbilityMgr;
    local X2DataTemplate            IterateTemplate;
    local array<X2DataTemplate>     DataTemplates;
    local X2DataTemplate            DataTemplate;
    local X2AbilityTemplate         Template;


    AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach AbilityMgr.IterateTemplates(IterateTemplate)
    {
        if (!ClassIsChildOf(IterateTemplate.Class, class'X2AbilityTemplate')) continue;

        AbilityMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);

        foreach DataTemplates(DataTemplate)
        {
            Template = X2AbilityTemplate(DataTemplate);

            if (Template.DataName == 'CombatPresence')
            {
                PatchCombatPresence(Template);
            }

            if (Template.DataName == 'IRI_TemplarShield' && default.bUpdateTemplarShield)
            {
                PatchTemplarShield(Template);
            }

            if (Template.DataName == 'IRI_Rider_Guard')
            {
                PatchGuardForAutoGuard(Template);
            }

            if (class'X2AbilitySet_Gremlin'.default.Botnet_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddBotnetEffectToAbility(Template);
            }
            if (class'X2AbilitySet_Merist'.default.Aim_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddSharpshooterAimToAbility(Template);
            }
            if (class'X2AbilitySet_Merist'.default.SuppressingFire_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddSuppressingFireToAbility(Template);
            }
            if (class'X2AbilitySet_Merist'.default.ImprovedSuppression_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddImprovedSuppressionToAbility(Template);
            }
            if (class'X2AbilitySet_Merist'.default.TroubleShooter_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddTroubleShooterToAbility(Template);
            }
            if (class'X2AbilitySet_Merist'.default.MarauderElite_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddMarauderEliteToAbility(Template);
            }
            if (class'X2AbilitySet_Merist'.default.WatchfulEye_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddWatchfulEyeToAbility(Template);
            }
            if (class'X2AbilitySet_Gremlin'.default.AidProtocols.Find(Template.DataName) != INDEX_NONE)
            {
                AddAdditionalAidProtocolEffectsToAbility(Template);
            }
            if (class'X2AbilitySet_Gremlin'.default.OffensiveProtocols.Find(Template.DataName) != INDEX_NONE)
            {
                AddRapidDumpingToAbility(Template);
            }
            if (class'X2AbilitySet_Psionics'.default.LetItGo_AllowedAbilities.Find(Template.DataName) != INDEX_NONE)
            {
                AddLetItGoToAbility(Template);
            }
        }
    }

    AddEffectsToGrenades();
    AddModifiersToGrenadeAbilities();
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
    OrganicCondition.ExcludeFriendlyToSource = false;

    RobotCondition = new class'X2Condition_UnitProperty';
    RobotCondition.ExcludeRobotic = false;
    RobotCondition.ExcludeOrganic = true;
    RobotCondition.IncludeWeakAgainstTechLikeRobot = true;
    RobotCondition.ExcludeFriendlyToSource = false;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_ConcussiveGrenades');

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
    DisorientedEffect.bRemoveWhenSourceDies = false;
    DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

    RobotocDisorientedEffect = class'M31_Helpers'.static.CreateRoboticDisorientedStatusEffect();
    RobotocDisorientedEffect.bRemoveWhenSourceDies = false;
    RobotocDisorientedEffect.TargetConditions.AddItem(AbilityCondition);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(
        `GetConfigInt("M31_ConcussiveGrenades_StunDuration"), `GetConfigInt("M31_ConcussiveGrenades_StunChance"), false);
    StunnedEffect.bRemoveWhenSourceDies = false;
    StunnedEffect.TargetConditions.AddItem(AbilityCondition);

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

                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Effect_VileMix'.static.HarrierVileMixEffect());
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Effect_VileMix'.static.HarrierVileMixEffect());

                    if (default.EMPGrenades.Find(GrenadeTemplate.DataName) == INDEX_NONE)
                    {
                        GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2AbilitySet_Merist'.static.CreatePipeBombsBleedingEffect());
                        GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2AbilitySet_Merist'.static.CreatePipeBombsBleedingEffect());
                    }
                }
                if (default.SmokeGrenades.Find(GrenadeTemplate.DataName) != INDEX_NONE)
                {
                }
                if (class'X2AbilitySet_PA_WinterSentinel'.default.FrostGrenades.Find(GrenadeTemplate.DataName) != INDEX_NONE)
                {
                    GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2AbilitySet_PA_WinterSentinel'.static.GetChillingMistHypothermiaEffect());
                    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2AbilitySet_PA_WinterSentinel'.static.GetChillingMistHypothermiaEffect());
                }
                if (default.EMPGrenades.Find(GrenadeTemplate.DataName) != INDEX_NONE)
                {
                    AddEffectsToEMPGrenade(GrenadeTemplate);
                }
            }
        }
    }
}

static function AddEffectsToEMPGrenade(X2GrenadeTemplate GrenadeTemplate)
{
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_UnitProperty      OrganicCondition;
    local X2Condition_UnitImmunities    UnitImmunityCondition;

    local X2Effect_Persistent                   DisorientedEffect;
    local X2Effect_ApplyDamage_RequiredAbility  DamageEffect;
    local X2Effect_DisarmWeapon                 DisarmEffect;
    local X2Effect_RemoveEffects                RemoveEffects;

    OrganicCondition = new class'X2Condition_UnitProperty';
    OrganicCondition.ExcludeRobotic = true;
    OrganicCondition.ExcludeOrganic = false;
    OrganicCondition.IncludeWeakAgainstTechLikeRobot = false;
    OrganicCondition.ExcludeFriendlyToSource = false;

    UnitImmunityCondition = new class'X2Condition_UnitImmunities';
    UnitImmunityCondition.AddExcludeDamageType('Electrical');
    UnitImmunityCondition.bOnlyOnCharacterTemplate = false;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_StaticGrenades');

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
    DisorientedEffect.bRemoveWhenSourceDies = false;
    DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
    DisorientedEffect.TargetConditions.AddItem(OrganicCondition);
    DisorientedEffect.TargetConditions.AddItem(UnitImmunityCondition);

    DamageEffect = new class'X2Effect_ApplyDamage_RequiredAbility';
    DamageEffect.bIgnoreBaseDamage = true;
    DamageEffect.RequiredAbility = 'M31_StaticGrenades';
    DamageEffect.BonusDamageTag = 'M31_StaticGrenades';
    DamageEffect.TargetConditions.AddItem(AbilityCondition);
    DamageEffect.TargetConditions.AddItem(OrganicCondition);
    DamageEffect.TargetConditions.AddItem(UnitImmunityCondition);

    DisarmEffect = new class'X2Effect_DisarmWeapon';
    DisarmEffect.TargetConditions.AddItem(AbilityCondition);

    RemoveEffects = new class'X2Effect_RemoveEffects';
    RemoveEffects.EffectNamesToRemove = default.EMPGrenades_AdditionalEffectsToRemove;

    GrenadeTemplate.ThrownGrenadeEffects.AddItem(DisorientedEffect);
    GrenadeTemplate.ThrownGrenadeEffects.AddItem(DamageEffect);
    GrenadeTemplate.ThrownGrenadeEffects.AddItem(DisarmEffect);
    GrenadeTemplate.ThrownGrenadeEffects.AddItem(RemoveEffects);
    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(DisorientedEffect);
    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(DamageEffect);
    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(DisarmEffect);
    GrenadeTemplate.LaunchedGrenadeEffects.AddItem(RemoveEffects);

    switch (GrenadeTemplate.DataName)
    {
        case 'EMPGrenade':
            GrenadeTemplate.ExtraDamage.AddItem(`GetConfigDamage("M31_StaticGrenades_Mk1_Damage"));
            break;
        case 'EMPGrenadeMk2':
            GrenadeTemplate.ExtraDamage.AddItem(`GetConfigDamage("M31_StaticGrenades_Mk2_Damage"));
            break;
    }
}

static function AddModifiersToGrenadeAbilities()
{
    local X2AbilityTemplateManager      AbilityTemplateManager;
    local X2AbilityTemplate             AbilityTemplate;
    local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
    local name                          AbilityName;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach default.GrenadeAbilities(AbilityName)
    {
        AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
        if (AbilityTemplate != none)
        {
            RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityTemplate.AbilityMultiTargetStyle);
            if (RadiusMultiTarget != none)
            {
                RadiusMultiTarget.AddAbilityBonusRadius('M31_Warbringer', `GetConfigFloat("M31_Warbringer_RadiusBonus"));
            }
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

    HackDefenseEffect = class'M31_Helpers'.static.CreateHackDefenseReductionStatusEffect(
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
                ActionPointCost.AllowedTypes.AddItem(class'X2AbilitySet_Merist'.default.SuppressingFireActionPoint);
            }
        }

        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.EventID = 'M31_SuppressingFire_Suppress';
        Trigger.ListenerData.Filter = eFilter_Unit;
        Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
        Trigger.ListenerData.Priority = 70;
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
            RobotocDisorientedEffect = class'M31_Helpers'.static.CreateRoboticDisorientedStatusEffect();
            RobotocDisorientedEffect.TargetConditions.AddItem(AbilityCondition);
            Template.AddTargetEffect(RobotocDisorientedEffect);
        }
    }
}

static function AddTroubleShooterToAbility(X2AbilityTemplate Template)
{
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2Condition_AbilityProperty           AbilityCondition;
    local X2Effect_PersistentStatChange         HackDefenseEffect;
    
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeOrganic = true;
    UnitPropertyCondition.IncludeWeakAgainstTechLikeRobot = true;
    UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_TroubleShooter');

    HackDefenseEffect = class'M31_Helpers'.static.CreateHackDefenseReductionStatusEffect(
        'M31_TroubleShooter_HackEffect',
        `GetConfigInt("M31_TroubleShooter_HackDefenseReduction") * -1,
        UnitPropertyCondition);
        
    if (`GetConfigInt("M31_TroubleShooter_Duration") > 0)
        HackDefenseEffect.BuildPersistentEffect(`GetConfigInt("M31_TroubleShooter_Duration"), false, false, false, eGameRule_PlayerTurnBegin);
    HackDefenseEffect.DuplicateResponse = (`GetConfigBool("M31_TroubleShooter_bAllowStack") ? eDupe_Allow : eDupe_Refresh);
    HackDefenseEffect.TargetConditions.AddItem(AbilityCondition);

    Template.AddTargetEffect(HackDefenseEffect);
}

static function AddLetItGoToAbility(X2AbilityTemplate Template)
{
    local X2AbilityCost                 AbilityCost;
    local X2AbilityCost_ActionPoints    ActionPointCost;

    if (Template != none)
    {
        foreach Template.AbilityCosts(AbilityCost)
        {
            ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
            if (ActionPointCost != none)
            {
                ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_LetItGo');
            }
        }
    }
}

static function AddMarauderEliteToAbility(X2AbilityTemplate Template)
{
    local X2AbilityCost                 AbilityCost;
    local X2AbilityCost_ActionPoints    ActionPointCost;

    if (Template != none)
    {
        foreach Template.AbilityCosts(AbilityCost)
        {
            ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
            if (ActionPointCost != none)
            {
                ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('M31_MarauderElite');
            }
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

static function AddAdditionalAidProtocolEffectsToAbility(X2AbilityTemplate Template)
{
    if (Template != none)
    {
        if (Template.AbilityTargetStyle != none && Template.AbilityTargetEffects.Length > 0)
        {
            AddAdvancedAidToAbility(Template, false);
            AddTargetingAidToAbility(Template, false);
            AddShadowstepAidToAbility(Template, false);
        }
        if (Template.AbilityMultiTargetStyle != none && Template.AbilityMultiTargetEffects.Length > 0)
        {
            AddAdvancedAidToAbility(Template, true);
            AddTargetingAidToAbility(Template, true);
            AddShadowstepAidToAbility(Template, true);
        }
    }
}

static function AddAdvancedAidToAbility(X2AbilityTemplate Template, bool bAddToMultiTarget)
{
    local X2Effect_AdvancedAidProtocol  Effect;
    local X2Condition_AbilityProperty   AbilityCondition;
    if (Template != none)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_AdvancedAidProtocol');

        Effect = new class'X2Effect_AdvancedAidProtocol';
        Effect.EffectName = 'M31_AdvancedAid';
        Effect.DuplicateResponse = eDupe_Refresh;
        Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
        Effect.SetDisplayInfo(ePerkBuff_Bonus, `GetLocalizedString("M31_AdvancedAidProtocol_FriendlyName"), `GetLocalizedString("M31_AdvancedAidProtocol_BuffText"), "img:///UILibrary_MZChimeraIcons.Ability_ArmorSystem", true,, Template.AbilitySourceName);
        Effect.TargetConditions.AddItem(AbilityCondition);
        if (bAddToMultiTarget)
        {
            Template.AddMultiTargetEffect(Effect);
        }
        else
        {
            Template.AddTargetEffect(Effect);
        }
    }
}

static function AddTargetingAidToAbility(X2AbilityTemplate Template, bool bAddToMultiTarget)
{
    local X2Effect_TargetingAid         Effect;
    local X2Condition_AbilityProperty   AbilityCondition;

    if (Template != none)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem('M31_TargetingAid');

        Effect = new class'X2Effect_TargetingAid';
        Effect.EffectName = 'M31_TargetingAid';
        Effect.DuplicateResponse = eDupe_Refresh;
        Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
        Effect.SetDisplayInfo(ePerkBuff_Bonus, `GetLocalizedString("M31_TargetingAid_FriendlyName"), `GetLocalizedString("M31_TargetingAid_BuffText"), "img:///UILibrary_MZChimeraIcons.Ability_CombatProtocol", true,, Template.AbilitySourceName);
        Effect.TargetConditions.AddItem(AbilityCondition);
        if (bAddToMultiTarget)
        {
            Template.AddMultiTargetEffect(Effect);
        }
        else
        {
            Template.AddTargetEffect(Effect);
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

static function AddWatchfulEyeToAbility(X2AbilityTemplate Template)
{
    if (Template != none)
    {
        class'X2AbilitySet_Merist'.static.AddWatchfulEyeEffect(Template);
    }
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
                AnimSetEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
                AnimSetEffect.AddAnimSetWithPath("IRIParryReworkAnims.Anims.AS_BallisticShield");
                AnimSetEffect.AddAnimSetWithPath("IRIParryReworkAnims.Anims.AS_TemplarShield");
                Template.AbilityTargetEffects.InsertItem(i, AnimSetEffect);
            }
            else if (Template.AbilityTargetEffects[i].IsA('X2Effect_TemplarShield'))
            {
                Template.AbilityTargetEffects.Remove(i, 1);

                ShieldEffect = new class'X2Effect_MeristTemplarShield';
                ShieldEffect.ShieldPriority = 100;
                ShieldEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
                // ShieldEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
                Template.AbilityTargetEffects.InsertItem(i, ShieldEffect);
            }
        }
    }
}

static function PatchGuardForAutoGuard(X2AbilityTemplate Template)
{
    local X2AbilityTrigger_EventListener Trigger;

    if (Template != none)
    {
        Trigger = new class'X2AbilityTrigger_EventListener';
        Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
        Trigger.ListenerData.EventID = 'UnitGroupTurnBegun';
        Trigger.ListenerData.Filter = eFilter_None;
        Trigger.ListenerData.EventFn = class'X2Effect_Rider_AutoGuard'.static.AbilityTriggerEventListener_AutoGuard;
        Template.AbilityTriggers.AddItem(Trigger);
    }
}

//=======================================================================================
//                                  MOD HELPERS
//---------------------------------------------------------------------------------------

static final function CacheActiveMods()
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    default.CachedActiveMods.Length = 0;

    for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
    {
        default.CachedActiveMods.AddItem(EventManager.GetDLCNames(Index));
    }
}

static final function bool IsModActive(name ModName)
{
    return default.CachedActiveMods.Find(ModName) != INDEX_NONE;
}

static final function bool AreModsActive(const array<name> ModNames)
{
    local name ModName;

    foreach ModNames(ModName)
    {
        if (!IsModActive(ModName))
        {
            return false;
        }
    }
    return true;
}