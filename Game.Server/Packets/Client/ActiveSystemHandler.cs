using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.ACTIVITY_SYSTEM, "场景用户离开")]
    public class ActiveSystemHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            byte num = packet.ReadByte();
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ACTIVITY_SYSTEM, client.Player.PlayerCharacter.ID);
            if (num == 8)
            {
                pkg.WriteByte((byte)GuildMemberWeekPackageType.PLAYERTOP10);
                pkg.WriteInt(1);
                return 1;
            }
            return 0;
        }
    }
}
