using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Threading;
using SqlDataProvider.Data;
using Bussiness;


namespace Bussiness.Managers
{
    public class TotemMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, TotemInfo> _totem;
        private static Random rand;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, TotemInfo> tempTotem = new Dictionary<int, TotemInfo>();

                if (Load(tempTotem))
                {
                    try
                    {
                        _totem = tempTotem;
                        return true;
                    }
                    catch
                    { }

                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("TotemMgr", e);
            }

            return false;
        }

        /// <summary>
        /// Initializes the StrengthenMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            try
            {
                _totem = new Dictionary<int, TotemInfo>();
                rand = new Random();
                return Load(_totem);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("TotemMgr", e);
                return false;
            }

        }

        private static bool Load(Dictionary<int, TotemInfo> totem)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                TotemInfo[] infos = db.GetAllTotem();
                foreach (TotemInfo info in infos)
                {
                    if (!totem.ContainsKey(info.ID))
                    {
                        totem.Add(info.ID, info);
                    }
                }
            }

            return true;
        }
        public static int MaxTotem()
        {
            return 10350;
        }
        private static ReaderWriterLock m_clientLocker = new ReaderWriterLock();
        public static TotemInfo FindTotemInfo(int id)
        {
            m_clientLocker.AcquireWriterLock(Timeout.Infinite);
            try
            {
                if (_totem.ContainsKey(id))
                    return _totem[id];
            }
            finally
            {
                m_clientLocker.ReleaseWriterLock();
            }
            return null;
        }
        public static int GetTotemProp(int id, string typeOf, double ratePlus = 0)
        {
            int totalProp = 0;
            for (int i = 10001; i <= id; i++)
            {
                TotemInfo temp = FindTotemInfo(i);
                switch (typeOf)
                {
                    case "att":
                        totalProp += temp.AddAttack;
                        break;
                    case "agi":
                        totalProp += temp.AddAgility;
                        break;
                    case "def":
                        totalProp += temp.AddDefence;
                        break;
                    case "luc":
                        totalProp += temp.AddLuck;
                        break;
                    case "blo":
                        totalProp += temp.AddBlood;
                        break;
                    case "dam":
                        totalProp += temp.AddDamage;
                        break;
                    case "gua":
                        totalProp += temp.AddGuard;
                        break;
                }
            }

            // plus
            totalProp += (int)(totalProp * (ratePlus / 100));
            return totalProp;
        }
    }
}
