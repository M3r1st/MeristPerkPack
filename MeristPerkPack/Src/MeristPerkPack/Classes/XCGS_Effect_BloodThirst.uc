class XCGS_Effect_BloodThirst extends XComGameState_Effect;

var array<int> arrStacksRemaining;

final function int GetTotalStacksRemaining()
{
    local X2Effect_BloodThirst BloodThirstEffect;
    local int Index;
    local int Count;

    BloodThirstEffect = X2Effect_BloodThirst(GetX2Effect());
    for (Index = 0; Index < BloodThirstEffect.iMaxStacks; Index++)
    {
        Count += arrStacksRemaining[Index];
    }
    return Count;
}