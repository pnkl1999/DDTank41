using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Packets.Client
{
    [PacketHandler(259, "FIRSTRECHARGE")]
	public class FirstRechargeGetAwardHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			packet.ReadInt();
			if (DateTime.Compare(client.Player.LastOpenCard.AddSeconds(0.5), DateTime.Now) > 0)
			{
				return 0;
			}
			string translateId = "FirstRechargeGetAward.Successfull";
			ProduceBussiness produceBussiness = new ProduceBussiness();
			EventRewardInfo[] eventRewardInfoByType = produceBussiness.GetEventRewardInfoByType(7, 1);
			EventRewardGoodsInfo[] eventRewardGoodsByType = produceBussiness.GetEventRewardGoodsByType(7, 1);
			List<ItemInfo> list = new List<ItemInfo>();
			EventRewardGoodsInfo[] array = eventRewardGoodsByType;
			EventRewardGoodsInfo[] array2 = array;
			foreach (EventRewardGoodsInfo eventRewardGoodsInfo in array2)
			{
				ItemInfo itemInfo = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(eventRewardGoodsInfo.TemplateId), 1, 104);
				itemInfo.StrengthenLevel = eventRewardGoodsInfo.StrengthLevel;
				itemInfo.AttackCompose = eventRewardGoodsInfo.AttackCompose;
				itemInfo.DefendCompose = eventRewardGoodsInfo.DefendCompose;
				itemInfo.AgilityCompose = eventRewardGoodsInfo.AgilityCompose;
				itemInfo.LuckCompose = eventRewardGoodsInfo.LuckCompose;
				itemInfo.IsBinds = eventRewardGoodsInfo.IsBind;
				itemInfo.Count = eventRewardGoodsInfo.Count;
				itemInfo.ValidDate = eventRewardGoodsInfo.ValidDate;
				list.Add(itemInfo);
			}
			if (!client.Player.PlayerCharacter.IsRecharged)
			{
				translateId = "FirstRechargeGetAward.NotCharge";
				return 0;
			}
			if (client.Player.PlayerCharacter.IsGetAward)
			{
				translateId = "FirstRechargeGetAward.AlreadyGetAward";
				return 0;
			}
			EventRewardInfo[] array3 = eventRewardInfoByType;
			for (int j = 0; j < array3.Length; j++)
			{
				_ = array3[j];
				if (client.Player.PlayerCharacter.IsRecharged && !client.Player.PlayerCharacter.IsGetAward)
				{
					if (!client.Player.SendItemsToMail(list, LanguageMgr.GetTranslation("FirstRechargeGetAward.Content"), LanguageMgr.GetTranslation("FirstRechargeGetAward.Title"), eMailType.Manage))
					{
						translateId = "FirstRechargeGetAward.Error";
						return 0;
					}
					client.Player.PlayerCharacter.IsGetAward = true;
				}
			}
			client.Player.Out.SendUpdateFirstRecharge(client.Player.PlayerCharacter.IsRecharged, client.Player.PlayerCharacter.IsGetAward);
			client.Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation(translateId));
			client.Player.LastOpenCard = DateTime.Now;
			return 1;
        }
    }
}
