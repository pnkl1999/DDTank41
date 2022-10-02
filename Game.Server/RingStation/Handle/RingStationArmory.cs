using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_ARMORY)]
    public class RingStationArmory : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            UserRingStationInfo[] ranks = RingStationMgr.GetRingStationRanks();
            GSPacketIn pkg = new GSPacketIn((short) ePackageType.RING_STATION, Player.PlayerId);
            pkg.WriteByte((byte) RingStationPackageType.RINGSTATION_ARMORY);
            pkg.WriteInt(ranks.Length); //var _loc_4:* = _loc_2.readInt();
            foreach (UserRingStationInfo rank in ranks)
            {
                pkg.WriteInt(rank.Rank); //    _loc_6.PlayerRank = _loc_2.readInt();
                pkg.WriteInt(rank.Info.Grade); //    _loc_6.FamLevel = _loc_2.readInt();
                pkg.WriteString(rank.Info.NickName); //    _loc_6.PlayerName = _loc_2.readUTF();
                pkg.WriteInt(rank.Info.FightPower); //    _loc_6.Fighting = _loc_2.readInt();
                pkg.WriteInt(rank.Info.Total); //    _loc_2.readInt();
            }

            Player.SendTCP(pkg);
            return true;
        }
    }
}