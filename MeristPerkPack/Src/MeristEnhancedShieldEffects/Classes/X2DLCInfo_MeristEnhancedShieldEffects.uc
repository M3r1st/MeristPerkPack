class X2DLCInfo_MeristEnhancedShieldEffects extends X2DownloadableContentInfo;

var config bool bLog;

// Add the shield Handler ability to all appropriate character templates.
static event OnPostTemplatesCreated()
{
    local X2CharacterTemplateManager    CharacterTemplateManager;
    local X2CharacterTemplate           CharTemplate;
    local array<X2DataTemplate>         DataTemplates;
    local X2DataTemplate                Template, DiffTemplate;
    local bool bLoggedTemplate;

    CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    foreach CharacterTemplateManager.IterateTemplates(Template, none)
    {
        bLoggedTemplate = !default.bLog;
        CharacterTemplateManager.FindDataTemplateAllDifficulties(Template.DataName, DataTemplates);
        foreach DataTemplates(DiffTemplate)
        {
            CharTemplate = X2CharacterTemplate(DiffTemplate);
            if (CharTemplate != none)
            {
                `Log("Adding shield handler ability to <" $ CharTemplate.DataName $ ">", !bLoggedTemplate, 'MeristEnhancedShieldEffects');
                CharTemplate.Abilities.InsertItem(0, class'X2Ability_EnergyShieldHandler'.default.ShieldHandlerAbilityName);
                bLoggedTemplate = true;
            }
        }
    }
}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
    local XCGS_Effect_EnergyShieldExtended EffectState;

    switch (InString)
    {
        case "M31_ShieldRemaining":
            EffectState = XCGS_Effect_EnergyShieldExtended(ParseObj);
            OutString = string(EffectState.ShieldRemaining);
            return true;

        case "M31_ShieldPriority":
            EffectState = XCGS_Effect_EnergyShieldExtended(ParseObj);
            OutString = string(EffectState.ShieldPriority);
            return true;
    }

    return false;
}

static function int GetShieldAmountPreview(Object ParseObj, Object StrategyParseObj, XComGameState GameState,
    optional bool bCheckShooterEffects = true, optional bool bCheckTargetEffects = true, optional bool bCheckMultiTargetEffects = true)
{
    local XComGameState_Effect  EffectState;
    local XComGameState_Ability AbilityState;
    local X2AbilityTemplate     AbilityTemplate;
    local X2Effect_EnergyShieldExtended ShieldEffect;
    local int i;

    EffectState = XComGameState_Effect(ParseObj);
    AbilityState = XComGameState_Ability(ParseObj);
    AbilityTemplate = X2AbilityTemplate(ParseObj);

    if (EffectState != none)
    {
        AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
    }
    if (AbilityState != none)
    {
        AbilityTemplate = AbilityState.GetMyTemplate();
    }

    if (AbilityTemplate != none)
    {
        if (bCheckShooterEffects)
        {
            for (i = 0; i < AbilityTemplate.AbilityShooterEffects.Length; i++)
            {
                ShieldEffect = X2Effect_EnergyShieldExtended(AbilityTemplate.AbilityShooterEffects[i]);
                if (ShieldEffect != none)
                {
                    return ShieldEffect.GetShieldAmountPreview(AbilityState);
                }
            }
        }

        if (bCheckTargetEffects)
        {
            for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; i++)
            {
                ShieldEffect = X2Effect_EnergyShieldExtended(AbilityTemplate.AbilityTargetEffects[i]);
                if (ShieldEffect != none)
                {
                    return ShieldEffect.GetShieldAmountPreview(AbilityState);
                }
            }
        }

        if (bCheckMultiTargetEffects)
        {
            for (i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; i++)
            {
                ShieldEffect = X2Effect_EnergyShieldExtended(AbilityTemplate.AbilityMultiTargetEffects[i]);
                if (ShieldEffect != none)
                {
                    return ShieldEffect.GetShieldAmountPreview(AbilityState);
                }
            }
        }
    }

    return 0;
}