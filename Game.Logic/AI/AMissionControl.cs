using Game.Base.Packets;

namespace Game.Logic.AI
{
    public abstract class AMissionControl
    {
        private PVEGame m_game;

        public PVEGame Game
        {
			get
			{
				return m_game;
			}
			set
			{
				m_game = value;
			}
        }

        public virtual int CalculateScoreGrade(int score)
        {
			return 0;
        }

        public virtual bool CanGameOver()
        {
			return true;
        }

        public virtual void Dispose()
        {
        }

        public virtual void DoOther()
        {
        }

        public virtual void GameOverAllSession()
        {
        }

        public virtual void OnBeginNewTurn()
        {
        }

        public virtual void OnDied()
        {
        }

        public virtual void OnGameOver()
        {
        }

        public virtual void OnGameOverMovie()
        {
        }

        public virtual void OnNewTurnStarted()
        {
        }

        public virtual void OnPrepareNewGame()
        {
        }

        public virtual void OnPrepareNewSession()
        {
        }

        public virtual void OnShooted()
        {
        }

        public virtual void OnStartGame()
        {
        }

        public virtual void OnStartMovie()
        {
        }

        public virtual void OnMissionEvent(GSPacketIn packet)
        {
        }

        public virtual void OnPrepareGameOver()
        {
        }
        public virtual void OnWaitingGameState()
        {

        }
        public virtual int UpdateUIData()
        {
			return 0;
        }

        public virtual void OnPrepareStartGame()
        {
        }

        public virtual void OnGeneralCommand(GSPacketIn packet)
        {
        }

        public virtual void OnCalculatePoint(int point, bool isdouble)
        {

        }
    }
}
