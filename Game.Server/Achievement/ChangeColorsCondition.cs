using SqlDataProvider.Data;

namespace Game.Server.Achievement
{
    public class ChangeColorsCondition : BaseUserRecord
    {
        public ChangeColorsCondition(GamePlayer player, int type)
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
			string[] array = character.Colors.Split(',');
			int num = 0;
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i].ToString() != "" && array[i].ToString() != "|")
				{
					num++;
				}
			}
			m_player.AchievementInventory.UpdateUserAchievement(m_type, num, 1);
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.PlayerPropertyChanged -= player_PlayerPropertyChanged;
        }
    }
}
