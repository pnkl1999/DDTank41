using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.LITTLEGAME_COMMAND, "温泉小游戏")]
    public class LittleGameHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            client.Player.LittleGame?.ProcessData(client.Player, packet);
            return 0;
        }
    }
}