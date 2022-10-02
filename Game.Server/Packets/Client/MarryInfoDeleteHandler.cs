using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(234, "撤消征婚信息")]
	public class MarryInfoDeleteHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			string msg = LanguageMgr.GetTranslation("MarryInfoDeleteHandler.Fail");
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				if (playerBussiness.DeleteMarryInfo(num, client.Player.PlayerCharacter.ID, ref msg))
				{
					client.Out.SendAuctionRefresh(null, num, isExist: false, null);
				}
				client.Out.SendMessage(eMessageType.GM_NOTICE, msg);
			}
			return 0;
        }
    }
}
