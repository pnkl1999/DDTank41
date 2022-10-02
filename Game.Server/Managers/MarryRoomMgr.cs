using Bussiness;
using Game.Server.SceneMarryRooms;
using log4net;
using log4net.Util;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Game.Server.Managers
{
    public class MarryRoomMgr
    {
        protected static ReaderWriterLock _locker = new ReaderWriterLock();

        protected static TankMarryLogicProcessor _processor = new TankMarryLogicProcessor();

        protected static Dictionary<int, MarryRoom> _Rooms;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static MarryRoom CreateMarryRoom(GamePlayer player, MarryRoomInfo info)
        {
			if (player.PlayerCharacter.IsMarried)
			{
				MarryRoom marryRoom = null;
				DateTime now = DateTime.Now;
				info.PlayerID = player.PlayerCharacter.ID;
				info.PlayerName = player.PlayerCharacter.NickName;
				if (player.PlayerCharacter.Sex)
				{
					info.GroomID = info.PlayerID;
					info.GroomName = info.PlayerName;
					info.BrideID = player.PlayerCharacter.SpouseID;
					info.BrideName = player.PlayerCharacter.SpouseName;
				}
				else
				{
					info.BrideID = info.PlayerID;
					info.BrideName = info.PlayerName;
					info.GroomID = player.PlayerCharacter.SpouseID;
					info.GroomName = player.PlayerCharacter.SpouseName;
				}
				info.BeginTime = now;
				info.BreakTime = now;
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					if (playerBussiness.InsertMarryRoomInfo(info))
					{
						marryRoom = new MarryRoom(info, _processor);
						GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(info.GroomID);
						GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(info.BrideID);
						GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(info.GroomID, state: true, info);
						GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(info.BrideID, state: true, info);
					}
				}
				if (marryRoom != null)
				{
					_locker.AcquireWriterLock();
					try
					{
						_Rooms.Add(marryRoom.Info.ID, marryRoom);
					}
					finally
					{
						_locker.ReleaseWriterLock();
					}
					if (marryRoom.AddPlayer(player))
					{
						marryRoom.BeginTimer(3600000 * marryRoom.Info.AvailTime);
						return marryRoom;
					}
				}
			}
			return null;
        }

        public static MarryRoom CreateMarryRoomFromDB(MarryRoomInfo roomInfo, int timeLeft)
        {
			_locker.AcquireWriterLock();
			try
			{
				MarryRoom marryRoom = new MarryRoom(roomInfo, _processor);
				if (marryRoom != null)
				{
					_Rooms.Add(marryRoom.Info.ID, marryRoom);
					marryRoom.BeginTimer(60000 * timeLeft);
					return marryRoom;
				}
			}
			finally
			{
				_locker.ReleaseWriterLock();
			}
			return null;
        }

        private static void CheckRoomStatus()
        {
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			MarryRoomInfo[] marryRoomInfo = playerBussiness.GetMarryRoomInfo();
			MarryRoomInfo[] array = marryRoomInfo;
			foreach (MarryRoomInfo marryRoomInfo2 in array)
			{
				if (marryRoomInfo2.ServerID != GameServer.Instance.Configuration.ServerID)
				{
					continue;
				}
				TimeSpan timeSpan = DateTime.Now - marryRoomInfo2.BeginTime;
				int num = marryRoomInfo2.AvailTime * 60 - (int)timeSpan.TotalMinutes;
				if (num > 0)
				{
					CreateMarryRoomFromDB(marryRoomInfo2, num);
					continue;
				}
				playerBussiness.DisposeMarryRoomInfo(marryRoomInfo2.ID);
				if (GameServer.Instance.LoginServer != null)
				{
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(marryRoomInfo2.GroomID);
					GameServer.Instance.LoginServer.SendUpdatePlayerMarriedStates(marryRoomInfo2.BrideID);
					GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(marryRoomInfo2.GroomID, state: false, marryRoomInfo2);
					GameServer.Instance.LoginServer.SendMarryRoomInfoToPlayer(marryRoomInfo2.BrideID, state: false, marryRoomInfo2);
				}
			}
        }

        public static MarryRoom[] GetAllMarryRoom()
        {
			MarryRoom[] array = null;
			_locker.AcquireReaderLock();
			try
			{
				array = new MarryRoom[_Rooms.Count];
				_Rooms.Values.CopyTo(array, 0);
			}
			finally
			{
				_locker.ReleaseReaderLock();
			}
			if (array != null)
			{
				return array;
			}
			return new MarryRoom[0];
        }

        public static MarryRoom GetMarryRoombyID(int id, string pwd, ref string msg)
        {
			MarryRoom result = null;
			_locker.AcquireReaderLock();
			try
			{
				if (id <= 0 || !_Rooms.Keys.Contains(id))
				{
					return result;
				}
				if (_Rooms[id].Info.Pwd != pwd)
				{
					msg = "Game.Server.Managers.PWDError";
					return result;
				}
				return _Rooms[id];
			}
			finally
			{
				_locker.ReleaseReaderLock();
			}
        }

        public static bool Init()
        {
			_Rooms = new Dictionary<int, MarryRoom>();
			CheckRoomStatus();
			return true;
        }

        public static void RemoveMarryRoom(MarryRoom room)
        {
			_locker.AcquireReaderLock();
			try
			{
				if (_Rooms.Keys.Contains(room.Info.ID))
				{
					_Rooms.Remove(room.Info.ID);
				}
			}
			finally
			{
				_locker.ReleaseReaderLock();
			}
        }

        public static bool UpdateBreakTimeWhereServerStop()
        {
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			return playerBussiness.UpdateBreakTimeWhereServerStop();
        }
    }
}
