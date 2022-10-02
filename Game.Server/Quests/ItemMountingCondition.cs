using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class ItemMountingCondition : BaseCondition
    {
        public ItemMountingCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return player.EquipBag.GetItemCount(0, m_info.Para1) >= m_info.Para2;
        }
    }
}
