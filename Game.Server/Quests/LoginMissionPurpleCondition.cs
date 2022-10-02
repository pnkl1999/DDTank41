using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class LoginMissionPurpleCondition : BaseCondition
    {
        public LoginMissionPurpleCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerLogin += player_Login;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			if (player.PlayerCharacter.typeVIP == 2)
			{
				return true;
			}
			return false;
        }

        private void player_Login()
        {
			base.Value--;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerLogin -= player_Login;
        }
    }
}
