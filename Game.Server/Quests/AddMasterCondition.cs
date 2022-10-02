using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class AddMasterCondition : BaseCondition
    {
        public AddMasterCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
			base.Value = 0;
        }

        public override void AddTrigger(GamePlayer player)
        {
			base.Value = 0;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
