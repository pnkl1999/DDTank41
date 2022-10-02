using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Packets;
using Newtonsoft.Json;
using SqlDataProvider.Data;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.PET_RISINGSTAR)]
	public class PetRisingStar : IPetCommandHadler
	{
		public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			int templeteId = packet.ReadInt();
			int count = packet.ReadInt();
			int petPlace = packet.ReadInt();
			bool success = false;
			UsersPetInfo currPet = Player.PetBag.GetPetAt(petPlace);
			if (currPet == null)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("PetRisingStar.PetNotFound"));
			}
			else
			{
				int risingTempate = 11162;
				ItemInfo item = Player.GetItemByTemplateID(templeteId);
				bool deedBuff = false;
				if (item == null)
				{
					Player.SendMessage(LanguageMgr.GetTranslation("PetRisingStar.ItemNotFound"));
				}
				else
				{
					PetStarExpInfo info = PetMgr.FindPetStarExp(currPet.TemplateID);
					if (info == null)
					{
						Player.SendMessage(LanguageMgr.GetTranslation("PetRisingStar.UnSupport"));
					}
					else
					{
						if (item.TemplateID == risingTempate)
						{
							if (item.Count < count)
							{
								count = item.Count;
							}
							int exp = item.Template.Property2 * count;
							int totalExp = currPet.currentStarExp + exp;
							if (totalExp >= info.Exp)
							{
								int needExp = info.Exp - currPet.currentStarExp;
								if (needExp < exp && !deedBuff)
								{
									count = (exp - needExp) / item.Template.Property2;
								}
								if (Player.RemoveCountFromStack(item, count))
								{
									currPet.currentStarExp = 0;
									PetTemplateInfo tempInfo = PetMgr.FindPetTemplate(info.NewID);
									if (tempInfo != null)
									{
										UsersPetInfo petInfo = PetMgr.CreatePet(tempInfo, currPet.UserID, currPet.Place, currPet.Level, Player.PlayerCharacter.VIPLevel);
										currPet.BaseProp = JsonConvert.SerializeObject(petInfo);

										petInfo.Level = currPet.Level;
										petInfo.VIPLevel = Player.PlayerCharacter.VIPLevel;

										Player.PetBag.UpdateEvolutionPet(petInfo, currPet.Level, Player.PetBag.MaxLevelByGrade, Player.PlayerCharacter.VIPLevel);
										currPet.TemplateID = petInfo.TemplateID;

										currPet.AttackGrow = petInfo.AttackGrow;
										currPet.DefenceGrow = petInfo.DefenceGrow;
										currPet.AgilityGrow = petInfo.AgilityGrow;
										currPet.LuckGrow = petInfo.LuckGrow;
										currPet.BloodGrow = petInfo.BloodGrow;
										currPet.DamageGrow = petInfo.DamageGrow;
										currPet.GuardGrow = petInfo.GuardGrow;

										currPet.Attack = petInfo.Attack;
										currPet.Defence = petInfo.Defence;
										currPet.Agility = petInfo.Agility;
										currPet.Luck = petInfo.Luck;
										currPet.Blood = petInfo.Blood;
										currPet.Damage = petInfo.Damage;
										currPet.Guard = petInfo.Guard;

										success = true;
									}
								}
							}
							else
							{
								if (Player.RemoveCountFromStack(item, count))
									currPet.currentStarExp = totalExp;
							}
							Player.PetBag.UpdatePet(currPet);

						}
						else
						{
							Player.SendMessage(LanguageMgr.GetTranslation("PetRisingStar.ItemNotFound"));
						}
					}

				}
			}
			GSPacketIn pkg = new GSPacketIn((short)ePackageType.PET);
			pkg.WriteByte((byte)PetPackageType.PET_RISINGSTAR);
			pkg.WriteBoolean(success);
			Player.SendTCP(pkg);
			return false;
		}
	}
}
