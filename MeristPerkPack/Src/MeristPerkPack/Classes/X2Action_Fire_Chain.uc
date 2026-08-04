class X2Action_Fire_Chain extends X2Action_Fire_Arc;

var config bool bUseCustomFireAnim;
var config bool bUseCustomSelfFireAnim;

simulated state Executing
{
Begin:
    UnitPawn.EnableRMA(true, true);
    UnitPawn.EnableRMAInteractPhysics(true);

    if (bUseCustomFireAnim && AbilityTemplate.CustomFireAnim != '')
    {
        AnimParams.AnimName = AbilityTemplate.CustomFireAnim;
    }
    else if (bUseCustomSelfFireAnim && AbilityTemplate.CustomSelfFireAnim != '')
    {
        AnimParams.AnimName = AbilityTemplate.CustomSelfFireAnim;
    }
    else
    {
        AnimParams.AnimName = AnimName;
    }

    if (bComingFromEndMove)
    {
        AnimParams.DesiredEndingAtoms.Add(1);
        AnimParams.DesiredEndingAtoms[0].Translation = MoveEndDestination;
        AnimParams.DesiredEndingAtoms[0].Translation.Z = Unit.GetDesiredZForLocation(MoveEndDestination);
        AnimParams.DesiredEndingAtoms[0].Rotation = QuatFromRotator(Rotator(MoveEndDirection));
        AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;

        Unit.RestoreLocation = AnimParams.DesiredEndingAtoms[0].Translation;
        Unit.RestoreHeading = Vector(QuatToRotator(AnimParams.DesiredEndingAtoms[0].Rotation));
    }
    PlayingSequence = UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams);

    while (!StartChain && !IsTimedOut())
    {
        Sleep(0.0f);
    }

    HandleSingleTarget(UnitPawn.ObjectID, PrimaryTargetID, StartingSocket, TargetSocket);
    if (AbilityContext.InputContext.MultiTargets.Length != 0)
    {
        Sleep(ChainDelay);
        HandleSingleTarget(PrimaryTargetID, AbilityContext.InputContext.MultiTargets[0].ObjectID, TargetSocket, TargetSocket);
        for (MultiTargetIndex = 0; MultiTargetIndex < AbilityContext.InputContext.MultiTargets.Length - 1; MultiTargetIndex++)
        {
            Sleep(ChainDelay);

            HandleSingleTarget(AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID, AbilityContext.InputContext.MultiTargets[MultiTargetIndex + 1].ObjectID, TargetSocket, TargetSocket);
        }
    }

    FinishAnim(PlayingSequence);

    CompleteAction();
}
