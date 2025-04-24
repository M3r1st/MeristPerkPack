class X2Effect_WS_BoltBonus extends X2Effect_Persistent;

protected function bool IsSourceWeaponBallista(const XComGameState_Ability AbilityState)
{
    local name ItemTemplateName;

    if (AbilityState == none)
        return false;

    ItemTemplateName = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID)).GetMyTemplateName();

    return class'X2AbilitySet_WinterSentinel'.default.Ballista_Categories.Find(ItemTemplateName) != INDEX_NONE;
}