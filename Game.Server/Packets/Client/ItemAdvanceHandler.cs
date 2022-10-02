using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;
using System.Configuration;
using Game.Server.Managers;
using Game.Server.Statics;
using Game.Server.GameObjects;
using Game.Server.GameUtils;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.ITEM_ADVANCE, "物品强化")]
    public class ItemAdvanceHandler : IPacketHandler
    {
        public static ThreadSafeRandom random = new ThreadSafeRandom();
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            StringBuilder str = new StringBuilder();
            int RateAdvance = GameProperties.RateAdvance;
            bool isBinds = false;
            bool consortia = packet.ReadBoolean();
            bool MultiSelected = packet.ReadBoolean();

            //GSPacketIn pkg = packet.Clone();
            //pkg.ClearContext();           
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.ITEM_ADVANCE, client.Player.PlayerCharacter.ID);

            ItemInfo stone = client.Player.StoreBag.GetItemAt(0);
            ItemInfo item = client.Player.StoreBag.GetItemAt(1);
            int oldLv = item.StrengthenLevel;
            if (stone == null || item == null || stone.Count <= 0)
            {
                client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg1")); ;
                return 0;
            }
            if (oldLv >= 15)
            {
                client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg2"));
                return 0;
            }
            int removeCount = 1;
            string AddItem = "";
            item.StrengthenTimes = (int)(DateTime.Now.Date.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
            if (item != null && item.Template.CanStrengthen && item.Template.CategoryID < 18 && item.Count == 1)
            {
                isBinds = isBinds ? true : item.IsBinds;
                str.Append(item.ItemID + ":" + item.TemplateID + ",");
                int stoneExp = 0;
                if (stone.TemplateID == (int)EquipType.EXALT_ROCK)
                {
                    isBinds = isBinds ? true : stone.IsBinds;
                    AddItem += "," + stone.ItemID.ToString() + ":" + stone.Template.Name;
                    stoneExp = stone.Template.Property2 < 10 ? 10 : stone.Template.Property2;
                }
                else
                {
                    client.Out.SendMessage(eMessageType.ERROR, LanguageMgr.GetTranslation("ItemAdvanceHandler.Msg3"));
                    return 0;
                }

                str.Append("true");
                bool isUp = false;
                int rand = random.Next(RateAdvance);
                double probability = item.StrengthenExp / oldLv;

                if (probability > rand)
                {
                    item.IsBinds = isBinds;
                    item.StrengthenLevel++;
                    item.StrengthenExp = 0;
                    pkg.WriteByte(0);
                    pkg.WriteInt(stoneExp);
                    isUp = true;
                    StrengthenGoodsInfo strengthenGoodsInfo = StrengthenMgr.FindStrengthenGoodsInfo(item.StrengthenLevel, item.TemplateID);
                    if (strengthenGoodsInfo != null && item.Template.CategoryID == 7 && strengthenGoodsInfo.GainEquip > item.TemplateID)
                    {
                        ItemTemplateInfo _temp = ItemMgr.FindItemTemplate(strengthenGoodsInfo.GainEquip);
                        if (_temp != null)
                        {
                            ItemInfo newItem = ItemInfo.CloneFromTemplate(_temp, item);
                            client.Player.StoreBag.RemoveItemAt(1);
                            client.Player.StoreBag.AddItemTo(newItem, 1);
                            item = newItem;
                        }
                    }
                }
                else
                {
                    item.StrengthenExp += stoneExp;
                    pkg.WriteByte(1);
                    pkg.WriteInt(stoneExp);
                }
                client.Player.StoreBag.RemoveCountFromStack(stone, removeCount);
                client.Player.StoreBag.UpdateItem(item);
                //LogMgr.LogItemAdd(client.Player.PlayerCharacter.ID, LogItemType.Strengthen, BeginProperty, item, AddItem, 1);//强化日志                
                client.Out.SendTCP(pkg);
                //if (item.ItemID == 0)
                //    client.Player.StoreBag.SaveToDatabase();
                if (isUp && item.ItemID > 0)
                {
                    string msg = LanguageMgr.GetTranslation("ItemStrengthenHandler.congratulation2", client.Player.ZoneName, client.Player.PlayerCharacter.NickName, item.TemplateID, item.StrengthenLevel - 12);
                    GSPacketIn sys_notice = WorldMgr.SendSysNotice(eMessageType.SYS_TIP_NOTICE, msg, item.ItemID, item.TemplateID/*, client.Player.ZoneId*/, null);
                    GameServer.Instance.LoginServer.SendPacket(sys_notice);
                }

                str.Append(item.StrengthenLevel);
            }
            else
            {
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("ItemStrengthenHandler.Content1") + stone.Template.Name + LanguageMgr.GetTranslation("ItemStrengthenHandler.Content2"));
            }
            if (item.Place < 31)
            {
                client.Player.EquipBag.UpdatePlayerProperties();
            }

            return 0;
        }


    }
}