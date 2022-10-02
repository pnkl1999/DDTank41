using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class ConsortiaLevelMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, ConsortiaLevelInfo> _consortiaLevel;

        private static ReaderWriterLock m_lock;

        private static ThreadSafeRandom rand;

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, ConsortiaLevelInfo> tempConsortiaLevel = new Dictionary<int, ConsortiaLevelInfo>();
				if (Load(tempConsortiaLevel))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_consortiaLevel = tempConsortiaLevel;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ConsortiaLevelMgr", e);
				}
			}
			return false;
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_consortiaLevel = new Dictionary<int, ConsortiaLevelInfo>();
				rand = new ThreadSafeRandom();
				return Load(_consortiaLevel);
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ConsortiaLevelMgr", e);
				}
				return false;
			}
        }

        private static bool Load(Dictionary<int, ConsortiaLevelInfo> consortiaLevel)
        {
			using (ConsortiaBussiness db = new ConsortiaBussiness())
			{
				ConsortiaLevelInfo[] array = db.GetAllConsortiaLevel();
				ConsortiaLevelInfo[] array2 = array;
				foreach (ConsortiaLevelInfo info in array2)
				{
					if (!consortiaLevel.ContainsKey(info.Level))
					{
						consortiaLevel.Add(info.Level, info);
					}
				}
			}
			return true;
        }

        public static ConsortiaLevelInfo FindConsortiaLevelInfo(int level)
        {
			m_lock.AcquireReaderLock(-1);
			try
			{
				if (_consortiaLevel.ContainsKey(level))
				{
					return _consortiaLevel[level];
				}
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }
    }
}
