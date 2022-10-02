using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.ENTER_WORLDBOSSROOM)]
    public class EnterRoom : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, Player.PlayerCharacter.ID);
            pkg.WriteByte((byte)WorldBossPackageType.CANENTER);
            pkg.WriteBoolean(true);
            pkg.WriteBoolean(false);
            pkg.WriteInt(0);
            pkg.WriteInt(0);
            Player.Out.SendTCP(pkg);
            return 0;
        }
    }
}