class X2Effect_HunkerDown_LW extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo			VisInfo;
    local ShotModifierInfo						ShotInfo;

	if (Target != none)
	{
		if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
		{
			// && !AbilityState.IsMeleeAbility() // If we want to make dash melee not affected, add this to the below if.
			if (Target.CanTakeCover() && (VisInfo.TargetCover == CT_Midlevel || VisInfo.TargetCover == CT_Standing))
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = -1 * (class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DEFENSE);
				ShotModifiers.AddItem(ShotInfo);

				ShotInfo.ModType = eHit_Graze;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DODGE;
				ShotModifiers.AddItem(ShotInfo);
			}
		}
	}
}

static function X2Effect_HunkerDown_LW HunkerDownEffect()
{
	local X2Effect_HunkerDown_LW		HunkerDownEffect;

	HunkerDownEffect = new class 'X2Effect_HunkerDown_LW';
	HunkerDownEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

	return HunkerDownEffect;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Refresh           //  if you keep using hunker down, just extend the lifetime of the effect
	EffectName = "HunkerDown"
}