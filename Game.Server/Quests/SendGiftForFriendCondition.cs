using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class SendGiftForFriendCondition : BaseCondition
    {
        public SendGiftForFriendCondition(BaseQuest quest, QuestConditionInfo info, int value)
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

        private void player_SendGiftForFriend()
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
