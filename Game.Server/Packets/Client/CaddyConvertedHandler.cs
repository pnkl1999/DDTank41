using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(215, "Envia mensagem para todos de sua associação")]
	public class CaddyConvertedHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			string title = packet.ReadString();
			string content = packet.ReadString();
			string text = "";
			bool flag = false;
			int riches = 1000;
			text = "ConsortiaRichiUpdateHandler.Failed";
			ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(client.Player.PlayerCharacter.ConsortiaID);
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				ConsortiaUserInfo[] allMemberByConsortia = playerBussiness.GetAllMemberByConsortia(client.Player.PlayerCharacter.ConsortiaID);
				MailInfo mailInfo = new MailInfo();
				ConsortiaUserInfo[] array = allMemberByConsortia;
				ConsortiaUserInfo[] array2 = array;
				foreach (ConsortiaUserInfo consortiaUserInfo in array2)
				{
					mailInfo.SenderID = client.Player.PlayerCharacter.ID;
					mailInfo.Sender = "Chủ Guild " + consortiaInfo.ConsortiaName;
					mailInfo.ReceiverID = consortiaUserInfo.UserID;
					mailInfo.Receiver = consortiaUserInfo.UserName;
					mailInfo.Title = title;
					mailInfo.Content = content;
					mailInfo.Type = 59;
					if (consortiaUserInfo.UserID != client.Player.PlayerCharacter.ID && playerBussiness.SendMail(mailInfo))
					{
						text = "ConsortiaRichiUpdateHandler.Success";
						flag = true;
						if (consortiaUserInfo.State != 0)
						{
							client.Player.Out.SendMailResponse(consortiaUserInfo.UserID, eMailRespose.Receiver);
						}
						client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Send);
					}
					if (!flag)
					{
						text = "ConsortiaRichiUpdateHandler.Success";
						flag = true;
						if (consortiaUserInfo.State != 0)
						{
							client.Player.Out.SendMailResponse(consortiaUserInfo.UserID, eMailRespose.Receiver);
						}
						client.Player.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Send);
					}
				}
			}
			if (flag)
			{
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				consortiaBussiness.ConsortiaRichRemove(client.Player.PlayerCharacter.ConsortiaID, ref riches);
			}
			client.Out.SendConsortiaMail(flag, client.Player.PlayerCharacter.ID);
			client.Player.SendMessage(LanguageMgr.GetTranslation(text));
			return 0;
        }
    }
}
