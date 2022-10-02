using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_FIGHTFLAG)]
    public class RingStationFightFlag : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            GSPacketIn pkg = new GSPacketIn((short) ePackageType.RING_STATION, Player.PlayerId);
            pkg.WriteByte((byte) RingStationPackageType.RINGSTATION_FIGHTFLAG);
            pkg.WriteInt(0);
            pkg.WriteDateTime(DateTime.Now);
            Player.SendTCP(pkg);
            return true;
        }
    }
}