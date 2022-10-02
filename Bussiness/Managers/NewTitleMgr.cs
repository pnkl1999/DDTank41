using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class NewTitleMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, NewTitleInfo> m_NewTitles = new Dictionary<int, NewTitleInfo>();

        private static Random random = new Random();

        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();

        public static bool ReLoad()
        {
			try
			{
				NewTitleInfo[] tempNewTitle = LoadNewTitleDb();
				Dictionary<int, NewTitleInfo> tempNewTitles = LoadNewTitles(tempNewTitle);
				if (tempNewTitle.Length != 0)
				{
					Interlocked.Exchange(ref m_NewTitles, tempNewTitles);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReLoad NewTitle", e);
				}
				return false;
			}
			return true;
        }

        public static bool Init()
        {
			return ReLoad();
        }

        public static NewTitleInfo[] LoadNewTitleDb()
        {
			using ProduceBussiness pb = new ProduceBussiness();
			return pb.GetAllNewTitle();
        }

        public static Dictionary<int, NewTitleInfo> LoadNewTitles(NewTitleInfo[] NewTitle)
        {
			Dictionary<int, NewTitleInfo> infos = new Dictionary<int, NewTitleInfo>();
			foreach (NewTitleInfo info in NewTitle)
			{
				if (!infos.Keys.Contains(info.ID))
				{
					infos.Add(info.ID, info);
				}
			}
			return infos;
        }

        public static NewTitleInfo FindNewTitle(int ID)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_NewTitles.ContainsKey(ID))
				{
					return m_NewTitles[ID];
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return null;
        }

        public static NewTitleInfo FindNewTitleByName(string Name)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				foreach (NewTitleInfo info in m_NewTitles.Values)
				{
					if (info.Name.ToLower() == Name.ToLower())
					{
						return info;
					}
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return null;
        }
    }
}
