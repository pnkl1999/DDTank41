using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(119, "物品比较")]
	public class GetLinkGoodsHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			packet.ReadString();
			int itemID = packet.ReadInt();
			GSPacketIn gSPacketIn = new GSPacketIn(119, client.Player.PlayerCharacter.ID);
			string nickName = client.Player.PlayerCharacter.NickName;
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			gSPacketIn.WriteInt(num);
			switch (num)
			{
			case 4:
				gSPacketIn.WriteString(nickName);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			case 5:
				packet.ReadString();
				gSPacketIn.WriteString(nickName);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(0);
				client.Out.SendTCP(gSPacketIn);
				return 0;
			default:
			{
				ItemInfo userItemSingle = playerBussiness.GetUserItemSingle(itemID);
				if (userItemSingle != null)
				{
					gSPacketIn.WriteString(nickName);
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
					gSPacketIn.WriteString(userItemSingle.Template.Pic);
					gSPacketIn.WriteInt(userItemSingle.RefineryLevel);
					gSPacketIn.WriteDateTime(DateTime.Now);
					gSPacketIn.WriteByte((byte)userItemSingle.Hole5Level);
					gSPacketIn.WriteInt(userItemSingle.Hole5Exp);
					gSPacketIn.WriteByte((byte)userItemSingle.Hole6Level);
					gSPacketIn.WriteInt(userItemSingle.Hole6Exp);
					client.Out.SendTCP(gSPacketIn);
				}
				return 1;
			}
			}
        }
    }
}
