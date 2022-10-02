using Bussiness.Managers;
using Game.Logic;
using Game.Server.Statics;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Quests
{
    public class TurnPropertyCondition : BaseCondition
    {
        private GamePlayer m_player;

        private BaseQuest m_quest;

        public TurnPropertyCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
			m_quest = quest;
        }

        public override void AddTrigger(GamePlayer player)
        {
			m_player = player;
			player.GameKillDrop += QuestDropItem;
			base.AddTrigger(player);
        }

        public override bool CancelFinish(GamePlayer player)
        {
			ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(m_info.Para1);
			if (itemTemplateInfo != null)
			{
				ItemInfo cloneItem = ItemInfo.CreateFromTemplate(itemTemplateInfo, m_info.Para2, 117);
				return player.AddTemplate(cloneItem, eBageType.TempBag, m_info.Para2, eGameView.OtherTypeGet);
			}
			return false;
        }

        public override bool Finish(GamePlayer player)
        {
			return player.RemoveTemplate(m_info.Para1, m_info.Para2);
        }

        public override bool IsCompleted(GamePlayer player)
        {
			bool result = false;
			if (player.GetItemCount(m_info.Para1) >= m_info.Para2)
			{
				base.Value = 0;
				result = true;
			}
			return result;
        }

        private void QuestDropItem(AbstractGame game, int copyId, int npcId, bool playResult)
        {
			if (m_player.GetItemCount(m_info.Para1) >= m_info.Para2)
			{
				return;
			}
			List<ItemInfo> info = null;
			int gold = 0;
			int money = 0;
			int giftToken = 0;
			if (game is PVEGame)
			{
				DropInventory.PvEQuestsDrop(npcId, ref info);
			}
			if (game is PVPGame)
			{
				DropInventory.PvPQuestsDrop(game.RoomType, playResult, ref info);
			}
			if (info == null)
			{
				return;
			}
			foreach (ItemInfo item in info)
			{
				ItemInfo.FindSpecialItemInfo(item, ref gold, ref money, ref giftToken);
				if (item != null)
				{
					m_player.TempBag.AddTemplate(item, item.Count);
				}
			}
			m_player.AddGold(gold);
			m_player.AddGiftToken(giftToken);
			m_player.AddMoney(money);
			LogMgr.LogMoneyAdd(LogMoneyType.Award, LogMoneyType.Award_Drop, m_player.PlayerCharacter.ID, money, m_player.PlayerCharacter.Money, 0, 0, 0, "", "", "");
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.GameKillDrop -= QuestDropItem;
			base.RemoveTrigger(player);
        }
    }
}
