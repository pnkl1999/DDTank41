using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public static class AccumulActiveLoginMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static AccumulAtiveLoginAwardInfo[] m_AccumulAtiveLoginAward;

        private static Dictionary<int, List<AccumulAtiveLoginAwardInfo>> m_AccumulAtiveLoginAwards = new Dictionary<int, List<AccumulAtiveLoginAwardInfo>>();

        private static Random random = new Random();

        public static bool ReLoad()
        {
			try
			{
				AccumulAtiveLoginAwardInfo[] tempAccumulAtiveLoginAward = LoadAccumulAtiveLoginAwardDb();
				Dictionary<int, List<AccumulAtiveLoginAwardInfo>> tempAccumulAtiveLoginAwards = LoadAccumulAtiveLoginAwards(tempAccumulAtiveLoginAward);
				if (tempAccumulAtiveLoginAward != null)
				{
					Interlocked.Exchange(ref m_AccumulAtiveLoginAward, tempAccumulAtiveLoginAward);
					Interlocked.Exchange(ref m_AccumulAtiveLoginAwards, tempAccumulAtiveLoginAwards);
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReLoad", e);
				}
				return false;
			}
			return true;
        }

        public static bool Init()
        {
			return ReLoad();
        }

        public static AccumulAtiveLoginAwardInfo[] LoadAccumulAtiveLoginAwardDb()
        {
			using ProduceBussiness db = new ProduceBussiness();
			return db.GetAccumulAtiveLoginAwardInfos();
        }

        public static Dictionary<int, List<AccumulAtiveLoginAwardInfo>> LoadAccumulAtiveLoginAwards(AccumulAtiveLoginAwardInfo[] AccumulAtiveLoginAwards)
        {
			Dictionary<int, List<AccumulAtiveLoginAwardInfo>> infos = new Dictionary<int, List<AccumulAtiveLoginAwardInfo>>();
			foreach (AccumulAtiveLoginAwardInfo info in AccumulAtiveLoginAwards)
			{
				if (!infos.Keys.Contains(info.Type))
				{
					IEnumerable<AccumulAtiveLoginAwardInfo> temp = AccumulAtiveLoginAwards.Where((AccumulAtiveLoginAwardInfo s) => s.Type == info.Type);
					infos.Add(info.Type, temp.ToList());
				}
			}
			return infos;
        }

        public static List<AccumulAtiveLoginAwardInfo> FindAccumulAtiveLoginAward(int Count)
        {
			if (m_AccumulAtiveLoginAwards.ContainsKey(Count))
			{
				return m_AccumulAtiveLoginAwards[Count];
			}
			return null;
        }

        public static List<ItemInfo> GetAllAccumulAtiveLoginAward(int Count)
        {
			List<AccumulAtiveLoginAwardInfo> items = FindAccumulAtiveLoginAward(Count);
			List<ItemInfo> infos = new List<ItemInfo>();
			if (items != null)
			{
				foreach (AccumulAtiveLoginAwardInfo info in items)
				{
					ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(info.RewardItemID), info.RewardItemCount, 105);
					item.IsBinds = info.IsBind;
					item.ValidDate = info.RewardItemValid;
					item.StrengthenLevel = info.StrengthenLevel;
					item.AttackCompose = info.AttackCompose;
					item.DefendCompose = info.DefendCompose;
					item.AgilityCompose = info.AgilityCompose;
					item.LuckCompose = info.LuckCompose;
					infos.Add(item);
				}
			}
			return infos;
        }

        public static List<ItemInfo> GetSelecedAccumulAtiveLoginAward(int ID)
        {
			List<ItemInfo> infos = new List<ItemInfo>();
			List<AccumulAtiveLoginAwardInfo> items = FindAccumulAtiveLoginAward(7);
			if (items != null)
			{
				foreach (AccumulAtiveLoginAwardInfo info in items)
				{
					if (ID == info.ID)
					{
						ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(info.RewardItemID), info.RewardItemCount, 105);
						item.IsBinds = info.IsBind;
						item.ValidDate = info.RewardItemValid;
						item.StrengthenLevel = info.StrengthenLevel;
						item.AttackCompose = info.AttackCompose;
						item.DefendCompose = info.DefendCompose;
						item.AgilityCompose = info.AgilityCompose;
						item.LuckCompose = info.LuckCompose;
						infos.Add(item);
						break;
					}
				}
			}
			return infos;
        }
    }
}
