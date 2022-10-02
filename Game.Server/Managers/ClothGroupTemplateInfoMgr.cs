using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
	public class ClothGroupTemplateInfoMgr
	{
		private static Dictionary<int, ClothGroupTemplateInfo> _clothGroup;

		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static ReaderWriterLock m_lock;

		public static int CountClothGroupWithID(int ID)
		{
			int count;
			lock (ClothGroupTemplateInfoMgr.m_lock)
			{
				count = ClothGroupTemplateInfoMgr.GetClothGroupWithID(ID).Count;
			}
			return count;
		}

		public static ClothGroupTemplateInfo GetClothGroup(int ID, int TemplateID, int Sex)
		{
			ClothGroupTemplateInfo clothGroupTemplateInfo;
			ClothGroupTemplateInfo result;
			lock (ClothGroupTemplateInfoMgr.m_lock)
			{
				if (ClothGroupTemplateInfoMgr._clothGroup.Count > 0)
				{
					foreach (ClothGroupTemplateInfo current in ClothGroupTemplateInfoMgr._clothGroup.Values)
					{
						if (current.TemplateID == TemplateID && current.ID == ID && current.Sex == Sex)
						{
							clothGroupTemplateInfo = current;
							result = clothGroupTemplateInfo;
							return result;
						}
					}
				}
				clothGroupTemplateInfo = null;
			}
			result = clothGroupTemplateInfo;
			return result;
		}

		public static List<ClothGroupTemplateInfo> GetClothGroupWithID(int ID)
		{
			List<ClothGroupTemplateInfo> result;
			lock (ClothGroupTemplateInfoMgr.m_lock)
			{
				List<ClothGroupTemplateInfo> list = new List<ClothGroupTemplateInfo>();
				if (ClothGroupTemplateInfoMgr._clothGroup.Count > 0)
				{
					foreach (ClothGroupTemplateInfo current in ClothGroupTemplateInfoMgr._clothGroup.Values)
					{
						if (current.ID == ID)
						{
							list.Add(current);
						}
					}
				}
				result = list;
			}
			return result;
		}

		public static bool Init()
		{
			bool result;
			try
			{
				ClothGroupTemplateInfoMgr.m_lock = new ReaderWriterLock();
				ClothGroupTemplateInfoMgr._clothGroup = new Dictionary<int, ClothGroupTemplateInfo>();
				result = ClothGroupTemplateInfoMgr.LoadClothGroup(ClothGroupTemplateInfoMgr._clothGroup);
			}
			catch (Exception exception)
			{
				if (ClothGroupTemplateInfoMgr.log.IsErrorEnabled)
				{
					ClothGroupTemplateInfoMgr.log.Error("ClothGroupMgr", exception);
				}
				result = false;
			}
			return result;
		}

		private static bool LoadClothGroup(Dictionary<int, ClothGroupTemplateInfo> clothGroup)
		{
			using (ProduceBussiness pb = new ProduceBussiness())
			{
				ClothGroupTemplateInfo[] allClothGroup = pb.GetAllClothGroup();
				for (int i = 0; i < allClothGroup.Length; i++)
				{
					ClothGroupTemplateInfo clothGroupTemplateInfo = allClothGroup[i];
					if (!clothGroup.ContainsKey(clothGroupTemplateInfo.ItemID))
					{
						clothGroup.Add(clothGroupTemplateInfo.ItemID, clothGroupTemplateInfo);
					}
				}
			}
			return true;
		}

		public static bool ReLoad()
		{
			bool flag;
			bool result;
			try
			{
				Dictionary<int, ClothGroupTemplateInfo> clothGroup = new Dictionary<int, ClothGroupTemplateInfo>();
				if (ClothGroupTemplateInfoMgr.LoadClothGroup(clothGroup))
				{
					ClothGroupTemplateInfoMgr.m_lock.AcquireWriterLock(-1);
					try
					{
						ClothGroupTemplateInfoMgr._clothGroup = clothGroup;
						flag = true;
						result = flag;
						return result;
					}
					catch
					{
					}
					finally
					{
						ClothGroupTemplateInfoMgr.m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (ClothGroupTemplateInfoMgr.log.IsErrorEnabled)
				{
					ClothGroupTemplateInfoMgr.log.Error("ClothGroupMgr", exception);
				}
			}
			flag = false;
			result = flag;
			return result;
		}
	}
}
