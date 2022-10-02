using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(118, "取消付款邮件")]
	public class MailPaymentCancelHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			new GSPacketIn(118, client.Player.PlayerCharacter.ID);
			int mailID = packet.ReadInt();
			int senderID = 0;
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				if (playerBussiness.CancelPaymentMail(client.Player.PlayerCharacter.ID, mailID, ref senderID))
				{
					client.Out.SendMailResponse(senderID, eMailRespose.Receiver);
					packet.WriteBoolean(val: true);
				}
				else
				{
					packet.WriteBoolean(val: false);
				}
			}
			client.Out.SendTCP(packet);
			return 1;
        }
    }
}
