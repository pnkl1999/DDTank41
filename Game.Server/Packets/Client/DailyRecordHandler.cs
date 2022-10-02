using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(103, "DailyRecord")]
	public class DailyRecordHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn pkg)
        {
			PlayerBussiness playerBussiness = new PlayerBussiness();
			DailyRecordInfo[] dailyRecord = playerBussiness.GetDailyRecord(client.Player.PlayerCharacter.ID);
			int num = dailyRecord.Length;
			GSPacketIn gSPacketIn = new GSPacketIn(103, client.Player.PlayerId);
			gSPacketIn.WriteInt(num);
			for (int i = 0; i < num; i++)
			{
				DailyRecordInfo dailyRecordInfo = dailyRecord[i];
				gSPacketIn.WriteInt(dailyRecordInfo.Type);
				gSPacketIn.WriteString(dailyRecordInfo.Value);
				playerBussiness.DeleteDailyRecord(client.Player.PlayerId, dailyRecordInfo.Type);
			}
			client.Out.SendTCP(gSPacketIn);
			return 1;
        }

        private bool isUpdate(int type)
        {
			if ((uint)(type - 10) <= 10u)
			{
				return true;
			}
			return false;
        }
    }
}
