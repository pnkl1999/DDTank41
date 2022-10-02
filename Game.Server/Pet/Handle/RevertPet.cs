using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Packets;
using Newtonsoft.Json;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.REVER_PET)]
	public class RevertPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
			int place = packet.ReadInt();
			int recycleCost = Convert.ToInt32(PetMgr.FindConfig("RecycleCost").Value);
			if (player.MoneyDirect(recycleCost, IsAntiMult: false, false))
			{
				UsersPetInfo currentPet = player.PetBag.GetPetAt(place);
				if (currentPet == null)
				{
					return false;
				}
				UsersPetInfo ogrPet = JsonConvert.DeserializeObject<UsersPetInfo>(currentPet.BaseProp);
				if (ogrPet == null)
				{
					player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg7"));
					return false;
				}
				ItemTemplateInfo Item = ItemMgr.FindItemTemplate(334100);
				ItemInfo cloneItem = ItemInfo.CreateFromTemplate(Item, 1, 102);
				cloneItem.IsBinds = true;
				cloneItem.DefendCompose = currentPet.GP;
				cloneItem.AgilityCompose = currentPet.MaxGP;
				cloneItem.Hole1 = currentPet.breakGrade;
				cloneItem.Hole2 = currentPet.breakAttack;
				cloneItem.Hole3 = currentPet.breakDefence;
				cloneItem.Hole4 = currentPet.breakAgility;
				cloneItem.Hole5 = currentPet.breakLuck;
				cloneItem.Blood = currentPet.breakBlood;
				if (!player.PropBag.AddTemplate(cloneItem, 1))
				{
					player.SendItemToMail(cloneItem, LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), LanguageMgr.GetTranslation("UserChangeItemPlaceHandler.full"), eMailType.ItemOverdue);
					player.Out.SendMailResponse(player.PlayerCharacter.ID, eMailRespose.Receiver);
				}
				currentPet.breakGrade = ogrPet.breakGrade;
				currentPet.breakAttack = ogrPet.breakAttack;
				currentPet.breakDefence = ogrPet.breakDefence;
				currentPet.breakAgility = ogrPet.breakAgility;
				currentPet.breakLuck = ogrPet.breakLuck;
				currentPet.breakBlood = ogrPet.breakBlood;
				currentPet.Attack = ogrPet.Attack;
				currentPet.Defence = ogrPet.Defence;
				currentPet.Agility = ogrPet.Agility;
				currentPet.Luck = ogrPet.Luck;
				currentPet.Blood = ogrPet.Blood;
				currentPet.AttackGrow = ogrPet.AttackGrow;
				currentPet.DefenceGrow = ogrPet.DefenceGrow;
				currentPet.AgilityGrow = ogrPet.AgilityGrow;
				currentPet.LuckGrow = ogrPet.LuckGrow;
				currentPet.BloodGrow = ogrPet.BloodGrow;
				currentPet.TemplateID = ogrPet.TemplateID;
				currentPet.Skill = ogrPet.Skill;
				currentPet.SkillEquip = ogrPet.SkillEquip;
				currentPet.GP = 0;
				currentPet.Level = 1;
				currentPet.MaxGP = 55;

				//RemovePetEquip
				player.PetBag.RemoveEqPet(currentPet.Place, 0);
				player.PetBag.RemoveEqPet(currentPet.Place, 1);
				player.PetBag.RemoveEqPet(currentPet.Place, 2);
				player.PetBag.OnChangedPetEquip(currentPet.Place);

				player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg8"));
				player.PetBag.UpdatePet(currentPet);
				player.PetBag.SaveToDatabase(saveAdopt: false);
			}
			return false;
        }
    }
}
