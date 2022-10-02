using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.Rooms;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(16, "Player enter scene.")]
	public class UserEnterSceneHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			client.Player.BeginChanges();
			switch (num)
			{
			case 1:
				client.Player.PlayerState = ePlayerState.Manual;
				break;
			case 2:
				client.Player.PlayerState = ePlayerState.Away;
				break;
			default:
				Console.WriteLine("UserEnterScene: typeScene {0}", num);
				break;
			}
			client.Player.CommitChanges();
			RoomMgr.EnterWaitingRoom(client.Player);
			if (WorldMgr.HotSpringScene.GetClientFromID(client.Player.PlayerCharacter.ID) != null)
			{
				WorldMgr.HotSpringScene.RemovePlayer(client.Player);
			}
			return 1;
        }
    }
}
