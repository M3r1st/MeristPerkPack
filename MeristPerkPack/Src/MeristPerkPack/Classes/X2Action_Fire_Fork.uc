//---------------------------------------------------------------------------------------
//  FILE:    X2Action_Fire_Fork.uc
//  AUTHOR:  Merist
//  PURPOSE: A version of X2Action_Fire_Arc that uses Dijkstra's
//           algorithm to notify additional targets
//---------------------------------------------------------------------------------------
class X2Action_Fire_Fork extends X2Action_Fire;

var string ParticleSystemName;
var name StartingSocket;
var name TargetSocket;
var float ChainDelay;

struct TargetNode
{
    var int TargetID;
    var Vector vTargetLocation;
    var bool bIsHit;
    var float fTentativeCost;
    var int iPrevNode;
    var int iDepth;

    structdefaultproperties
    {
        fTentativeCost = 100000000
        iPrevNode = -1
    }
};

struct TetherNode
{
    var ParticleSystemComponent TetherSpawned;
    var int SourceIndex;
    var int TargetIndex;
};

var array<TargetNode> Targets;
var array<int> OpenSet;

var int TargetsHit;
var int TargetsNotified;

var ParticleSystem ArcTether;
var array<TetherNode> Tethers;
var int MultiTargetIndex;
var bool StartChain;
var int CurrentDepth, NodeIndex;

var AnimNodeSequence PlayingSequence;

var name AnimName;

function Init()
{
    local TargetNode NewNode, EmptyNode;
    local int i;

    super.Init();

    ArcTether = ParticleSystem(DynamicLoadObject(ParticleSystemName, class'ParticleSystem'));

    NewNode = EmptyNode;
    NewNode.TargetID = AbilityContext.InputContext.PrimaryTarget.ObjectID;
    NewNode.bIsHit = AbilityContext.IsResultContextHit();
    NewNode.vTargetLocation = History.GetVisualizer(NewNode.TargetID).Location;
    Targets.AddItem(NewNode);

    for (i = 0; i < AbilityContext.InputContext.MultiTargets.Length; i++)
    {
        NewNode = EmptyNode;
        NewNode.TargetID = AbilityContext.InputContext.MultiTargets[i].ObjectID;
        NewNode.bIsHit = AbilityContext.IsResultContextMultiHit(i);
        NewNode.vTargetLocation = History.GetVisualizer(NewNode.TargetID).Location;
        Targets.AddItem(NewNode);
    }
    BuildTargetPath();
    TargetsNotified = 0;
}

function NotifyTargetsAbilityApplied()
{
    StartChain = true;
}

function BuildTargetPath()
{
    local int i;
    local int iCurrentNode;
    local int iMinIdx;
    local float fNewCost;

    // 1: all nodes have a tentative cost of infinity, except for our initial node
    Targets[0].fTentativeCost = 0.0;
    TargetsHit = 1;

    // 2. mark all other nodes as unvisited ("open set")
    // unless we never want to visit them anyway
    for (i = 1; i < Targets.Length; i++)
    {
        if (Targets[i].bIsHit)
        {
            OpenSet.AddItem(i);
            TargetsHit++;
        }
    }

    iCurrentNode = 0;
    while (OpenSet.Length > 0)
    {
        iMinIdx = INDEX_NONE;
        // 3. for all unvisited neighbors of the current node (everything is a neighbor!)
        for (i = 0; i < OpenSet.Length; i++)
        {
            // update the tentative cost
            fNewCost = Targets[iCurrentNode].fTentativeCost
                + VSizeSq(Targets[OpenSet[i]].vTargetLocation - Targets[iCurrentNode].vTargetLocation) * (Targets[iCurrentNode].bIsHit ? 0.01 : 1.00);
            if (fNewCost < Targets[OpenSet[i]].fTentativeCost)
            {
                Targets[OpenSet[i]].fTentativeCost = fNewCost;
                // remember the path
                Targets[OpenSet[i]].iPrevNode = iCurrentNode;
                Targets[OpenSet[i]].iDepth = Targets[iCurrentNode].iDepth + 1;
            }
            // find the nearest node
            if (iMinIdx == INDEX_NONE || Targets[OpenSet[i]].fTentativeCost < Targets[iMinIdx].fTentativeCost)
            {
                iMinIdx = OpenSet[i];
            }
        }
        // 4. mark as visited and set a new node
        iCurrentNode = iMinIdx;
        OpenSet.RemoveItem(iCurrentNode);
    }
    // 5. OpenSet is empty. all nodes have been visited
}

function HandleSingleTarget(int ObjectID, int TargetObjectID, name StartSocket, name EndSocket)
{
    local TetherNode NewTether, EmptyTether;
    local XComUnitPawn FirstTethered, SecondTethered;
    local int TetherIndex;
    local Vector Origin, Delta;

    if (ObjectID > 0 && TargetObjectID > 0)
    {
        FirstTethered = XGUnit(History.GetVisualizer(ObjectID)).GetPawn();
        SecondTethered = XGUnit(History.GetVisualizer(TargetObjectID)).GetPawn();
        if (ArcTether != none && FirstTethered != none && SecondTethered != none)
        {
            // Spawn then immediately update its location/rotation to be correct
            NewTether = EmptyTether;
            NewTether.TetherSpawned = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ArcTether, Vect(0,0,0), Rotator(Vect(0,0,0)));
            NewTether.SourceIndex = ObjectID;
            NewTether.TargetIndex = TargetObjectID;
            TetherIndex = Tethers.AddItem(NewTether);

            UpdateSingleTether(TetherIndex, StartSocket, EndSocket, Origin, Delta);

            `XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', History.GetGameStateForObjectID(TargetObjectID), self);

            NotifyInterveningStateObjects(Origin, Delta);

            TargetsNotified++;
        }
    }
}

function NotifyInterveningStateObjects(Vector Origin, Vector Delta)
{
    local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
    local XComGameState_InteractiveObject InteractiveObject;
    local XComInteractiveLevelActor InteractiveLevelActor;
    local Vector StateObjectDelta;
    local float DistFromDelta;

    // find all the environmental damage that are within half a tile of the arc segment
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
    {
        StateObjectDelta = Normal(EnvironmentDamageEvent.HitLocation - Origin);
        DistFromDelta = VSize(StateObjectDelta - ProjectOnTo( StateObjectDelta, Delta));

        if(DistFromDelta < (class'XComWorldData'.const.WORLD_StepSize / 2))
        {
            `XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
        }
    }

    // find all the interactive objects that are within half a tile of the arc segment
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
    {
        InteractiveLevelActor = XComInteractiveLevelActor(History.GetVisualizer(InteractiveObject.ObjectID));
        StateObjectDelta = Normal(InteractiveLevelActor.Location - Origin);
        DistFromDelta = VSize(StateObjectDelta - ProjectOnTo(StateObjectDelta, Delta));

        if (DistFromDelta < (class'XComWorldData'.const.WORLD_StepSize / 2))
        {
            `XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);
        }
    }
}


function UpdateSingleTether(int TetherIndex, name StartSocket, name EndSocket, optional out Vector Origin, optional out Vector Delta)
{
    local XComUnitPawn FirstTethered, SecondTethered;
    local Vector FirstLocation, SecondLocation;
    local Vector FirstToSecond;
    local float DistanceBetween;
    local Vector DistanceBetweenVector;

    // FirstTethered = XGUnit(History.GetVisualizer(UnitsTethered[TetherIndex])).GetPawn();
    // SecondTethered = XGUnit(History.GetVisualizer(UnitsTethered[TetherIndex + 1])).GetPawn();

    FirstTethered = XGUnit(History.GetVisualizer(Tethers[TetherIndex].SourceIndex)).GetPawn();
    SecondTethered = XGUnit(History.GetVisualizer(Tethers[TetherIndex].TargetIndex)).GetPawn();

    FirstTethered.Mesh.GetSocketWorldLocationAndRotation(StartSocket, FirstLocation);
    SecondTethered.Mesh.GetSocketWorldLocationAndRotation(EndSocket, SecondLocation);
    FirstToSecond = SecondLocation - FirstLocation;
    DistanceBetween = VSize(FirstToSecond);
    FirstToSecond = Normal(FirstToSecond);

    Tethers[TetherIndex].TetherSpawned.SetAbsolute(true, true);
    Tethers[TetherIndex].TetherSpawned.SetTranslation(FirstLocation);
    Tethers[TetherIndex].TetherSpawned.SetRotation(Rotator(FirstToSecond));

    DistanceBetweenVector.X = DistanceBetween;
    DistanceBetweenVector.Y = DistanceBetween;
    DistanceBetweenVector.Z = DistanceBetween;
    Tethers[TetherIndex].TetherSpawned.SetVectorParameter('Distance', DistanceBetweenVector);
    Tethers[TetherIndex].TetherSpawned.SetFloatParameter('Distance', DistanceBetween);

    Origin = FirstLocation;
    Delta = SecondLocation - FirstLocation;
}

simulated state Executing
{
    simulated event Tick(float fDeltaT)
    {
        local int TetherIndex;

        super.Tick(fDeltaT);

        // Loop through our tethers and update the distance parameter and their location/rotation
        for (TetherIndex = 0; TetherIndex < Tethers.Length; TetherIndex++)
        {
            UpdateSingleTether(TetherIndex, (Tethers[TetherIndex].SourceIndex == UnitPawn.ObjectID ? StartingSocket : TargetSocket), TargetSocket);
        }
    }
Begin:
    UnitPawn.EnableRMA(true, true);
    UnitPawn.EnableRMAInteractPhysics(true);
    
    AnimParams.AnimName = AnimName;
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
        CurrentDepth = 0;
        while (TargetsNotified < TargetsHit && CurrentDepth < 30)
        {
            CurrentDepth++;
            Sleep(ChainDelay);
            for (NodeIndex = 1; NodeIndex < Targets.Length; NodeIndex++)
            {
                if (Targets[NodeIndex].bIsHit && Targets[NodeIndex].iDepth == CurrentDepth)
                {
                    HandleSingleTarget(Targets[Targets[NodeIndex].iPrevNode].TargetID, Targets[NodeIndex].TargetID, TargetSocket, TargetSocket);
                }
            }
        }
    }

    FinishAnim(PlayingSequence);

    CompleteAction();
}

defaultproperties
{
    bNotifyMultiTargetsAtOnce = false

    ParticleSystemName = "FX_Templar_Volt.P_Volt_Tether"
    StartingSocket = R_Hand
    TargetSocket = FX_CHEST
    ChainDelay = 0.25
}
