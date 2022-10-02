using log4net;
using System.Reflection;

namespace Game.Logic.Actions
{
	public class CheckPVPGameStateAction : IAction
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private bool m_isFinished;

		private long m_tick;

		public CheckPVPGameStateAction(int delay)
		{
			m_tick += TickHelper.GetTickCount() + delay;
		}

		public void Execute(BaseGame game, long tick)
		{
			if (m_tick > tick)
			{
				return;
			}
			PVPGame pvp = game as PVPGame;
			if (pvp != null)
			{
				switch (game.GameState)
				{
					case eGameState.Inited:
						pvp.Prepare();
						break;
					case eGameState.Prepared:
						pvp.StartLoading();
						break;
					case eGameState.Loading:
						if (pvp.IsAllComplete())
						{
							pvp.StartGame();
						}
						break;
					case eGameState.Playing:
						if (pvp.CurrentPlayer == null || !pvp.CurrentPlayer.IsAttacking)
						{
							if (pvp.TurnIndex >= 100 && pvp.RoomType == eRoomType.Match)
							{
								pvp.GameOver();
							}
							if (pvp.CanGameOver())
							{
								pvp.GameOver();
							}
							else
							{
								pvp.NextTurn();
							}
						}
						break;
					case eGameState.GameOver:
						pvp.Stop();
						break;
				}
			}
			m_isFinished = true;
		}

		public bool IsFinished(long tick)
		{
			return m_isFinished;
		}
	}
}
