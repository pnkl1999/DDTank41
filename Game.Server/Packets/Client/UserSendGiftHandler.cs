using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(221, "领取奖品")]
    public class UserSendGiftHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            string text = packet.ReadString();
            int iD = packet.ReadInt();
            int num = packet.ReadInt();
            packet.ReadInt();
            if (text == client.Player.PlayerCharacter.NickName || num <= 0 || num > 9999)
            {
                return 0;
            }
            ShopItemInfo shopItemInfoById = ShopMgr.GetShopItemInfoById(iD);
            if (shopItemInfoById == null || shopItemInfoById.AValue1 <= 0)
            {
                return 0;
            }
            GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text);
            using (PlayerBussiness playerBussiness = new PlayerBussiness())
            {
                PlayerInfo playerInfo = ((clientByPlayerNickName == null) ? playerBussiness.GetUserSingleByNickName(text) : clientByPlayerNickName.PlayerCharacter);
                if (playerInfo != null)
                {
                    int value = shopItemInfoById.AValue1 * num;
                    if (client.Player.RemoveMoney(value) > 0)
                    {
                        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(shopItemInfoById.TemplateID);
                        int num2 = itemTemplateInfo.Property2 * num;
                        playerBussiness.AddUserGift(new UserGiftInfo
                        {
                            SenderID = client.Player.PlayerCharacter.ID,
                            ReceiverID = playerInfo.ID,
                            TemplateID = itemTemplateInfo.TemplateID,
                            Count = num
                        });
                        playerBussiness.UpdateUserCharmGP(playerInfo.ID, num2);
                        if (playerBussiness.SendMail(new MailInfo
                        {
                            SenderID = client.Player.PlayerCharacter.ID,
                            Sender = client.Player.PlayerCharacter.NickName,
                            ReceiverID = playerInfo.ID,
                            Receiver = playerInfo.NickName,
                            Title = LanguageMgr.GetTranslation("UserGiftSystem.MailTitle"),
                            Content = client.Player.PlayerCharacter.NickName + LanguageMgr.GetTranslation("GoodsPresentHandler.Content") + itemTemplateInfo.Name + "]",
                            Type = 55
                        }) && clientByPlayerNickName != null)
                        {
                            clientByPlayerNickName.PlayerCharacter.charmGP += num2;
                            clientByPlayerNickName.SendUpdatePublicPlayer();
                            clientByPlayerNickName.Out.SendMailResponse(clientByPlayerNickName.PlayerCharacter.ID, eMailRespose.Gift);
                        }
                        GSPacketIn gSPacketIn = new GSPacketIn(221);
                        gSPacketIn.WriteBoolean(val: true);
                        client.SendTCP(gSPacketIn);
                        client.Player.SendMessage(LanguageMgr.GetTranslation("GoodsPresentHandler.Success"));
                    }
                    else
                    {
                        client.Player.SendMessage(LanguageMgr.GetTranslation("GoodsPresentHandler.NoMoney"));
                    }
                }
                else
                {
                    client.Player.SendMessage(LanguageMgr.GetTranslation("GoodsPresentHandler.NoUser"));
                }
            }
            return 0;
        }
    }
}
