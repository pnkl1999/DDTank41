using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class CashCondition : BaseCondition
    {
        public CashCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.MoneyCharge += player_MoneyCharge;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_MoneyCharge(int money)
        {
			base.Value -= money;
			if (m_info.Para2 <= money)
			{
				base.Value = 0;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.MoneyCharge -= player_MoneyCharge;
        }
    }
}
