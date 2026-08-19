interface ShieldInterface dependson(XGS_ShieldHandler);

function ShieldsTakeDamage(
    int DamageTaken,
    const out ShieldEffectData CurrentShieldData,
    XComGameState_Effect kNewEffectState,
    XComGameState_Unit kTargetUnitState,
    XComGameState NewGameState
);

function bool OverrideShouldRemoveEffect();

function bool ShouldRemoveEffect(
    int DamageTaken,
    const out ShieldEffectData CurrentShieldData,
    XComGameState_Effect kNewEffectState,
    XComGameState_Unit kTargetUnitState,
    XComGameState NewGameState
);

function int GetShieldPriority();

function bool RemoveWhenDepleted();

function bool CanBeHandled();