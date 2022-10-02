using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(119, "物品比较")]
	public class ItemCompareHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (packet.ReadInt() != 2)
			{
				return 0;
			}
			int itemID = packet.ReadInt();
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			ItemInfo userItemSingle = playerBussiness.GetUserItemSingle(itemID);
			if (userItemSingle != null)
			{
				GSPacketIn gSPacketIn = new GSPacketIn(119, client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteInt(userItemSingle.TemplateID);
				gSPacketIn.WriteInt(userItemSingle.ItemID);
				gSPacketIn.WriteInt(userItemSingle.StrengthenLevel);
				gSPacketIn.WriteInt(userItemSingle.AttackCompose);
				gSPacketIn.WriteInt(userItemSingle.AgilityCompose);
				gSPacketIn.WriteInt(userItemSingle.LuckCompose);
				gSPacketIn.WriteInt(userItemSingle.DefendCompose);
				gSPacketIn.WriteInt(userItemSingle.ValidDate);
				gSPacketIn.WriteBoolean(userItemSingle.IsBinds);
				gSPacketIn.WriteBoolean(userItemSingle.IsJudge);
				gSPacketIn.WriteBoolean(userItemSingle.IsUsed);
				if (userItemSingle.IsUsed)
				{
					gSPacketIn.WriteString(userItemSingle.BeginDate.ToString());
				}
				gSPacketIn.WriteInt(userItemSingle.Hole1);
				gSPacketIn.WriteInt(userItemSingle.Hole2);
				gSPacketIn.WriteInt(userItemSingle.Hole3);
				gSPacketIn.WriteInt(userItemSingle.Hole4);
				gSPacketIn.WriteInt(userItemSingle.Hole5);
				gSPacketIn.WriteInt(userItemSingle.Hole6);
				gSPacketIn.WriteString(userItemSingle.Template.Hole);
				client.Out.SendTCP(gSPacketIn);
			}
			return 1;
        }
    }
}
