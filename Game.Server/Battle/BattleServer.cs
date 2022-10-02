using Game.Base;
using Game.Base.Packets;
using Game.Server.Managers;
using Game.Server.Rooms;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Server.Battle
{
    public class BattleServer
    {
        private int int_0;

        private int int_1;

        private DateTime dateTime_0;

        private readonly ILog ilog_0;

        private FightServerConnector fightServerConnector_0;

        private Dictionary<int, BaseRoom> dictionary_0;

        private string string_0;

        private int int_2;

        private string string_1;

        public int RetryCount
        {
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
			}
        }

        public DateTime LastRetryTime
        {
			get
			{
				return dateTime_0;
			}
			set
			{
				dateTime_0 = value;
			}
        }

        public FightServerConnector Server=> fightServerConnector_0;

        public string LoginKey=> string_1;

        public int ServerId=> int_0;

        public bool IsActive=> fightServerConnector_0.IsConnected;

        public string Ip=> string_0;

        public int Port=> int_2;

        public event EventHandler Disconnected;

        public BattleServer(int serverId, string ip, int port, string loginKey)
        {
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			int_0 = serverId;
			string_0 = ip;
			int_2 = port;
			string_1 = loginKey;
			int_1 = 0;
			dateTime_0 = DateTime.Now;
			fightServerConnector_0 = new FightServerConnector(this, ip, port, loginKey);
			dictionary_0 = new Dictionary<int, BaseRoom>();
			fightServerConnector_0.Disconnected += method_2;
			fightServerConnector_0.Connected += method_1;
        }

        public BattleServer Clone()
        {
			return new BattleServer(int_0, string_0, int_2, string_1);
        }

        public void Start()
        {
			if (!fightServerConnector_0.Connect())
			{
				ThreadPool.QueueUserWorkItem(method_0);
			}
        }

        private void method_0(object object_0)
        {
			method_2(fightServerConnector_0);
        }

        private void method_1(BaseClient baseClient_0)
        {
        }

        private void method_2(BaseClient baseClient_0)
        {
			RemoveAllRoom();
			if (this.Disconnected != null)
			{
				this.Disconnected(this, null);
			}
        }

        public void RemoveAllRoom()
        {
			BaseRoom[] array = null;
			lock (dictionary_0)
			{
				array = dictionary_0.Values.ToArray();
				dictionary_0.Clear();
			}
			BaseRoom[] array2 = array;
			BaseRoom[] array3 = array2;
			foreach (BaseRoom baseRoom in array3)
			{
				if (baseRoom != null)
				{
					baseRoom.RemoveAllPlayer();
					RoomMgr.StopProxyGame(baseRoom);
				}
			}
        }

        public BaseRoom FindRoom(int roomId)
        {
			BaseRoom result = null;
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(roomId))
				{
					return dictionary_0[roomId];
				}
				return result;
			}
        }

        public bool AddRoom(BaseRoom room)
        {
			bool flag = false;
			lock (dictionary_0)
			{
				if (!dictionary_0.ContainsKey(room.RoomId))
				{
					dictionary_0.Add(room.RoomId, room);
					flag = true;
				}
			}
			if (flag)
			{
				fightServerConnector_0.SendAddRoom(room);
			}
			return flag;
        }

        public bool RemoveRoom(BaseRoom room)
        {
			bool flag = false;
			lock (dictionary_0)
			{
				flag = dictionary_0.ContainsKey(room.RoomId);
			}
			if (flag)
			{
				fightServerConnector_0.SendRemoveRoom(room);
			}
			return flag;
        }

        public void RemoveRoomImp(int roomId)
        {
			BaseRoom baseRoom = null;
			lock (dictionary_0)
			{
				if (dictionary_0.ContainsKey(roomId))
				{
					baseRoom = dictionary_0[roomId];
					dictionary_0.Remove(roomId);
				}
			}
			if (baseRoom != null)
			{
				if (baseRoom.IsPlaying && baseRoom.Game == null)
				{
					RoomMgr.CancelPickup(this, baseRoom);
				}
				else
				{
					RoomMgr.StopProxyGame(baseRoom);
				}
			}
        }

        public void StartGame(int roomId, ProxyGame game)
        {
			BaseRoom baseRoom = FindRoom(roomId);
			if (baseRoom != null)
			{
				RoomMgr.StartProxyGame(baseRoom, game);
			}
        }

        public void StopGame(int roomId, int gameId)
        {
			BaseRoom baseRoom = FindRoom(roomId);
			if (baseRoom != null)
			{
				RoomMgr.StopProxyGame(baseRoom);
				lock (dictionary_0)
				{
					dictionary_0.Remove(roomId);
				}
			}
        }

        public void SendToRoom(int roomId, GSPacketIn pkg, int exceptId, int exceptGameId)
        {
			BaseRoom baseRoom = FindRoom(roomId);
			if (baseRoom == null)
			{
				return;
			}
			if (exceptId != 0)
			{
				GamePlayer playerById = WorldMgr.GetPlayerById(exceptId);
				if (playerById != null)
				{
					if (playerById.TempGameId == exceptGameId)
					{
						baseRoom.SendToAll(pkg, playerById);
					}
					else
					{
						baseRoom.SendToAll(pkg);
					}
				}
			}
			else
			{
				baseRoom.SendToAll(pkg);
			}
        }

        public void SendToUser(int playerid, GSPacketIn pkg)
        {
			WorldMgr.GetPlayerById(playerid)?.SendTCP(pkg);
        }

        public void UpdatePlayerGameId(int playerid, int gamePlayerId)
        {
			GamePlayer playerById = WorldMgr.GetPlayerById(playerid);
			if (playerById != null)
			{
				playerById.GamePlayerId = gamePlayerId;
				playerById.TempGameId = gamePlayerId;
			}
        }

        public override string ToString()
        {
			return $"ServerID:{int_0},Ip:{fightServerConnector_0.RemoteEP.Address},Port:{fightServerConnector_0.RemoteEP.Port},IsConnected:{fightServerConnector_0.IsConnected},RoomCount:{dictionary_0.Count}";
        }
    }
}
