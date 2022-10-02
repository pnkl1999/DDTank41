using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class GameShowCardAction : BaseAction
    {
        private PVEGame m_game;

        public GameShowCardAction(PVEGame game, int delay, int finishTime)
			: base(delay, finishTime)
        {
			m_game = game;
        }

        protected override void ExecuteImp(BaseGame game, long tick)
        {
			foreach (Player p in m_game.GetAllFightPlayers())
			{
				if (p.IsActive && p.CanTakeOut > 0)
				{
					p.HasPaymentTakeCard = true;
					int left = p.CanTakeOut;
					for (int i = 0; i < left; i++)
					{
						m_game.TakeCard(p);
					}
				}
			}
			m_game.SendShowCards();
			base.ExecuteImp(game, tick);
        }
    }
}
