using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class DirectFinishCondition : BaseCondition
    {
        public DirectFinishCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return true;
        }
    }
}
