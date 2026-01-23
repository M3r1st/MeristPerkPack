class X2TargetingMethod_MeleePath_RushAndBind extends X2TargetingMethod_MeleePath;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    local XComPresentationLayer Pres;

    super(X2TargetingMethod).Init(InAction, NewTargetIndex);

    Pres = `PRES;

    Cursor = `CURSOR;
    PathingPawn = Cursor.Spawn(class'X2PathingPawn_RushAndBind', Cursor);
    PathingPawn.SetVisible(true);
    PathingPawn.Init(UnitState, Ability, self);
    IconManager = Pres.GetActionIconMgr();
    LevelBorderManager = Pres.GetLevelBorderMgr();

    // force the initial updates
    IconManager.ShowIcons(true);
    LevelBorderManager.ShowBorder(true);
    IconManager.UpdateCursorLocation(true);
    LevelBorderManager.UpdateCursorLocation(Cursor.Location, true);

    DirectSelectNearestTarget();
}