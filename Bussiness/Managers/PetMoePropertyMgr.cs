using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System.Linq;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Reflection;

namespace Bussiness.Managers
{
    public class PetMoePropertyMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Dictionary<int, PetMoePropertyInfo> m_PetMoePropertys = new Dictionary<int, PetMoePropertyInfo>();
        private static Random random = new Random();
        public static bool ReLoad()
        {
            try
            {
                PetMoePropertyInfo[] tempPetMoeProperty = LoadPetMoePropertyDb();
                Dictionary<int, PetMoePropertyInfo> tempPetMoePropertys = LoadPetMoePropertys(tempPetMoeProperty);
                if (tempPetMoeProperty.Length > 0)
                {
                    Interlocked.Exchange(ref m_PetMoePropertys, tempPetMoePropertys);
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ReLoad PetMoeProperty", e);
                return false;
            }
            return true;
        }
        public static bool Init()
        {
            return ReLoad();
        }
        public static PetMoePropertyInfo[] LoadPetMoePropertyDb()
        {
            using (ProduceBussiness pb = new ProduceBussiness())
            {
                PetMoePropertyInfo[] infos = pb.GetAllPetMoeProperty();
                return infos;
            }
        }
        public static Dictionary<int, PetMoePropertyInfo> LoadPetMoePropertys(PetMoePropertyInfo[] PetMoeProperty)
        {
            Dictionary<int, PetMoePropertyInfo> infos = new Dictionary<int, PetMoePropertyInfo>();
            foreach (PetMoePropertyInfo info in PetMoeProperty)
            {
                if (!infos.Keys.Contains(info.Level))
                {
                    infos.Add(info.Level, info);
                }
            }
            return infos;
        }
        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();
        public static PetMoePropertyInfo FindPetMoeProperty(int Level)
        {
            m_clientLocker.AcquireWriterLock(Timeout.Infinite);
            try
            {
                if (m_PetMoePropertys.ContainsKey(Level))
                {
                    PetMoePropertyInfo item = m_PetMoePropertys[Level];
                    return item;
                }
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return null;
        }
        public static int FindMaxLevel()
        {
            return m_PetMoePropertys.Count;
        }
        public static PetMoePropertyInfo FindPetMoePropertyByGp(int exp)
        {
            PetMoePropertyInfo maxInfo = FindPetMoeProperty(FindMaxLevel());
            if (maxInfo != null && exp >= maxInfo.Exp)
                return maxInfo;

            for (int i = 1; i <= m_PetMoePropertys.Count; i++)
            {
                if (m_PetMoePropertys.ContainsKey(i) && exp < m_PetMoePropertys[i].Exp)
                    return i == 1 ? null : m_PetMoePropertys[i - 1];
            }
            return null;
        }

        public static PetMoePropertyInfo FindPetMoeExpInfo(int level)
        {
            if (m_PetMoePropertys.ContainsKey(level))
                return m_PetMoePropertys[level];

            return null;
        }

        public static int getNeedExp(int Exp, int level)
        {
            PetMoePropertyInfo temp = FindPetMoeExpInfo(level + 1);
            if (temp == null)
                return 0;

            return temp.Exp - Exp;
        }
    }
}