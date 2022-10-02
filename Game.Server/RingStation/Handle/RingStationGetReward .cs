using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_GETREWARD)]
    public class RingStationGetReward : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            UserRingStationInfo currentRing = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
            GSPacketIn pkg = new GSPacketIn((short) ePackageType.RING_STATION, Player.PlayerId);
            pkg.WriteByte((byte) RingStationPackageType.RINGSTATION_FIGHTFLAG);
            if (currentRing != null && currentRing.ReardEnable)
            {
                currentRing.ReardEnable = false;
                RingStationMgr.UpdateRingStationInfo(currentRing);
                int prestigeCount = RingStationMgr.ConfigInfo.AwardNumByRank(currentRing.Rank);
                pkg.WriteBoolean(true);
                pkg.WriteInt(currentRing.Rank);
                pkg.WriteInt(prestigeCount);
                Player.AddLeagueMoney(prestigeCount);
            }
            else
            {
                pkg.WriteBoolean(false);
            }

            Player.SendTCP(pkg);
            return true;
        }
    }
}