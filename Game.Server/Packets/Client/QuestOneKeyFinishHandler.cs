using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;
using System;

namespace Game.Server.Packets.Client
{
	[PacketHandler(86, "任务完成")]
	public class QuestOneKeyFinishHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			BaseRoom currentRoom = client.Player.CurrentRoom;
			client.Player.CurrentRoom.GetPlayers();
			if (currentRoom != null && currentRoom.Host == client.Player)
			{
				if (client.Player.MainWeapon == null)
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("Game.Server.SceneGames.NoEquip", Array.Empty<object>()));
					return 0;
				}
				RoomMgr.StartGame(client.Player.CurrentRoom);
				client.Player.CurrentRoom.IsPlaying = true;
			}
			return 0;
		}
	}
}
