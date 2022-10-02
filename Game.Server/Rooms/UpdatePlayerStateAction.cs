namespace Game.Server.Rooms
{
    public class UpdatePlayerStateAction : IAction
    {
        private GamePlayer m_player;

        private BaseRoom m_room;

        private byte m_state;

        public UpdatePlayerStateAction(GamePlayer player, BaseRoom room, byte state)
        {
			m_player = player;
			m_state = state;
			m_room = room;
        }

        public void Execute()
        {
			if (m_player.CurrentRoom != null && m_room != null && m_player.CurrentRoom.RoomId == m_room.RoomId)
			{
				m_room.UpdatePlayerState(m_player, m_state, sendToClient: true);
			}
        }
    }
}
