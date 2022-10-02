using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.GameObjects;
using Game.Base.Packets;
using Bussiness;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using Game.Server.Statics;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.AUCTION_ADD, "添加拍卖")]
    public class AuctionAddHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            eBageType bagType = (eBageType)packet.ReadByte();
            int place = packet.ReadInt();
            int payType = packet.ReadByte();
            int price = packet.ReadInt();
            int mouthful = packet.ReadInt();
            int validDate = packet.ReadInt();
            int goodsCount = packet.ReadInt();

            string msg = "AuctionAddHandler.Fail";
            payType = 1;

            if (client.Player.isPlayerWarrior())
            {
                client.Out.SendMessage(eMessageType.GM_NOTICE, "Tài khoản không có quyền thực hiện chức năng này.");
                return 0;
            }
            if (client.Player.PlayerCharacter.HasBagPassword && client.Player.PlayerCharacter.IsLocked)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("Bag.Locked"));
                return 0;
            }

            if (price < 0 || (mouthful != 0 && mouthful < price))
                return 0;

            int multiple = 1;
            if (payType != 0)
            {
                //multiple = 10;
                multiple = 1;
                payType = 1;
            }
            int needGold = (int)(multiple * price * 0.03 * (validDate == 0 ? 1 : validDate == 1 ? 3 : 6));
            needGold = needGold < 1 ? 1 : needGold;
            ItemInfo goods = client.Player.GetItemAt(bagType, place);
            if (goods == null)
            {
                client.Player.SendMessage(LanguageMgr.GetTranslation("AuctionAddHandler.Msg13"));
                return 0;
            }

            if (goods.Count < goodsCount || goodsCount < 0)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("AuctionAddHandler.Msg11"));
                return 0;
            }
            if (client.Player.IsLimitCount(goodsCount))
                return 0;

            int TotalItemAt = goods.Count - goodsCount;
            int limit = GameProperties.LimitLevel(1);
            if (client.Player.PlayerCharacter.Grade < limit)
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("AuctionAddHandler.Msg12", limit));
                return 0;
            }
            if (price < 0)
            {
                msg = "AuctionAddHandler.Msg1";
            }
            else if (mouthful != 0 && mouthful < price)
            {
                msg = "AuctionAddHandler.Msg2";
            }
            else if (needGold > client.Player.PlayerCharacter.Gold)
            {
                msg = "AuctionAddHandler.Msg3";
            }
            else if (goods == null)
            {
                msg = "AuctionAddHandler.Msg4";
            }
            else if (goods.IsBinds)
            {
                msg = "AuctionAddHandler.Msg5";
            }
            else
            {
                ItemInfo newitem = ItemInfo.CloneFromTemplate(goods.Template, goods);
                ItemInfo itemAddAution = ItemInfo.CloneFromTemplate(goods.Template, goods);
                itemAddAution.Count = goodsCount;
                //Console.WriteLine("goodsCount: " + goodsCount);
                if (itemAddAution.ItemID == 0)
                {
                    using (PlayerBussiness playerBussiness = new PlayerBussiness())
                        playerBussiness.AddGoods(itemAddAution);
                }

                AuctionInfo info = new AuctionInfo();
                info.AuctioneerID = client.Player.PlayerCharacter.ID;//获取物品ID
                info.AuctioneerName = client.Player.PlayerCharacter.NickName;//获取物品妮称
                info.BeginDate = DateTime.Now;
                info.BuyerID = 0;
                info.BuyerName = "";
                info.IsExist = true;
                info.ItemID = itemAddAution.ItemID;
                info.Mouthful = mouthful;
                info.PayType = payType;
                info.Price = price;
                info.Rise = price / 10;
                info.Rise = info.Rise < 1 ? 1 : info.Rise;
                info.Name = itemAddAution.Template.Name;
                info.Category = itemAddAution.Template.CategoryID;
                info.ValidDate = validDate == 0 ? 8 : validDate == 1 ? 24 : 48;
                info.TemplateID = itemAddAution.TemplateID;
                info.goodsCount = goodsCount;
                info.Random = ThreadSafeRandom.NextStatic(GameProperties.BeginAuction, GameProperties.EndAuction);
                using (PlayerBussiness db = new PlayerBussiness())//写数据库
                {
                    if (db.AddAuction(info))
                    {
                        //goods.Count = goodsCount;
                        client.Player.RemoveAt(bagType, place);// TakeOutItem(goods);
                        if (TotalItemAt > 0)
                        {
                            newitem.Count = TotalItemAt;
                            client.Player.AddTemplate(newitem, bagType, TotalItemAt, eGameView.CaddyTypeGet);
                        }
                        client.Player.SaveIntoDatabase();
                        client.Player.RemoveGold(needGold);
                        msg = "AuctionAddHandler.Msg6";
                        client.Out.SendAuctionRefresh(info, info.AuctionID, true, itemAddAution);
                    }
                }
            }
            //client.Out.SendMailResponse(client.Player.PlayerCharacter.ID, eMailRespose.Receiver);
            client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation(msg));
            return 0;
        }
    }
}