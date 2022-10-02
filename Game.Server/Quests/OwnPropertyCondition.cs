using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class OwnPropertyCondition : BaseCondition
    {
        public OwnPropertyCondition(BaseQuest quest, QuestConditionInfo info, int value)
            : base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
            if (player.GetItemCount(m_info.Para1) >= m_info.Para2)
            {
                Value = 0;
                return true;
            }
            return false;
        }

        private void player_OwnProperty()
        {
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}