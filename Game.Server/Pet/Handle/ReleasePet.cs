using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.RELEASE_PET)]
	public class ReleasePet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
			int place = packet.ReadInt();
			UsersPetInfo pet = player.PetBag.GetPetAt(place);
			if (player.PetBag.RemovePet(pet))
			{
				//player.EquipBag.UpdatePlayerProperties();
				using (PlayerBussiness pb = new PlayerBussiness())
				{
					pb.UpdateUserAdoptPet(pet.ID);
				}
				PetTemplateInfo petinfo = PetMgr.FindPetTemplate(pet.TemplateID);
				if (petinfo.WashGetCount > 0)
				{
					ItemInfo info = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(12656), petinfo.WashGetCount, 105);
					info.IsBinds = true;
					player.SendItemToMail(info, "", "", eMailType.Default);
					player.SendMessage("Nhận được: " + info.Template.Name + "x" + info.Count.ToString());
				}
			}
			player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg19"));
			player.PetBag.SaveToDatabase(saveAdopt: false);
			return false;
        }
    }
}
