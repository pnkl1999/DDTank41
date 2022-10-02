using Game.Base.Packets;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler(82, "游戏开始")]
	public class GameUserStartHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			bool flag = packet.ReadBoolean();
			BaseRoom currentRoom = client.Player.CurrentRoom;
			if (flag && currentRoom != null)
			{
				RoomMgr.StartGameMission(currentRoom);
			}
			return 0;
        }
    }
}
