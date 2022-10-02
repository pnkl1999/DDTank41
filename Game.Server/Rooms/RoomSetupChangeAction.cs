using Game.Logic;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;

namespace Game.Server.Rooms
{
    internal class RoomSetupChangeAction : IAction
    {
        private BaseRoom m_room;

        private eRoomType m_roomType;

        private byte m_timeMode;

        private eHardLevel m_hardLevel;

        private int m_mapId;

        private int m_levelLimits;

        private string m_password;

        private string m_roomName;

        private bool m_isCrosszone;

        private string m_pic;

        private int m_currentFloor;

		private bool m_isOpenBoss;

		public RoomSetupChangeAction(BaseRoom room, eRoomType roomType, byte timeMode, eHardLevel hardLevel, int levelLimits, int mapId, string password, string roomname, bool isCrosszone, bool isOpenBoss, string Pic, int currentFloor)
        {
			m_room = room;
			m_roomType = roomType;
			m_timeMode = timeMode;
			m_hardLevel = hardLevel;
			m_levelLimits = levelLimits;
			m_mapId = mapId;
			m_password = password;
			m_roomName = roomname;
			m_isCrosszone = isCrosszone;
			m_isOpenBoss = isOpenBoss;
			m_pic = Pic;
			m_currentFloor = currentFloor;
            if (isOpenBoss)
            {
                
                m_currentFloor = GetLastFloor(mapId, (int)hardLevel)[0];
                m_pic = "show" + GetLastFloor(mapId, (int)hardLevel)[1] + ".jpg";
            }
        }

        public List<int> GetLastFloor(int mapID, int hardLevel)
        {
            List<int> floor = new List<int>();
            PveInfo pve = PveInfoMgr.GetPveInfoById(mapID);
            if (pve != null)
            {
                if (pve.LastFloor != null)
                {
                    string[] splitLastFloor = pve.LastFloor.Split(',');
                    floor.Add(Convert.ToInt32(splitLastFloor[hardLevel]));
                    floor.Add(floor[0]);//mac dinh
                }
            }
            return floor;
        }


        public void Execute()
        {
			m_room.RoomType = m_roomType;
			m_room.TimeMode = m_timeMode;
			m_room.HardLevel = m_hardLevel;
			m_room.LevelLimits = m_levelLimits;
			m_room.MapId = m_mapId;
			m_room.Name = m_roomName;
			m_room.Password = m_password;
			m_room.isCrosszone = m_isCrosszone;
			m_room.isOpenBoss = m_isOpenBoss;
			m_room.currentFloor = m_currentFloor;
			m_room.Pic = m_pic;
            m_room.UpdateGameStyle();
            m_room.UpdateRoomGameType();
			m_room.SendRoomSetupChange(m_room);
			RoomMgr.WaitingRoom.SendUpdateRoom(m_room);
        }
    }
}
