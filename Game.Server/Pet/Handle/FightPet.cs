using System;
using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Base.Packets;
using SqlDataProvider.Data;
using Bussiness;

namespace Game.Server.Pet.Handle
{
    [PetHandleAttbute((byte)PetPackageType.FIGHT_PET)]
    public class FightPet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
            int place = packet.ReadInt();
            bool isEquip = packet.ReadBoolean();

            UsersPetInfo pet = player.PetBag.GetPetAt(place);
            if (pet == null)
                return false;
            if (pet.Level > player.PetBag.MaxLevelByGrade && !pet.IsEquip)
            {
                player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg21"));
                return false;
            }
            if (player.PetBag.EquipPet(place, isEquip))
            {
                player.EquipBag.UpdatePlayerProperties();
            }
            else
            {
                player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg22"));
            }

            return false;
        }

    }
}
