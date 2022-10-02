using Game.Base.Packets;

namespace Game.Server.Pet.Handle
{
	[PetHandleAttbute((byte)PetPackageType.DEL_PET_EQUIP)]
	public class DelPetEquip : IPetCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			int eqPlace = packet.ReadInt();
			string infoPetDel = "Delete Pet " + Player.PetBag.GetPetAt(num);
			if (Player.PetBag.RemoveEqPet(num, eqPlace))
			{
				Player.PetBag.OnChangedPetEquip(num);
				Player.AddLog("DEL_PET_EQUIP: ", Player.PetBag.GetPetAt(num).Name);
			}
			return false;
        }
    }
}
