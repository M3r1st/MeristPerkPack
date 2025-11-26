//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_Chain.uc
//  AUTHOR:  Merist
//  PURPOSE: A version of X2TargetingMethod_Volt that doesn't lock the camera
//           and marks the primary target
//---------------------------------------------------------------------------------------
class X2TargetingMethod_Chain extends X2TargetingMethod_Volt;

function DirectSetTarget(int TargetIndex)
{
    local XComGameStateHistory History;
    local array<Actor> TargetedActors;
    local int i;

    ClearTargetedActors();
    
    super(X2TargetingMethod_TopDown).DirectSetTarget(TargetIndex);

    if (Action.AvailableTargets[LastTarget].AdditionalTargets.Length > 0)
    {
        History = `XCOMHISTORY;
        TargetedActors.AddItem(History.GetVisualizer(Action.AvailableTargets[LastTarget].PrimaryTarget.ObjectID));
        for (i = 0; i < Action.AvailableTargets[LastTarget].AdditionalTargets.Length; ++i)
        {
            TargetedActors.AddItem(History.GetVisualizer(Action.AvailableTargets[LastTarget].AdditionalTargets[i].ObjectID));
        }
        MarkTargetedActors(TargetedActors);
    }
}

function Canceled()
{
    super(X2TargetingMethod).Canceled();
    if (LookatCamera != none)
    {
        `CAMERASTACK.RemoveCamera(LookatCamera);
    }
    ClearTargetedActors();
}

function Update(float DeltaTime)
{
    if (LookatCamera.HasArrived)
    {
        `CAMERASTACK.RemoveCamera(LookatCamera);
        LookatCamera = none;
    }
}