using Game.Logic.Phy.Object;

namespace Game.Logic.Actions
{
    public class RemovePlayerAction : IAction
    {
        private bool m_isFinished;

        private Player m_player;

        public RemovePlayerAction(Player player)
        {
			m_player = player;
			m_isFinished = false;
        }

        public void Execute(BaseGame game, long tick)
        {
			m_player.DeadLink();
			m_isFinished = true;
        }

        public bool IsFinished(long tick)
        {
			return m_isFinished;
        }
    }
}
