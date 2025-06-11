// This is an Unreal Script
class X2Effect_Radiation extends X2Effect_Burning;

var privatewrite name RadBurningEffectAddedEventName;
var privatewrite name RadBleedingEffectAddedEventName;
var privatewrite name RadDisorientedEffectAddedEventName;
var privatewrite name LostRadRegenEffectApplied;

DefaultProperties
{
    RadBurningEffectAddedEventName="RadBurningEffectAdded"
    RadBleedingEffectAddedEventName="RadBleedingEffectAdded"
    RadDisorientedEffectAddedEventName="RadDisorientedEffectAdded"
    LostRadRegenEffectApplied="LostRadRegenEffectApplied"
}