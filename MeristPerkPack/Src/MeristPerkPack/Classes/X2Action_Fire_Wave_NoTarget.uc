class X2Action_Fire_Wave_NoTarget extends X2Action_Fire_Wave;

function NotifyTargetsAbilityApplied()
{
    local int MultiTargetIndex;
    local XComGameState_InteractiveObject InteractiveObject;
    local Actor CurrentActor;
    local XComGameState_EnvironmentDamage EnvironmentDamageEvent;

    // CurrentActor = `XCOMHISTORY.GetVisualizer(PrimaryTargetID);
    // if( CurrentActor != None )
    // {
    //     AddTimer(PrimaryTargetID, CurrentActor.Location);
    // }

    for( MultiTargetIndex = 0; MultiTargetIndex < AbilityContext.InputContext.MultiTargets.length; ++MultiTargetIndex )
    {
        CurrentActor = `XCOMHISTORY.GetVisualizer(AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID);
        if( CurrentActor != None )
        {
            AddTimer(AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID, CurrentActor.Location);
        }
    }

    // find all the interactive objects that are within half a tile of the arc segment
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
    {
        CurrentActor = `XCOMHISTORY.GetVisualizer(InteractiveObject.ObjectID);
        if( CurrentActor != None )
        {
            AddTimer(InteractiveObject.ObjectID, CurrentActor.Location);
        }
    }

    // find all the environmental damage that are within half a tile of the arc segment
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
    {
        AddTimer(EnvironmentDamageEvent.ObjectID, EnvironmentDamageEvent.HitLocation);
    }

    WaveTime = 0;
    // Jwats: Make sure we don't timeout before sending all our events
    if( TimersOrder.Length != 0 )
    {
        TimeoutSeconds += TimersOrder[TimersOrder.Length - 1];
    }
}