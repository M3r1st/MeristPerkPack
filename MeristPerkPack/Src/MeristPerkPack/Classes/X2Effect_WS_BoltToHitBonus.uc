class X2Effect_WS_BoltToHitBonus extends X2Effect_Persistent;

struct BoltToHitBonusInfo
{
    var name AbilityName;
    var int Aim;
    var int Crit;
    var bool bBallista;
};

var array<BoltToHitBonusInfo> ToHitBonuses;

function AddToHitBonus(name AbilityName, int Aim, int Crit, optional bool bBallista)
{
    local BoltToHitBonusInfo NewBonus;

    NewBonus.AbilityName = AbilityName;
    NewBonus.Aim = Aim;
    NewBonus.Crit = Crit;
    NewBonus.bBallista = bBallista;

    ToHitBonuses.AddItem(NewBonus);
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
    local BoltToHitBonusInfo BonusInfo;
    local bool bBallista;

    bBallista = class'X2Effect_WS_ApplyBoltDamage'.static.IsSourceWeaponBallista(AbilityState);

    foreach ToHitBonuses(BonusInfo)
    {
        if (AbilityState.GetMyTemplateName() == BonusInfo.AbilityName
            && (bBallista && BonusInfo.bBallista || !bBallista && !BonusInfo.bBallista))
        {
            if (BonusInfo.Aim != 0)
            {
                AimInfo.ModType = eHit_Success;
                AimInfo.Reason = FriendlyName;
                AimInfo.Value = BonusInfo.Aim;
                ShotModifiers.AddItem(AimInfo);
            }
            if (BonusInfo.Crit != 0)
            {
                CritInfo.ModType = eHit_Crit;
                CritInfo.Reason = FriendlyName;
                CritInfo.Value = BonusInfo.Crit;
                ShotModifiers.AddItem(CritInfo);
            }
        }
    }
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
}