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
    public class PropItemMgr
    {
        private static Dictionary<int, ItemTemplateInfo> _allProp;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        public static int[] PropBag = new int[22]
		{
			10001,
			10002,
			10003,
			10004,
			10005,
			10006,
			10007,
			10008,
			10009,
			10010,
			10011,
			10012,
			10013,
			10014,
			10015,
			10016,
			10017,
			10018,
			10019,
			10020,
			10021,
			10022
		};

        public static int[] PropFightBag = new int[22]
		{
			10001,
			10002,
			10003,
			10004,
			10005,
			10006,
			10007,
			10008,
			10009,
			10010,
			10011,
			10012,
			10013,
			10014,
			10015,
			10016,
			10017,
			10018,
			10019,
			10020,
			10021,
			10022
		};

        private static ThreadSafeRandom random = new ThreadSafeRandom();

        public static ItemTemplateInfo FindAllProp(int id)
        {
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (_allProp.ContainsKey(id))
				{
					return _allProp[id];
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

        public static ItemTemplateInfo FindFightingProp(int id)
        {
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (!PropBag.Contains(id))
				{
					return null;
				}
				if (_allProp.ContainsKey(id))
				{
					return _allProp[id];
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

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_allProp = new Dictionary<int, ItemTemplateInfo>();
				return LoadProps(_allProp);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("InitProps", exception);
				}
				return false;
			}
        }

        private static bool LoadProps(Dictionary<int, ItemTemplateInfo> allProp)
        {
			using (ProduceBussiness bussiness = new ProduceBussiness())
			{
				ItemTemplateInfo[] singleCategory = bussiness.GetSingleCategory(10);
				ItemTemplateInfo[] array = singleCategory;
				foreach (ItemTemplateInfo info in array)
				{
					allProp.Add(info.TemplateID, info);
				}
			}
			return true;
        }

        public static bool Reload()
        {
			try
			{
				Dictionary<int, ItemTemplateInfo> allProp = new Dictionary<int, ItemTemplateInfo>();
				if (LoadProps(allProp))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_allProp = allProp;
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
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReloadProps", exception);
				}
			}
			return false;
        }
    }
}
