using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class CardMgr
    {
        private static readonly ILog ilog_0;

        private static Dictionary<int, CardUpdateConditionInfo> dictionary_0;

        private static List<CardUpdateInfo> list_0;

        private static ReaderWriterLock readerWriterLock_0;

        private static ThreadSafeRandom threadSafeRandom_0;

        public static bool Init()
        {
			try
			{
				readerWriterLock_0 = new ReaderWriterLock();
				dictionary_0 = new Dictionary<int, CardUpdateConditionInfo>();
				list_0 = new List<CardUpdateInfo>();
				threadSafeRandom_0 = new ThreadSafeRandom();
				return ReLoad();
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("CardMgr", exception);
				}
				return false;
			}
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, CardUpdateConditionInfo> ppN9moWQoUbKcnEHdIE = new Dictionary<int, CardUpdateConditionInfo>();
				List<CardUpdateInfo> kCtWs5WWQ5Yo0KY8qBs = new List<CardUpdateInfo>();
				if (smethod_0(ppN9moWQoUbKcnEHdIE, kCtWs5WWQ5Yo0KY8qBs))
				{
					readerWriterLock_0.AcquireWriterLock(-1);
					try
					{
						dictionary_0 = ppN9moWQoUbKcnEHdIE;
						list_0 = kCtWs5WWQ5Yo0KY8qBs;
						return true;
					}
					catch
					{
					}
					finally
					{
						readerWriterLock_0.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("CardMgr", exception);
				}
			}
			return false;
        }

        private static bool smethod_0(Dictionary<int, CardUpdateConditionInfo> PpN9moWQoUbKcnEHdIE, List<CardUpdateInfo> kCtWs5WWQ5Yo0KY8qBs)
        {
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				CardUpdateConditionInfo[] allCardUpdateCondition = produceBussiness.GetAllCardUpdateCondition();
				CardUpdateInfo[] allCardUpdateInfo = produceBussiness.GetAllCardUpdateInfo();
				CardUpdateConditionInfo[] array = allCardUpdateCondition;
				CardUpdateConditionInfo[] array2 = array;
				foreach (CardUpdateConditionInfo cardUpdateConditionInfo in array2)
				{
					if (!PpN9moWQoUbKcnEHdIE.ContainsKey(cardUpdateConditionInfo.Level))
					{
						PpN9moWQoUbKcnEHdIE.Add(cardUpdateConditionInfo.Level, cardUpdateConditionInfo);
					}
				}
				CardUpdateInfo[] array3 = allCardUpdateInfo;
				CardUpdateInfo[] array4 = array3;
				foreach (CardUpdateInfo item in array4)
				{
					kCtWs5WWQ5Yo0KY8qBs.Add(item);
				}
			}
			return true;
        }

        public static CardUpdateConditionInfo GetCardUpdateCondition(int level)
        {
			if (dictionary_0.ContainsKey(level))
			{
				return dictionary_0[level];
			}
			return null;
        }

        public static CardUpdateInfo GetCardUpdateInfo(int templateId, int level)
        {
			foreach (CardUpdateInfo item in list_0)
			{
				if (item.Id == templateId && item.Level == level)
				{
					return item;
				}
			}
			return null;
        }

        public static int MaxLevel()
        {
			return dictionary_0.Count;
        }

        static CardMgr()
        {
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }
    }
}
