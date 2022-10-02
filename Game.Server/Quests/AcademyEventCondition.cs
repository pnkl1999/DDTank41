using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class AcademyEventCondition : BaseCondition
    {
        private int checkType;

        public AcademyEventCondition(BaseQuest quest, QuestConditionInfo info, int type, int value)
			: base(quest, info, value)
        {
			checkType = type;
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AcademyEvent += AcademyAccept;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.AcademyEvent -= AcademyAccept;
        }

        public void AcademyAccept(GamePlayer AcademyFriendLy, int AcademyType)
        {
			if (AcademyType == checkType && base.Value > 0)
			{
				base.Value--;
			}
			if (base.Value < 0)
			{
				base.Value = 0;
			}
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }
    }
}
