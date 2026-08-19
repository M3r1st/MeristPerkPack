class X2AbilityCooldown_Extended extends X2AbilityCooldown;

struct CooldownModifierInfo
{
    var name RequiredAbility;
    var int Modifier;
    var bool bRemoveCooldown;
};

var array<CooldownModifierInfo> CooldownModifiers;

var bool bApplyOnlyOnHit;

var array<int> NumTurnsFromTech;
var EInventorySlot SpecificSlot;

function AddCooldownModifier(name RequiredAbility, optional int Modifier, optional bool bRemoveCooldown)
{
    local CooldownModifierInfo CooldownModifier;
    CooldownModifier.RequiredAbility = RequiredAbility;
    CooldownModifier.Modifier = Modifier;
    CooldownModifier.bRemoveCooldown = bRemoveCooldown;
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
    local XComGameState_Unit    SourceUnit;
    local XComGameState_Item    SourceItem;
    local CooldownModifierInfo  CooldownModifier;
    local int                   Cooldown;
    local int                   Tech;

    SourceUnit = XComGameState_Unit(AffectState);

    Cooldown = iNumTurns;

    if (NumTurnsFromTech.Length > 0)
    {
        if (SpecificSlot != eInvSlot_Unknown)
            SourceItem = SourceUnit.GetItemInSlot(SpecificSlot);
        else
            SourceItem = AffectWeapon;

        if (SourceItem != none)
        {
            Tech = `GetTechLevel(SourceItem.GetMyTemplate());
            Tech = Clamp(Tech, 0, NumTurnsFromTech.Length - 1);
            Cooldown = NumTurnsFromTech[Tech];
        }
    }

    if (SourceUnit != none)
    {
        foreach CooldownModifiers(CooldownModifier)
        {
            if (SourceUnit.HasSoldierAbility(CooldownModifier.RequiredAbility, true))
            {
                if (CooldownModifier.bRemoveCooldown)
                {
                    Cooldown = 0;
                    break;
                }
                else
                {
                    Cooldown = Max(0, Cooldown + CooldownModifier.Modifier);
                }
            }
        }
    }

    return Cooldown;
}