class X2Effect_WS_BoltToHitBonus extends X2Effect_Persistent;

struct BoltToHitBonusInfo
{
    var name AbilityName;
    var int AimBonus;
    var int CritBonus;
};

var array<BoltToHitBonusInfo> Bonuses;
var array<BoltToHitBonusInfo> BallistaBonuses;

function AddBonus(name _AbilityName, int _AimBonus, int _CritBonus)
{
    local BoltToHitBonusInfo NewBonus;

    NewBonus.AbilityName = _AbilityName;
    NewBonus.AimBonus = _AimBonus;
    NewBonus.CritBonus = _CritBonus;

    Bonuses.AddItem(NewBonus);
}

function AddBallistaBonus(name _AbilityName, int _AimBonus, int _CritBonus)
{
    local BoltToHitBonusInfo NewBonus;

    NewBonus.AbilityName = _AbilityName;
    NewBonus.AimBonus = _AimBonus;
    NewBonus.CritBonus = _CritBonus;

    BallistaBonuses.AddItem(NewBonus);
}

function GetToHitModifiers(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    XComGameState_Unit Target,
    XComGameState_Ability AbilityState,
    class<X2AbilityToHitCalc> ToHitType,
    bool bMelee,
    bool bFlanking,
    bool bIndirectFire,
    out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    local int Index;

    if (class'X2Effect_WS_ApplyBoltDamage'.static.IsSourceWeaponBallista(AbilityState))
    {
        `LOG("BallistaBonuses.Length = " $ BallistaBonuses.Length, true, 'X2Effect_WS_BoltToHitBonus');
        Index = BallistaBonuses.Find('AbilityName', AbilityState.GetMyTemplateName());
        if (Index != INDEX_NONE)
        {
            if (BallistaBonuses[Index].AimBonus != 0)
            {
                AimInfo.ModType = eHit_Success;
                AimInfo.Reason = AbilityState.GetMyFriendlyName();
                AimInfo.Value = BallistaBonuses[Index].AimBonus;
                ShotModifiers.AddItem(AimInfo);
            }
            if (BallistaBonuses[Index].CritBonus != 0)
            {
                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = AbilityState.GetMyFriendlyName();
                CritInfo.Value = BallistaBonuses[Index].CritBonus;
                ShotModifiers.AddItem(CritInfo);
            }
        }
    }
    else
    {
        Index = Bonuses.Find('AbilityName', AbilityState.GetMyTemplateName());
        if (Index != INDEX_NONE)
        {
            if (Bonuses[Index].AimBonus != 0)
            {
                AimInfo.ModType = eHit_Success;
                AimInfo.Reason = AbilityState.GetMyFriendlyName();
                AimInfo.Value = Bonuses[Index].AimBonus;
                ShotModifiers.AddItem(AimInfo);
            }
            if (Bonuses[Index].CritBonus != 0)
            {
                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = AbilityState.GetMyFriendlyName();
                CritInfo.Value = Bonuses[Index].CritBonus;
                ShotModifiers.AddItem(CritInfo);
            }
        }
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
}