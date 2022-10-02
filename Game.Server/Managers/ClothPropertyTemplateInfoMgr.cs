using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
	public class ClothPropertyTemplateInfoMgr
	{
		private static Dictionary<int, ClothPropertyTemplateInfo> _clothProperty;

		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		private static ReaderWriterLock m_lock;

		public static ClothPropertyTemplateInfo GetClothPropertyWithID(int ID)
		{
			ClothPropertyTemplateInfo clothPropertyTemplateInfo;
			ClothPropertyTemplateInfo result;
			lock (ClothPropertyTemplateInfoMgr.m_lock)
			{
				if (ClothPropertyTemplateInfoMgr._clothProperty.Count > 0)
				{
					foreach (ClothPropertyTemplateInfo current in ClothPropertyTemplateInfoMgr._clothProperty.Values)
					{
						if (current.ID == ID)
						{
							clothPropertyTemplateInfo = current;
							result = clothPropertyTemplateInfo;
							return result;
						}
					}
				}
				clothPropertyTemplateInfo = null;
			}
			result = clothPropertyTemplateInfo;
			return result;
		}

		public static ClothPropertyTemplateInfo GetClothPropertyWithID(int ID, int Sex)
		{
			ClothPropertyTemplateInfo clothPropertyTemplateInfo;
			ClothPropertyTemplateInfo result;
			lock (ClothPropertyTemplateInfoMgr.m_lock)
			{
				if (ClothPropertyTemplateInfoMgr._clothProperty.Count > 0)
				{
					foreach (ClothPropertyTemplateInfo current in ClothPropertyTemplateInfoMgr._clothProperty.Values)
					{
						if (current.ID == ID && current.Sex == Sex)
						{
							clothPropertyTemplateInfo = current;
							result = clothPropertyTemplateInfo;
							return result;
						}
					}
				}
				clothPropertyTemplateInfo = null;
			}
			result = clothPropertyTemplateInfo;
			return result;
		}

		public static bool Init()
		{
			bool result;
			try
			{
				ClothPropertyTemplateInfoMgr.m_lock = new ReaderWriterLock();
				ClothPropertyTemplateInfoMgr._clothProperty = new Dictionary<int, ClothPropertyTemplateInfo>();
				result = ClothPropertyTemplateInfoMgr.LoadClothProperty(ClothPropertyTemplateInfoMgr._clothProperty);
			}
			catch (Exception exception)
			{
				if (ClothPropertyTemplateInfoMgr.log.IsErrorEnabled)
				{
					ClothPropertyTemplateInfoMgr.log.Error("ClothPropertyMgr", exception);
				}
				result = false;
			}
			return result;
		}

		private static bool LoadClothProperty(Dictionary<int, ClothPropertyTemplateInfo> clothProperty)
		{
			using (ProduceBussiness pb = new ProduceBussiness())
			{
				ClothPropertyTemplateInfo[] allClothProperty = pb.GetAllClothProperty();
				for (int i = 0; i < allClothProperty.Length; i++)
				{
					ClothPropertyTemplateInfo clothPropertyTemplateInfo = allClothProperty[i];
					if (!clothProperty.ContainsKey(clothPropertyTemplateInfo.ID))
					{
						clothProperty.Add(clothPropertyTemplateInfo.ID, clothPropertyTemplateInfo);
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
				Dictionary<int, ClothPropertyTemplateInfo> clothProperty = new Dictionary<int, ClothPropertyTemplateInfo>();
				if (ClothPropertyTemplateInfoMgr.LoadClothProperty(clothProperty))
				{
					ClothPropertyTemplateInfoMgr.m_lock.AcquireWriterLock(-1);
					try
					{
						ClothPropertyTemplateInfoMgr._clothProperty = clothProperty;
						flag = true;
						result = flag;
						return result;
					}
					catch
					{
					}
					finally
					{
						ClothPropertyTemplateInfoMgr.m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (ClothPropertyTemplateInfoMgr.log.IsErrorEnabled)
				{
					ClothPropertyTemplateInfoMgr.log.Error("ClothPropertyMgr", exception);
				}
			}
			flag = false;
			result = flag;
			return result;
		}
	}
}
