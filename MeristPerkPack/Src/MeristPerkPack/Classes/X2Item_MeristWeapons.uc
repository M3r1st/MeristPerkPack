class X2Item_MeristWeapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue Zombie_M1_Damage;
var config WeaponDamageValue Zombie_M2_Damage;
var config WeaponDamageValue Zombie_M3_Damage;

var config WeaponDamageValue EnhZombie_M1_Damage;
var config WeaponDamageValue EnhZombie_M2_Damage;
var config WeaponDamageValue EnhZombie_M3_Damage;

var config WeaponDamageValue Lancer_M1_Damage;
var config WeaponDamageValue Lancer_M2_Damage;
var config WeaponDamageValue Lancer_M3_Damage;

var config WeaponDamageValue EnhLancer_M1_Damage;
var config WeaponDamageValue EnhLancer_M2_Damage;
var config WeaponDamageValue EnhLancer_M3_Damage;

var config WeaponDamageValue Creature_M1_Damage;
var config WeaponDamageValue Creature_M2_Damage;
var config WeaponDamageValue Creature_M3_Damage;

var config WeaponDamageValue EnhCreature_M1_Damage;
var config WeaponDamageValue EnhCreature_M2_Damage;
var config WeaponDamageValue EnhCreature_M3_Damage;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Weapons;

    Weapons.AddItem(CreateTemplate_SpectralZombie_MeleeAttack('M31_SpectralZombie_M1_Melee', default.Zombie_M1_Damage));
    Weapons.AddItem(CreateTemplate_SpectralZombie_MeleeAttack('M31_SpectralZombie_M2_Melee', default.Zombie_M2_Damage));
    Weapons.AddItem(CreateTemplate_SpectralZombie_MeleeAttack('M31_SpectralZombie_M3_Melee', default.Zombie_M3_Damage));

    Weapons.AddItem(CreateTemplate_SpectralZombie_MeleeAttack('M31_EnhSpectralZombie_M1_Melee', default.EnhZombie_M1_Damage, true));
    Weapons.AddItem(CreateTemplate_SpectralZombie_MeleeAttack('M31_EnhSpectralZombie_M2_Melee', default.EnhZombie_M2_Damage, true));
    Weapons.AddItem(CreateTemplate_SpectralZombie_MeleeAttack('M31_EnhSpectralZombie_M3_Melee', default.EnhZombie_M3_Damage, true));


    Weapons.AddItem(CreateTemplate_SpectralLancer_FakeRifle('M31_SpectralLancer_FakeRifle'));

    Weapons.AddItem(CreateTemplate_SpectralLancer_MeleeAttack('M31_SpectralLancer_M1_Melee', default.Lancer_M1_Damage));
    Weapons.AddItem(CreateTemplate_SpectralLancer_MeleeAttack('M31_SpectralLancer_M2_Melee', default.Lancer_M2_Damage));
    Weapons.AddItem(CreateTemplate_SpectralLancer_MeleeAttack('M31_SpectralLancer_M3_Melee', default.Lancer_M3_Damage));

    Weapons.AddItem(CreateTemplate_SpectralLancer_MeleeAttack('M31_EnhSpectralLancer_M1_Melee', default.EnhLancer_M1_Damage, true));
    Weapons.AddItem(CreateTemplate_SpectralLancer_MeleeAttack('M31_EnhSpectralLancer_M2_Melee', default.EnhLancer_M2_Damage, true));
    Weapons.AddItem(CreateTemplate_SpectralLancer_MeleeAttack('M31_EnhSpectralLancer_M3_Melee', default.EnhLancer_M3_Damage, true));


    Weapons.AddItem(CreateTemplate_SpectralCreature_MeleeAttack('M31_SpectralCreature_M1_Melee', default.Creature_M1_Damage));
    Weapons.AddItem(CreateTemplate_SpectralCreature_MeleeAttack('M31_SpectralCreature_M2_Melee', default.Creature_M2_Damage));
    Weapons.AddItem(CreateTemplate_SpectralCreature_MeleeAttack('M31_SpectralCreature_M3_Melee', default.Creature_M3_Damage));

    Weapons.AddItem(CreateTemplate_SpectralCreature_MeleeAttack('M31_EnhSpectralCreature_M1_Melee', default.EnhCreature_M1_Damage, true));
    Weapons.AddItem(CreateTemplate_SpectralCreature_MeleeAttack('M31_EnhSpectralCreature_M2_Melee', default.EnhCreature_M2_Damage, true));
    Weapons.AddItem(CreateTemplate_SpectralCreature_MeleeAttack('M31_EnhSpectralCreature_M3_Melee', default.EnhCreature_M3_Damage, true));
    
    return Weapons;
}

static function X2DataTemplate CreateTemplate_SpectralZombie_MeleeAttack(name DataName, WeaponDamageValue WeaponBaseDamage, optional bool bImproved = false)
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);
    
    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'melee';
    Template.WeaponTech = 'alien';
    Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
    Template.InventorySlot = eInvSlot_PrimaryWeapon;
    Template.StowedLocation = eSlot_RightHand;
    Template.GameArchetype = "WP_Zombiefist.WP_Zombiefist";
    Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

    Template.iRange = 2;
    Template.iRadius = 1;
    Template.NumUpgradeSlots = 0;
    Template.InfiniteAmmo = true;
    Template.iPhysicsImpulse = 5;
    Template.iIdealRange = 1;

    Template.BaseDamage = WeaponBaseDamage;
    Template.BaseDamage.DamageType = 'Melee';
    Template.iSoundRange = 2;
    Template.iEnvironmentDamage = 0;

    Template.StartingItem = false;
    Template.CanBeBuilt = false;

    Template.bDisplayWeaponAndAmmo = false;

    if (bImproved)
    {
        Template.Abilities.AddItem('SwordSlice');
    }
    else
    {
        Template.Abilities.AddItem('StandardMelee');
    }

    return Template;
}

static function X2DataTemplate CreateTemplate_SpectralLancer_FakeRifle(name DataName)
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'rifle';
    Template.WeaponTech = 'alien';
    Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
    Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

    Template.InventorySlot = eInvSlot_PrimaryWeapon;

    Template.bDisplayWeaponAndAmmo = false;
    
    Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";

    Template.iPhysicsImpulse = 5;

    Template.CanBeBuilt = false;
    Template.TradingPostValue = 0;

    Template.DamageTypeTemplateName = 'Projectile_Conventional';

    return Template;
}

static function X2DataTemplate CreateTemplate_SpectralLancer_MeleeAttack(name DataName, WeaponDamageValue WeaponBaseDamage, optional bool bImproved = false)
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);
    Template.WeaponPanelImage = "_ConventionalRifle";

    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'baton';
    Template.WeaponTech = 'alien';
    Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagSword";
    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_RightBack;
    // Template.GameArchetype = "WP_Adv_StunLancer.WP_StunLance";
    Template.GameArchetype = "DLC60_WP_HunterAxe_BM.WP_HunterAxe_BM";
    Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

    Template.iRange = 1;
    Template.iRadius = 1;
    Template.NumUpgradeSlots = 0;
    Template.InfiniteAmmo = true;
    Template.iPhysicsImpulse = 5;
    Template.iIdealRange = 1;

    Template.BaseDamage = WeaponBaseDamage;
    Template.BaseDamage.DamageType = 'Melee';
    Template.iSoundRange = 2;
    Template.iEnvironmentDamage = 0;

    Template.StartingItem = false;
    Template.CanBeBuilt = false;

    Template.Abilities.AddItem('SwordSlice');
    
    if (bImproved)
    {
        Template.Abilities.AddItem('Whirlwind2');
    }

    return Template;
}

static function X2DataTemplate CreateTemplate_SpectralCreature_MeleeAttack(name DataName, WeaponDamageValue WeaponBaseDamage, optional bool bImproved = false)
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'melee';
    Template.WeaponTech = 'alien';
    Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
    Template.InventorySlot = eInvSlot_PrimaryWeapon;
    Template.StowedLocation = eSlot_RightHand;
    Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

    Template.iRange = 1;
    Template.iRadius = 1;
    Template.NumUpgradeSlots = 0;
    Template.InfiniteAmmo = true;
    Template.iPhysicsImpulse = 5;
    Template.iIdealRange = 1;

    Template.BaseDamage = WeaponBaseDamage;
    Template.BaseDamage.DamageType = 'Melee';
    Template.iSoundRange = 2;
    Template.iEnvironmentDamage = 0;

    //Build Data
    Template.StartingItem = false;
    Template.CanBeBuilt = false;

    Template.bDisplayWeaponAndAmmo = false;

    Template.Abilities.AddItem('M31_ENEMY_LightningClaw');

    return Template;
}