namespace Game.Server.Rooms
{
    public class StopProxyGameAction : IAction
    {
        private BaseRoom m_room;

        public StopProxyGameAction(BaseRoom room)
        {
			m_room = room;
        }

        public void Execute()
        {
			if (m_room.Game != null)
			{
				m_room.Game.Stop();
			}
			RoomMgr.WaitingRoom.SendUpdateCurrentRoom(m_room);
        }
    }
}
