using System;
using Bussiness;
using Game.Base.Packets;
using Game.Server.Quests;

namespace Game.Server.Packets.Client
{
	[PacketHandler((int)ePackageType.QUEST_FINISH, "任务完成")]
	public class QuestFinishHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int id = packet.ReadInt();
			int rewardItemID = packet.ReadInt();
			if (DateTime.Compare(client.Player.LastDrillUpTime.AddSeconds(1), DateTime.Now) > 0)
			{
				return 0;
			}
			client.Player.LastDrillUpTime = DateTime.Now;
			BaseQuest baseQuest = client.Player.QuestInventory.FindQuest(id);
			bool result = false;
			if (baseQuest != null)
			{
				result = client.Player.QuestInventory.Finish(baseQuest, rewardItemID);
			}
			if (result)
			{
				//client.Player.OnQuestFinish(baseQuest.Data, baseQuest.Info);
				GSPacketIn pkg = new GSPacketIn((byte)ePackageType.QUEST_FINISH, client.Player.PlayerCharacter.ID);
				pkg.WriteInt(id);
				client.Out.SendTCP(pkg);
			}
			return 1;
		}
	}
}
