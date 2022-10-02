namespace Fighting.Server.Rooms
{
    public class RemoveRoomAction : IAction
    {
        private ProxyRoom m_room;

        public RemoveRoomAction(ProxyRoom room)
        {
			m_room = room;
        }

        public void Execute()
        {
			ProxyRoomMgr.RemoveRoomUnsafe(m_room.RoomId);
			m_room.Dispose();
        }
    }
}
