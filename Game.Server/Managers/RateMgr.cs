using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class RateMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock = new ReaderWriterLock();

        private static ArrayList m_RateInfos = new ArrayList();

        public static float GetRate(eRateType eType)
        {
			float result = 1f;
			m_lock.AcquireReaderLock(10000);
			try
			{
				RateInfo rateInfoWithType = GetRateInfoWithType((int)eType);
				if (rateInfoWithType == null)
				{
					return result;
				}
				if (rateInfoWithType.Rate == 0f)
				{
					return 1f;
				}
				if (IsValid(rateInfoWithType))
				{
					result = rateInfoWithType.Rate;
					return result;
				}
				return result;
			}
			catch
			{
				return result;
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        private static RateInfo GetRateInfoWithType(int type)
        {
			foreach (RateInfo rateInfo in m_RateInfos)
			{
				if (rateInfo.Type == type)
				{
					return rateInfo;
				}
			}
			return null;
        }

        public static bool Init(GameServerConfig config)
        {
			m_lock.AcquireWriterLock(-1);
			try
			{
				using (ServiceBussiness serviceBussiness = new ServiceBussiness())
				{
					m_RateInfos = serviceBussiness.GetRate(config.ServerID);
				}
				return true;
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("RateMgr", exception);
				}
				return false;
			}
			finally
			{
				m_lock.ReleaseWriterLock();
			}
        }

        private static bool IsValid(RateInfo _RateInfo)
        {
			_ = _RateInfo.BeginDay;
			_ = _RateInfo.EndDay;
			if (_RateInfo.BeginDay.Year <= DateTime.Now.Year && DateTime.Now.Year <= _RateInfo.EndDay.Year && _RateInfo.BeginDay.DayOfYear <= DateTime.Now.DayOfYear && DateTime.Now.DayOfYear <= _RateInfo.EndDay.DayOfYear && _RateInfo.BeginTime.TimeOfDay <= DateTime.Now.TimeOfDay)
			{
				return DateTime.Now.TimeOfDay <= _RateInfo.EndTime.TimeOfDay;
			}
			return false;
        }

        public static bool ReLoad()
        {
			return Init(GameServer.Instance.Configuration);
        }
    }
}
