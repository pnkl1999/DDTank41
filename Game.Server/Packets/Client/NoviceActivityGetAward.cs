using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(258, "Novice Activity")]
    public class NoviceActivityGetAward : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int ActivityType = packet.ReadInt();
            int SubActivityType = packet.ReadInt();
            if (DateTime.Compare(client.Player.LastOpenCard.AddSeconds(1.5), DateTime.Now) > 0)
            {
                return 0;
            }
            bool isPlus = false;
            int awardGot = 0;
            string translateId = "Nhận quà sự kiện thành công!";
            ProduceBussiness pb = new ProduceBussiness();
            EventRewardProcessInfo eventProcess = client.Player.Extra.GetEventProcess(ActivityType);
            List<ItemInfo> list = new List<ItemInfo>();
            awardGot = ((SubActivityType == 1) ? 1 : (eventProcess.AwardGot * 2 + 1));
            switch (awardGot)
            {
                case 1:
                    SubActivityType = 1;
                    break;
                case 3:
                    SubActivityType = 2;
                    break;
                case 7:
                    SubActivityType = 3;
                    break;
                case 15:
                    SubActivityType = 4;
                    break;
                case 31:
                    SubActivityType = 5;
                    break;
                case 63:
                    SubActivityType = 6;
                    break;
                case 127:
                    SubActivityType = 7;
                    break;
                case 255:
                    SubActivityType = 8;
                    break;
                case 511:
                    SubActivityType = 9;
                    break;
            }
            EventRewardInfo[] info = pb.GetEventRewardInfoByType(ActivityType, SubActivityType);
            EventRewardGoodsInfo[] good = pb.GetEventRewardGoodsByType(ActivityType, SubActivityType);
            foreach (EventRewardGoodsInfo item in good)
            {
                ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(item.TemplateId), 1, 104);
                itemInfo.StrengthenLevel = item.StrengthLevel;
                itemInfo.AttackCompose = item.AttackCompose;
                itemInfo.DefendCompose = item.DefendCompose;
                itemInfo.AgilityCompose = item.AgilityCompose;
                itemInfo.LuckCompose = item.LuckCompose;
                itemInfo.IsBinds = item.IsBind;
                itemInfo.Count = item.Count;
                itemInfo.ValidDate = item.ValidDate;
                list.Add(itemInfo);
            }
            foreach (EventRewardInfo eventRewardInfo in info)
            {
                if (awardGot != 999)
                {
                    EventRewardProcessInfo info2 = client.Player.Extra.GetEventProcess(ActivityType);
                    if (eventRewardInfo.Condition <= info2.Conditions)
                    {
                        client.Player.Extra.UpdateEventCondition(ActivityType, eventRewardInfo.Condition, isPlus, awardGot);
                        client.Player.SendItemsToMail(list, $"Đây là thư tự động từ phần thưởng Quà Mở Máy Chủ, người chơi vui lòng không reply.", LanguageMgr.GetTranslation("Quà Mở Máy Chủ"), eMailType.Manage);
                    }
                    else
                    {
                        client.Player.SendMessage("Điều kiện không đủ! thao tác thất bại.");
                    }
                }
            }
            client.Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(translateId));
            client.Player.LastOpenCard = DateTime.Now;
            return 1;
        }
    }
}
