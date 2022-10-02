using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(73, "大喇叭")]
    public class CBugleHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int templateId = 11100;
            int clientId = packet.ReadInt();
            ItemInfo itemByTemplateID = client.Player.PropBag.GetItemByTemplateID(0, templateId);
            if (DateTime.Compare(client.Player.LastChatTime.AddSeconds(2.0), DateTime.Now) > 0)
            {
                client.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("GoSlow"));
                return 1;
            }
            GSPacketIn gSPacketIn = new GSPacketIn(73, clientId);
            if (itemByTemplateID != null)
            {
                packet.ReadString();
                string str = packet.ReadString();
                client.Player.PropBag.RemoveCountFromStack(itemByTemplateID, 1);
                gSPacketIn.WriteInt(client.Player.ZoneId);
                gSPacketIn.WriteInt(client.Player.PlayerCharacter.ID);
                gSPacketIn.WriteString(client.Player.PlayerCharacter.NickName);
                gSPacketIn.WriteString(str);
                gSPacketIn.WriteString(client.Player.ZoneName);
                //GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
                foreach (var item in GameServer.Instance.OtherLoginServer)
                {
                    if (item.IsConnected)
                    {
                        //GSPacketIn gSPacketIn2 = new GSPacketIn(72);
                        //gSPacketIn2.WriteInt(itemByTemplateID.Template.Property2);
                        //gSPacketIn2.WriteInt(client.Player.PlayerCharacter.ID);
                        //gSPacketIn2.WriteString(client.Player.PlayerCharacter.NickName);
                        //gSPacketIn2.WriteString(str);
                        //item.SendPacket(gSPacketIn2);
                        item.SendPacket(gSPacketIn);
                    }

                }
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
