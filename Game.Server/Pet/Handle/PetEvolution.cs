using System;
using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;
using Game.Logic;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)PetPackageType.PET_EVOLUTION)]
    public class PetEvolution : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            int tempalteId = packet.ReadInt();
            int count = packet.ReadInt();
            if (tempalteId != 11163)
                return false;
            int exp = 0;
            ItemInfo food = player.GetItemByTemplateID(tempalteId);
            if (food != null && count > 0 && tempalteId == 11163)
            {
                if (food.Count < count)
                    count = food.Count;
                exp = food.Template.Property2 * count;
            }
            if (exp > 0)
            {
                bool uplevel = false;
                int currentGrade = player.PlayerCharacter.evolutionGrade;
                int currentGp = player.PlayerCharacter.evolutionExp;

                int totalExp = player.PlayerCharacter.evolutionExp + exp;
                int maxLv = PetMgr.GetEvolutionMax();
                for (int i = currentGrade; i <= maxLv; i++)
                {
                    PetFightPropertyInfo item = PetMgr.FindFightProperty(i + 1);
                    if (item != null && item.Exp <= totalExp)
                    {
                        player.PlayerCharacter.evolutionGrade = i + 1;
                        uplevel = true;
                    }
                }

                player.PlayerCharacter.evolutionExp = totalExp;
                //player.PropBag.RemoveCountFromStack(food, count);
                player.RemoveTemplate(tempalteId, count);
                player.AddLog("PET_EVOLUTION: ", "Count: " + food.Count + "|Name: " + food.Name);
                player.EquipBag.UpdatePlayerProperties();
                player.SendUpdatePublicPlayer();
                GSPacketIn pkg = new GSPacketIn((short)ePackageType.PET);
                pkg.WriteByte((byte)PetPackageType.PET_EVOLUTION);
                pkg.WriteBoolean(uplevel);
                player.SendTCP(pkg);
            }
            return false;
        }

    }
}
