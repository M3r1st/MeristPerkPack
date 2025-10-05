//---------------------------------------------------------------------------------------
//  FILE:    XCGS_Effect_BloodThirst.uc
//  AUTHOR:  Merist
//  PURPOSE: Tracks the amount of stacks for X2Effect_BloodThirst.
//---------------------------------------------------------------------------------------
class XCGS_Effect_BloodThirst extends XComGameState_Effect;

var array<int> arrStacksRemaining;
var int iStacksThisTurn;

final function int GetTotalStacksRemaining()
{
    local X2Effect_BloodThirst  BloodThirstEffect;
    local XComGameState_Unit    UnitState;
    local int Index;
    local int Count;

    BloodThirstEffect = X2Effect_BloodThirst(GetX2Effect());
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    
    if (BloodThirstEffect != none)
    {
        for (Index = 0; Index < BloodThirstEffect.GetStackDuration(UnitState); Index++)
        {
            Count += arrStacksRemaining[Index];
        }
    }

    return Count;
}
