using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using Game.Server.Rooms;
using Game.Server.Statics;

namespace Game.Server.WorldBoss.Handle
{
    [WorldBossHandle((byte)WorldBossGamePackageType.REQUEST_REVIVE)]
    public class RequestRevive : IWorldBossCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            //var type = packet.ReadInt(); //1: hồi sinh, 2: chiến đấu
            //var isBand = packet.ReadBoolean();
            //var needMoney = 0;// RoomMgr.WorldBossRoom.ReviveMoney;
            //if (type == 2)
            //{
            //    needMoney = 0;// RoomMgr.WorldBossRoom.ReFightMoney;
            //}

            //if (Player.MoneyDirect(/*isBand ? MoneyType.DDTMoney : MoneyType.Money, */needMoney, IsAntiMult: false))
            //{
            //    var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, Player.PlayerCharacter.ID);
            //    pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_PLAYER_REVIVE);
            //    pkg.WriteInt(Player.PlayerId);
            //    RoomMgr.WorldBossRoom.SendToAll(pkg);
            //}

            int type = packet.ReadInt();//1: hồi sinh, 2: chiến đấu
            bool isBand = packet.ReadBoolean();
            int needMoney = RoomMgr.WorldBossRoom.ReviveMoney;
            if (type == 2)
            {
                needMoney = RoomMgr.WorldBossRoom.ReFightMoney;
            }
            if (Player.MoneyDirect(needMoney, IsAntiMult: false, false))
            {
                var pkg = new GSPacketIn((byte)ePackageType.WORLDBOSS_CMD, Player.PlayerCharacter.ID);
                pkg.WriteByte((byte)WorldBossPackageType.WORLDBOSS_PLAYER_REVIVE);
                pkg.WriteInt(Player.PlayerId);
                RoomMgr.WorldBossRoom.SendToAll(pkg);
            }

            return 0;
        }
    }
}