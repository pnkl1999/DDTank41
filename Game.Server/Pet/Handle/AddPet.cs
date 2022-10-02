using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Newtonsoft.Json;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.ADD_PET)]
	public class AddPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
			int place = packet.ReadInt();
			int bagType = packet.ReadInt();
			int iD = player.PlayerCharacter.ID;
			PetInventory petBag = player.PetBag;
			int num = petBag.FindFirstEmptySlot();
			if (player.PlayerCharacter.Grade < 25)
			{
				player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg2"));
				return false;
			}
			if (num == -1)
			{
				player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg3"));
			}
			else
			{
				ItemInfo itemAt = player.GetItemAt((eBageType)bagType, place);
				PetTemplateInfo petTemplateInfo = PetMgr.FindPetTemplate(itemAt.Template.Property5);
				if (petTemplateInfo == null)
				{
					player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg4"));
					return false;
				}
				UsersPetInfo usersPetInfo = PetMgr.CreatePet(petTemplateInfo, iD, num, petBag.MaxLevelByGrade, player.PlayerCharacter.VIPLevel);
				usersPetInfo.IsExit = true;
				usersPetInfo.PetEquips = new List<PetEquipInfo>();
				usersPetInfo.BaseProp = JsonConvert.SerializeObject(usersPetInfo);
				usersPetInfo.VIPLevel = player.PlayerCharacter.VIPLevel;
				petBag.AddPetTo(usersPetInfo, num);
				player.RemoveCountFromStack(itemAt, 1);
				if (petTemplateInfo.StarLevel > 4)
				{
					string translation = LanguageMgr.GetTranslation("PetHandler.Msg5", player.PlayerCharacter.NickName, petTemplateInfo.Name, petTemplateInfo.StarLevel);
					GSPacketIn packet2 = WorldMgr.SendSysNotice(translation);
					GameServer.Instance.LoginServer.SendPacket(packet2);
				}
				else
				{
					player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg6", petTemplateInfo.Name, petTemplateInfo.StarLevel));
				}
				petBag.SaveToDatabase(saveAdopt: false);
				GSPacketIn gSPacketIn = new GSPacketIn(68);
				gSPacketIn.WriteByte(2);
				gSPacketIn.WriteInt(petTemplateInfo.TemplateID);
				gSPacketIn.WriteBoolean(val: true);
				player.SendTCP(gSPacketIn);
			}
			return false;
        }
    }
}
