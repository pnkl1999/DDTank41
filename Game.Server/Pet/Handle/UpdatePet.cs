using Bussiness;
using Bussiness.Helpers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Linq;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.UPDATE_PET)]
	public class UpdatePet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
			int playerID = packet.ReadInt();
			GamePlayer gp = WorldMgr.GetPlayerById(playerID);
			UsersPetInfo[] pets;
			EatPetsInfo eatpet;
			if (gp != null)
			{
				pets = gp.PetBag.GetPets();
				eatpet = gp.PetBag.EatPets;
			}
			else
			{
				using (PlayerBussiness pb = new PlayerBussiness())
                {
					pets = pb.GetUserPetSingles(playerID, player.PlayerCharacter.VIPLevel);
					eatpet = pb.GetAllEatPetsByID(playerID);
					for (int i = 0; i < pets.Length; i++)
					{
						pets[i].PetEquips = player.PetBag.DeserializePetEquip(pets[i].eQPets);
					}
				}
			}
			if (pets != null && eatpet != null)
			{
				if (pets.Length > 20)
				{
					IEnumerable<IEnumerable<UsersPetInfo>> enumerable = pets.Split(20);
					foreach (IEnumerable<UsersPetInfo> item in enumerable)
					{
						player.Out.SendPetInfo(playerID, player.ZoneId, item.ToArray(), eatpet);
					}
				}
				else
				{
					player.Out.SendPetInfo(playerID, player.ZoneId, pets, eatpet);
				}
			}
			return false;
        }
    }
}
