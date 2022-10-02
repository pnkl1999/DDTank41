using System.Collections.Generic;
using Game.Base.Packets;

namespace Game.Server.RingStation.Battle
{
    public class RingStationBattleServer
    {
        private int m_serverId;

        private RingStationFightConnector m_server;

        public RingStationFightConnector Server
        {
            get { return m_server; }
        }

        private Dictionary<int, BaseRoomRingStation> m_rooms;
        private string m_ip;

        private int m_port;

        public RingStationBattleServer(int serverId, string ip, int port, string loginKey)
        {
            m_serverId = serverId;
            m_ip = ip;
            m_port = port;
            m_server = new RingStationFightConnector(this, ip, port, loginKey);
            m_rooms = new Dictionary<int, BaseRoomRingStation>();
        }

        public bool IsActive
        {
            get { return m_server.IsConnected; }
        }

        public string Ip
        {
            get { return m_ip; }
        }

        public int Port
        {
            get { return m_port; }
        }

        public bool Start()
        {
            return m_server.Connect();
        }

        public void Stop()
        {
            m_server.Disconnect();
        }

        public bool AddRoom(BaseRoomRingStation room)
        {
            bool flag = false;
            BaseRoomRingStation exitRoom = null;
            lock (m_rooms)
            {
                if (m_rooms.ContainsKey(room.RoomId))
                {
                    exitRoom = m_rooms[room.RoomId];
                    m_rooms.Remove(room.RoomId);
                }
            }

            if ((exitRoom != null) && (exitRoom.Game != null))
            {
                exitRoom.Game.Stop();
            }

            lock (m_rooms)
            {
                if (!m_rooms.ContainsKey(room.RoomId))
                {
                    m_rooms.Add(room.RoomId, room);
                    flag = true;
                }
            }

            if (flag)
            {
                m_server.SendAddRoom(room);
            }

            room.BattleServer = this;
            room.IsPlaying = true;
            return flag;
        }

        public bool RemoveRoom(BaseRoomRingStation room)
        {
            bool flag = false;
            lock (m_rooms)
            {
                flag = m_rooms.ContainsKey(room.RoomId);
                if (flag)
                {
                    m_server.SendRemoveRoom(room);
                }
            }

            return flag;
        }

        public void RemoveRoomImp(int roomId)
        {
            BaseRoomRingStation room = null;
            //Console.WriteLine("roomId {0}", roomId);
            lock (m_rooms)
            {
                if (m_rooms.ContainsKey(roomId))
                {
                    room = m_rooms[roomId];
                    m_rooms.Remove(roomId);
                }
            }
        }

        public void StartGame(int roomId, ProxyRingStationGame game)
        {
            BaseRoomRingStation baseRoom = FindRoom(roomId);
            if (baseRoom != null)
            {
                baseRoom.StartGame(game);
            }
        }

        public void StopGame(int roomId, int gameId)
        {
            BaseRoomRingStation baseRoom = FindRoom(roomId);
            if (baseRoom != null)
            {
                lock (m_rooms)
                {
                    m_rooms.Remove(roomId);
                }
            }
        }

        public void SendToRoom(int roomId, GSPacketIn pkg, int exceptId, int exceptGameId)
        {
            BaseRoomRingStation baseRoom = FindRoom(roomId);
            if (baseRoom != null)
            {
                if (exceptId != 0)
                {
                    VirtualGamePlayer playerById = RingStationMgr.GetPlayerById(exceptId);
                    if (playerById != null)
                    {
                        if (playerById.GamePlayerId == exceptGameId)
                        {
                            baseRoom.SendToAll(pkg, playerById);
                            return;
                        }

                        baseRoom.SendToAll(pkg);
                        return;
                    }
                }
                else
                {
                    baseRoom.SendToAll(pkg);
                }
            }
        }

        private BaseRoomRingStation FindRoom(int roomId)
        {
            BaseRoomRingStation result = null;
            lock (m_rooms)
            {
                try
                {
                    if (m_rooms.ContainsKey(roomId))
                    {
                        result = m_rooms[roomId];
                    }
                }
                finally
                {
                }
            }

            return result;
        }

        public void UpdatePlayerGameId(int playerid, int gamePlayerId)
        {
            VirtualGamePlayer playerById = RingStationMgr.GetPlayerById(playerid);
            if (playerById != null)
            {
                playerById.GamePlayerId = gamePlayerId;
                //Console.WriteLine("gamePlayerId: " + gamePlayerId);
            }
        }

        public override string ToString()
        {
            return string.Format("ServerID:{0},Ip:{1},Port:{2},IsConnected:{3},RoomCount:", m_serverId,
                m_server.RemoteEP.Address, m_server.RemoteEP.Port, m_server.IsConnected);
        }
    }
}