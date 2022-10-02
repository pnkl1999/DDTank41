using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class GameKillByRoomCondition : BaseCondition
    {
        public GameKillByRoomCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.AfterKillingLiving += player_AfterKillingLiving;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void player_AfterKillingLiving(AbstractGame game, int type, int id, bool isLiving, int demage, bool isSpanArea)
        {
			if (isLiving || type != 1)
			{
				return;
			}
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
			player.AfterKillingLiving -= player_AfterKillingLiving;
        }
    }
}
