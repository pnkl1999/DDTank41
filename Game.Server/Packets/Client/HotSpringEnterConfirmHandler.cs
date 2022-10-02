using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler(212, "礼堂数据")]
	public class HotSpringEnterConfirmHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			if (client.Player.CurrentHotSpringRoom == null)
			{
				if (HotSpringMgr.GetHotSpringRoombyID(num) != null)
				{
					GSPacketIn gSPacketIn = new GSPacketIn(212);
					gSPacketIn.WriteInt(num);
					client.Out.SendTCP(gSPacketIn);
				}
				else
				{
					client.Player.SendMessage(LanguageMgr.GetTranslation("SpaRoomLoginHandler.Failed4"));
				}
			}
			return 0;
        }
    }
}
