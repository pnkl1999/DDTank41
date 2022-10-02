namespace Game.Server.Rooms
{
    public class StartGameMissionAction : IAction
    {
        private BaseRoom m_room;

        public StartGameMissionAction(BaseRoom room)
        {
			m_room = room;
        }

        public void Execute()
        {
			m_room.Game.MissionStart(m_room.Host);
        }
    }
}
