using System;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Game.Server.GameUtils;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.USE_REWORK_NAME, "场景用户离开")]
    public class UseReworkNameHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            byte bag = packet.ReadByte();
            int place = packet.ReadInt();
            string newNickname = packet.ReadString();//.Trim();
            string msg = LanguageMgr.GetTranslation("UseReworkNameHandler.Msg");
            PlayerInventory inventory = client.Player.GetInventory((eBageType)bag);
            ItemInfo card = inventory.GetItemAt(place);
            string specialCharacters = @"%!@#$%^&*()?/>.<,:;'\|}]{[_~`+=-" + "\"";
            char[] specialCharactersArray = specialCharacters.ToCharArray();
            if (newNickname.IndexOfAny(specialCharactersArray) != -1)
            {
                client.Player.SendMessage(LanguageMgr.GetTranslation("UseReworkNameHandler.HasSpecialCharacters"));
                return 0;
            }
            if (card.TemplateID == (int)EquipType.CHANGE_NAME_CARD)
            {
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    if (pb.RenameNick(client.Player.PlayerCharacter.UserName, client.Player.PlayerCharacter.NickName, newNickname))
                    {
                        inventory.RemoveCountFromStack(card, 1);
                        msg = "";
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
