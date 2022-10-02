using System;
using Game.Base.Packets;
using Game.Server.GameObjects;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.SAVE_DB, "场景用户离开")]
    public class SaveToDB : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            client.Player.SaveIntoDatabase();
            return 0;
        }
    }
}
