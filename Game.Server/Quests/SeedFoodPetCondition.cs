using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class SeedFoodPetCondition : BaseCondition
    {
        public SeedFoodPetCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.SeedFoodPetEvent += player_SeedFoodPet;
        }

        private void player_SeedFoodPet()
        {
			if (base.Value < m_info.Para2)
			{
				base.Value++;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.SeedFoodPetEvent -= player_SeedFoodPet;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value >= m_info.Para2;
        }
    }
}
