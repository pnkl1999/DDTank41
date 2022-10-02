using Game.Base.Packets;
using Game.Server.Packets;

namespace Game.Server.HotSpringRooms.TankHandle
{
    [HotSpringCommandAttbute(1)]
	public class TargetPointCmd : IHotSpringCommandHandler
    {
        public bool HandleCommand(TankHotSpringLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentHotSpringRoom != null)
			{
				string pathStr = packet.ReadString();
				int id = packet.ReadInt();
				int X = packet.ReadInt();
				int Y = packet.ReadInt();
				packet.ReadInt();
				int hot_Direction = packet.ReadInt();
				GamePlayer playerWithID = player.CurrentHotSpringRoom.GetPlayerWithID(id);
				if (playerWithID != null)
				{
					playerWithID.Hot_X = X;
					playerWithID.Hot_Y = Y;
					playerWithID.Hot_Direction = hot_Direction;
					GSPacketIn gSPacketIn = new GSPacketIn((short)ePackageType.HOTSPRING_CMD);
					gSPacketIn.WriteByte((byte)HotSpringCmdType.TARGET_POINT);
					gSPacketIn.WriteString(pathStr);
					gSPacketIn.WriteInt(id);
					gSPacketIn.WriteInt(X);
					gSPacketIn.WriteInt(Y);
					player.CurrentHotSpringRoom.SendToPlayerExceptSelf(gSPacketIn, player);
				}
			}
			return false;
        }
    }
}
