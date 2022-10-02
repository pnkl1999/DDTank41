using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class PlayerOnlineSpaCondiction : BaseCondition
    {
        public PlayerOnlineSpaCondiction(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.HotSpingExpAdd += SpringOnline;
        }

        private void SpringOnline(int minitues, int exp)
        {
			if (base.Value > 0)
			{
				base.Value--;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.HotSpingExpAdd -= SpringOnline;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }
    }
}
