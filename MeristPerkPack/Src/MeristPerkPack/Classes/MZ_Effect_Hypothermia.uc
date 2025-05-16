class MZ_Effect_Hypothermia extends X2Effect_Persistent config(MZBitterfrost);

var privatewrite name HyptothermiaEffectAddedEventName;
var config bool Hypothermia_Ignores_Shield, Hypothermia_Ignores_Armour;
var config int Damage, TierDamage, Spread;

var localized string HypothermiaEffectName, HypothermiaEffectDesc;

static function MZ_Effect_Hypothermia CreateHypothermiaEffect(int Turns) //, int DamagePerTick, int DamageSpreadPerTick)
{
    local MZ_Effect_Hypothermia BurningEffect;
    local X2Condition_UnitProperty UnitPropCondition;

    BurningEffect = new class'MZ_Effect_Hypothermia';
    BurningEffect.BuildPersistentEffect(Turns,, false,,eGameRule_PlayerTurnBegin);
    BurningEffect.SetDisplayInfo(ePerkBuff_Penalty, default.HypothermiaEffectName, default.HypothermiaEffectDesc, "img:///UILibrary_DLC2Images.UIPerk_freezingbreath");
    BurningEffect.SetBurnDamage();
    BurningEffect.bRemoveWhenTargetDies = true;
    BurningEffect.DamageTypes.AddItem('Frost');
    BurningEffect.DuplicateResponse = eDupe_Refresh;
    BurningEffect.bCanTickEveryAction = true;
    BurningEffect.EffectAppliedEventName = default.HyptothermiaEffectAddedEventName;

    UnitPropCondition = new class'X2Condition_UnitProperty';
    UnitPropCondition.ExcludeFriendlyToSource = false;
    BurningEffect.TargetConditions.AddItem(UnitPropCondition);

    return BurningEffect;
}

simulated function SetBurnDamage()
{
    local MZ_Damage_Hypothermia BurnDamage;

    BurnDamage = new class'MZ_Damage_Hypothermia';
    BurnDamage.bAllowFreeKill = false;
    BurnDamage.bIgnoreArmor = default.Hypothermia_Ignores_Armour;
    BurnDamage.bBypassShields = default.Hypothermia_Ignores_Shield; //Issue #89

    BurnDamage.Damage = default.Damage;
    BurnDamage.TierDamage = default.TierDamage;
    BurnDamage.Spread = default.Spread;
    BurnDamage.EffectDamageValue.DamageType = 'Frost';
    BurnDamage.bIgnoreBaseDamage = true;
    BurnDamage.DamageTag = self.Name;

    ApplyOnTick.AddItem(BurnDamage);
}

DefaultProperties
{
    DuplicateResponse=eDupe_Refresh
    bCanTickEveryAction=true
    EffectName="MZHypothermia"

    HyptothermiaEffectAddedEventName="HypothermiaEffectAdded"
}