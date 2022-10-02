using Game.Base.Packets;
using Game.Logic;
using System;

namespace Game.Server.Rooms
{
    public class CreateRoomAction : IAction
    {
        private GamePlayer m_player;

        private string m_name;

        private string m_password;

        private eRoomType m_roomType;

        private byte m_timeType;

        private Random rand;

        public CreateRoomAction(GamePlayer player, string name, string password, eRoomType roomType, byte timeType)
        {
			m_player = player;
			m_name = name;
			m_password = password;
			m_roomType = roomType;
			m_timeType = timeType;
			rand = new Random();
        }

        public void Execute()
        {
			if (m_player.CurrentRoom != null)
			{
				m_player.CurrentRoom.RemovePlayerUnsafe(m_player);
			}
			if (!m_player.IsActive)
			{
				return;
			}
			BaseRoom[] rooms = RoomMgr.Rooms;
			BaseRoom baseRoom = null;
			int num = rand.Next(rooms.Length);
			for (int i = 0; i < rooms.Length; i++)
			{
				if (!rooms[num].IsUsing)
				{
					baseRoom = rooms[num];
					break;
				}
				num = rand.Next(rooms.Length);
			}
			if (baseRoom != null)
			{
				RoomMgr.WaitingRoom.RemovePlayer(m_player);
				baseRoom.Start();
				if (m_roomType == eRoomType.Dungeon)
				{
					baseRoom.HardLevel = eHardLevel.Normal;
					baseRoom.LevelLimits = (int)baseRoom.GetLevelLimit(m_player);
					baseRoom.isOpenBoss = false;
					baseRoom.currentFloor = 0;
					baseRoom.maxViewerCnt = 1;
				}
				if (baseRoom.isWithinLeageTime)
				{
					baseRoom.isCrosszone = true;
				}
				baseRoom.AreaID = m_player.ZoneId;
				baseRoom.UpdateRoom(m_name, m_password, m_roomType, m_timeType, 0);
				GSPacketIn gSPacketIn = m_player.Out.SendRoomCreate(baseRoom);
				baseRoom.AddPlayerUnsafe(m_player);
				RoomMgr.WaitingRoom.SendUpdateCurrentRoom(baseRoom);
				RoomMgr.WaitingRoom.SendUpdateRoom(baseRoom);
			}
        }
    }
}
