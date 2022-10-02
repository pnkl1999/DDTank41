using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using log4net;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class GoldEquipMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, GoldEquipTemplateInfo> _items;
        private static List<GoldEquipTemplateInfo> _itemAlls;
        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, GoldEquipTemplateInfo> tempItems = new Dictionary<int, GoldEquipTemplateInfo>();
                List<GoldEquipTemplateInfo> tempAllItems = new List<GoldEquipTemplateInfo>();

                if (LoadItem(tempItems, tempAllItems))
                {
                    try
                    {
                        _items = tempItems;
                        return true;
                    }
                    catch
                    { }
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("ReLoad", e);
            }

            return false;
        }

        /// <summary>
        /// Initializes the ItemMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            try
            {
                _items = new Dictionary<int, GoldEquipTemplateInfo>();
                _itemAlls = new List<GoldEquipTemplateInfo>();
                return LoadItem(_items, _itemAlls);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
                return false;
            }
        }

        public static bool LoadItem(Dictionary<int, GoldEquipTemplateInfo> infos, List<GoldEquipTemplateInfo>  infoAlls)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                GoldEquipTemplateInfo[] items = db.GetAllGoldEquipTemplateLoad();
                foreach (GoldEquipTemplateInfo item in items)
                {
                    if(item.OldTemplateId == -1)
                    {
                        infoAlls.Add(item);
                    }
                    else if (!infos.Keys.Contains(item.OldTemplateId))
                    {
                        infos.Add(item.OldTemplateId, item);
                    }
                }
            }
            return true;
        }
        public static GoldEquipTemplateInfo FindGoldEquipByTemplate(int templateId)
        {
            if (_items == null)
                Init();
            try
            {
                if (_items.Keys.Contains(templateId))
                {
                    //Console.WriteLine("_items.Count {0}", _items.Count);
                    return _items[templateId];
                }
            }
            catch { }
            return null;
        }
        public static GoldEquipTemplateInfo FindGoldEquipOldTemplate(int TemplateId)
        {
            if (_items == null)
                Init();

            try
            {
                foreach (GoldEquipTemplateInfo info in _items.Values)
                {
                    string OldTemplateId = info.OldTemplateId.ToString();
                    if (info.NewTemplateId == TemplateId && OldTemplateId.Substring(4) != "4")
                    {
                        return info;

                    }
                }
            }
            catch { }
            return null;
        }

        public static GoldEquipTemplateInfo FindGoldEquipByTemplate(int templateId, int categoryId)
        {
            GoldEquipTemplateInfo info = null;
            if (_items == null)
            {
                Init();
            }
            try
            {
                foreach (GoldEquipTemplateInfo equipTemplateInfo in _items.Values)
                {
                    if (equipTemplateInfo.OldTemplateId == templateId)
                    {
                        info = equipTemplateInfo;
                        break;
                    }
                }

                if(info == null)
                {
                    foreach (GoldEquipTemplateInfo equipTemplateInfo in _itemAlls)
                    {
                        if ((equipTemplateInfo.OldTemplateId == -1 && equipTemplateInfo.CategoryID == categoryId))
                        {
                            info = equipTemplateInfo;
                            break;
                        }
                    }
                }

                
                return info;
            }
            catch
            {
                return info;
            }
        }
    }
}