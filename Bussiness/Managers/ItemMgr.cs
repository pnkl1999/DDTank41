using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class ItemMgr
    {
        private static Dictionary<int, ItemTemplateInfo> _items;

        private static Dictionary<int, LoadUserBoxInfo> _timeBoxs;

        private static List<ItemTemplateInfo> Lists;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ReaderWriterLock m_lock;

        public static LoadUserBoxInfo FindItemBoxTemplate(int Id)
        {
			if (_timeBoxs == null)
			{
				Init();
			}
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (_timeBoxs.Keys.Contains(Id))
				{
					return _timeBoxs[Id];
				}
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static LoadUserBoxInfo FindItemBoxTypeAndLv(int type, int lv)
        {
			if (_timeBoxs == null)
			{
				Init();
			}
			m_lock.AcquireReaderLock(10000);
			try
			{
				foreach (LoadUserBoxInfo info in _timeBoxs.Values)
				{
					if (info.Type == type && info.Level == lv)
					{
						return info;
					}
				}
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static ItemTemplateInfo FindItemTemplate(int templateId)
        {
			if (_items == null)
			{
				Init();
			}
			m_lock.AcquireReaderLock(10000);
			try
			{
				if (_items.Keys.Contains(templateId))
				{
					return _items[templateId];
				}
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static ItemTemplateInfo GetGoodsbyFusionTypeandLevel(int fusionType, int level)
        {
			if (_items == null)
			{
				Init();
			}
			m_lock.AcquireReaderLock(-1);
			try
			{
				foreach (ItemTemplateInfo info in _items.Values)
				{
					if (info.FusionType == fusionType && info.Level == level)
					{
						return info;
					}
				}
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static ItemTemplateInfo GetGoodsbyFusionTypeandQuality(int fusionType, int quality)
        {
			if (_items == null)
			{
				Init();
			}
			m_lock.AcquireReaderLock(10000);
			try
			{
				foreach (ItemTemplateInfo info in _items.Values)
				{
					if (info.FusionType == fusionType && info.Quality == quality)
					{
						return info;
					}
				}
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			return null;
        }

        public static bool Init()
        {
			try
			{
				m_lock = new ReaderWriterLock();
				_items = new Dictionary<int, ItemTemplateInfo>();
				_timeBoxs = new Dictionary<int, LoadUserBoxInfo>();
				Lists = new List<ItemTemplateInfo>();
				return LoadItem(_items, _timeBoxs);
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("Init", exception);
				}
				return false;
			}
        }

        public static bool LoadItem(Dictionary<int, ItemTemplateInfo> infos, Dictionary<int, LoadUserBoxInfo> userBoxs)
        {
			using (ProduceBussiness bussiness = new ProduceBussiness())
			{
				ItemTemplateInfo[] allGoods = bussiness.GetAllGoods();
				ItemTemplateInfo[] array = allGoods;
				foreach (ItemTemplateInfo info in array)
				{
					if (!infos.Keys.Contains(info.TemplateID))
					{
						infos.Add(info.TemplateID, info);
					}
				}
				LoadUserBoxInfo[] allTimeBoxAward = bussiness.GetAllTimeBoxAward();
				LoadUserBoxInfo[] array2 = allTimeBoxAward;
				foreach (LoadUserBoxInfo info2 in array2)
				{
					if (!userBoxs.Keys.Contains(info2.ID))
					{
						userBoxs.Add(info2.ID, info2);
					}
				}
			}
			return true;
        }

        public static bool ReLoad()
        {
			try
			{
				Dictionary<int, ItemTemplateInfo> infos = new Dictionary<int, ItemTemplateInfo>();
				Dictionary<int, LoadUserBoxInfo> userBoxs = new Dictionary<int, LoadUserBoxInfo>();
				if (LoadItem(infos, userBoxs))
				{
					m_lock.AcquireWriterLock(-1);
					try
					{
						_items = infos;
						_timeBoxs = userBoxs;
						return true;
					}
					catch
					{
					}
					finally
					{
						m_lock.ReleaseWriterLock();
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("ReLoad", exception);
				}
			}
			return false;
        }

        public static List<ItemInfo> SpiltGoodsMaxCount(ItemInfo itemInfo)
        {
			List<ItemInfo> list = new List<ItemInfo>();
			for (int i = 0; i < itemInfo.Count; i += itemInfo.Template.MaxCount)
			{
				int num2 = ((itemInfo.Count < itemInfo.Template.MaxCount) ? itemInfo.Count : itemInfo.Template.MaxCount);
				ItemInfo item = itemInfo.Clone();
				item.Count = num2;
				list.Add(item);
			}
			return list;
        }

		//     public static ItemTemplateInfo FindGoldItemTemplate(int templateId, bool IsGold)
		//     {
		//if (IsGold)
		//{
		//	GoldEquipTemplateInfo goldEquipByTemplate = GoldEquipMgr.FindGoldEquipByTemplate(templateId);
		//	if (goldEquipByTemplate == null)
		//	{
		//		return null;
		//	}
		//	if (_items.Keys.Contains(goldEquipByTemplate.NewTemplateId))
		//	{
		//		return _items[goldEquipByTemplate.NewTemplateId];
		//	}
		//	return null;
		//}
		//return null;
		//     }

		public static ItemTemplateInfo FindGoldItemTemplate(int templateId, bool IsGold)
		{
			if (!IsGold)
				return null;
			GoldEquipTemplateInfo goldEquip = GoldEquipMgr.FindGoldEquipByTemplate(templateId);
			if (goldEquip == null)
				return null;

			if (_items.Keys.Contains(goldEquip.NewTemplateId))
			{
				return _items[goldEquip.NewTemplateId];
			}
			return null;
		}
	}
}
