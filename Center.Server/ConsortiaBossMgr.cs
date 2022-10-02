using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Center.Server
{
    public sealed class ConsortiaBossMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();

        private static Dictionary<int, ConsortiaInfo> m_consortias = new Dictionary<int, ConsortiaInfo>();

        public static int TimeCheckingAward = 0;

        public static bool AddConsortia(int consortiaId, ConsortiaInfo consortia)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					return false;
				}
				m_consortias.Add(consortiaId, consortia);
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return true;
        }

        public static void CloseConsortia(int consortiaId, bool IsBossDie)
        {
			if (m_consortias.ContainsKey(consortiaId) && m_consortias[consortiaId].bossState == 1)
			{
				m_consortias[consortiaId].bossState = 2;
				m_consortias[consortiaId].IsSendAward = true;
				m_consortias[consortiaId].IsBossDie = IsBossDie;
				m_consortias[consortiaId].SendToClient = true;
			}
        }

        public static bool ExtendAvailable(int consortiaId, int riches)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					if (m_consortias[consortiaId].extendAvailableNum <= 0)
					{
						return false;
					}
					m_consortias[consortiaId].extendAvailableNum--;
					m_consortias[consortiaId].endTime = m_consortias[consortiaId].endTime.AddMinutes(10.0);
					m_consortias[consortiaId].Riches = riches;
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return true;
        }

        public static List<int> GetAllConsortiaGetAward()
        {
			List<int> list = new List<int>();
			m_clientLocker.AcquireReaderLock(-1);
			try
			{
				foreach (ConsortiaInfo info in m_consortias.Values)
				{
					int consortiaID = info.ConsortiaID;
					if (info.IsSendAward)
					{
						list.Add(consortiaID);
						if (m_consortias.ContainsKey(consortiaID))
						{
							m_consortias[consortiaID].IsSendAward = false;
						}
					}
				}
			}
			finally
			{
				m_clientLocker.ReleaseReaderLock();
			}
			return list;
        }

        public static ConsortiaInfo GetConsortiaById(int consortiaId)
        {
			ConsortiaInfo info = null;
			m_clientLocker.AcquireReaderLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					info = m_consortias[consortiaId];
				}
			}
			finally
			{
				m_clientLocker.ReleaseReaderLock();
			}
			return info;
        }

        public static bool Init()
        {
			bool flag = false;
			try
			{
				m_consortias.Clear();
				flag = true;
			}
			catch (Exception exception)
			{
				log.Error("ConsortiaBossMgr Init", exception);
			}
			return flag;
        }

        public static void ResetConsortia(int consortiaId)
        {
			if (m_consortias.ContainsKey(consortiaId) && m_consortias[consortiaId].bossState == 2)
			{
				m_consortias[consortiaId].bossState = 0;
				m_consortias[consortiaId].IsBossDie = false;
			}
        }

        public static List<RankingPersonInfo> SelectRank(int consortiaId)
        {
			List<RankingPersonInfo> list = new List<RankingPersonInfo>();
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (!m_consortias.ContainsKey(consortiaId) || m_consortias[consortiaId].RankList == null)
				{
					return list;
				}
				IOrderedEnumerable<KeyValuePair<string, RankingPersonInfo>> enumerable = m_consortias[consortiaId].RankList.OrderByDescending((KeyValuePair<string, RankingPersonInfo> pair) => pair.Value.TotalDamage);
				foreach (KeyValuePair<string, RankingPersonInfo> item in enumerable)
				{
					list.Add(item.Value);
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return list;
        }

        public static void UpdateBlood(int consortiaId, int damage)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					ConsortiaInfo local1 = m_consortias[consortiaId];
					local1.TotalAllMemberDame += damage;
					if (m_consortias[consortiaId].TotalAllMemberDame >= m_consortias[consortiaId].MaxBlood)
					{
						CloseConsortia(consortiaId, IsBossDie: true);
					}
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
        }

        public static bool UpdateConsortia(int consortiaId, int bossState, DateTime endTime, DateTime LastOpenBoss, long MaxBlood)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					m_consortias[consortiaId].bossState = bossState;
					m_consortias[consortiaId].endTime = endTime;
					m_consortias[consortiaId].LastOpenBoss = LastOpenBoss;
					m_consortias[consortiaId].MaxBlood = MaxBlood;
					m_consortias[consortiaId].TotalAllMemberDame = 0L;
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return true;
        }

        public static void UpdateRank(int consortiaId, int damage, int richer, int honor, string nickName, int UserID)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					if (m_consortias[consortiaId].RankList == null)
					{
						m_consortias[consortiaId].RankList = new Dictionary<string, RankingPersonInfo>();
					}
					if (m_consortias[consortiaId].RankList.ContainsKey(nickName))
					{
						m_consortias[consortiaId].RankList[nickName].TotalDamage += damage;
						m_consortias[consortiaId].RankList[nickName].Damage += richer;
						m_consortias[consortiaId].RankList[nickName].Honor += honor;
						return;
					}
					RankingPersonInfo info = new RankingPersonInfo
					{
						ID = m_consortias[consortiaId].RankList.Count + 1,
						Name = nickName,
						UserID = UserID,
						TotalDamage = damage,
						Damage = richer,
						Honor = honor
					};
					m_consortias[consortiaId].RankList.Add(nickName, info);
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
        }

        public static void UpdateSendToClient(int consortiaId)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					m_consortias[consortiaId].SendToClient = false;
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
        }

        public static void UpdateTime()
        {
			foreach (ConsortiaInfo info in m_consortias.Values)
			{
				if (info.endTime < DateTime.Now)
				{
					CloseConsortia(info.ConsortiaID, IsBossDie: false);
				}
				if (info.LastOpenBoss.Date < DateTime.Now.Date)
				{
					ResetConsortia(info.ConsortiaID);
				}
			}
        }
    }
}
