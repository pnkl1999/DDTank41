using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTION_MAIL)]
	public class ConsortiaMail : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			string title = packet.ReadString();
			string content = packet.ReadString();
			string msg = "ConsortiaRichiUpdateHandler.Failed";
			bool flag = false;
			ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(Player.PlayerCharacter.ConsortiaID);
			if (consortiaInfo == null)
			{
				return 0;
			}
			if (consortiaInfo.Riches < 1000)
			{
				Player.SendMessage(LanguageMgr.GetTranslation("ConsortiaBussiness.Riches.Msg3"));
				return 0;
			}
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				ConsortiaUserInfo[] allMemberByConsortia = playerBussiness.GetAllMemberByConsortia(Player.PlayerCharacter.ConsortiaID);
				MailInfo mailInfo = new MailInfo();
				ConsortiaUserInfo[] array = allMemberByConsortia;
				ConsortiaUserInfo[] array2 = array;
				foreach (ConsortiaUserInfo consortiaUserInfo in array2)
				{
					mailInfo.SenderID = Player.PlayerCharacter.ID;
					mailInfo.Sender = "Hội " + consortiaUserInfo.ConsortiaName;
					mailInfo.ReceiverID = consortiaUserInfo.UserID;
					mailInfo.Receiver = consortiaUserInfo.UserName;
					mailInfo.Title = title;
					mailInfo.Content = content;
					mailInfo.Type = 59;
					if (consortiaUserInfo.UserID != Player.PlayerCharacter.ID && playerBussiness.SendMail(mailInfo))
					{
						msg = "ConsortiaRichiUpdateHandler.Success";
						flag = true;
						if (consortiaUserInfo.State != 0)
						{
							Player.Out.SendMailResponse(consortiaUserInfo.UserID, eMailRespose.Receiver);
						}
						Player.Out.SendMailResponse(Player.PlayerCharacter.ID, eMailRespose.Send);
					}
				}
			}
			if (flag)
			{
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				consortiaBussiness.UpdateConsortiaRiches(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, 1000, ref msg);
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(29);
			gSPacketIn.WriteBoolean(flag);
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
