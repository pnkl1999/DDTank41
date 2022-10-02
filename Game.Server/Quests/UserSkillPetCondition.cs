using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class UserSkillPetCondition : BaseCondition
    {
        public UserSkillPetCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_UserSkillPet()
        {
			if (base.Value > 0)
			{
				base.Value--;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
        }
    }
}
