//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MeristPinionsAttack extends X2Action_Fire config(GameData);

var config float MinProjectileTimeDelaySec;
var config float MaxProjectileTimeDelaySec;

// Cached info for the unit performing the action
// *************************************
var protected int   TargetIndex;
var protected float ProjectileTimeDelay;

var bool            ProjectileHit;
var XComWeapon      WeaponEntity;
// *************************************

function Init()
{
    super.Init();

    if (WeaponEntity == none)
    {
        GetPerkWeapon();
    }
}

function GetPerkWeapon()
{
    local array<XComPerkContent> ValidPerks;
    local XComWeapon Weapon;
    local XComGameState_Item SourceWeapon;
    local int i;

    class'XComPerkContent'.static.GetAssociatedPerkDefinitions(ValidPerks, UnitPawn, AbilityContext.InputContext.AbilityTemplateName);

    for (i = 0; i < ValidPerks.Length; ++i)
    {
        Weapon = ValidPerks[i].PerkSpecificWeapon;
        if (Weapon != none)
        {
            WeaponEntity = Weapon;
            return;
        }
    }

    if (AbilityContext.InputContext.ItemObject.ObjectID > 0)
    {
        SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
        Weapon = XGWeapon(SourceWeapon.GetVisualizer()).GetEntity();

        if (Weapon != none)
        {
            WeaponEntity = Weapon;
            return;
        }
    }
}

function bool CheckInterrupted()
{
    return false;
}

function NotifyTargetsAbilityApplied()
{
    super.NotifyTargetsAbilityApplied();
    ProjectileHit = true;
}

function AddProjectiles(int ProjectileIndex)
{
    local TTile         SourceTile;
    local XComWorldData World;
    local Vector        SourceLocation, ImpactLocation;
    local int ZValue;

    World = `XWORLD;

    // Move it above the top level of the world a bit with *2
    ZValue = World.WORLD_FloorHeightsPerLevel * World.WORLD_TotalLevels * 2;

    ImpactLocation = AbilityContext.InputContext.TargetLocations[ProjectileIndex];

    // Calculate the upper z position for the projectile
    SourceTile = World.GetTileCoordinatesFromPosition(ImpactLocation);
    
    World.GetFloorPositionForTile(SourceTile, ImpactLocation);

    SourceTile.Z = ZValue;
    SourceLocation = World.GetPositionFromTileCoordinates(SourceTile);

    AddPinionsProjectile(SourceLocation, ImpactLocation);
}

function AddPinionsProjectile(Vector SourceLocation, Vector ImpactLocation)
{
    local AnimNotify_FireWeaponVolley   FireVolleyNotify;
    local X2UnifiedProjectile           NewProjectile;

    //The archetypes for the projectiles come from the weapon entity archetype
    if (WeaponEntity != none)
    {
        FireVolleyNotify = new class'AnimNotify_FireWeaponVolley';
        FireVolleyNotify.NumShots = 1;
        FireVolleyNotify.ShotInterval = 0.3f;
        FireVolleyNotify.bCosmeticVolley = true;

        NewProjectile = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2UnifiedProjectile', , , , , WeaponEntity.DefaultProjectileTemplate);
        NewProjectile.ConfigureNewProjectileCosmetic(FireVolleyNotify, AbilityContext, , , Unit.CurrentFireAction, SourceLocation, ImpactLocation, true);
        NewProjectile.GotoState('Executing');
    }
}

simulated state Executing
{
Begin:
    Unit.CurrentFireAction = self;

    for (TargetIndex = 0; TargetIndex < AbilityContext.InputContext.TargetLocations.Length; TargetIndex++)
    {
        if (TargetIndex > 0)
        {
            ProjectileTimeDelay = MinProjectileTimeDelaySec + FRand() * (MaxProjectileTimeDelaySec - MinProjectileTimeDelaySec);
            Sleep(ProjectileTimeDelay * GetDelayModifier());
        }
        AddProjectiles(TargetIndex);
    }

    while (!ProjectileHit)
    {
        Sleep(0.01f);
    }

    Sleep(0.5f * GetDelayModifier()); // Sleep to allow destruction to be seen

    CompleteAction();
}
