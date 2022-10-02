using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Game.Server.Packets.Client;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using Bussiness;

[PacketHandler(216, "卡牌系统")]
internal class CardDataHandler : IPacketHandler
{
    public static Random random = new Random();

    public int HandlePacket(GameClient client, GSPacketIn packet)
    {
        int cmdCard = packet.ReadInt();
        int slot = 0;
        int place = 0;
        CardInventory cardBag = client.Player.CardBag;
        ItemInfo itemInfo = null;
        List<ItemInfo> list = new List<ItemInfo>();
        List<UsersCardInfo> infos;
        using (PlayerBussiness playerBussiness = new PlayerBussiness())
        {
            infos = playerBussiness.GetUserCardEuqip(client.Player.PlayerCharacter.ID);
        }
        cardBag.BeginChanges();
        switch (cmdCard)
        {
            case 0:
                slot = packet.ReadInt();
                place = packet.ReadInt();
                if (slot == place && slot >= 5)
                {
                    return 0;
                }
                if ((slot < 5 && place >= 5) || (slot == place && slot < 5))
                {
                    cardBag.RemoveCardAt(slot);
                    client.Player.EquipBag.UpdatePlayerProperties();
                }
                else if (slot >= 5 && place < 5)
                {
                    UsersCardInfo itemAt2 = cardBag.GetItemAt(slot);
                    if (itemAt2 != null)
                    {
                        if (!cardBag.IsCardEquip(itemAt2.TemplateID))
                        {
                            cardBag.RemoveCardAt(place);
                            UsersCardInfo usersCardInfo2 = itemAt2.Clone();
                            usersCardInfo2.Count = 0;
                            cardBag.AddCardTo(usersCardInfo2, place);
                            client.Player.OnEquipCardEvent();
                            client.Player.EquipBag.UpdatePlayerProperties();
                        }
                        else
                        {
                            client.Player.SendMessage("Thẻ bài này đã được trang bị.");
                        }
                    }
                }
                else
                {
                    cardBag.MoveCard(slot, place);
                }
                break;
            case 1:
                {
                    place = packet.ReadInt();
                    UsersCardInfo usersCardInfo = new UsersCardInfo();
                    usersCardInfo.Count = -1;
                    usersCardInfo.UserID = client.Player.PlayerCharacter.ID;
                    usersCardInfo.Place = place;
                    usersCardInfo.TemplateID = 314101;
                    usersCardInfo.isFirstGet = true;
                    usersCardInfo.Damage = 0;
                    usersCardInfo.Guard = 0;
                    usersCardInfo.Attack = 0;
                    usersCardInfo.Defence = 0;
                    usersCardInfo.Luck = 0;
                    usersCardInfo.Agility = 0;
                    client.Player.CardBag.AddCardTo(usersCardInfo, place);
                    break;
                }
            case 2:
                {
                    slot = packet.ReadInt();
                    int count = packet.ReadInt();
                    itemInfo = client.Player.EquipBag.GetItemAt(slot);
                    if (itemInfo != null)
                    {
                        if (count <= 0 || count > itemInfo.Count)
                        {
                            client.Player.SendMessage("Thẻ bài không tồn tại.");
                            return 0;
                        }
                        int property = itemInfo.Template.Property5;
                        ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(property);
                        if (itemTemplateInfo == null || itemTemplateInfo.CategoryID != 26)
                        {
                            client.Player.SendMessage("Thẻ bài không tồn tại.");
                            return 0;
                        }
                        client.Player.EquipBag.RemoveCountFromStack(itemInfo, itemInfo.Count);
                        int num5 = itemInfo.Count;
                        Random random2 = new Random();
                        for (int i = 0; i < itemInfo.Count; i++)
                        {
                            num5 += random2.Next(1, 3);
                        }
                        cardBag.AddCard(property, num5);
                    }
                    else
                    {
                        client.Player.SendMessage("Thẻ bài không tồn tại.");
                    }
                    break;
                }
            case 3:
                {
                    slot = packet.ReadInt();
                    if (slot < 5)
                    {
                        return 0;
                    }
                    UsersCardInfo itemAt = cardBag.GetItemAt(slot);
                    if (itemAt == null)
                    {
                        break;
                    }
                    if (itemAt.Level < CardMgr.MaxLevel())
                    {
                        CardUpdateConditionInfo cardUpdateCondition = CardMgr.GetCardUpdateCondition(itemAt.Level + 1);
                        if (cardUpdateCondition != null && itemAt.Count >= cardUpdateCondition.UpdateCardCount)
                        {
                            Random random = new Random();
                            itemAt.Count -= cardUpdateCondition.UpdateCardCount;
                            itemAt.CardGP += random.Next(cardUpdateCondition.MinExp, cardUpdateCondition.MaxExp);
                            if (itemAt.CardGP >= cardUpdateCondition.Exp)
                            {
                                CardUpdateInfo cardUpdateInfo = CardMgr.GetCardUpdateInfo(itemAt.TemplateID, cardUpdateCondition.Level);
                                if (cardUpdateInfo != null)
                                {
                                    itemAt.Level++;
                                    itemAt.Attack += cardUpdateInfo.Attack;
                                    itemAt.Defence += cardUpdateInfo.Defend;
                                    itemAt.Agility += cardUpdateInfo.Agility;
                                    itemAt.Luck += cardUpdateInfo.Lucky;
                                    itemAt.Damage += cardUpdateInfo.Damage;
                                    itemAt.Guard += cardUpdateInfo.Guard;
                                    UsersCardInfo cardEquip = cardBag.GetCardEquip(itemAt.TemplateID);
                                    if (cardEquip != null)
                                    {
                                        cardEquip.CopyProp(itemAt);
                                        cardBag.UpdateCard(cardEquip);
                                        client.Player.EquipBag.UpdatePlayerProperties();
                                        client.Player.OnEquipCardEvent();
                                    }
                                }
                                else
                                {
                                    Console.WriteLine("cardUpInfo is null - " + itemAt.TemplateID + " - " + cardUpdateCondition.Level + " - exp: " + cardUpdateCondition.Exp);
                                }
                            }
                            cardBag.UpdateCard(itemAt);
                        }
                        else
                        {
                            client.Player.SendMessage("Bạn không có đủ số lượng thẻ bài để tăng cấp.");
                        }
                    }
                    else
                    {
                        client.Player.SendMessage("Thẻ của bạn đã đạt cấp cao nhất không thể tiếp tục.");
                    }
                    break;
                }
            case 4:
                packet.ReadInt();
                packet.ReadInt();
                break;
        }
        cardBag.CommitChanges();
        return 0;
    }
}
