using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    [MarryCommandAttbute(5)]
	public class LargessCommand : IMarryCommandHandler
    {
        public bool HandleCommand(TankMarryLogicProcessor process, GamePlayer player, GSPacketIn packet)
        {
			if (player.CurrentMarryRoom == null)
			{
				return false;
			}
			int num = packet.ReadInt();
			int num2 = GameProperties.LimitLevel(3);
			if (player.PlayerCharacter.Grade < num2)
			{
				player.Out.SendMessage(eMessageType.GM_NOTICE, $"Cần đạt cấp độ tối thiểu là { num2 }.");
				return false;
			}
			if (num <= 0)
			{
				return false;
			}
			if (!player.MoneyDirect(num, IsAntiMult: false, false))
			{
				return false;
			}
			if (!player.ActiveMoneyEnable(num))
			{
				return false;
			}
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				string translation = LanguageMgr.GetTranslation("LargessCommand.Content", player.PlayerCharacter.NickName, num / 2);
				string translation2 = LanguageMgr.GetTranslation("LargessCommand.Title", player.PlayerCharacter.NickName);
				MailInfo mailInfo = new MailInfo
				{
					Annex1 = "",
					Content = translation,
					Gold = 0,
					IsExist = true,
					Money = num / 2,
					Receiver = player.CurrentMarryRoom.Info.BrideName,
					ReceiverID = player.CurrentMarryRoom.Info.BrideID,
					Sender = LanguageMgr.GetTranslation("LargessCommand.Sender"),
					SenderID = 0,
					Title = translation2,
					Type = 14
				};
				playerBussiness.SendMail(mailInfo);
				player.Out.SendMailResponse(mailInfo.ReceiverID, eMailRespose.Receiver);
				MailInfo mailInfo2 = new MailInfo
				{
					Annex1 = "",
					Content = translation,
					Gold = 0,
					IsExist = true,
					Money = num / 2,
					Receiver = player.CurrentMarryRoom.Info.GroomName,
					ReceiverID = player.CurrentMarryRoom.Info.GroomID,
					Sender = LanguageMgr.GetTranslation("LargessCommand.Sender"),
					SenderID = 0,
					Title = translation2,
					Type = 14
				};
				playerBussiness.SendMail(mailInfo2);
				player.Out.SendMailResponse(mailInfo2.ReceiverID, eMailRespose.Receiver);
			}
			player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("LargessCommand.Succeed"));
			GSPacketIn packet2 = player.Out.SendMessage(eMessageType.ChatNormal, LanguageMgr.GetTranslation("LargessCommand.Notice", player.PlayerCharacter.NickName, num));
			player.CurrentMarryRoom.SendToPlayerExceptSelf(packet2, player);
			return true;
        }
    }
}
