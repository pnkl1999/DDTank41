using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class MarryCondition : BaseCondition
    {
        public MarryCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.GameMarryTeam += method_0;
        }

        public override void RemoveTrigger(GamePlayer player)
        {
			player.GameMarryTeam -= method_0;
        }

        private void method_0(AbstractGame abstractGame_0, bool bool_0, int int_1, int int_2)
        {
			switch (abstractGame_0.RoomType)
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
			case eRoomType.Boss:
				if ((m_info.Para1 == 3 || m_info.Para1 == -1) && base.Value > 0)
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
			case eRoomType.Freshman:
				if ((m_info.Para1 == 2 || m_info.Para1 == -1) && base.Value > m_info.Para2)
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

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }
    }
}
