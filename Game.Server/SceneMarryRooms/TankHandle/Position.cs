using Game.Base.Packets;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    [MarryCommandAttbute(10)]
	public class Position : IMarryCommandHandler
    {
        public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentMarryRoom != null)
			{
				player.X = packet.ReadInt();
				player.Y = packet.ReadInt();
				return true;
			}
			return false;
        }
    }
}
