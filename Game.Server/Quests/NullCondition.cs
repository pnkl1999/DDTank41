using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class NullCondition : BaseCondition
    {
        public NullCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return false;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
