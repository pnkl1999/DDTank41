using Bussiness;
using Game.Base.Packets;
using Game.Server.HotSpringRooms;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.HOTSPRING_ROOM_ENTER, "礼堂数据")]
    public class HotSpringRoomEnterHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            //int id = packet.ReadInt();
            //packet.ReadString();
            int needGold = 10000;
            int roomId = packet.ReadInt();
            string pass = packet.ReadString();
            if (client.Player.CurrentHotSpringRoom == null)
            {
                HotSpringRoom room = HotSpringMgr.GetHotSpringRoombyID(roomId);
                if (room != null)
                {
                    //if (hotSpringRoombyID.Info.roomID <= 4)
                    //{
                    //	int num = 10000;
                    //	if (client.Player.PlayerCharacter.Gold >= num)
                    //	{
                    //		if (hotSpringRoombyID.AddPlayer(client.Player) && client.Player.RemoveGold(num) > 0)
                    //		{
                    //			client.Out.SendEnterHotSpringRoom(client.Player);
                    //		}
                    //	}
                    //	else
                    //	{
                    //		client.Player.SendMessage("Không đủ Vàng để vào Suối Nước Nóng.");
                    //	}
                    //}
                    //if (hotSpringRoombyID.Info.roomID >= 5)
                    //{
                    //	int num2 = 2500;
                    //	if (client.Player.PlayerCharacter.Money >= num2)
                    //	{
                    //		if (hotSpringRoombyID.AddPlayer(client.Player) && client.Player.RemoveMoney(num2) > 0)
                    //		{
                    //			client.Out.SendEnterHotSpringRoom(client.Player);
                    //		}
                    //	}
                    //	else
                    //	{
                    //		client.Player.SendMessage("Không đủ Xu để vào Suối Nước Nóng.");
                    //	}
                    //}
                    if (client.Player.PlayerCharacter.Gold < needGold)
                    {
                        client.Player.SendMessage(LanguageMgr.GetTranslation("HotSpringRoomEnterDataHandler.NotEmoughtGold"));
                        return 0;
                    }
                    else
                    {
                        if (room.AddPlayer(client.Player) && client.Player.RemoveGold(needGold) > 0)
                        {
                            client.Out.SendEnterHotSpringRoom(client.Player);
                        }
                    }
                }
                else
                {
                    client.Player.SendMessage(LanguageMgr.GetTranslation("SpaRoomLoginHandler.Failed4"));
                }
            }
            return 0;
        }
    }
}
