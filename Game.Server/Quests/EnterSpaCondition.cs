using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class EnterSpaCondition : BaseCondition
    {
        public EnterSpaCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.EnterHotSpringEvent += EnterSpa;
        }

        private void EnterSpa(GamePlayer gamePlayer)
        {
			base.Value--;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.EnterHotSpringEvent -= EnterSpa;
        }
    }
}
