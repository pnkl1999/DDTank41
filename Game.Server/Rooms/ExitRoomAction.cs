namespace Game.Server.Rooms
{
    public class ExitRoomAction : IAction
    {
        private BaseRoom m_room;

        private GamePlayer m_player;

        public ExitRoomAction(BaseRoom room, GamePlayer player)
        {
			m_room = room;
			m_player = player;
        }

        public void Execute()
        {
			m_room.RemovePlayerUnsafe(m_player);
            m_room.SendPlaceState();//test
			RoomMgr.WaitingRoom.SendUpdateCurrentRoom(m_room);
			if (m_room.IsEmpty)
			{
                m_room.RemoveAllPlayer();
				m_room.Stop();
			}
            RoomMgr.WaitingRoom.SendUpdateRoom(this.m_room);

        }
    }
}
