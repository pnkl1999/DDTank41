using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Logic
{
    public static class NPCInfoMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock = new ReaderWriterLock();

        private static Dictionary<int, NpcInfo> m_npcs = new Dictionary<int, NpcInfo>();

        private static ThreadSafeRandom m_rand = new ThreadSafeRandom();

        public static NpcInfo GetNpcInfoById(int id)
        {
			if (m_npcs.ContainsKey(id))
			{
				return m_npcs[id];
			}
			return null;
        }

        public static bool Init()
        {
			return ReLoad();
        }

        private static Dictionary<int, NpcInfo> LoadFromDatabase()
        {
			Dictionary<int, NpcInfo> dictionary = new Dictionary<int, NpcInfo>();
			using ProduceBussiness bussiness = new ProduceBussiness();
			NpcInfo[] allNPCInfo = bussiness.GetAllNPCInfo();
			NpcInfo[] array = allNPCInfo;
			foreach (NpcInfo info in array)
			{
				if (!dictionary.ContainsKey(info.ID))
				{
					dictionary.Add(info.ID, info);
				}
			}
			return dictionary;
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, NpcInfo> dictionary = LoadFromDatabase();
				if (dictionary != null && dictionary.Count > 0)
				{
					Interlocked.Exchange(ref m_npcs, dictionary);
				}
				return true;
			}
			catch (Exception exception)
			{
				log.Error("NPCInfoMgr", exception);
			}
			return false;
        }
    }
}
