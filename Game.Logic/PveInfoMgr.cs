using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Logic
{
    public static class PveInfoMgr
    {
        private static readonly ILog ilog_0;

        private static Dictionary<int, PveInfo> dictionary_0;

        private static ReaderWriterLock readerWriterLock_0;

        private static ThreadSafeRandom threadSafeRandom_0;

        public static bool Init()
        {
			return ReLoad();
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, PveInfo> dictionary = LoadFromDatabase();
				if (dictionary.Count > 0)
				{
					Interlocked.Exchange(ref dictionary_0, dictionary);
				}
				return true;
			}
			catch (Exception ex)
			{
				ilog_0.Error("PveInfoMgr", ex);
			}
			return false;
        }

        public static Dictionary<int, PveInfo> LoadFromDatabase()
        {
			Dictionary<int, PveInfo> dictionary = new Dictionary<int, PveInfo>();
			using PveBussiness pveBussiness = new PveBussiness();
			PveInfo[] allPveInfos = pveBussiness.GetAllPveInfos();
			PveInfo[] array = allPveInfos;
			foreach (PveInfo allPveInfo in array)
			{
				if (!dictionary.ContainsKey(allPveInfo.ID))
				{
					dictionary.Add(allPveInfo.ID, allPveInfo);
				}
			}
			return dictionary;
        }

        public static PveInfo GetPveInfoById(int id)
        {
			if (dictionary_0.ContainsKey(id))
			{
				return dictionary_0[id];
			}
			return null;
        }

        public static PveInfo[] GetPveInfo()
        {
			if (dictionary_0 == null)
			{
				ReLoad();
			}
			return dictionary_0.Values.ToArray();
        }

        public static PveInfo GetPveInfoByType(eRoomType roomType, int levelLimits)
        {
			switch (roomType)
			{
			case eRoomType.Exploration:
				foreach (PveInfo current in dictionary_0.Values)
				{
					if (current.Type == (int)roomType && current.LevelLimits == levelLimits)
					{
						return current;
					}
				}
				break;
			case eRoomType.Boss:
			case eRoomType.Dungeon:
			case eRoomType.FightLab:
			case eRoomType.Freshman:
			case eRoomType.Academy:
			case eRoomType.Labyrinth:
			case eRoomType.CoupleBoss:
				foreach (PveInfo current2 in dictionary_0.Values)
				{
					if (current2.Type == (int)roomType)
					{
						return current2;
					}
				}
				break;
			}
			return null;
        }

        public static PveInfo GetRandomPve()
        {
			List<PveInfo> pves = dictionary_0.Values.Where((PveInfo x) => x.Type == 4).ToList();
			return pves[threadSafeRandom_0.Next(0, pves.Count())];
        }

        static PveInfoMgr()
        {
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			dictionary_0 = new Dictionary<int, PveInfo>();
			readerWriterLock_0 = new ReaderWriterLock();
			threadSafeRandom_0 = new ThreadSafeRandom();
        }
    }
}
