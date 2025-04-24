class X2DLCInfo_MeristEnhancedShieldEffects extends X2DownloadableContentInfo;

var privatewrite bool bLog;

// Add the shield interface ability to all appropriate character templates.
static event OnPostTemplatesCreated()
{
    local X2CharacterTemplateManager CharacterTemplateManager;
    local X2CharacterTemplate CharTemplate;
    local array<X2DataTemplate> DataTemplates;
    local X2DataTemplate Template, DiffTemplate;
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
                `Log("Adding shield interface ability to <" $ CharTemplate.DataName $ ">", !bLoggedTemplate, 'MeristEnhancedShieldEffects');
                CharTemplate.Abilities.AddItem(class'X2Ability_EnergyShieldInterface'.default.ShieldInterfaceAbilityName);
                bLoggedTemplate = true;
            }
        }
    }
}

defaultproperties
{
    bLog = false
}