class XCGS_Effect_PA_TaipanVengeance extends XComGameState_Effect;

struct ToHitBonusInfo
{
    var int TargetObjectID;
    var int AimBonus;
    var int CritBonus;
};

var array<ToHitBonusInfo> arrToHitBonuses;

function AddToHitBonus(int TargetObjectID, int AimBonus, int CritBonus)
{
    local int Index;
    local ToHitBonusInfo NewBonusInfo;

    Index = arrToHitBonuses.Find('TargetObjectID', TargetObjectID);
    if (Index != INDEX_NONE)
    {
        arrToHitBonuses[Index].AimBonus += AimBonus;
        arrToHitBonuses[Index].CritBonus += CritBonus;
    }
    else
    {
        NewBonusInfo.TargetObjectID = TargetObjectID;
        NewBonusInfo.AimBonus = AimBonus;
        NewBonusInfo.CritBonus = CritBonus;
        arrToHitBonuses.AddItem(NewBonusInfo);
    }

    LogCurrentBonuses();
}

function bool GetToHitBonus(int TargetObjectID, out int AimBonus, out int CritBonus)
{
    local int Index;

    LogCurrentBonuses();

    Index = arrToHitBonuses.Find('TargetObjectID', TargetObjectID);
    if (Index != INDEX_NONE)
    {
        `LOG("Found target: " $ TargetObjectID);
        AimBonus = arrToHitBonuses[Index].AimBonus;
        CritBonus = arrToHitBonuses[Index].CritBonus;
        return true;
    }

    return false;
}

function LogCurrentBonuses()
{
    local ToHitBonusInfo Info; 
    foreach arrToHitBonuses(Info)
    {
        `LOG(Info.TargetObjectID $ " - " $ Info.AimBonus $ " - " $ Info.CritBonus, class'X2Effect_PA_TaipanVengeance'.default.bLog, 'XCGS_Effect_PA_TaipanVengeance');
    }
}