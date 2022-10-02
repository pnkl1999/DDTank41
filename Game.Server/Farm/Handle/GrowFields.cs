using Game.Base.Packets;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(2)]
	public class GrowFields : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadByte();
			int num2 = packet.ReadInt();
			int fieldId = packet.ReadInt();
			if (Player.Farm.GrowField(fieldId, num2))
			{
				Player.FarmBag.RemoveTemplate(num2, 1);
				Player.OnSeedFoodPetEvent();
			}
			return true;
        }
    }
}
