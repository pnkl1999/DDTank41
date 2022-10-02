using Fighting.Server.Games;
using Fighting.Server.Guild;
using Game.Logic;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Fighting.Server.Rooms
{
    public class ProxyRoomMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static readonly int THREAD_INTERVAL = 20;

        public static readonly int PICK_UP_INTERVAL = 5000;

        public static readonly int CLEAR_ROOM_INTERVAL = 250;

        private static bool startWithNpc = false;

        private static int serverId = 1;

        private static Queue<IAction> m_actionQueue = new Queue<IAction>();

        private static Thread m_thread;

        private static Dictionary<int, ProxyRoom> m_rooms = new Dictionary<int, ProxyRoom>();

        private static int RoomIndex = 0;

        private static long m_nextPickTick = 0L;

        private static long m_nextClearTick = 0L;

        public static bool Setup()
        {
            m_thread = new Thread(RoomThread);
            return true;
        }

        public static void Start()
        {
            if (!startWithNpc)
            {
                startWithNpc = true;
                m_thread.Start();
            }
        }

        public static void Stop()
        {
            if (startWithNpc)
            {
                startWithNpc = false;
                m_thread.Join();
            }
        }

        public static void AddAction(IAction action)
        {
            lock (m_actionQueue)
            {
                m_actionQueue.Enqueue(action);
            }
        }

        private static void RoomThread()
        {
            long balance = 0L;
            m_nextClearTick = TickHelper.GetTickCount();
            m_nextPickTick = TickHelper.GetTickCount();
            while (startWithNpc)
            {
                long start = TickHelper.GetTickCount();
                try
                {
                    ExecuteActions();
                    if (m_nextPickTick <= start)
                    {
                        m_nextPickTick += PICK_UP_INTERVAL;
                        PickUpRooms(start);
                    }
                    if (m_nextClearTick <= start)
                    {
                        m_nextClearTick += CLEAR_ROOM_INTERVAL;
                        ClearRooms(start);
                        ClearAutoBotRooms();
                    }
                }
                catch (Exception ex)
                {
                    log.Error("Room Mgr Thread Error:", ex);
                }
                long end = TickHelper.GetTickCount();
                balance += THREAD_INTERVAL - (end - start);
                if (balance > 0)
                {
                    Thread.Sleep((int)balance);
                    balance = 0L;
                }
                else if (balance < -1000)
                {
                    log.WarnFormat("Room Mgr is delay {0} ms!", balance);
                    balance += 1000;
                }
            }
        }

        private static void ExecuteActions()
        {
            IAction[] actions = null;
            lock (m_actionQueue)
            {
                if (m_actionQueue.Count > 0)
                {
                    actions = new IAction[m_actionQueue.Count];
                    m_actionQueue.CopyTo(actions, 0);
                    m_actionQueue.Clear();
                }
            }
            if (actions == null)
            {
                return;
            }
            foreach (IAction action in actions)
            {
                try
                {
                    action.Execute();
                }
                catch (Exception ex)
                {
                    log.Error("RoomMgr execute action error:", ex);
                }
            }
        }

        private static void PickUpRooms(long long_2)
        {
            List<ProxyRoom> waitMatchRoomUnsafe = GetWaitMatchRoomUnsafe();
            foreach (ProxyRoom red in waitMatchRoomUnsafe)
            {
                int minValue = int.MinValue;
                ProxyRoom matchRoom = null;
                if (red.IsPlaying)
                {
                    continue;
                }
                if (red.RoomType == eRoomType.Match)
                {
                    switch (red.GameType)
                    {
                        case eGameType.Guild:
                            foreach (ProxyRoom current in waitMatchRoomUnsafe)
                            {
                                if ((current.GuildId == 0 || current.GuildId != red.GuildId) && current != red && current.GameType == eGameType.Guild && red.GameType == eGameType.Guild && !current.IsPlaying && current.PlayerCount == red.PlayerCount && !red.isAutoBot && !current.isAutoBot && red.ZoneId == current.ZoneId && current.PlayerCount > 1)
                                {
                                    int num9 = GuildMgr.FindGuildRelationShip(red.GuildId, current.GuildId) + 1;
                                    int gameType = (int)current.GameType;
                                    int num2 = Math.Abs(red.FightPower - current.FightPower);
                                    int num4 = Math.Abs(red.AvgLevel - current.AvgLevel);
                                    int num6 = 10000;
                                    if (num9 * num6 + gameType * 1000 + num2 + num4 > minValue)
                                    {
                                        matchRoom = current;
                                        //break;
                                    }
                                }
                            }
                            break;
                        case eGameType.ALL:
                            foreach (ProxyRoom blue in waitMatchRoomUnsafe)
                            {
                                if (blue != red && !red.isAutoBot && blue.PlayerCount == red.PlayerCount && !blue.IsPlaying && !blue.IsCrossZone && blue.ZoneId == red.ZoneId && (blue.GameType == eGameType.ALL || blue.GameType == eGameType.Free))
                                {
                                    int score = CalculateScore(red, blue);
                                    if (score < 2 && red.PickUpCount < 3 && !blue.isAutoBot)
                                    {
                                        matchRoom = blue;
                                        //break;
                                    }
                                }
                            }
                            break;
                        default:
                            if (!red.isAutoBot && !red.startWithNpc)
                            {
                                ProxyRoom unsafeWithResult = GetMathRoomUnsafeWithResult(red);
                                if (unsafeWithResult != null)
                                {
                                    matchRoom = unsafeWithResult;
                                    //Console.WriteLine("StartMatch in rate: {0}% FP and ratelevel: {1}", red.PickUpRate, red.PickUpRateLevel);
                                }
                                else
                                {
                                    red.PickUpRateLevel++;
                                    red.PickUpRate += 10;
                                }
                            }
                            break;
                    }
                }
                if (matchRoom != null)
                {
                    StartMatchGame(red, matchRoom);
                    continue;
                }
                if (!red.IsCrossZone)
                {
                    if (red.PickUpCount >= 4 && !red.startWithNpc && !red.isAutoBot && red.RoomType == eRoomType.Match && red.NpcId > 0 && red.GameType != eGameType.Guild)// && red.PlayerCount == 1)
                    {
                        red.startWithNpc = true;
                        red.Client.SendBeginFightNpc(red.selfId, (int)red.RoomType, (int)red.GameType, red.NpcId, red.PlayerCount);
                        Console.WriteLine("Call AutoBot No.{0}", red.NpcId);
                    }
                    else if (red.startWithNpc && !red.isAutoBot)
                    {
                        bool flag = false;
                        foreach (ProxyRoom proxyRoom_1_2 in waitMatchRoomUnsafe)
                        {
                            if (proxyRoom_1_2 != red && proxyRoom_1_2.PlayerCount == red.PlayerCount && !proxyRoom_1_2.IsPlaying && proxyRoom_1_2.isAutoBot && red.NpcId == proxyRoom_1_2.NpcId)
                            {
                                flag = true;
                                Console.WriteLine("Start fight with AutoBot No.{0}. RoomType: {1}, GameType: {2}", red.NpcId, red.RoomType, red.GameType);
                                StartMatchGame(red, proxyRoom_1_2);
                                break;
                            }
                        }
                        if (!flag)
                        {
                            red.PickUpNPCTotal++;
                            Console.WriteLine("Fight with AutoBot No.{0} - Step: {1} is error no room", red.NpcId, red.PickUpNPCTotal);
                            if (red.PickUpNPCTotal > 3)
                            {
                                red.startWithNpc = false;
                                red.PickUpNPCTotal = 0;
                            }
                        }
                    }
                }
                if (red.isAutoBot && !red.IsPlaying)
                {
                    red.PickUpCount--;
                }
                else
                {
                    red.PickUpCount++;
                }
            }
        }

        private static int CalculateScore(ProxyRoom red, ProxyRoom blue)
        {
            //return (int)blue.GameType * 100000 - Math.Abs(red.FightPower - blue.FightPower) * 100 - Math.Abs(red.AvgLevel - blue.AvgLevel);
            //return (15 * (red.PickUpCount + 1) + 10) * red.FightPower / 100;
            if (red.PickUpCount < 3)
            {
                int FightPower = Math.Abs(red.FightPower - blue.FightPower);
                if (red.FightPower.ToString().Length < 5 && blue.FightPower.ToString().Length < 5 && FightPower < 10000)
                {
                    return 1;
                }
                if (red.FightPower.ToString().Length > 5 && blue.FightPower.ToString().Length > 5 && FightPower < 100000)
                {
                    return 1;
                }
                if (red.FightPower.ToString().Length > 6 && blue.FightPower.ToString().Length > 6 && FightPower < 600000)
                {
                    return 1;
                }
            }
            return Math.Abs(red.AvgLevel - blue.AvgLevel);

        }
        private static void ClearRooms(long tick)
        {
            List<ProxyRoom> proxyRoomList = new List<ProxyRoom>();
            foreach (ProxyRoom proxyRoom2 in m_rooms.Values)
            {
                if (!proxyRoom2.IsPlaying && proxyRoom2.Game != null)
                {
                    proxyRoomList.Add(proxyRoom2);
                }
            }
            foreach (ProxyRoom proxyRoom in proxyRoomList)
            {
                m_rooms.Remove(proxyRoom.RoomId);
                try
                {
                    proxyRoom.Dispose();
                }
                catch (Exception ex)
                {
                    log.Error("Room dispose error:", ex);
                }
            }
        }

        private static void ClearAutoBotRooms()
        {
            List<ProxyRoom> proxyRoomList = new List<ProxyRoom>();
            foreach (ProxyRoom proxyRoom2 in m_rooms.Values)
            {
                if (!proxyRoom2.IsPlaying && proxyRoom2.PickUpCount < -1)
                {
                    proxyRoomList.Add(proxyRoom2);
                }
            }
            foreach (ProxyRoom proxyRoom in proxyRoomList)
            {
                m_rooms.Remove(proxyRoom.RoomId);
                try
                {
                    proxyRoom.Dispose();
                }
                catch (Exception ex)
                {
                    log.Error("Room dispose error:", ex);
                }
            }
        }

        private static void StartMatchGame(ProxyRoom proxyRoom_0, ProxyRoom proxyRoom_1)
        {
            int mapIndex = MapMgr.GetMapIndex(0, 0, serverId);
            eGameType gameType = eGameType.Free;
            eRoomType roomType = eRoomType.Match;
            if (proxyRoom_0.GameType == proxyRoom_1.GameType)
            {
                gameType = proxyRoom_0.GameType;
            }
            BaseGame game = GameMgr.StartBattleGame(proxyRoom_0.GetPlayers(), proxyRoom_0, proxyRoom_1.GetPlayers(), proxyRoom_1, mapIndex, roomType, gameType, 2);
            if (game != null)
            {
                proxyRoom_1.StartGame(game);
                proxyRoom_0.StartGame(game);
                if (game.GameType == eGameType.Guild)
                {
                    proxyRoom_0.Client.SendConsortiaAlly(proxyRoom_0.GetPlayers()[0].PlayerCharacter.ConsortiaID, proxyRoom_1.GetPlayers()[0].PlayerCharacter.ConsortiaID, game.Id);
                }
            }
        }

        public static void StartWithNpcUnsafe(ProxyRoom room)
        {
            int npcId = room.NpcId;
            ProxyRoom roomUnsafe = GetRoomUnsafe(room.RoomId);
            foreach (ProxyRoom proxyRoom_1 in GetWaitMatchRoomUnsafe())
            {
                if (proxyRoom_1.isAutoBot && !proxyRoom_1.IsPlaying && proxyRoom_1.Game == null && proxyRoom_1.NpcId == npcId)
                {
                    Console.WriteLine("Start fight with AutoBot or VPlayer No.{0} ", npcId);
                    StartMatchGame(roomUnsafe, proxyRoom_1);
                }
            }
        }

        public static bool AddRoomUnsafe(ProxyRoom room)
        {
            if (m_rooms.ContainsKey(room.RoomId))
            {
                return false;
            }
            m_rooms.Add(room.RoomId, room);
            return true;
        }

        public static bool RemoveRoomUnsafe(int roomId)
        {
            if (!m_rooms.ContainsKey(roomId))
            {
                return false;
            }
            m_rooms.Remove(roomId);
            return true;
        }

        public static ProxyRoom GetRoomUnsafe(int roomId)
        {
            if (m_rooms.ContainsKey(roomId))
            {
                return m_rooms[roomId];
            }
            return null;
        }

        public static ProxyRoom[] GetAllRoom()
        {
            lock (m_rooms)
            {
                return GetAllRoomUnsafe();
            }
        }

        public static ProxyRoom[] GetAllRoomUnsafe()
        {
            ProxyRoom[] array = new ProxyRoom[m_rooms.Values.Count];
            m_rooms.Values.CopyTo(array, 0);
            return array;
        }

        public static List<ProxyRoom> GetWaitMatchRoomUnsafe()
        {
            List<ProxyRoom> proxyRoomList = new List<ProxyRoom>();
            foreach (ProxyRoom proxyRoom in m_rooms.Values)
            {
                if (!proxyRoom.IsPlaying && proxyRoom.Game == null)
                {
                    proxyRoomList.Add(proxyRoom);
                }
            }
            return proxyRoomList;
        }

        public static List<ProxyRoom> GetWaitMatchRoomWithoutBotUnsafe(ProxyRoom roomCompare)
        {
            List<ProxyRoom> proxyRoomList = new List<ProxyRoom>();
            foreach (ProxyRoom proxyRoom in m_rooms.Values)
            {
                if (!proxyRoom.IsPlaying && proxyRoom.Game == null && !proxyRoom.isAutoBot && !proxyRoom.startWithNpc && proxyRoom.IsCrossZone == roomCompare.IsCrossZone && (proxyRoom.IsCrossZone || proxyRoom.ZoneId == roomCompare.ZoneId))
                {
                    proxyRoomList.Add(proxyRoom);
                }
            }
            return proxyRoomList;
        }

        public static ProxyRoom GetMathRoomUnsafeWithResult(ProxyRoom roomCompare)
        {
            List<ProxyRoom> source = new List<ProxyRoom>();
            bool flag = false;
            List<ProxyRoom> withoutBotUnsafe = GetWaitMatchRoomWithoutBotUnsafe(roomCompare);
            foreach (ProxyRoom proxyRoom2 in withoutBotUnsafe)
            {
                if (!proxyRoom2.IsPlaying && proxyRoom2.Game == null && proxyRoom2 != roomCompare && (proxyRoom2.PickUpRateLevel >= roomCompare.PickUpRateLevel || roomCompare.PickUpRateLevel == 1) && proxyRoom2.PlayerCount == roomCompare.PlayerCount)
                {
                    int num2 = roomCompare.AvgLevel - roomCompare.PickUpRateLevel;
                    int num4 = roomCompare.AvgLevel + roomCompare.PickUpRateLevel;
                    if (proxyRoom2.AvgLevel >= num2 && proxyRoom2.AvgLevel <= num4)
                    {
                        source.Add(proxyRoom2);
                        flag = true;
                    }
                }
            }
            if (source.Count == 0)
            {
                foreach (ProxyRoom proxyRoom in withoutBotUnsafe)
                {
                    if (!proxyRoom.IsPlaying && proxyRoom.Game == null && proxyRoom != roomCompare && (proxyRoom.PickUpRate >= roomCompare.PickUpRate || roomCompare.PickUpRate == 1) && proxyRoom.PlayerCount == roomCompare.PlayerCount)
                    {
                        int num1 = roomCompare.FightPower - roomCompare.FightPower / 100 * roomCompare.PickUpRate;
                        int num3 = roomCompare.FightPower + roomCompare.FightPower / 100 * roomCompare.PickUpRate;
                        if (proxyRoom.FightPower >= num1 && proxyRoom.FightPower <= num3)
                        {
                            source.Add(proxyRoom);
                        }
                    }
                }
            }
            if (source.Count <= 0)
            {
                return null;
            }
            List<ProxyRoom> obj = (flag ? source.OrderBy((ProxyRoom a) => a.AvgLevel).ToList() : source.OrderBy((ProxyRoom a) => a.FightPower).ToList());
            return obj[obj.Count / 2];
        }

        public static int NextRoomId()
        {
            return Interlocked.Increment(ref RoomIndex);
        }

        public static void AddRoom(ProxyRoom room)
        {
            AddAction(new AddRoomAction(room));
        }

        public static void RemoveRoom(ProxyRoom room)
        {
            AddAction(new RemoveRoomAction(room));
        }
    }
}
