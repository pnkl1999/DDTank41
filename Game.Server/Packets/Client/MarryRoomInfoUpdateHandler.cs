using Bussiness;
using Game.Base.Packets;
using Game.Server.SceneMarryRooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler(237, "更新礼堂信息")]
	internal class MarryRoomInfoUpdateHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.CurrentMarryRoom != null && client.Player.PlayerCharacter.ID == client.Player.CurrentMarryRoom.Info.PlayerID)
			{
				string name = packet.ReadString();
				bool flag = packet.ReadBoolean();
				string pwd = packet.ReadString();
				string roomIntroduction = packet.ReadString();
				MarryRoom currentMarryRoom = client.Player.CurrentMarryRoom;
				currentMarryRoom.Info.RoomIntroduction = roomIntroduction;
				currentMarryRoom.Info.Name = name;
				if (flag)
				{
					currentMarryRoom.Info.Pwd = pwd;
				}
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					playerBussiness.UpdateMarryRoomInfo(currentMarryRoom.Info);
				}
				currentMarryRoom.SendMarryRoomInfoUpdateToScenePlayers(currentMarryRoom);
				client.Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("MarryRoomInfoUpdateHandler.Successed"));
				return 0;
			}
			return 1;
        }
    }
}
