using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(203, "场景用户离开")]
	public class LookupEffortHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			using (PlayerBussiness playerBussiness = new PlayerBussiness())
			{
				AchievementData[] userAchievement = playerBussiness.GetUserAchievement(num);
				PlayerInfo userSingleByUserID = playerBussiness.GetUserSingleByUserID(num);
				GSPacketIn gSPacketIn = new GSPacketIn(203, num);
                if (userSingleByUserID == null)
                {
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
					gSPacketIn.WriteInt(0);
					return 0;
				}
				gSPacketIn.WriteInt(userSingleByUserID.AchievementPoint);
				gSPacketIn.WriteInt(userAchievement.Length);
				AchievementData[] array = userAchievement;
				foreach (AchievementData achievementData in array)
				{
					gSPacketIn.WriteInt(achievementData.AchievementID);
				}
				client.SendTCP(gSPacketIn);
			}
			return 0;
        }
    }
}
