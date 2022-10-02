using Bussiness;
using Bussiness.Managers;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class RefineryMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, RefineryInfo> m_Item_Refinery = new Dictionary<int, RefineryInfo>();

        private static ThreadSafeRandom rand = new ThreadSafeRandom();

        public static bool Init()
        {
			return Reload();
        }

        public static Dictionary<int, RefineryInfo> LoadFromBD()
        {
			new List<RefineryInfo>();
			Dictionary<int, RefineryInfo> dictionary = new Dictionary<int, RefineryInfo>();
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			foreach (RefineryInfo item in produceBussiness.GetAllRefineryInfo())
			{
				if (!dictionary.ContainsKey(item.RefineryID))
				{
					dictionary.Add(item.RefineryID, item);
				}
			}
			return dictionary;
        }

        public static ItemTemplateInfo Refinery(GamePlayer player, List<ItemInfo> Items, ItemInfo Item, bool Luck, int OpertionType, ref bool result, ref int defaultprobability, ref bool IsFormula)
        {
			new ItemTemplateInfo();
			foreach (int key in m_Item_Refinery.Keys)
			{
				if (m_Item_Refinery[key].m_Equip.Contains(Item.TemplateID))
				{
					IsFormula = true;
					int num = 0;
					List<int> list = new List<int>();
					foreach (ItemInfo Item2 in Items)
					{
						if (Item2.TemplateID == m_Item_Refinery[key].Item1 && Item2.Count >= m_Item_Refinery[key].Item1Count && !list.Contains(Item2.TemplateID))
						{
							list.Add(Item2.TemplateID);
							if (OpertionType != 0)
							{
								Item2.Count -= m_Item_Refinery[key].Item1Count;
							}
							num++;
						}
						if (Item2.TemplateID == m_Item_Refinery[key].Item2 && Item2.Count >= m_Item_Refinery[key].Item2Count && !list.Contains(Item2.TemplateID))
						{
							list.Add(Item2.TemplateID);
							if (OpertionType != 0)
							{
								Item2.Count -= m_Item_Refinery[key].Item2Count;
							}
							num++;
						}
						if (Item2.TemplateID == m_Item_Refinery[key].Item3 && Item2.Count >= m_Item_Refinery[key].Item3Count && !list.Contains(Item2.TemplateID))
						{
							list.Add(Item2.TemplateID);
							if (OpertionType != 0)
							{
								Item2.Count -= m_Item_Refinery[key].Item3Count;
							}
							num++;
						}
					}
					if (num != 3)
					{
						continue;
					}
					for (int i = 0; i < m_Item_Refinery[key].m_Reward.Count; i++)
					{
						if (Items[Items.Count - 1].TemplateID == m_Item_Refinery[key].m_Reward[i])
						{
							if (Luck)
							{
								defaultprobability += 20;
							}
							if (OpertionType == 0)
							{
								return ItemMgr.FindItemTemplate(m_Item_Refinery[key].m_Reward[i + 1]);
							}
							if (rand.Next(100) < defaultprobability)
							{
								int templateId = m_Item_Refinery[key].m_Reward[i + 1];
								result = true;
								return ItemMgr.FindItemTemplate(templateId);
							}
						}
					}
				}
				else
				{
					IsFormula = false;
				}
			}
			return null;
        }

        public static ItemTemplateInfo RefineryTrend(int Operation, ItemInfo Item, ref bool result)
        {
			if (Item != null)
			{
				foreach (int key in m_Item_Refinery.Keys)
				{
					if (!m_Item_Refinery[key].m_Reward.Contains(Item.TemplateID))
					{
						continue;
					}
					for (int i = 0; i < m_Item_Refinery[key].m_Reward.Count; i++)
					{
						if (m_Item_Refinery[key].m_Reward[i] == Operation)
						{
							int templateId = m_Item_Refinery[key].m_Reward[i + 2];
							result = true;
							return ItemMgr.FindItemTemplate(templateId);
						}
					}
				}
			}
			return null;
        }

        public static bool Reload()
        {
			try
			{
				Dictionary<int, RefineryInfo> dictionary = new Dictionary<int, RefineryInfo>();
				dictionary = LoadFromBD();
				if (dictionary.Count > 0)
				{
					Interlocked.Exchange(ref m_Item_Refinery, dictionary);
				}
				return true;
			}
			catch (Exception exception)
			{
				log.Error("NPCInfoMgr", exception);
			}
			return false;
        }
    }
}
