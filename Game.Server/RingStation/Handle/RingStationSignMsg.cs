using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_SENDSIGNMSG)]
    public class RingStationSignMsg : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            string signMsg = packet.ReadString();
            UserRingStationInfo currentRing = RingStationMgr.GetSingleRingStationInfos(Player.PlayerId);
            currentRing.signMsg = signMsg;
            RingStationMgr.UpdateRingStationInfo(currentRing);
            return true;
        }
    }
}