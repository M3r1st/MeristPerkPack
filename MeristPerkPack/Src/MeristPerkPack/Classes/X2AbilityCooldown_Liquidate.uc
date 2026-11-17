class X2AbilityCooldown_Liquidate extends X2AbilityCooldown_Extended;

var int iNumTurnsOnKill;

simulated function int GetBaseNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    local XComGameStateHistory History;
    local XComGameStateContext_Ability AbilityContext;
    local XComGameState_Unit TargetUnit, OldTargetState;

    if (NewGameState != none)
    {
        AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
        if (AbilityContext != none)
        {
            History = `XCOMHISTORY;
            TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
            if (TargetUnit != none)
            {
                OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID,, NewGameState.HistoryIndex - 1));
                if (OldTargetState != none && OldTargetState.IsAlive() && TargetUnit.IsDead())
                {
                    return iNumTurnsOnKill;
                }
            }
        }
    }

    return super.GetBaseNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);
}