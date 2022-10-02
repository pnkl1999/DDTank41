using System.Collections.Generic;

namespace Game.Server.Rooms
{
    public class EnterWaitingRoomAction : IAction
    {
        private GamePlayer m_player;

        public EnterWaitingRoomAction(GamePlayer player)
        {
			m_player = player;
        }

        public void Execute()
        {
			if (m_player == null)
			{
				return;
			}
			if (m_player.CurrentRoom != null)
			{
				m_player.CurrentRoom.RemovePlayerUnsafe(m_player);
			}
			BaseWaitingRoom waitingRoom = RoomMgr.WaitingRoom;
			if (waitingRoom.AddPlayer(m_player))
			{
				List<BaseRoom> allRooms = RoomMgr.GetAllRooms();
				m_player.Out.SendUpdateRoomList(allRooms);
				GamePlayer[] playersSafe = waitingRoom.GetPlayersSafe();
				GamePlayer[] array = playersSafe;
				foreach (GamePlayer gamePlayer in array)
				{
					if (gamePlayer != m_player)
					{
						m_player.Out.SendSceneAddPlayer(gamePlayer);
					}
				}
			}
			else
			{
				waitingRoom.SendUpdateRoom(m_player);
				waitingRoom.SendSceneUpdate(m_player);
			}
        }
    }
}
