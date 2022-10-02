using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(230, "Send achievement finish")]
	public class AchievementFinishHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			AchievementInfo achievementInfo = client.Player.AchievementInventory.FindAchievement(num);
			if (new PlayerBussiness().GetUserAchievementData(client.Player.PlayerCharacter.ID, num).Count == 0)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(230, client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(num);
				DateTime now = DateTime.Now;
				gSPacketIn.WriteInt(now.Year);
				gSPacketIn.WriteInt(now.Month);
				gSPacketIn.WriteInt(now.Day);
				client.Player.AchievementInventory.AddAchievementData(achievementInfo);
				client.Player.AchievementInventory.SendReward(achievementInfo);
				client.Player.OnAchievementQuest();
				client.Player.AchievementInventory.SaveToDatabase();
				client.SendTCP(gSPacketIn);
			}
			return 0;
        }
    }
}
