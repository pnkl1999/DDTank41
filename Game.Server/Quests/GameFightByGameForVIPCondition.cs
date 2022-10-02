using Game.Logic;
using SqlDataProvider.Data;

namespace Game.Server.Quests
{
    public class GameFightByGameForVIPCondition : BaseCondition
    {
        public GameFightByGameForVIPCondition(BaseQuest quest, QuestConditionInfo info, int value)
			: base(quest, info, value)
        {
        }

        public override void AddTrigger(GamePlayer player)
        {
			player.GameOver += method_0;
        }

        public override bool IsCompleted(GamePlayer player)
        {
			return base.Value <= 0;
        }

        private void method_0(AbstractGame abstractGame_0, bool bool_0, int int_1, bool isSpanArea, bool isCouple)
        {
			if (!bool_0)
			{
				return;
			}
			switch (abstractGame_0.GameType)
			{
			case eGameType.Free:
				if ((m_info.Para1 == 0 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eGameType.Guild:
				if ((m_info.Para1 == 1 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eGameType.Training:
				if ((m_info.Para1 == 2 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eGameType.Boss:
				if ((m_info.Para1 == 6 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eGameType.ALL:
				if ((m_info.Para1 == 4 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eGameType.Exploration:
				if ((m_info.Para1 == 5 || m_info.Para1 == -1) && base.Value > 0)
				{
					base.Value--;
				}
				break;
			case eGameType.Dungeon:
				if ((m_info.Para1 == 7 || m_info.Para1 == -1) && base.Value > 0)
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
			player.GameOver -= method_0;
        }
    }
}
