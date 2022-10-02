using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.SceneMarryRooms;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(242, "进入礼堂")]
	public class MarryRoomLoginHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			MarryRoom marryRoom = null;
			string msg = "";
			int num = packet.ReadInt();
			string text = packet.ReadString();
			int marryMap = packet.ReadInt();
			if (num != 0)
			{
				marryRoom = MarryRoomMgr.GetMarryRoombyID(num, (text == null) ? "" : text, ref msg);
			}
			else
			{
				if (client.Player.PlayerCharacter.IsCreatedMarryRoom)
				{
					MarryRoom[] allMarryRoom = MarryRoomMgr.GetAllMarryRoom();
					MarryRoom[] array = allMarryRoom;
					foreach (MarryRoom marryRoom2 in array)
					{
						if (marryRoom2.Info.GroomID == client.Player.PlayerCharacter.ID || marryRoom2.Info.BrideID == client.Player.PlayerCharacter.ID)
						{
							marryRoom = marryRoom2;
							break;
						}
					}
				}
				if (marryRoom == null && client.Player.PlayerCharacter.SelfMarryRoomID != 0)
				{
					client.Player.Out.SendMarryRoomLogin(client.Player, result: false);
					MarryRoomInfo marryRoomInfo = null;
					using (PlayerBussiness playerBussiness = new PlayerBussiness())
					{
						marryRoomInfo = playerBussiness.GetMarryRoomInfoSingle(client.Player.PlayerCharacter.SelfMarryRoomID);
					}
					if (marryRoomInfo != null)
					{
						client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryRoomLoginHandler.RoomExist", marryRoomInfo.ServerID, client.Player.PlayerCharacter.SelfMarryRoomID));
						return 0;
					}
				}
			}
			if (marryRoom != null)
			{
				if (marryRoom.CheckUserForbid(client.Player.PlayerCharacter.ID))
				{
					client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation("MarryRoomLoginHandler.Forbid"));
					client.Player.Out.SendMarryRoomLogin(client.Player, result: false);
					return 1;
				}
				if (marryRoom.RoomState == eRoomState.FREE)
				{
					if (marryRoom.AddPlayer(client.Player))
					{
						client.Player.MarryMap = marryMap;
						client.Player.Out.SendMarryRoomLogin(client.Player, result: true);
						marryRoom.SendMarryRoomInfoUpdateToScenePlayers(marryRoom);
						return 0;
					}
				}
				else
				{
					client.Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("MarryRoomLoginHandler.AlreadyBegin"));
				}
				client.Player.Out.SendMarryRoomLogin(client.Player, result: false);
			}
			else
			{
				client.Out.SendMessage(eMessageType.BIGBUGLE_NOTICE, LanguageMgr.GetTranslation(string.IsNullOrEmpty(msg) ? "MarryRoomLoginHandler.Failed" : msg));
				client.Player.Out.SendMarryRoomLogin(client.Player, result: false);
			}
			return 1;
        }
    }
}
