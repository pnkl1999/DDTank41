using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class EnterHotSpringCondition : BaseCondition
    {
        public EnterHotSpringCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.EnterHotSpringEvent += method_0;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void method_0(GamePlayer gamePlayer_0)
        {
			base.Value--;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.EnterHotSpringEvent -= method_0;
        }
    }
}
