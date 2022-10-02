using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.LEAVE_ROOM)]
    public class LeaveRoom : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            RoomMgr.WorldBossRoom.RemovePlayer(Player);
            Player.ClearFightBuffOneMatch();
            return 0;
        }
    }
}