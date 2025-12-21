//---------------------------------------------------------------------------------------
//  FILE:    XCGS_Effect_BloodThirst.uc
//  AUTHOR:  Merist
//  PURPOSE: Tracks the amount of stacks for X2Effect_BloodThirst.
//---------------------------------------------------------------------------------------
class XCGS_Effect_BloodThirst extends XComGameState_Effect;

var array<int> arrStacksRemaining;
var int iStacksThisTurn;

function int GetTotalStacksRemaining()
{
    local X2Effect_BloodThirst  Effect;
    local XComGameState_Unit    UnitState;
    local int Index;
    local int Count;

    Effect = X2Effect_BloodThirst(GetX2Effect());
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (Effect != none)
    {
        for (Index = 0; Index < Effect.GetStackDuration(UnitState); Index++)
        {
            Count += arrStacksRemaining[Index];
        }
    }

    return Count;
}

function AddStacks(int NumStacks = 1, optional XComGameState_Unit TargetUnit)
{
    local X2Effect_BloodThirst  Effect;
    local XComGameState_Unit    UnitState;
    local int                   Length;
    local int                   Count;
    local int                   MaxCount;
    local int                   MaxCountPerTurn;
    local int                   Index, i;

    Effect = X2Effect_BloodThirst(GetX2Effect());

    UnitState = TargetUnit;
    if (UnitState != none)
    {
        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    }

    Length = Effect.GetStackDuration(UnitState);
    MaxCount = Effect.GetMaxStackCount(UnitState);
    MaxCountPerTurn = Effect.GetMaxStackCountPerTurn(UnitState);
    Count = GetTotalStacksRemaining();

    for (i = 0; i < NumStacks && (MaxCountPerTurn <= 0 || iStacksThisTurn < MaxCountPerTurn); i++)
    {
        if (MaxCount > 0 && Count >= MaxCount)
        {
            for (Index = 0; Index < Length; Index++)
            {
                if (arrStacksRemaining[Index] > 0)
                {
                    arrStacksRemaining[Index] -= 1;
                    break;
                }
            }
        }

        if (Effect.bRefreshDuration)
        {
            for (Index = 0; Index < Length - 1; Index++)
            {
                arrStacksRemaining[Length - 1] = arrStacksRemaining[Length - 1] + arrStacksRemaining[Index];
                arrStacksRemaining[Index] = 0;
            }
        }

        iStacksThisTurn += 1;
        arrStacksRemaining[Length - 1] = arrStacksRemaining[Length - 1] + 1;
    }
}