using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(12, "礼堂数据")]
	public class HotSpringRoomTimeAdded : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			byte b = packet.ReadByte();
			if (b == 11)
			{
				int spaAddictionMoneyNeeded = GameProperties.SpaAddictionMoneyNeeded;
				if (client.Player.PlayerCharacter.Money < spaAddictionMoneyNeeded)
				{
					client.Player.SendMessage("Xu của bạn không đủ.");
				}
				else
				{
					int spaPriRoomContinueTime = GameProperties.SpaPriRoomContinueTime;
					client.Player.RemoveMoney(spaAddictionMoneyNeeded);
					client.Player.Extra.Info.MinHotSpring += spaPriRoomContinueTime;
					GSPacketIn gSPacketIn = new GSPacketIn(191);
					gSPacketIn.WriteByte(12);
					client.Player.SendTCP(gSPacketIn);
					client.Player.SendMessage($"Gia hạn thành công! bạn bị trừ {spaAddictionMoneyNeeded} Xu và nhận được thêm {spaPriRoomContinueTime} Phút");
				}
			}
			return 0;
        }
    }
}
