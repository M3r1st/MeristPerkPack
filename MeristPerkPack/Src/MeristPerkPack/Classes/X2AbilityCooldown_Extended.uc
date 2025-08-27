class X2AbilityCooldown_Extended extends X2AbilityCooldown;

struct CooldownModifierInfo
{
    var name RequiredAbility;
    var int Modifier;
    var bool bRemoveCooldown;
};

var array<CooldownModifierInfo> CooldownModifiers;

var() bool    bApplyOnlyOnHit;

function AddCooldownModifier(name RequiredAbility, int Modifier)
{
    local CooldownModifierInfo CooldownModifier;
    CooldownModifier.RequiredAbility = RequiredAbility;
    CooldownModifier.Modifier = Modifier;
    CooldownModifiers.AddItem(CooldownModifier);
}

function AddAdditionalCooldownInfo(name AbilityName, optional int NumTurns, optional bool bUseAbilityCooldownNumTurns, optional name ApplyCooldownType = 'AdditionalCooldown_ApplyLarger')
{
    local AdditionalCooldownInfo CooldownInfo;

    CooldownInfo.AbilityName = AbilityName;
    CooldownInfo.NumTurns = NumTurns;
    CooldownInfo.bUseAbilityCooldownNumTurns = bUseAbilityCooldownNumTurns;
    CooldownInfo.ApplyCooldownType = ApplyCooldownType;

    AditionalAbilityCooldowns.AddItem(CooldownInfo);
}

simulated function ApplyCooldown(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    local XComGameStateContext_Ability AbilityContext;

    if (`CHEATMGR != none && `CHEATMGR.strAIForcedAbility ~= string(kAbility.GetMyTemplateName()))
        iNumTurns = 0;

    AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

    if (AbilityContext != none)
    {
        if (bDoNotApplyOnHit && AbilityContext.IsResultContextHit())
            return;

        if (bApplyOnlyOnHit && AbilityContext.IsResultContextMiss())
            return;
    }

    kAbility.iCooldown = GetNumTurns(kAbility, AffectState, AffectWeapon, NewGameState);

    ApplyAdditionalCooldown(kAbility, AffectState, AffectWeapon, NewGameState);
}

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    local XComGameState_Unit    Unit;
    local CooldownModifierInfo  CooldownModifier;
    local int x;

    Unit = XComGameState_Unit(AffectState);

    x = iNumTurns;
    if (Unit != none)
    {
        foreach CooldownModifiers(CooldownModifier)
        {
            if (Unit.HasSoldierAbility(CooldownModifier.RequiredAbility, true))
            {
                if (CooldownModifier.bRemoveCooldown)
                {
                    x = 0;
                    break;
                }
                else
                {
                    x = Max(0, x + CooldownModifier.Modifier);
                }
            }
        }
    }

    return x;
}