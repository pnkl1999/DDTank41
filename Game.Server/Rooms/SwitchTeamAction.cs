namespace Game.Server.Rooms
{
    public class SwitchTeamAction : IAction
    {
        private GamePlayer m_player;

        public SwitchTeamAction(GamePlayer player)
        {
			m_player = player;
        }

        public void Execute()
        {
			m_player.CurrentRoom?.SwitchTeamUnsafe(m_player);
        }
    }
}
