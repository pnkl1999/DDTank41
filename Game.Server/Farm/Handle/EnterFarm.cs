using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(1)]
	public class EnterFarm : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn pkg)
        {
			if (player.PlayerCharacter.Grade < 25)
			{
				player.SendMessage(LanguageMgr.GetTranslation("Bạn chưa đạt cấp độ 25 không thể vào Nông Trại!"));
				return false;
			}
			int num = pkg.ReadInt();
			if (num == player.PlayerCharacter.ID)
			{
				player.Farm.EnterFarm(isEnter: true);
				if (player.PlayerCharacter.IsFistGetPet)
				{
					player.PetBag.ClearAdoptPets();
					List<UsersPetInfo> list = PetMgr.CreateFirstAdoptList(num, player.Level, player.PlayerCharacter.VIPLevel);
					foreach (UsersPetInfo item in list)
					{
						player.PetBag.AddAdoptPetTo(item, item.Place);
					}
					player.RemoveFistGetPet();
				}
				else if (player.PlayerCharacter.LastRefreshPet.Date < DateTime.Now.Date)
				{
					player.PetBag.ClearAdoptPets();
					List<UsersPetInfo> list2 = PetMgr.CreateFirstAdoptList(num, player.Level, player.PlayerCharacter.VIPLevel);
					foreach (UsersPetInfo item2 in list2)
					{
						player.PetBag.AddAdoptPetTo(item2, item2.Place);
					}
					player.RemoveLastRefreshPet();
				}
			}
			else
			{
				player.Farm.EnterFriendFarm(num);
			}
			return true;
        }
    }
}
