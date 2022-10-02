using Bussiness.Protocol;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
	public class DropMgr
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static List<DropCondiction> m_dropcondiction = new List<DropCondiction>();

		private static Dictionary<int, List<DropItem>> m_dropitem = new Dictionary<int, List<DropItem>>();

		private static string[] m_DropTypes = Enum.GetNames(typeof(eDropType));

		public static int FindCondiction(eDropType type, string para1, string para2)
		{
			string str = "," + para1 + ",";
			string str2 = "," + para2 + ",";
			foreach (DropCondiction condiction in m_dropcondiction)
			{
				if (condiction.CondictionType == (int)type && condiction.Para1.IndexOf(str) != -1 && condiction.Para2.IndexOf(str2) != -1)
				{
					return condiction.DropId;
				}
			}
			return 0;
		}

		public static List<DropItem> FindDropItem(int dropId)
		{
			if (m_dropitem.ContainsKey(dropId))
			{
				return m_dropitem[dropId];
			}
			return null;
		}

		public static bool Init()
		{
			return ReLoad();
		}

		public static List<DropCondiction> LoadDropConditionDb()
		{
			using ProduceBussiness bussiness = new ProduceBussiness();
			return bussiness.GetAllDropCondictions()?.ToList();
		}

		public static Dictionary<int, List<DropItem>> LoadDropItemDb()
		{
			Dictionary<int, List<DropItem>> dictionary = new Dictionary<int, List<DropItem>>();
			using ProduceBussiness bussiness = new ProduceBussiness();
			DropItem[] allDropItems = bussiness.GetAllDropItems();
			foreach (DropCondiction info in m_dropcondiction)
			{
				IEnumerable<DropItem> source = allDropItems.Where((DropItem s) => s.DropId == info.DropId);
				dictionary.Add(info.DropId, source.ToList());
			}
			return dictionary;
		}

		public static bool ReLoad()
		{
			try
			{
				List<DropCondiction> list = LoadDropConditionDb();
				Interlocked.Exchange(ref m_dropcondiction, list);
				Dictionary<int, List<DropItem>> dictionary = LoadDropItemDb();
				Interlocked.Exchange(ref m_dropitem, dictionary);
				return true;
			}
			catch (Exception exception)
			{
				log.Error("DropMgr", exception);
			}
			return false;
		}
	}
}