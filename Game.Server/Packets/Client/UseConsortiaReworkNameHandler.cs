using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.USE_CONSORTIA_REWORK_NAME, "场景用户离开")]
    public class UseConsortiaReworkNameHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int consortiaID = packet.ReadInt();
            byte bag = packet.ReadByte();
            int place = packet.ReadInt();
            string newNickname = packet.ReadString();
            string msg = "";
            if (client.Player.PlayerCharacter.ConsortiaID == 0)
                return 0;

            PlayerInventory inventory = client.Player.GetInventory((eBageType)bag);
            ItemInfo card = inventory.GetItemAt(place);
            if (card.TemplateID == (int)EquipType.CONSORTIA_CHANGE_NAME_CARD)
            {

                using (ConsortiaBussiness pb = new ConsortiaBussiness())
                {
                    ConsortiaInfo info = pb.GetConsortiaSingle(consortiaID);
                    if (info == null)
                    {
                        client.Player.SendMessage(LanguageMgr.GetTranslation("UseConsortiaReworkNameHandler.Msg1"));
                        return 0;
                    }
                    else
                    {
                        if (client.Player.PlayerCharacter.ID != info.ChairmanID)
                        {
                            client.Player.SendMessage(LanguageMgr.GetTranslation("UseConsortiaReworkNameHandler.Msg2"));
                            return 0;
                        }
                    }
                    if (pb.RenameConsortia(consortiaID, client.Player.PlayerCharacter.NickName, newNickname))
                    {
                        inventory.RemoveCountFromStack(card, 1);
                    }
                    else
                    {
                        msg = LanguageMgr.GetTranslation("UseConsortiaReworkNameHandler.Msg3");
                    }
                }
            }
            if (msg != "")
            {
                client.Player.SendMessage(msg);
            }
            return 0;
        }
    }
}
