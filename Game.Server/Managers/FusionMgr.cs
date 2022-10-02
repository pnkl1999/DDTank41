using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using Bussiness;
using Bussiness.Managers;
using log4net;
using SqlDataProvider.Data;

public class FusionMgr
{
    private static readonly ILog ILog = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

    private static Dictionary<string, FusionInfo> _fusions;

    private static ReaderWriterLock m_lock;

    private static Random rand;

    public static bool ReLoad()
    {
        try
        {
            Dictionary<string, FusionInfo> fusion = new Dictionary<string, FusionInfo>();
            if (LoadFusion(fusion))
            {
                m_lock.AcquireWriterLock(-1);
                try
                {
                    _fusions = fusion;
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
            if (ILog.IsErrorEnabled)
            {
                ILog.Error("FusionMgr", exception);
            }
        }
        return false;
    }

    public static bool Init()
    {
        try
        {
            m_lock = new ReaderWriterLock();
            _fusions = new Dictionary<string, FusionInfo>();
            rand = new Random();
            return LoadFusion(_fusions);
        }
        catch (Exception exception)
        {
            if (ILog.IsErrorEnabled)
            {
                ILog.Error("FusionMgr", exception);
            }
            return false;
        }
    }

    private static bool LoadFusion(Dictionary<string, FusionInfo> fusion)
    {
        using (ProduceBussiness produceBussiness = new ProduceBussiness())
        {
            FusionInfo[] allFusion = produceBussiness.GetAllFusion();
            FusionInfo[] array = allFusion;
            foreach (FusionInfo fusionInfo in array)
            {
                List<int> list = new List<int>();
                list.Add(fusionInfo.Item1);
                list.Add(fusionInfo.Item2);
                list.Add(fusionInfo.Item3);
                list.Add(fusionInfo.Item4);
                list.Sort();
                StringBuilder stringBuilder = new StringBuilder();
                foreach (int item in list)
                {
                    if (item != 0)
                    {
                        stringBuilder.Append(item);
                    }
                }
                string key = stringBuilder.ToString();
                if (!fusion.ContainsKey(key))
                {
                    fusion.Add(key, fusionInfo);
                }
            }
        }
        return true;
    }

    public static ItemTemplateInfo Fusion(List<ItemInfo> Items, List<ItemInfo> AppendItems, ref bool isBind, ref bool result)
    {
        List<int> list = new List<int>();
        int MaxLevel = 0;
        int TotalRate = 0;
        int num2 = 0;
        if (Items == null)
        {
            return null;
        }
        ItemTemplateInfo itemTemplateInfo = null;
        foreach (ItemInfo Item in Items)
        {
            if (Item != null)
            {
                list.Add(Item.Template.FusionType);
                if (Item.Template.Level > MaxLevel)
                {
                    MaxLevel = Item.Template.Level;
                }
                TotalRate += Item.Template.FusionRate;
                num2 += Item.Template.FusionNeedRate;
                if (Item.IsBinds)
                {
                    isBind = true;
                }
            }
        }
        foreach (ItemInfo AppendItem in AppendItems)
        {
            TotalRate += AppendItem.Template.FusionRate / 2;
            num2 += AppendItem.Template.FusionNeedRate / 2;
            if (AppendItem.IsBinds)
            {
                isBind = true;
            }
        }
        list.Sort();
        StringBuilder stringBuilder = new StringBuilder();
        foreach (int item in list)
        {
            stringBuilder.Append(item);
        }
        string key = stringBuilder.ToString();
        m_lock.AcquireReaderLock(-1);
        try
        {
            if (_fusions.ContainsKey(key))
            {
                FusionInfo fusionInfo = _fusions[key];
                ItemTemplateInfo goodsbyFusionTypeandLevel = ItemMgr.GetGoodsbyFusionTypeandLevel(fusionInfo.Reward, MaxLevel);
                ItemTemplateInfo goodsbyFusionTypeandLevel3 = ItemMgr.GetGoodsbyFusionTypeandLevel(fusionInfo.Reward, MaxLevel + 2);
                ItemTemplateInfo goodsbyFusionTypeandLevel2 = ItemMgr.GetGoodsbyFusionTypeandLevel(fusionInfo.Reward, MaxLevel + 1);
                List<ItemTemplateInfo> list2 = new List<ItemTemplateInfo>();
                if (goodsbyFusionTypeandLevel2 != null)
                {
                    list2.Add(goodsbyFusionTypeandLevel2);
                }
                if (goodsbyFusionTypeandLevel != null)
                {
                    list2.Add(goodsbyFusionTypeandLevel);
                }
                if (goodsbyFusionTypeandLevel3 != null)
                {
                    list2.Add(goodsbyFusionTypeandLevel3);
                }
                ItemTemplateInfo itemTemplateInfo2 = (from s in list2
                                                      where (double)TotalRate / (double)s.FusionNeedRate <= 1.1
                                                      orderby (double)TotalRate / (double)s.FusionNeedRate descending
                                                      select s).FirstOrDefault();
                ItemTemplateInfo itemTemplateInfo3 = (from s in list2
                                                      where (double)TotalRate / (double)s.FusionNeedRate > 1.1
                                                      orderby (double)TotalRate / (double)s.FusionNeedRate
                                                      select s).FirstOrDefault();
                if (itemTemplateInfo2 != null && itemTemplateInfo3 == null)
                {
                    itemTemplateInfo = itemTemplateInfo2;
                    if (rand.Next(num2) < TotalRate)
                    {
                        result = true;
                    }
                }
                if (itemTemplateInfo2 != null && itemTemplateInfo3 != null)
                {
                    if (itemTemplateInfo2.Level - itemTemplateInfo3.Level == 2)
                    {
                        double num3 = (double)(100 * TotalRate) * 0.6 / (double)itemTemplateInfo2.FusionNeedRate;
                    }
                    else
                    {
                        double num4 = (double)(100 * TotalRate) / (double)itemTemplateInfo2.FusionNeedRate;
                    }
                    if ((double)(100 * TotalRate) / (double)itemTemplateInfo2.FusionNeedRate > (double)rand.Next(100))
                    {
                        itemTemplateInfo = itemTemplateInfo2;
                        result = true;
                    }
                    else
                    {
                        itemTemplateInfo = itemTemplateInfo3;
                        result = true;
                    }
                }
                if (itemTemplateInfo2 == null && itemTemplateInfo3 != null)
                {
                    itemTemplateInfo = itemTemplateInfo3;
                    if (rand.Next(num2) < TotalRate)
                    {
                        result = true;
                    }
                }
                if (result)
                {
                    foreach (ItemInfo Item2 in Items)
                    {
                        if (Item2.Template.TemplateID == itemTemplateInfo.TemplateID)
                        {
                            result = false;
                            break;
                        }
                    }
                }
                return itemTemplateInfo;
            }
        }
        catch
        {
        }
        finally
        {
            m_lock.ReleaseReaderLock();
        }
        return null;
    }

    public static Dictionary<int, double> FusionPreview(List<ItemInfo> Items, List<ItemInfo> AppendItems, ref bool isBind)
    {
        List<int> list = new List<int>();
        int MaxLevel = 0;
        int FusionRate = 0;
        int FusionNeedRate = 0;
        Dictionary<int, double> Item_Rate = new Dictionary<int, double>();
        Item_Rate.Clear();
        foreach (ItemInfo Item in Items)
        {
            list.Add(Item.Template.FusionType);
            if (Item.Template.Level > MaxLevel)
            {
                MaxLevel = Item.Template.Level;
            }
            FusionRate += Item.Template.FusionRate;
            FusionNeedRate += Item.Template.FusionNeedRate;
            if (Item.IsBinds)
            {
                isBind = true;
            }
        }
        foreach (ItemInfo p in AppendItems)
        {
            FusionRate += p.Template.FusionRate / 2;
            FusionNeedRate += p.Template.FusionRate / 2;
            if (p.IsBinds)
            {
                isBind = true;
            }
        }
        list.Sort();
        StringBuilder itemString = new StringBuilder();
        foreach (int item in list)
        {
            itemString.Append(item);
        }
        string key = itemString.ToString().Trim();
        m_lock.AcquireReaderLock(-1);
        try
        {
            if (_fusions.ContainsKey(key))
            {
                FusionInfo info = _fusions[key];
                double TotalRate = 0.0;
                double rateMin = 0.0;
                ItemTemplateInfo temp_0 = ItemMgr.GetGoodsbyFusionTypeandLevel(info.Reward, MaxLevel);
                ItemTemplateInfo temp_2 = ItemMgr.GetGoodsbyFusionTypeandLevel(info.Reward, MaxLevel + 2);
                ItemTemplateInfo temp_1 = ItemMgr.GetGoodsbyFusionTypeandLevel(info.Reward, MaxLevel + 1);
                List<ItemTemplateInfo> temps = new List<ItemTemplateInfo>();
                if (temp_1 != null)
                {
                    temps.Add(temp_1);
                }
                if (temp_0 != null)
                {
                    temps.Add(temp_0);
                }
                if (temp_2 != null)
                {
                    temps.Add(temp_2);
                }
                ItemTemplateInfo tempMax = (from s in temps
                                                     where (double)FusionRate / (double)s.FusionNeedRate <= 1.1
                                                     orderby (double)FusionRate / (double)s.FusionNeedRate descending
                                                     select s).FirstOrDefault();
                ItemTemplateInfo tempMin = (from s in temps
                                                      where (double)FusionRate / (double)s.FusionNeedRate > 1.1
                                                      orderby (double)FusionRate / (double)s.FusionNeedRate
                                                      select s).FirstOrDefault();
                if (tempMax != null && tempMin == null)
                {
                    TotalRate = (double)(100 * FusionRate) / (double)FusionNeedRate;
                    Item_Rate.Add(tempMax.TemplateID, TotalRate);
                }
                if (tempMax != null && tempMin != null)
                {
                    if (tempMax.Level - tempMin.Level == 2)
                    {
                        TotalRate = (double)(100 * FusionRate) * 0.6 / (double)tempMax.FusionNeedRate;
                        rateMin = 100.0 - TotalRate;
                    }
                    else
                    {
                        TotalRate = (double)(100 * FusionRate) / (double)tempMax.FusionNeedRate;
                        rateMin = 100.0 - TotalRate;
                    }
                    Item_Rate.Add(tempMax.TemplateID, TotalRate);
                    Item_Rate.Add(tempMin.TemplateID, rateMin);
                }
                if (tempMax == null && tempMin != null)
                {
                    rateMin = (double)(100 * FusionRate) / (double)FusionNeedRate;
                    Item_Rate.Add(tempMin.TemplateID, rateMin);
                }
                int[] templist = Item_Rate.Keys.ToArray();
                int[] _list = templist;
                foreach (int num5 in _list)
                {
                    foreach (ItemInfo item in Items)
                    {
                        if (num5 == item.Template.TemplateID && Item_Rate.ContainsKey(num5))
                        {
                            Item_Rate.Remove(num5);
                        }
                    }
                }
                return Item_Rate;
            }
            return Item_Rate;
        }
        catch
        {
        }
        finally
        {
            m_lock.ReleaseReaderLock();
        }
        return null;
    }
}
