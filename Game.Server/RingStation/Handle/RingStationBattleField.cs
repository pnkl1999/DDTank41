using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets;
using SqlDataProvider.Data;

namespace Game.Server.RingStation.Handle
{
    [RingStationHandleAttbute((byte) RingStationPackageType.RINGSTATION_NEWBATTLEFIELD)]
    public class RingStationBattleField : IRingStationCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            RingstationBattleFieldInfo[] list = RingStationMgr.GetRingBattleFields(Player.PlayerId);
            GSPacketIn pkg = new GSPacketIn((short) ePackageType.RING_STATION, Player.PlayerId);
            pkg.WriteByte((byte) RingStationPackageType.RINGSTATION_NEWBATTLEFIELD);
            pkg.WriteInt(list.Length); // _loc_4:* = _loc_2.readInt();
            foreach (RingstationBattleFieldInfo field in list)
            {
                pkg.WriteBoolean(field
                    .DareFlag); // _loc_3.DareFlag = _loc_2.readBoolean();//true:khiêu chiến, false: bị đánh
                pkg.WriteString(field.UserName); //_loc_3.UserName = _loc_2.readUTF();
                pkg.WriteBoolean(field.SuccessFlag); //_loc_3.SuccessFlag = _loc_2.readBoolean();//kết quả
                pkg.WriteInt(field.Level); //_loc_3.Level = _loc_2.readInt();
            }

            Player.SendTCP(pkg);
            return true;
        }
    }
}