using Bussiness;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Threading;

namespace Game.Server.Managers
{
    public class UserBoxMgr
    {
        private static Dictionary<int, LoadUserBoxInfo> m_BoxInfo;

        private static ReaderWriterLock m_lock;

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, LoadUserBoxInfo> dictionary = new Dictionary<int, LoadUserBoxInfo>();
				if (LoadStrengthen(dictionary))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						m_BoxInfo = dictionary;
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
			catch (Exception arg)
			{
				Console.WriteLine("UserBoxMgr", arg);
			}
			return false;
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				m_BoxInfo = new Dictionary<int, LoadUserBoxInfo>();
				return LoadStrengthen(m_BoxInfo);
			}
			catch (Exception arg)
			{
				Console.WriteLine("UserBoxMgr", arg);
				return false;
			}
        }

        private static bool LoadStrengthen(Dictionary<int, LoadUserBoxInfo> m_TimeBoxInfo)
        {
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				LoadUserBoxInfo[] allTimeBoxAward = produceBussiness.GetAllTimeBoxAward();
				LoadUserBoxInfo[] array = allTimeBoxAward;
				foreach (LoadUserBoxInfo loadUserBoxInfo in array)
				{
					if (!m_TimeBoxInfo.ContainsKey(loadUserBoxInfo.ID))
					{
						m_TimeBoxInfo.Add(loadUserBoxInfo.ID, loadUserBoxInfo);
					}
				}
			}
			return true;
        }

        public static LoadUserBoxInfo FindTemplateByCondition(int type, int level, int condition)
        {
			foreach (KeyValuePair<int, LoadUserBoxInfo> item in m_BoxInfo)
			{
				if (type == 0)
				{
					if (type == item.Value.Type && level <= item.Value.Level && condition < item.Value.Condition)
					{
						return item.Value;
					}
				}
				else if (type == item.Value.Type && level < item.Value.Level && condition == item.Value.Condition)
				{
					return item.Value;
				}
			}
			return null;
        }
    }
}
