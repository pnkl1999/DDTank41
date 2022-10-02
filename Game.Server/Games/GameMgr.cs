using Game.Logic;
using Game.Logic.Phy.Maps;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Games
{
    public class GameMgr
    {
        private static readonly int CLEAR_GAME_INTERVAL = 10000;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static int m_boxBroadcastLevel;

        private static long m_clearGamesTimer;

        private static int m_gameId;

        private static List<BaseGame> m_games;

        private static bool m_running;

        private static int m_serverId;

        private static Thread m_thread;

        public static readonly long THREAD_INTERVAL = 40L;

        private static DateTime m_synDate;

        public static int BoxBroadcastLevel=> m_boxBroadcastLevel;

        public static int SynDate=> DateTime.Compare(m_synDate.AddSeconds(THREAD_INTERVAL), DateTime.Now);

        private static void ClearStoppedGames(object state)
        {
			foreach (BaseGame item in state as ArrayList)
			{
				try
				{
					item.Dispose();
				}
				catch (Exception exception)
				{
					log.Error("game dispose error:", exception);
				}
			}
        }

        private static void GameThread()
        {
			Thread.CurrentThread.Priority = ThreadPriority.Highest;
			long num = 0L;
			m_clearGamesTimer = TickHelper.GetTickCount();
			while (m_running)
			{
				long tickCount = TickHelper.GetTickCount();
				int num2 = 0;
				try
				{
					num2 = UpdateGames(tickCount);
					if (m_clearGamesTimer <= tickCount)
					{
						m_clearGamesTimer += CLEAR_GAME_INTERVAL;
						ArrayList arrayList = new ArrayList();
						foreach (BaseGame game in m_games)
						{
							if (game.GameState == eGameState.Stopped)
							{
								arrayList.Add(game);
							}
						}
						foreach (BaseGame item in arrayList)
						{
							m_games.Remove(item);
						}
						ThreadPool.QueueUserWorkItem(ClearStoppedGames, arrayList);
					}
				}
				catch (Exception exception)
				{
					log.Error("Game Mgr Thread Error:", exception);
				}
				long tickCount2 = TickHelper.GetTickCount();
				num += THREAD_INTERVAL - (tickCount2 - tickCount);
				if (tickCount2 - tickCount > THREAD_INTERVAL * 2)
				{
					log.WarnFormat("Game Mgr spent too much times: {0} ms, count:{1}", tickCount2 - tickCount, num2);
				}
				if (num > 0)
				{
					Thread.Sleep((int)num);
					num = 0L;
				}
				else if (num < -1000)
				{
					num += 1000;
				}
				m_synDate = DateTime.Now;
			}
        }

        public static List<BaseGame> GetAllGame()
        {
			List<BaseGame> list = new List<BaseGame>();
			lock (m_games)
			{
				list.AddRange(m_games);
				return list;
			}
        }

        public static bool Setup(int serverId, int boxBroadcastLevel)
        {
			m_thread = new Thread(GameThread);
			m_games = new List<BaseGame>();
			m_serverId = serverId;
			m_boxBroadcastLevel = boxBroadcastLevel;
			m_gameId = 0;
			m_synDate = DateTime.Now;
			return true;
        }

        public static bool Start()
        {
			if (!m_running)
			{
				m_running = true;
				m_thread.Start();
			}
			return true;
        }

        public static BaseGame StartPVEGame(int roomId, List<IGamePlayer> players, int copyId, eRoomType roomType, eGameType gameType, int timeType, eHardLevel hardLevel, int levelLimits, int currentFloor)
        {
			try
			{
				PveInfo pveInfo = ((copyId != 0 && copyId != 100000) ? PveInfoMgr.GetPveInfoById(copyId) : PveInfoMgr.GetPveInfoByType(roomType, levelLimits));
				if (pveInfo != null)
				{
					PVEGame pVEGame = new PVEGame(m_gameId++, roomId, pveInfo, players, null, roomType, gameType, timeType, hardLevel, currentFloor);
					lock (m_games)
					{
						m_games.Add(pVEGame);
					}
					pVEGame.Prepare();
					Console.ForegroundColor = ConsoleColor.Magenta;
					Console.WriteLine("StartPVE type {0} with {1} player, <{2}>game count:: {5}, <{3}>{4}", pVEGame.RoomType, pVEGame.PlayerCount, pVEGame.Id, copyId, "hi", m_games.Count);
					Console.ResetColor();
					return pVEGame;
				}
				return null;
			}
			catch (Exception exception)
			{
				log.Error("Create game error:", exception);
				return null;
			}
        }

        public static BaseGame StartPVPGame(int roomId, List<IGamePlayer> red, List<IGamePlayer> blue, int mapIndex, eRoomType roomType, eGameType gameType, int timeType)
        {
			BaseGame result;
			try
			{
				int index = MapMgr.GetMapIndex(mapIndex, (byte)roomType, GameMgr.m_serverId);
				Map map = MapMgr.CloneMap(index);
				if (map != null)
				{
					PVPGame game = new PVPGame(GameMgr.m_gameId++, roomId, red, blue, map, roomType, gameType, timeType);
					List<BaseGame> games;
					Monitor.Enter(games = GameMgr.m_games);
					try
					{
						GameMgr.m_games.Add(game);
					}
					finally
					{
						Monitor.Exit(games);
					}
					game.Prepare();
					result = game;
				}
				else
				{
					result = null;
				}
			}
			catch (Exception exception)
			{
				GameMgr.log.Error("Create game error:", exception);
				result = null;
			}
			return result;
		}

        public static void Stop()
        {
			if (m_running)
			{
				m_running = false;
				m_thread.Join();
			}
        }

        private static int UpdateGames(long tick)
        {
			IList allGame = GetAllGame();
			if (allGame != null)
			{
				foreach (BaseGame item in allGame)
				{
					try
					{
						item.Update(tick);
					}
					catch (Exception exception)
					{
						log.Error("Game  updated error:", exception);
					}
				}
				return allGame.Count;
			}
			return 0;
        }

        public static void ClearAllGames()
        {
			ArrayList arrayList = new ArrayList();
			lock (m_games)
			{
				foreach (BaseGame game in m_games)
				{
					arrayList.Add(game);
				}
				foreach (BaseGame item in arrayList)
				{
					m_games.Remove(item);
					try
					{
						item.Dispose();
					}
					catch (Exception exception)
					{
						log.Error("game dispose error:", exception);
					}
				}
			}
        }
    }
}
