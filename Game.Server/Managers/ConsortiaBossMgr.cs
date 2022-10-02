using Bussiness;
using Bussiness.Managers;
using Game.Base.Packets;
using Game.Logic;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class ConsortiaBossMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();

        private static Dictionary<int, ConsortiaInfo> m_consortias = new Dictionary<int, ConsortiaInfo>();

        public static bool AddConsortia(ConsortiaInfo consortia)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(180);
			gSPacketIn.WriteInt(consortia.ConsortiaID);
			gSPacketIn.WriteInt(consortia.ChairmanID);
			gSPacketIn.WriteByte((byte)consortia.bossState);
			gSPacketIn.WriteDateTime(consortia.endTime);
			gSPacketIn.WriteInt(consortia.extendAvailableNum);
			gSPacketIn.WriteInt(consortia.callBossLevel);
			gSPacketIn.WriteInt(consortia.Level);
			gSPacketIn.WriteInt(consortia.SmithLevel);
			gSPacketIn.WriteInt(consortia.StoreLevel);
			gSPacketIn.WriteInt(consortia.SkillLevel);
			gSPacketIn.WriteInt(consortia.Riches);
			gSPacketIn.WriteDateTime(consortia.LastOpenBoss);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
			return true;
        }

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

        public static void CreateBoss(ConsortiaInfo consortia, int npcId)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(183);
			gSPacketIn.WriteInt(consortia.ConsortiaID);
			gSPacketIn.WriteByte((byte)consortia.bossState);
			gSPacketIn.WriteDateTime(consortia.endTime);
			gSPacketIn.WriteDateTime(consortia.LastOpenBoss);
			int val = 15000000;
			NpcInfo npcInfoById = NPCInfoMgr.GetNpcInfoById(npcId);
			if (npcInfoById != null)
			{
				val = npcInfoById.Blood;
			}
			gSPacketIn.WriteInt(val);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
        }

        public static void ExtendAvailable(int consortiaId, int riches)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(182);
			gSPacketIn.WriteInt(consortiaId);
			gSPacketIn.WriteInt(riches);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
        }

        public static long GetConsortiaBossTotalDame(int consortiaId)
        {
			if (m_consortias.ContainsKey(consortiaId))
			{
				long num = m_consortias[consortiaId].TotalAllMemberDame;
				long maxBlood = m_consortias[consortiaId].MaxBlood;
				if (num > maxBlood)
				{
					num = maxBlood - 1000;
				}
				return num;
			}
			return 0L;
        }

        public static ConsortiaInfo GetConsortiaById(int consortiaId)
        {
			ConsortiaInfo result = null;
			m_clientLocker.AcquireReaderLock(10000);
			try
			{
				if (m_consortias.ContainsKey(consortiaId))
				{
					return m_consortias[consortiaId];
				}
				return result;
			}
			finally
			{
				m_clientLocker.ReleaseReaderLock();
			}
        }

        public static bool GetConsortiaExit(int consortiaId)
        {
			m_clientLocker.AcquireReaderLock(10000);
			try
			{
				return m_consortias.ContainsKey(consortiaId);
			}
			finally
			{
				m_clientLocker.ReleaseReaderLock();
			}
        }

        public static void reload(int consortiaId)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(184);
			gSPacketIn.WriteInt(consortiaId);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
        }

        public static void SendConsortiaAward(int consortiaId)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				if (!m_consortias.ContainsKey(consortiaId))
				{
					return;
				}
				ConsortiaInfo consortiaInfo = m_consortias[consortiaId];
				int num = 50000 + consortiaInfo.callBossLevel;
				List<ItemInfo> info = null;
				DropInventory.CopyAllDrop(num, ref info);
				int riches = 0;
				if (consortiaInfo.RankList == null)
				{
					return;
				}
				foreach (RankingPersonInfo value in consortiaInfo.RankList.Values)
				{
					if (consortiaInfo.IsBossDie)
					{
						string title = "Recompensas chefe da guilda";
						if (info != null)
						{
							WorldEventMgr.SendItemsToMail(info, value.UserID, value.Name, title);
						}
						else
						{
							//Console.WriteLine("Boss Guild award error dropID {0} ", num);
						}
					}
					riches += value.Damage;
				}
				using ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness();
				consortiaBussiness.ConsortiaRichAdd(consortiaId, ref riches, 5, "Boss Guild");
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
        }

        public static void UpdateBlood(int consortiaId, int damage)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(186);
			gSPacketIn.WriteInt(consortiaId);
			gSPacketIn.WriteInt(damage);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
        }

        public static bool UpdateConsortia(ConsortiaInfo info)
        {
			m_clientLocker.AcquireWriterLock(-1);
			try
			{
				int consortiaID = info.ConsortiaID;
				if (m_consortias.ContainsKey(consortiaID))
				{
					m_consortias[consortiaID] = info;
				}
			}
			finally
			{
				m_clientLocker.ReleaseWriterLock();
			}
			return true;
        }

        public static void UpdateRank(int consortiaId, int damage, int richer, int honor, string Nickname, int userID)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(181);
			gSPacketIn.WriteInt(consortiaId);
			gSPacketIn.WriteInt(damage);
			gSPacketIn.WriteInt(richer);
			gSPacketIn.WriteInt(honor);
			gSPacketIn.WriteString(Nickname);
			gSPacketIn.WriteInt(userID);
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
        }
    }
}
