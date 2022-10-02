using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using System;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.RENAME_PET)]
	public class RenamePet : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer player, GSPacketIn packet)
        {
			int place = packet.ReadInt();
			string name = packet.ReadString();
			int value = Convert.ToInt32(PetMgr.FindConfig("ChangeNameCost").Value);
			if (player.MoneyDirect(value, IsAntiMult: false, false) && player.PetBag.RenamePet(place, name))
			{
				player.SendMessage(LanguageMgr.GetTranslation("PetHandler.Msg20"));
			}
			return false;
        }
    }
}
