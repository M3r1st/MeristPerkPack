class X2DLCInfo_MeristBuffMe extends X2DownloadableContentInfo;

var config bool bLog;

static event OnPostTemplatesCreated()
{
    local X2CharacterTemplateManager    CharacterTemplateManager;
    local X2CharacterTemplate           CharacterTemplate;
    local array<X2DataTemplate>         DataTemplates;
    local X2DataTemplate                Template, DiffTemplate;
    local bool                          bLoggedTemplate;

    CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    foreach CharacterTemplateManager.IterateTemplates(Template, none)
    {
        bLoggedTemplate = !default.bLog;
        CharacterTemplateManager.FindDataTemplateAllDifficulties(Template.DataName, DataTemplates);
        foreach DataTemplates(DiffTemplate)
        {
            CharacterTemplate = X2CharacterTemplate(DiffTemplate);
            if (Template != none)
            {
                `Log("Adding " $ class'X2Ability_BuffMe'.default.BuffMeAbilityName $ " to " $ CharacterTemplate.DataName, !bLoggedTemplate, 'BuffMe');
                CharacterTemplate.Abilities.AddItem(class'X2Ability_BuffMe'.default.BuffMeAbilityName);
                bLoggedTemplate = true;
            }
        }
    }
}