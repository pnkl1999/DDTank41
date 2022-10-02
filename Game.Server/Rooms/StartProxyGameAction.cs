using Game.Server.Battle;

namespace Game.Server.Rooms
{
    public class StartProxyGameAction : IAction
    {
        private BaseRoom m_room;

        private ProxyGame m_game;

        public StartProxyGameAction(BaseRoom room, ProxyGame game)
        {
			m_room = room;
			m_game = game;
        }

        public void Execute()
        {
			m_room.StartGame(m_game);
        }
    }
}
