using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.MOVE)]
    public class Move : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            var vx = packet.ReadInt();
            var vy = packet.ReadInt();
            var str = packet.ReadString();

            var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, Player.PlayerCharacter.ID);
            pkg.WriteByte((byte)WorldBossPackageType.MOVE);
            pkg.WriteInt(Player.PlayerId);
            pkg.WriteInt(vx);
            pkg.WriteInt(vy);
            pkg.WriteString(str);
            Player.SendTCP(pkg);
            RoomMgr.WorldBossRoom.SendToAll(pkg, Player);
            Player.X = vx;
            Player.Y = vy;
            //Console.WriteLine(string.Format("vx{0} vy{1}", vx, vy));
            return 0;
        }
    }
}