using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data
{
    public class DiceGameAwardMgr
    {
        private static Dictionary<int, DiceGameAwardInfo> m_diceGameAwards = new Dictionary<int, DiceGameAwardInfo>();

        public static bool Init() => DiceGameAwardMgr.ReLoad();

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, DiceGameAwardInfo> dictionary = DiceGameAwardMgr.LoadFromDatabase();
                if (dictionary.Values.Count > 0)
                {
                    Interlocked.Exchange<Dictionary<int, DiceGameAwardInfo>>(ref DiceGameAwardMgr.m_diceGameAwards, dictionary);
                    return true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("DiceGameAwardMgr init error:" + ex.ToString());
            }
            return false;
        }

        private static Dictionary<int, DiceGameAwardInfo> LoadFromDatabase()
        {
            Dictionary<int, DiceGameAwardInfo> dictionary = new Dictionary<int, DiceGameAwardInfo>();
            using (ProduceBussiness produceBussiness = new ProduceBussiness())
            {
                foreach (DiceGameAwardInfo diceGameAwardInfo in produceBussiness.GetAllDiceGameAward())
                {
                    if (!dictionary.ContainsKey(diceGameAwardInfo.Rank))
                        dictionary.Add(diceGameAwardInfo.Rank, diceGameAwardInfo);
                }
            }
            return dictionary;
        }

        public static List<DiceGameAwardInfo> GetAllDiceGameAward()
        {
            if (DiceGameAwardMgr.m_diceGameAwards.Count == 0)
                DiceGameAwardMgr.Init();
            return DiceGameAwardMgr.m_diceGameAwards.Values.ToList<DiceGameAwardInfo>();
        }

        public static DiceGameAwardInfo FindDiceGameAward(int id)
        {
            if (DiceGameAwardMgr.m_diceGameAwards.Count == 0)
                DiceGameAwardMgr.Init();
            return DiceGameAwardMgr.m_diceGameAwards.ContainsKey(id) ? DiceGameAwardMgr.m_diceGameAwards[id] : (DiceGameAwardInfo)null;
        }
    }
}
