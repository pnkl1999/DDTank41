using Game.Base.Packets;
using Game.Server.Quests;

namespace Game.Server.Packets.Client
{
	[PacketHandler(177, "删除任务")]
	public class QuestRemoveHandler : IPacketHandler
	{
		public int HandlePacket(GameClient client, GSPacketIn packet)
		{
			int id = packet.ReadInt();
			BaseQuest baseQuest = client.Player.QuestInventory.FindQuest(id);
			if (baseQuest != null)
			{
				client.Player.QuestInventory.RemoveQuest(baseQuest);
			}
			return 0;
		}
	}
}
