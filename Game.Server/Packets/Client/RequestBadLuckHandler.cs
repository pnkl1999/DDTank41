using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Linq;

namespace Game.Server.Packets.Client
{
    [PacketHandler(45, "打开物品")]
	public class RequestBadLuckHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(45);
			gSPacketIn.WriteString(WorldMgr.LastTimeUpdateCaddyRank.ToString());
			List<UsersExtraInfo> list = WorldMgr.CaddyRank.Values.ToList();
			gSPacketIn.WriteInt(list.Count);
			int num = 1;
			foreach (UsersExtraInfo item in list)
			{
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteInt(item.UserID);
				gSPacketIn.WriteInt(item.TotalCaddyOpen);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteString(item.NickName);
				num++;
			}
			client.Player.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
