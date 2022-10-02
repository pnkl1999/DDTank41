using Bussiness;
using Game.Base.Packets;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class FightRateMgr
    {
        protected static Dictionary<int, FightRateInfo> _fightRate;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        public static bool CanChangeStyle(BaseRoom game, GSPacketIn pkg)
        {
			FightRateInfo[] allFightRateInfo = GetAllFightRateInfo();
			try
			{
				FightRateInfo[] array = allFightRateInfo;
				FightRateInfo[] array2 = array;
				foreach (FightRateInfo fightRateInfo in array2)
				{
					if (fightRateInfo.BeginDay.Year <= DateTime.Now.Year && DateTime.Now.Year <= fightRateInfo.EndDay.Year && fightRateInfo.BeginDay.DayOfYear <= DateTime.Now.DayOfYear && DateTime.Now.DayOfYear <= fightRateInfo.EndDay.DayOfYear && fightRateInfo.BeginTime.TimeOfDay <= DateTime.Now.TimeOfDay && DateTime.Now.TimeOfDay <= fightRateInfo.EndTime.TimeOfDay && ThreadSafeRandom.NextStatic(1000000) < fightRateInfo.Rate)
					{
						return true;
					}
				}
			}
			catch
			{
			}
			pkg.WriteBoolean(val: false);
			return false;
        }

        public static FightRateInfo[] GetAllFightRateInfo()
        {
			FightRateInfo[] array = null;
			m_lock.AcquireReaderLock(10000);
			try
			{
				array = _fightRate.Values.ToArray();
			}
			catch
			{
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			if (array != null)
			{
				return array;
			}
			return new FightRateInfo[0];
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_fightRate = new Dictionary<int, FightRateInfo>();
				return LoadFightRate(_fightRate);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("AwardMgr", exception);
				}
				return false;
			}
        }

        private static bool LoadFightRate(Dictionary<int, FightRateInfo> fighRate)
        {
			using (ServiceBussiness serviceBussiness = new ServiceBussiness())
			{
				FightRateInfo[] fightRate = serviceBussiness.GetFightRate(GameServer.Instance.Configuration.ServerID);
				FightRateInfo[] array = fightRate;
				foreach (FightRateInfo fightRateInfo in array)
				{
					if (!fighRate.ContainsKey(fightRateInfo.ID))
					{
						fighRate.Add(fightRateInfo.ID, fightRateInfo);
					}
				}
			}
			return true;
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, FightRateInfo> dictionary = new Dictionary<int, FightRateInfo>();
				if (LoadFightRate(dictionary))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_fightRate = dictionary;
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
					log.Error("AwardMgr", exception);
				}
			}
			return false;
        }
    }
}
