namespace Game.Server.Rooms
{
    public class KickPlayerAction : IAction
    {
        private BaseRoom m_room;

        private int m_place;

        public KickPlayerAction(BaseRoom room, int place)
        {
			m_room = room;
			m_place = place;
        }

        public void Execute()
        {
			m_room.RemovePlayerAtUnsafe(m_place);
        }
    }
}
