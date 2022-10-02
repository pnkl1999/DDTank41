using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.STAUTS)]
    public class Status : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            byte state = packet.ReadByte();
            if (state != 3 || Player.States != 3)
            {
                var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, Player.PlayerCharacter.ID);
                pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_PLAYERSTAUTSUPDATE);
                pkg.WriteInt(Player.PlayerId);
                pkg.WriteByte(state);
                pkg.WriteInt(Player.X);
                pkg.WriteInt(Player.Y);
                RoomMgr.WorldBossRoom.SendToAll(pkg);
                if (state == 3 && Player.CurrentRoom.Game != null)
                {
                    Player.CurrentRoom.RemovePlayerUnsafe(Player);
                }

                var name = Player.PlayerCharacter.NickName;
                RoomMgr.WorldBossRoom.SendPrivateInfo(name);
            }

            Player.States = state;

            return 0;
        }
    }
}