using Game.Base.Packets;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(7)]
	public class KillCropField : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int fieldId = packet.ReadInt();
			Player.Farm.killCropField(fieldId);
			return true;
        }
    }
}
