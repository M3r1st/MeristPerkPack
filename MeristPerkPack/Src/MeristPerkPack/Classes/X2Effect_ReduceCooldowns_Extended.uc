class X2Effect_ReduceCooldowns_Extended extends X2Effect_ReduceCooldowns;

var bool bMatchSourceWeapon;
var array<name> AbilitiesToExclude;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    UnitState;
    local StateObjectReference  AbilityRef;
    local XComGameState_Ability AbilityState;

    History = `XCOMHISTORY;

    UnitState = XComGameState_Unit(kNewTargetState);
    if (UnitState != none)
    {
        foreach UnitState.Abilities(AbilityRef)
        {
            AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

            if (AbilityState != none)
            {
                if (bMatchSourceWeapon && AbilityState.SourceWeapon != ApplyEffectParameters.ItemStateObjectRef)
                {
                    continue;
                }

                if (AbilityState.iCooldown <= 0)
                {
                    continue;
                }

                if (AbilitiesToTick.Length > 0 && AbilitiesToTick.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
                {
                    continue;
                }

                if (AbilitiesToExclude.Length > 0 && AbilitiesToTick.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
                {
                    continue;
                }

                AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
                AbilityState.iCooldown = ReduceAll ? 0 : Max(AbilityState.iCooldown - Amount, 0);
            }
        }
    }
}
