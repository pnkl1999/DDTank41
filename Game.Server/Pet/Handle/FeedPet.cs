using System;
using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using Bussiness;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)PetPackageType.FEED_PET)]
    public class FeedPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            int itemPlace = packet.ReadInt();
            eBageType BagType = (eBageType)packet.ReadInt();
            int place = packet.ReadInt();

            ItemInfo item = player.GetItemAt(BagType, itemPlace);
            if (item == null)
            {
                player.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("PetHandler.Msg9"));
                return false;
            }

            int MaxHunger = Convert.ToInt32(PetMgr.FindConfig("MaxHunger").Value);
            UsersPetInfo currentPet = player.PetBag.GetPetAt(place);
            int neededFoodAmount = item.Count;
            int expItem = item.Template.Property2;
            int hungerItem = item.Template.Property1;
            int hungerAdd = neededFoodAmount * hungerItem;
            int totalHunger = hungerAdd + currentPet.Hunger;
            int exp = neededFoodAmount * expItem;

            string msg = "";
            if (item.TemplateID == 334100)
            {
                exp = item.DefendCompose;
                if (currentPet.breakGrade < item.Hole1)
                    currentPet.breakGrade = item.Hole1;
                if (currentPet.breakBlood < item.Blood)
                    currentPet.breakBlood = item.Blood;
                if (currentPet.breakAttack < item.Hole2)
                    currentPet.breakAttack = item.Hole2;
                if (currentPet.breakDefence < item.Hole3)
                    currentPet.breakDefence = item.Hole3;
                if (currentPet.breakAgility < item.Hole4)
                    currentPet.breakAgility = item.Hole4;
                if (currentPet.breakLuck < item.Hole5)
                    currentPet.breakLuck = item.Hole5;
            }
            int MaxLevelByGrade = player.PetBag.MaxLevelByGrade > currentPet.MaxLevel() ? currentPet.MaxLevel() : player.PetBag.MaxLevelByGrade;
            if (currentPet.Level < MaxLevelByGrade)
            {
                exp += currentPet.GP;

                int currentlv = currentPet.Level;
                int nextlv = PetMgr.GetLevel(exp, MaxLevelByGrade);
                int maxGP = PetMgr.GetGP(nextlv + 1, MaxLevelByGrade);
                int GpMaxLv = PetMgr.GetGP(MaxLevelByGrade, MaxLevelByGrade);
                int finalExp = exp;

                if (exp > GpMaxLv)
                {
                    exp -= GpMaxLv;
                    if (exp >= expItem && expItem != 0)
                    {
                        neededFoodAmount = neededFoodAmount - (int)Math.Ceiling(exp / (double)expItem);
                    }
                }
                currentPet.GP = finalExp >= GpMaxLv ? GpMaxLv : finalExp;
                currentPet.Level = nextlv;
                currentPet.MaxGP = maxGP == 0 ? GpMaxLv : maxGP;
                currentPet.Hunger = totalHunger > MaxHunger ? MaxHunger : totalHunger;
                bool updateProp = currentlv < nextlv;
                if (updateProp)
                {
                    player.PetBag.UpdateEvolutionPet(currentPet, nextlv, MaxLevelByGrade, player.PlayerCharacter.VIPLevel);
                    msg = LanguageMgr.GetTranslation("FeedPet.Success", currentPet.Name, nextlv);
                }
                if (item.TemplateID == 334100)
                {
                    player.StoreBag.RemoveItem(item);
                }
                else
                {
                    player.StoreBag.RemoveCountFromStack(item, neededFoodAmount);
                    player.OnUsingItem(item.TemplateID, neededFoodAmount);
                }
                currentPet.Hunger = totalHunger;
                if (currentPet.Hunger > MaxHunger)
                {
                    currentPet.Hunger = MaxHunger;
                }
                //player.OnUsingItem(item.TemplateID);
                player.PetBag.UpdatePet(currentPet);
                player.PetBag.SaveToDatabase(false);
                player.EquipBag.UpdatePlayerProperties();
            }
            else
            {
                if (currentPet.Hunger < MaxHunger)
                {
                    currentPet.Hunger = totalHunger;
                    if (currentPet.Hunger > MaxHunger)
                    {
                        currentPet.Hunger = MaxHunger;
                    }
                    player.StoreBag.RemoveCountFromStack(item, neededFoodAmount);
                    msg = LanguageMgr.GetTranslation("PetHandler.Msg10", hungerAdd);
                    player.PetBag.UpdatePet(currentPet);
                    player.PetBag.SaveToDatabase(false);
                    player.EquipBag.UpdatePlayerProperties();
                }
                else
                {
                    msg = LanguageMgr.GetTranslation("PetHandler.Msg11");
                }
            }
            if (!string.IsNullOrEmpty(msg))
            {
                player.SendMessage(msg);
            }
            return false;
        }

    }
}
