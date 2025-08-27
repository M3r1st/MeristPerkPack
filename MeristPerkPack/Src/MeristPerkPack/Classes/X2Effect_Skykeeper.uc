class X2Effect_Skykeeper extends X2Effect_Persistent;

var bool bMatchSourceWeapon;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    // local XComWorldData World;
    local ShotModifierInfo ShotInfo;
    local int AimBonus;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    // World = `XWORLD;

    // if (Target.UnitSize > 1 || !World.IsFloorTile(Target.TileLocation))
    if (Target.UnitSize > 1 || Target.GetMyTemplate().bCanUse_eTraversal_Flying)
        AimBonus = `GetConfigInt("M31_Skykeeper_AimBonus_NoCover") + `GetConfigInt("M31_Skykeeper_AimBonus_Flying");
    else if (!Target.CanTakeCover())
        AimBonus = `GetConfigInt("M31_Skykeeper_AimBonus_NoCover");

    if (AimBonus != 0)
    {
        ShotInfo.ModType = eHit_Success;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = AimBonus;
        ShotModifiers.AddItem(ShotInfo);
    }
}