using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(71, "小喇叭")]
	public class SmallBugleHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			ItemInfo itemByCategoryID = client.Player.PropBag.GetItemByCategoryID(0, 11, 4);
			if (itemByCategoryID != null)
			{
				client.Player.PropBag.RemoveCountFromStack(itemByCategoryID, 1);
				client.Player.OnUsingItem(itemByCategoryID.TemplateID, 1);
				packet.ReadInt();
				packet.ReadString();
				string str = packet.ReadString();
				if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(2.0), DateTime.Now) > 0)
				{
					client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("SmallBugleHandler.Msg"));
					return 1;
				}
				GSPacketIn gSPacketIn = new GSPacketIn(71);
				gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
				gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
				gSPacketIn.WriteString(str);
				GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
				client.Player.LastChatTime = DateTime.Now;
				GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				GamePlayer[] array = allPlayers;
				foreach (GamePlayer gamePlayer in array)
				{
					gSPacketIn.ClientID = gamePlayer.PlayerCharacter.ID;
					gamePlayer.Out.SendTCP(gSPacketIn);
				}
			}
			return 0;
        }
    }
}
