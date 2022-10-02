using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.ADDPLAYERS)]
    public class AddPlayer : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            var vx = packet.ReadInt();
            var vy = packet.ReadInt();

            Player.X = vx;
            Player.Y = vy;

            Player.CurrentRoom?.RemovePlayerUnsafe(Player);
            if (RoomMgr.WorldBossRoom.AddPlayer(Player))
            {
                RoomMgr.WorldBossRoom.ViewOtherPlayerRoom(Player);
            }

            return 0;
        }
    }
}