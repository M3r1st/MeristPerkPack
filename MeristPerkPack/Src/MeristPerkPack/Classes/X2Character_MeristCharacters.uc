class X2Character_MeristCharacters extends X2Character;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(SpectralZombie('M31_SpectralZombie_M1', 'M31_SpectralZombie_M1_Loadout'));
    Templates.AddItem(SpectralZombie('M31_SpectralZombie_M2', 'M31_SpectralZombie_M2_Loadout'));
    Templates.AddItem(SpectralZombie('M31_SpectralZombie_M3', 'M31_SpectralZombie_M3_Loadout'));

    Templates.AddItem(SpectralZombie('M31_EnhSpectralZombie_M1', 'M31_EnhSpectralZombie_M1_Loadout'));
    Templates.AddItem(SpectralZombie('M31_EnhSpectralZombie_M2', 'M31_EnhSpectralZombie_M2_Loadout'));
    Templates.AddItem(SpectralZombie('M31_EnhSpectralZombie_M3', 'M31_EnhSpectralZombie_M3_Loadout'));

    Templates.AddItem(SpectralLancer('M31_SpectralLancer_M1', 'M31_SpectralLancer_M1_Loadout'));
    Templates.AddItem(SpectralLancer('M31_SpectralLancer_M2', 'M31_SpectralLancer_M2_Loadout'));
    Templates.AddItem(SpectralLancer('M31_SpectralLancer_M3', 'M31_SpectralLancer_M3_Loadout'));

    Templates.AddItem(SpectralLancer('M31_EnhSpectralLancer_M1', 'M31_EnhSpectralLancer_M1_Loadout'));
    Templates.AddItem(SpectralLancer('M31_EnhSpectralLancer_M2', 'M31_EnhSpectralLancer_M2_Loadout'));
    Templates.AddItem(SpectralLancer('M31_EnhSpectralLancer_M3', 'M31_EnhSpectralLancer_M3_Loadout'));

    Templates.AddItem(SpectralCreature('M31_SpectralCreature_M1', 'M31_SpectralCreature_M1_Loadout'));
    Templates.AddItem(SpectralCreature('M31_SpectralCreature_M2', 'M31_SpectralCreature_M2_Loadout'));
    Templates.AddItem(SpectralCreature('M31_SpectralCreature_M3', 'M31_SpectralCreature_M3_Loadout'));

    Templates.AddItem(SpectralCreature('M31_EnhSpectralCreature_M1', 'M31_EnhSpectralCreature_M1_Loadout'));
    Templates.AddItem(SpectralCreature('M31_EnhSpectralCreature_M2', 'M31_EnhSpectralCreature_M2_Loadout'));
    Templates.AddItem(SpectralCreature('M31_EnhSpectralCreature_M3', 'M31_EnhSpectralCreature_M3_Loadout'));

    return Templates;
}

static function X2CharacterTemplate SpectralZombie(Name DataName, name LoadoutName)
{
    local X2CharacterTemplate CharTemplate;

    `CREATE_X2CHARACTER_TEMPLATE(CharTemplate, DataName);
    CharTemplate.CharacterGroupName = 'SpectralZombie';
    CharTemplate.DefaultLoadout = LoadoutName;
    CharTemplate.BehaviorClass = class'XGAIBehavior';
    CharTemplate.strPawnArchetypes.AddItem("Pawn_FrostDivision_FrostZombies.ARC_GameUnit_SpectralFrostZombie_M");
    CharTemplate.strPawnArchetypes.AddItem("Pawn_FrostDivision_FrostZombies.ARC_GameUnit_SpectralFrostZombie_F");
    // CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralZombie_M");
    // CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralZombie_F");

    CharTemplate.strMatineePackages.AddItem("CIN_Zombie");

    CharTemplate.UnitSize = 1;

    CharTemplate.bCanUse_eTraversal_Normal = true;
    CharTemplate.bCanUse_eTraversal_ClimbOver = true;
    CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
    CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
    CharTemplate.bCanUse_eTraversal_DropDown = true;
    CharTemplate.bCanUse_eTraversal_Grapple = false;
    CharTemplate.bCanUse_eTraversal_Landing = true;
    CharTemplate.bCanUse_eTraversal_BreakWindow = true;
    CharTemplate.bCanUse_eTraversal_KickDoor = true;
    CharTemplate.bCanUse_eTraversal_JumpUp = false;
    CharTemplate.bCanUse_eTraversal_WallClimb = false;
    CharTemplate.bCanUse_eTraversal_BreakWall = false;
    CharTemplate.bAppearanceDefinesPawn = false;    
    CharTemplate.bCanTakeCover = false;

    CharTemplate.bSkipDefaultAbilities = true;

    CharTemplate.bIsAlien = false;
    CharTemplate.bIsAdvent = false;
    CharTemplate.bIsCivilian = false;
    CharTemplate.bIsPsionic = false;
    CharTemplate.bIsRobotic = false;
    CharTemplate.bIsSoldier = false;
    CharTemplate.bIsMeleeOnly = true;

    CharTemplate.bCanBeTerrorist = false;
    CharTemplate.bCanBeCriticallyWounded = false;
    CharTemplate.bIsAfraidOfFire = true;
    
    CharTemplate.bAllowSpawnFromATT = false;

    CharTemplate.strScamperBT = "ScamperRoot_NoCover";

    CharTemplate.ImmuneTypes.AddItem('Mental');
    // CharTemplate.ImmuneTypes.AddItem('Fire');
    CharTemplate.ImmuneTypes.AddItem('Poison');
    CharTemplate.ImmuneTypes.AddItem('Stun');
    CharTemplate.ImmuneTypes.AddItem('Unconscious');
    CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
    CharTemplate.ImmuneTypes.AddItem('Acid');

    CharTemplate.Abilities.AddItem('StandardMove');

    CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

    return CharTemplate;
}

static function X2CharacterTemplate SpectralLancer(Name DataName, name LoadoutName)
{
    local X2CharacterTemplate CharTemplate;

    `CREATE_X2CHARACTER_TEMPLATE(CharTemplate, DataName);
    CharTemplate.CharacterGroupName = 'SpectralStunLancer';
    CharTemplate.DefaultLoadout = LoadoutName;
    CharTemplate.BehaviorClass = class'XGAIBehavior';
    CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralStunLancerM1_M");
    CharTemplate.strPawnArchetypes.AddItem("GameUnit_SpectralUnits.ARC_GameUnit_SpectralStunLancerM1_F");

    CharTemplate.strMatineePackages.AddItem("CIN_Advent");
    CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
    CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

    CharTemplate.UnitSize = 1;

    // Traversal Rules
    CharTemplate.bCanUse_eTraversal_Normal = true;
    CharTemplate.bCanUse_eTraversal_ClimbOver = true;
    CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
    CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
    CharTemplate.bCanUse_eTraversal_DropDown = true;
    CharTemplate.bCanUse_eTraversal_Grapple = false;
    CharTemplate.bCanUse_eTraversal_Landing = true;
    CharTemplate.bCanUse_eTraversal_BreakWindow = true;
    CharTemplate.bCanUse_eTraversal_KickDoor = true;
    CharTemplate.bCanUse_eTraversal_JumpUp = false;
    CharTemplate.bCanUse_eTraversal_WallClimb = false;
    CharTemplate.bCanUse_eTraversal_BreakWall = false;
    CharTemplate.bAppearanceDefinesPawn = false;
    CharTemplate.bSetGenderAlways = true;
    CharTemplate.bCanTakeCover = true;

    CharTemplate.bSkipDefaultAbilities = false;

    CharTemplate.bIsAlien = false;
    CharTemplate.bIsAdvent = true;
    CharTemplate.bIsCivilian = false;
    CharTemplate.bIsPsionic = false;
    CharTemplate.bIsRobotic = false;
    CharTemplate.bIsSoldier = false;

    CharTemplate.bAllowSpawnFromATT = false;

    CharTemplate.bCanBeTerrorist = false;
    CharTemplate.bCanBeCriticallyWounded = false;
    CharTemplate.bIsAfraidOfFire = true;

    CharTemplate.ImmuneTypes.AddItem('Mental');
    // CharTemplate.ImmuneTypes.AddItem('Fire');
    CharTemplate.ImmuneTypes.AddItem('Poison');
    CharTemplate.ImmuneTypes.AddItem('Stun');
    CharTemplate.ImmuneTypes.AddItem('Unconscious');
    CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
    CharTemplate.ImmuneTypes.AddItem('Acid');

    // CharTemplate.Abilities.AddItem('SpectralArmyUnitInitialize');
    CharTemplate.Abilities.AddItem('Shadowstep');
    CharTemplate.Abilities.AddItem('Infighter');

    CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
    CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

    return CharTemplate;
}

static function X2CharacterTemplate SpectralCreature(Name DataName, name LoadoutName, optional bool bImproved = false)
{
    local X2CharacterTemplate CharTemplate;

    `CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'NeonateChryssalid');
    CharTemplate.CharacterGroupName = 'SpectralChryssalid';
    CharTemplate.DefaultLoadout = LoadoutName;
    CharTemplate.BehaviorClass = class'XGAIBehavior';
    // CharTemplate.strPawnArchetypes.AddItem("GameUnit_AHWBugmancer.ARC_GameUnit_SpectralBug");
    CharTemplate.strPawnArchetypes.AddItem("GameUnit_NeonateChryssalid.ARC_GameUnit_NeonateChryssalid");

    CharTemplate.strMatineePackages.AddItem("CIN_Chryssalid");

    CharTemplate.UnitSize = 1;
    // Traversal Rules
    CharTemplate.bCanUse_eTraversal_Normal = true;
    CharTemplate.bCanUse_eTraversal_ClimbOver = true;
    CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
    CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
    CharTemplate.bCanUse_eTraversal_DropDown = true;
    CharTemplate.bCanUse_eTraversal_Grapple = false;
    CharTemplate.bCanUse_eTraversal_Landing = true;
    CharTemplate.bCanUse_eTraversal_BreakWindow = true;
    CharTemplate.bCanUse_eTraversal_KickDoor = true;
    CharTemplate.bCanUse_eTraversal_JumpUp = true;
    CharTemplate.bCanUse_eTraversal_WallClimb = false;
    CharTemplate.bCanUse_eTraversal_BreakWall = false;
    CharTemplate.bAppearanceDefinesPawn = false;
    CharTemplate.bCanTakeCover = false;

    CharTemplate.bIsAlien = true;
    CharTemplate.bIsAdvent = false;
    CharTemplate.bIsCivilian = false;
    CharTemplate.bIsPsionic = false;
    CharTemplate.bIsRobotic = false;
    CharTemplate.bIsSoldier = false;
    CharTemplate.bIsMeleeOnly = true;

    CharTemplate.bCanBeTerrorist = false;
    CharTemplate.bCanBeCriticallyWounded = false;
    CharTemplate.bIsAfraidOfFire = true;

    CharTemplate.bAllowSpawnFromATT = false;

    CharTemplate.strScamperBT = "ChryssalidScamperRoot";

    CharTemplate.ImmuneTypes.AddItem('Mental');
    // CharTemplate.ImmuneTypes.AddItem('Fire');
    CharTemplate.ImmuneTypes.AddItem('Poison');
    CharTemplate.ImmuneTypes.AddItem('Stun');
    CharTemplate.ImmuneTypes.AddItem('Unconscious');
    CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
    CharTemplate.ImmuneTypes.AddItem('Acid');

    CharTemplate.Abilities.AddItem('LightningReflexes_LW');
    CharTemplate.Abilities.AddItem('ZoneOfControl_LW');

    CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

    return CharTemplate;
}