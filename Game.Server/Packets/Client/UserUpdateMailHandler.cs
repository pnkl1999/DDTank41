using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(114, "修改邮件的已读未读标志")]
	public class UserUpdateMailHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(114, client.Player.PlayerCharacter.ID);
			int mailID = packet.ReadInt();
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				MailInfo mailSingle = playerBussiness.GetMailSingle(client.Player.PlayerCharacter.ID, mailID);
				if (mailSingle != null && !mailSingle.IsRead)
				{
					mailSingle.IsRead = true;
					if (mailSingle.Type < 100)
					{
						mailSingle.ValidDate = 72;
						mailSingle.SendTime = DateTime.Now;
					}
					playerBussiness.UpdateMail(mailSingle, mailSingle.Money);
					gSPacketIn.WriteBoolean(val: true);
				}
				else
				{
					gSPacketIn.WriteBoolean(val: false);
				}
			}
			client.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
