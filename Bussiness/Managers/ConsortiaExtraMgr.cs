using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class ConsortiaExtraMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, ConsortiaLevelInfo> _consortiaLevel;

        private static Dictionary<int, ConsortiaBuffTempInfo> _consortiaBuffTemp;

        private static Dictionary<int, ConsortiaBossConfigInfo> _consortiaBossConfig;

        private static Dictionary<int, ConsortiaBadgeConfigInfo> m_consortiaBadgeConfigs = new Dictionary<int, ConsortiaBadgeConfigInfo>();

        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, ConsortiaLevelInfo> tempConsortiaLevel = new Dictionary<int, ConsortiaLevelInfo>();
                Dictionary<int, ConsortiaBuffTempInfo> tempConsortiaBuffTemp = new Dictionary<int, ConsortiaBuffTempInfo>();
                Dictionary<int, ConsortiaBadgeConfigInfo> tempConsortiaBadgeConfigs = LoadFromDatabase();
                if (Load(tempConsortiaLevel, tempConsortiaBuffTemp))
                {
                    m_clientLocker.AcquireWriterLock(-1);
                    try
                    {
                        _consortiaLevel = tempConsortiaLevel;
                        _consortiaBuffTemp = tempConsortiaBuffTemp;
                        if (tempConsortiaBadgeConfigs.Values.Count > 0)
                        {
                            Interlocked.Exchange(ref m_consortiaBadgeConfigs, tempConsortiaBadgeConfigs);
                        }
                        return true;
                    }
                    catch
                    {
                    }
                    finally
                    {
                        m_clientLocker.ReleaseWriterLock();
                    }
                }
            }
            catch (Exception ex)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("ConsortiaExtraMgr", ex);
                }
            }
            return false;
        }

        public static bool Init()
        {
            try
            {
                return ReLoad();
            }
            catch (Exception ex)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("ConsortiaExtraMgr", ex);
                }
                return false;
            }
        }

        private static Dictionary<int, ConsortiaBadgeConfigInfo> LoadFromDatabase()
        {
            Dictionary<int, ConsortiaBadgeConfigInfo> list = new Dictionary<int, ConsortiaBadgeConfigInfo>();
            using (ProduceBussiness db = new ProduceBussiness())
            {
                ConsortiaBadgeConfigInfo[] consortiaBadgeConfigInfos = db.GetAllConsortiaBadgeConfig();
                ConsortiaBadgeConfigInfo[] array = consortiaBadgeConfigInfos;
                foreach (ConsortiaBadgeConfigInfo info in array)
                {
                    if (!list.ContainsKey(info.BadgeID))
                    {
                        list.Add(info.BadgeID, info);
                    }
                }
            }
            return list;
        }

        private static bool Load(Dictionary<int, ConsortiaLevelInfo> consortiaLevel, Dictionary<int, ConsortiaBuffTempInfo> consortiaBuffTemp)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                ConsortiaLevelInfo[] infos = db.GetAllConsortiaLevel();
                ConsortiaLevelInfo[] array = infos;
                foreach (ConsortiaLevelInfo info in array)
                {
                    if (!consortiaLevel.ContainsKey(info.Level))
                    {
                        consortiaLevel.Add(info.Level, info);
                    }
                }
                ConsortiaBuffTempInfo[] buffInfos = db.GetAllConsortiaBuffTemp();
                ConsortiaBuffTempInfo[] array2 = buffInfos;
                foreach (ConsortiaBuffTempInfo info in array2)
                {
                    if (!consortiaBuffTemp.ContainsKey(info.id))
                    {
                        consortiaBuffTemp.Add(info.id, info);
                    }
                }
            }
            return true;
        }

        public static ConsortiaBadgeConfigInfo FindConsortiaBadgeConfig(int level)
        {
            if (m_consortiaBadgeConfigs.ContainsKey(level))
            {
                return m_consortiaBadgeConfigs[level];
            }
            return null;
        }

        public static ConsortiaBossConfigInfo FindConsortiaBossInfo(int id)
        {
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                if (_consortiaBossConfig.ContainsKey(id))
                {
                    return _consortiaBossConfig[id];
                }
            }
            catch
            {
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return null;
        }

        public static ConsortiaLevelInfo FindConsortiaLevelInfo(int level)
        {
            m_clientLocker.AcquireReaderLock(-1);
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
                m_clientLocker.ReleaseReaderLock();
            }
            return null;
        }

        public static ConsortiaBuffTempInfo FindConsortiaBuffInfo(int id)
        {
            m_clientLocker.AcquireReaderLock(-1);
            try
            {
                if (_consortiaBuffTemp.ContainsKey(id))
                {
                    return _consortiaBuffTemp[id];
                }
            }
            catch
            {
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
            return null;
        }

        public static List<ConsortiaBuffTempInfo> GetAllConsortiaBuff()
        {
            m_clientLocker.AcquireReaderLock(-1);
            List<ConsortiaBuffTempInfo> list = new List<ConsortiaBuffTempInfo>();
            try
            {
                foreach (ConsortiaBuffTempInfo buff in _consortiaBuffTemp.Values)
                {
                    list.Add(buff);
                }
                return list;
            }
            catch
            {
                return list;
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
        }

        public static List<ConsortiaBuffTempInfo> GetAllConsortiaBuff(int level, int type)
        {
            m_clientLocker.AcquireReaderLock(-1);
            List<ConsortiaBuffTempInfo> list = new List<ConsortiaBuffTempInfo>();
            try
            {
                foreach (ConsortiaBuffTempInfo buff in _consortiaBuffTemp.Values)
                {
                    if (buff.level == level && buff.type == type)
                    {
                        list.Add(buff);
                    }
                }
                return list;
            }
            catch
            {
                return list;
            }
            finally
            {
                m_clientLocker.ReleaseReaderLock();
            }
        }
    }
}
