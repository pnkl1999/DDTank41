using SqlDataProvider.Data;

namespace Game.Server.Achievement
{
    public class ChangeAgilityCondition : BaseUserRecord
    {
        public ChangeAgilityCondition(GamePlayer player, int type)
			: base(player, type)
        {
			AddTrigger(player);
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.PlayerPropertyChanged += player_PlayerPropertyChanged;
        }

        private void player_PlayerPropertyChanged(PlayerInfo character)
        {
			m_player.AchievementInventory.UpdateUserAchievement(m_type, character.Agility, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerPropertyChanged -= player_PlayerPropertyChanged;
        }
    }
}
