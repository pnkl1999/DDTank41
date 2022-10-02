using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.SceneMarryRooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler(240, "Player enter marry scene.")]
	public class UserEnterMarrySceneHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(240, client.Player.PlayerCharacter.ID);
			if (WorldMgr.MarryScene.AddPlayer(client.Player))
			{
				gSPacketIn.WriteBoolean(val: true);
			}
			else
			{
				gSPacketIn.WriteBoolean(val: false);
			}
			client.Out.SendTCP(gSPacketIn);
			if (client.Player.CurrentMarryRoom == null)
			{
				MarryRoom[] allMarryRoom = MarryRoomMgr.GetAllMarryRoom();
				MarryRoom[] array = allMarryRoom;
				foreach (MarryRoom room in array)
				{
					client.Player.Out.SendMarryRoomInfo(client.Player, room);
				}
			}
			return 0;
        }
    }
}
