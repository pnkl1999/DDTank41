using System;
using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)PetPackageType.EQUIP_PET_SKILL)]
    public class EquipSkillPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            int place = packet.ReadInt();
            int killId = packet.ReadInt();
            int killindex = packet.ReadInt();
            string msg = "";
            if (killindex == 4 && player.UserVIPInfo.VIPLevel < 7)
            {
                //player.SendMessage(eMessageType.ALERT, "Chưa thể sử dụng ô này!");
                player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg181"));
                return true;
            }
            player.PetBag.EquipSkillPet(place, killId, killindex, ref msg);
            if (msg != "")
            {
                player.SendMessage(LanguageMgr.GetTranslation(msg));
            }
            return false;
        }
    }
}