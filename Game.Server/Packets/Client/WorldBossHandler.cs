using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Buffer;
using Game.Server.Rooms;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.WORLDBOSS_CMD, "场景用户离开")]
    public class WorldBossHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            client.Player.WorldBoss?.ProcessData(client.Player, packet);
            return 0;
        }
    }
}