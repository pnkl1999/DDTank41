namespace Game.Logic.AI
{
    public abstract class APVEGameControl
    {
        protected PVEGame m_game;

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

        public virtual void Dispose()
        {
        }

        public virtual void OnCreated()
        {
        }

        public virtual void OnGameOverAllSession()
        {
        }

        public virtual void OnPrepated()
        {
        }
    }
}
