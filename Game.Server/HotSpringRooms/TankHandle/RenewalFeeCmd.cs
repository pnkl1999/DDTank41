using Game.Base.Packets;

namespace Game.Server.HotSpringRooms.TankHandle
{
    [HotSpringCommandAttbute(3)]
	public class RenewalFeeCmd : IHotSpringCommandHandler
    {
        public bool HandleCommand(TankHotSpringLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentHotSpringRoom != null)
			{
				packet.ReadInt();
			}
			return false;
        }
    }
}
