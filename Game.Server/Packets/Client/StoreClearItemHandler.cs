using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(122, "物品强化")]
	public class StoreClearItemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			client.Player.ClearStoreBag();
			return 0;
        }
    }
}
