namespace Game.Server.Rooms
{
    public class ExitWaitRoomAction : IAction
    {
        private GamePlayer m_player;

        public ExitWaitRoomAction(GamePlayer player)
        {
			m_player = player;
        }

        public void Execute()
        {
			BaseWaitingRoom waitingRoom = RoomMgr.WaitingRoom;
			waitingRoom.RemovePlayer(m_player);
        }
    }
}
