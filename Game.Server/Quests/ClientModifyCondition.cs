using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class ClientModifyCondition : BaseCondition
    {
        public ClientModifyCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        public override void Reset(GamePlayer player)
        {
			base.Value = 1;
        }
    }
}
