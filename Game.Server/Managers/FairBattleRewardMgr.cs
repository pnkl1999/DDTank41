using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using log4net.Util;
using System.Threading;
using Bussiness;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
    public class FairBattleRewardMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Dictionary<int, FairBattleRewardInfo> _fairBattleRewards;
        private static Random rand;
        public static bool Init()
        {
            try
            {
                _fairBattleRewards = new Dictionary<int, FairBattleRewardInfo>();
                rand = new Random();
                return LoadFairBattleReward(_fairBattleRewards);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("FairBattleRewardMgr", e);
                return false;
            }

        }
        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, FairBattleRewardInfo> tempFairBattleRewards = new Dictionary<int, FairBattleRewardInfo>();
                if (LoadFairBattleReward(tempFairBattleRewards))
                {
                    try
                    {
                        _fairBattleRewards = tempFairBattleRewards;
                        return true;
                    }
                    catch
                    { }
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("FairBattleMgr", e);
            }

            return false;
        }

        private static bool LoadFairBattleReward(Dictionary<int, FairBattleRewardInfo> Level)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                FairBattleRewardInfo[] infos = db.GetAllFairBattleReward();
                foreach (FairBattleRewardInfo info in infos)
                {
                    if (!Level.ContainsKey(info.Level))
                    {
                        Level.Add(info.Level, info);
                    }

                }

            }

            return true;
        }

        public static FairBattleRewardInfo FindLevel(int Level)
        {
            try
            {
                if (_fairBattleRewards.ContainsKey(Level))
                    return _fairBattleRewards[Level];
            }
            catch
            { }
            return null;
        }

        public static FairBattleRewardInfo GetBattleDataByPrestige(int Prestige)
        {
            //var _loc_2:* = this._battleDataList.length;
            int _loc_2 = _fairBattleRewards.Values.Count;
            //var _loc_3:* = _loc_2 - 1;
            int _loc_3 = _loc_2 - 1;
            while (_loc_3 >= 0)
            {

                if (Prestige >= _fairBattleRewards[_loc_3].Prestige)
                {
                    return _fairBattleRewards[_loc_3];
                }
                _loc_3 = _loc_3 - 1;
            }
            return null;
        }

        public static int MaxLevel()
        {
            if (_fairBattleRewards == null)
                Init();
            return _fairBattleRewards.Values.Count;
        }

        public static int GetLevel(int GP)
        {
            if (GP >= FindLevel(MaxLevel()).Prestige)
            {
                return MaxLevel();
            }
            else
            {
                for (int i = 1; i <= MaxLevel(); i++)
                {
                    if (GP < FindLevel(i).Prestige)
                        return (i - 1) == 0 ? 1 : (i - 1);
                }

            }
            return 1;
        }

        public static int GetGP(int level)
        {
            if (MaxLevel() > level && level > 0)
            {
                return FindLevel(level - 1).Prestige;
            }
            return 0;
        }

    }
}
