using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    public interface IPacketHandler
    {
        int HandlePacket(GameClient client, GSPacketIn packet);
    }
}
