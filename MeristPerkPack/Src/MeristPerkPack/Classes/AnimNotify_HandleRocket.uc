class AnimNotify_HandleRocket extends AnimNotify_Scripted;

var() editinline int AnimNotifyToInject;
var() editinline name AttachSocket;
var() editinline bool ForTakingRocket;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local XComAnimNotify_SpawnMesh	SpawnMeshNotify;
	local XComAnimNotify_ItemAttach	ItemAttachNotify;
	local XGUnitNativeBase			OwnerUnit;
	local XComUnitPawn				Pawn;
	local XComWeapon				Rocket;
	local XComGameState_Item		WeaponState;
	local XComGameState				GameState;
	local XComGameState_Unit		UnitState;
	local int						Ammo;
	local UnitValue					UV;

	Pawn = XComUnitPawn(Owner);
    if (Pawn != none)
    {	
		Rocket = XComWeapon(Pawn.Weapon);
		OwnerUnit = Pawn.GetGameUnit();
		UnitState = OwnerUnit.GetVisualizedGameState();
		GameState = UnitState.GetParentGameState();

		if (ForTakingRocket)
		{	
			if (UnitState.GetUnitValue('IRI_Rocket_Value', UV))
			{
				WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(int(UV.fValue)));	

				Rocket = XComWeapon(`CONTENT.RequestGameArchetype(X2WeaponTemplate(WeaponState.GetMyTemplate()).GameArchetype));
			}
		}
		else
		{	
			WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(Rocket.m_kGameWeapon.ObjectID));
			Ammo = WeaponState.Ammo;
			WeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponState.SoldierKitOwner.ObjectID));
		}

		if (WeaponState != none) 
		{
			if(Ammo > 0 || WeaponState.Nickname == "nosocket" || ForTakingRocket)
			{
				SpawnMeshNotify = new class'XComAnimNotify_SpawnMesh';
				SpawnMeshNotify.AttachSocket = AttachSocket; 
				SpawnMeshNotify.SkeletalMesh = SkeletalMeshComponent(Rocket.Mesh).SkeletalMesh;
				SpawnMeshNotify.bSpawn = true;
				AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = SpawnMeshNotify;	
			}
			else
			{
				ItemAttachNotify = new class'XComAnimNotify_ItemAttach';
				ItemAttachNotify.FromSocket = name(WeaponState.Nickname);
				ItemAttachNotify.ToSocket = AttachSocket; 
				AnimSeqInstigator.AnimSeq.Notifies[AnimNotifyToInject].Notify = ItemAttachNotify;	

				`LOG("Handle rocket: " @ WeaponState.GetMyTemplateName() @ ", nickname: " @ WeaponState.Nickname,, 'IRIROCK');

				if (!ForTakingRocket)
				{
					if (UnitState.RemoveItemFromInventory(WeaponState, GameState))
					{
						GameState.RemoveStateObject(WeaponState.ObjectID);
						WeaponState = UnitState.GetItemInSlot(WeaponState.InventorySlot);
					}
					else `redscreen("AnimNotify_HandleRocket -> could not remove cosmetic rocket from the soldier: " @ UnitState.GetFullName() @ ".-Iridar");
				}
			}
		}
		else `redscreen("AnimNotify_HandleRocket -> could not retrieve Weapon State for cosmetic rocket on soldier " @ UnitState.GetFullName() @ " -Iridar");
    }
}