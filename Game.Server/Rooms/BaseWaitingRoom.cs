using Game.Base.Packets;
using Game.Logic;
using Game.Server.Managers;
using Game.Server.Packets;
using System.Collections.Generic;

namespace Game.Server.Rooms
{
    public class BaseWaitingRoom
    {
        private Dictionary<int, GamePlayer> m_list;

        public BaseWaitingRoom()
        {
			m_list = new Dictionary<int, GamePlayer>();
        }

        public bool AddPlayer(GamePlayer player)
        {
			bool flag = false;
			lock (m_list)
			{
				if (!m_list.ContainsKey(player.PlayerId))
				{
					m_list.Add(player.PlayerId, player);
					flag = true;
				}
			}
			if (flag)
			{
				GSPacketIn packet = player.Out.SendSceneAddPlayer(player);
				SendToALL(packet, player);
			}
			return flag;
        }

        public bool RemovePlayer(GamePlayer player)
        {
			bool flag = false;
			lock (m_list)
			{
				flag = m_list.Remove(player.PlayerId);
			}
			if (flag)
			{
				GSPacketIn packet = player.Out.SendSceneRemovePlayer(player);
				SendToALL(packet, player);
			}
			return true;
        }

        public void SendSceneUpdate(GamePlayer player)
        {
			GSPacketIn packet = player.Out.SendSceneAddPlayer(player);
			SendToALL(packet, player);
			GamePlayer[] playersSafe = GetPlayersSafe();
			GamePlayer[] array = playersSafe;
			foreach (GamePlayer gamePlayer in array)
			{
				if (gamePlayer != player)
				{
					player.Out.SendSceneAddPlayer(gamePlayer);
				}
			}
        }

        public void SendUpdateRoom(GamePlayer player)
        {
			List<BaseRoom> list = new List<BaseRoom>();
			if (player.PlayerState == ePlayerState.Away)
			{
				list.AddRange(RoomMgr.GetAllPveRooms());
			}
			else
			{
				list.AddRange(RoomMgr.GetAllMatchRooms());
			}
			player.Out.SendUpdateRoomList(list);
        }

		public void SendUpdateRoom(BaseRoom room)
		{
			GamePlayer[] playersSafe = this.GetPlayersSafe();
			List<BaseRoom> allRooms = RoomMgr.GetAllRooms();
			List<GamePlayer> list = new List<GamePlayer>();
			List<GamePlayer> list2 = new List<GamePlayer>();
			List<BaseRoom> list3 = new List<BaseRoom>();
			List<BaseRoom> list4 = new List<BaseRoom>();
			GamePlayer[] array = playersSafe;
			for (int i = 0; i < array.Length; i++)
			{
				GamePlayer gamePlayer = array[i];
				if (gamePlayer.PlayerState == ePlayerState.Online)
				{
					list.Add(gamePlayer);
				}
				if (gamePlayer.PlayerState == ePlayerState.Away)
				{
					list2.Add(gamePlayer);
				}
			}
			foreach (BaseRoom current in allRooms)
			{
				if (current.RoomType == eRoomType.Freedom || current.RoomType == eRoomType.Match)
				{
					list3.Add(current);
				}
				if (current.RoomType == eRoomType.Dungeon || current.RoomType == eRoomType.AcademyDungeon || current.RoomType == eRoomType.ActivityDungeon || current.RoomType == eRoomType.SpecialActivityDungeon)
				{
					list4.Add(current);
				}
			}
			this.SendUpdateRoom(list, list3);
			this.SendUpdateRoom(list2, list4);
		}

		public void SendUpdateRoom(List<GamePlayer> players, List<BaseRoom> rooms)
		{
			GSPacketIn gSPacketIn = null;
			foreach (GamePlayer current in players)
			{
				if (gSPacketIn == null)
				{
					gSPacketIn = current.Out.SendUpdateRoomList(rooms);
				}
				else
				{
					current.Out.SendTCP(gSPacketIn);
				}
			}
		}

		public void SendUpdateWaitingRoom(BaseRoom room)
        {
			List<BaseRoom> list = new List<BaseRoom>();
			list.AddRange(RoomMgr.GetAllRooms());
			foreach (GamePlayer player in WorldMgr.GetAllPlayersNoGame())
			{
				player.Out.SendUpdateRoomList(list);
			}
		}

        public void SendUpdateCurrentRoom(BaseRoom room)
        {
			if (room == null)
			{
				return;
			}
			List<BaseRoom> allRooms = RoomMgr.GetAllRooms(room);
			GSPacketIn gSPacketIn = null;
			foreach (GamePlayer player in room.GetPlayers())
			{
				if (gSPacketIn == null)
				{
					gSPacketIn = player.Out.SendUpdateRoomList(allRooms);
				}
				else
				{
					player.Out.SendTCP(gSPacketIn);
				}
			}
        }

        public void SendToALL(GSPacketIn packet)
        {
			SendToALL(packet, null);
        }

        public void SendToALL(GSPacketIn packet, GamePlayer except)
        {
			GamePlayer[] array = null;
			lock (m_list)
			{
				array = new GamePlayer[m_list.Count];
				m_list.Values.CopyTo(array, 0);
			}
			GamePlayer[] array2 = array;
			foreach (GamePlayer gamePlayer in array2)
			{
				if (gamePlayer != null && gamePlayer != except)
				{
					gamePlayer.Out.SendTCP(packet);
				}
			}
        }

        public GamePlayer[] GetPlayersSafe()
        {
			GamePlayer[] array = null;
			lock (m_list)
			{
				array = new GamePlayer[m_list.Count];
				m_list.Values.CopyTo(array, 0);
			}
			return array;
        }
    }
}
