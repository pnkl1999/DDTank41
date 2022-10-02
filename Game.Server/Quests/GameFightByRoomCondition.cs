using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class GameFightByRoomCondition : BaseCondition
    {
        public GameFightByRoomCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.GameOver += player_GameOver;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_GameOver(AbstractGame game, bool isWin, int gainXp, bool isSpanArea, bool isCouple)
        {
			switch (game.RoomType)
			{
			case eRoomType.Match:
				if ((m_info.Para1 == 0 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eRoomType.Freedom:
				if ((m_info.Para1 == 1 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eRoomType.Exploration:
				if ((m_info.Para1 == 2 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eRoomType.Dungeon:
				if ((m_info.Para1 == 4 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			}
			if (base.Value < 0)
			{
				base.Value = 0;
			}
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.GameOver -= player_GameOver;
        }
    }
}
