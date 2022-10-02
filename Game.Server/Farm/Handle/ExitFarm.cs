using Game.Base.Packets;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(16)]
	public class ExitFarm : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			Player.Farm.ExitFarm();
			return true;
        }
    }
}
