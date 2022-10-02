using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(250, "求婚答复")]
	internal class MarryApplyReplyHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			bool flag = packet.ReadBoolean();
			int userID = packet.ReadInt();
			int answerId = packet.ReadInt();
			if (flag && client.Player.PlayerCharacter.IsMarried)
			{
				client.Player.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("MarryApplyReplyHandler.Msg2"));
			}
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(userID);
				if (!flag)
				{
					SendGoodManCard(userSingleByUserID.NickName, userSingleByUserID.ID, client.Player.PlayerCharacter.NickName, client.Player.PlayerCharacter.ID, playerBussiness);
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(userSingleByUserID.ID);
				}
				if (userSingleByUserID == null || userSingleByUserID.Sex == client.Player.PlayerCharacter.Sex)
				{
					return 1;
				}
				if (userSingleByUserID.IsMarried)
				{
					client.Player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("MarryApplyReplyHandler.Msg3"));
				}
				MarryApplyInfo info = new MarryApplyInfo
				{
					UserID = userID,
					ApplyUserID = client.Player.PlayerCharacter.ID,
					ApplyUserName = client.Player.PlayerCharacter.NickName,
					ApplyType = 2,
					LoveProclamation = "",
					ApplyResult = flag
				};
				int id = 0;
				DailyRecordInfo info2 = new DailyRecordInfo
				{
					UserID = client.Player.PlayerCharacter.ID,
					Type = 3,
					Value = client.Player.PlayerCharacter.SpouseName
				};
				new PlayerBussiness().AddDailyRecord(info2);
				if (playerBussiness.SavePlayerMarryNotice(info, answerId, ref id))
				{
					if (flag)
					{
						client.Player.Out.SendMarryApplyReply(client.Player, userSingleByUserID.ID, userSingleByUserID.NickName, flag, isApplicant: false, id);
						client.Player.LoadMarryProp();
					}
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(userSingleByUserID.ID);
					return 0;
				}
			}
			return 1;
        }

        public void SendGoodManCard(string receiverName, int receiverID, string senderName, int senderID, PlayerBussiness db)
        {
			ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(11105), 1, 112);
			itemInfo.IsBinds = true;
			itemInfo.UserID = 0;
			db.AddGoods(itemInfo);
			MailInfo mail = new MailInfo
			{
				Annex1 = itemInfo.ItemID.ToString(),
				Content = LanguageMgr.GetTranslation("MarryApplyReplyHandler.Content"),
				Gold = 0,
				IsExist = true,
				Money = 0,
				Receiver = receiverName,
				ReceiverID = receiverID,
				Sender = senderName,
				SenderID = senderID,
				Title = LanguageMgr.GetTranslation("MarryApplyReplyHandler.Title"),
				Type = 14
			};
			db.SendMail(mail);
        }

        public void SendSYSMessages(GamePlayer player, PlayerInfo spouse)
        {
			string text = (player.PlayerCharacter.Sex ? player.PlayerCharacter.NickName : spouse.NickName);
			string text2 = (player.PlayerCharacter.Sex ? spouse.NickName : player.PlayerCharacter.NickName);
			string translation = LanguageMgr.GetTranslation("MarryApplyReplyHandler.Msg1", text, text2);
			player.OnPlayerMarry();
			GSPacketIn gSPacketIn = new GSPacketIn(10);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteString(translation);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
			GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
			for (int i = 0; i < allPlayers.Length; i++)
			{
				allPlayers[i].Out.SendTCP(gSPacketIn);
			}
        }
    }
}
