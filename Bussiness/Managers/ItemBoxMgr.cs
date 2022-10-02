using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Bussiness.Managers
{
    public class ItemBoxMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static ItemBoxInfo[] m_itemBox;

        private static Dictionary<int, List<ItemBoxInfo>> m_itemBoxs;

        private static ThreadSafeRandom random = new ThreadSafeRandom();

        public static bool ReLoad()
        {
            try
            {
                ItemBoxInfo[] tempItemBox = LoadItemBoxDb();
                Dictionary<int, List<ItemBoxInfo>> tempItemBoxs = LoadItemBoxs(tempItemBox);
                if (tempItemBox != null)
                {
                    Interlocked.Exchange(ref m_itemBox, tempItemBox);
                    Interlocked.Exchange(ref m_itemBoxs, tempItemBoxs);
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

        public static ItemBoxInfo[] LoadItemBoxDb()
        {
            using ProduceBussiness db = new ProduceBussiness();
            return db.GetItemBoxInfos();
        }

        public static Dictionary<int, List<ItemBoxInfo>> LoadItemBoxs(ItemBoxInfo[] itemBoxs)
        {
            Dictionary<int, List<ItemBoxInfo>> infos = new Dictionary<int, List<ItemBoxInfo>>();
            foreach (ItemBoxInfo info in itemBoxs)
            {
                if (!infos.Keys.Contains(info.ID))
                {
                    IEnumerable<ItemBoxInfo> temp = itemBoxs.Where((ItemBoxInfo s) => s.ID == info.ID);
                    infos.Add(info.ID, temp.ToList());
                }
            }
            return infos;
        }

        public static List<ItemBoxInfo> FindItemBox(int DataId)
        {
            if (m_itemBoxs.ContainsKey(DataId))
            {
                return m_itemBoxs[DataId];
            }
            return null;
        }

        public static List<ItemInfo> GetAllItemBoxAward(int DataId)
        {
            List<ItemBoxInfo> list = FindItemBox(DataId);
            List<ItemInfo> infos = new List<ItemInfo>();
            foreach (ItemBoxInfo info in list)
            {
                ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(info.TemplateId), info.ItemCount, 105);
                item.IsBinds = info.IsBind;
                item.ValidDate = info.ItemValid;
                infos.Add(item);
            }
            return infos;
        }

        public static bool CreateItemBox(int DateId, List<ItemInfo> itemInfos, SpecialItemDataInfo specialInfo)
        {
            return CreateItemBox(DateId, null, itemInfos, specialInfo);
        }

        public static bool CreateItemBox(int DateId, List<ItemBoxInfo> tempBox, List<ItemInfo> itemInfos, SpecialItemDataInfo specialValue)
        {
            new List<ItemBoxInfo>();
            List<ItemBoxInfo> source = FindItemBox(DateId);
            if (tempBox != null && tempBox.Count > 0)
            {
                source = tempBox;
            }
            if (source == null)
            {
                return false;
            }
            List<ItemBoxInfo> filtInfos = source.Where((ItemBoxInfo s) => s.IsSelect).ToList();
            int num1 = 1;
            int maxRound = 0;
            if (filtInfos.Count < source.Count)
            {
                maxRound = ThreadSafeRandom.NextStatic((from s in source
                                                        where !s.IsSelect
                                                        select s.Random).Max());
                if (maxRound <= 0)
                {
                    log.Error("ItemBoxMgr Random Error: " + maxRound + " | " + DateId);
                    maxRound = (from s in source
                                where !s.IsSelect
                                select s.Random).Max();
                }
            }
            List<ItemBoxInfo> list = source.Where((ItemBoxInfo s) => !s.IsSelect && s.Random >= maxRound).ToList();
            int num2 = list.Count();
            if (num2 > 0)
            {
                int count = ((num1 > num2) ? num2 : num1);
                int[] randomUnrepeatArray = GetRandomUnrepeatArray(0, num2 - 1, count);
                int[] array = randomUnrepeatArray;
                foreach (int randomUnrepeat in array)
                {
                    ItemBoxInfo itemBoxInfo2 = list[randomUnrepeat];
                    if (filtInfos == null)
                    {
                        filtInfos = new List<ItemBoxInfo>();
                    }
                    filtInfos.Add(itemBoxInfo2);
                }
            }
            foreach (ItemBoxInfo info in filtInfos)
            {
                if (info == null)
                {
                    return false;
                }
                switch (info.TemplateId)
                {
                    case -800://Vinh du
                        specialValue.Honor += info.ItemCount;
                        continue;
                    case -300:
                        specialValue.GiftToken += info.ItemCount;
                        continue;
                    case -200:
                        specialValue.Money += info.ItemCount;
                        continue;
                    case -100:
                        specialValue.Gold += info.ItemCount;
                        continue;
                    case 11107:
                        specialValue.GP += info.ItemCount;
                        continue;
                }
                ItemInfo item = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(info.TemplateId), info.ItemCount, 101);
                if (item != null)
                {
                    item.IsBinds = info.IsBind;
                    item.ValidDate = info.ItemValid;
                    item.StrengthenLevel = info.StrengthenLevel;
                    item.AttackCompose = info.AttackCompose;
                    item.DefendCompose = info.DefendCompose;
                    item.AgilityCompose = info.AgilityCompose;
                    item.LuckCompose = info.LuckCompose;
                    if (itemInfos == null)
                    {
                        itemInfos = new List<ItemInfo>();
                    }
                    itemInfos.Add(item);
                }
            }
            return true;
        }

        public static bool CreateItemBox(int DateId, List<ItemInfo> itemInfos, ref int gold, ref int point, ref int giftToken, ref int medal, ref int exp, ref int hardCurrency, ref int leagueMoney, ref int useableScore, ref int prestge, ref int honor)
        {
            List<ItemBoxInfo> FiltInfos = new List<ItemBoxInfo>();
            List<ItemBoxInfo> unFiltInfos = FindItemBox(DateId);
            if (unFiltInfos == null)
            {
                return false;
            }
            FiltInfos = unFiltInfos.Where((ItemBoxInfo s) => s.IsSelect).ToList();
            int dropItemCount = 1;
            int maxRound = 0;
            if (FiltInfos.Count < unFiltInfos.Count)
            {
                maxRound = ThreadSafeRandom.NextStatic((from s in unFiltInfos
                                                        where !s.IsSelect
                                                        select s.Random).Max());
            }
            List<ItemBoxInfo> RoundInfos = unFiltInfos.Where((ItemBoxInfo s) => !s.IsSelect && s.Random >= maxRound).ToList();
            int maxItems = RoundInfos.Count();
            if (maxItems > 0)
            {
                dropItemCount = ((dropItemCount > maxItems) ? maxItems : dropItemCount);
                int[] randomArray = GetRandomUnrepeatArray(0, maxItems - 1, dropItemCount);
                int[] array = randomArray;
                foreach (int i in array)
                {
                    ItemBoxInfo item = RoundInfos[i];
                    if (FiltInfos == null)
                    {
                        FiltInfos = new List<ItemBoxInfo>();
                    }
                    FiltInfos.Add(item);
                }
            }
            foreach (ItemBoxInfo info in FiltInfos)
            {
                if (info == null)
                {
                    return false;
                }
                switch (info.TemplateId)
                {
                    case -1300:
                        prestge += info.ItemCount;
                        continue;
                    case -1200:
                        useableScore += info.ItemCount;
                        continue;
                    case -1100:
                        giftToken += info.ItemCount;
                        continue;
                    case -1000:
                        leagueMoney += info.ItemCount;
                        continue;
                    case -900:
                        hardCurrency += info.ItemCount;
                        continue;
                    case -800:
                        honor += info.ItemCount;
                        continue;
                    case -300:
                        medal += info.ItemCount;
                        continue;
                    case -200:
                        point += info.ItemCount;
                        continue;
                    case -100:
                        gold += info.ItemCount;
                        continue;
                    case 11107:
                        exp += info.ItemCount;
                        continue;
                }
                ItemTemplateInfo temp = ItemMgr.FindItemTemplate(info.TemplateId);
                ItemInfo item2 = ItemInfo.CreateFromTemplate(temp, info.ItemCount, 101);
                if (item2 != null)
                {
                    item2.Count = info.ItemCount;
                    item2.IsBinds = info.IsBind;
                    item2.ValidDate = info.ItemValid;
                    item2.StrengthenLevel = info.StrengthenLevel;
                    item2.AttackCompose = info.AttackCompose;
                    item2.DefendCompose = info.DefendCompose;
                    item2.AgilityCompose = info.AgilityCompose;
                    item2.LuckCompose = info.LuckCompose;
                    item2.IsTips = info.IsTips != 0;
                    item2.IsLogs = info.IsLogs;
                    if (itemInfos == null)
                    {
                        itemInfos = new List<ItemInfo>();
                    }
                    itemInfos.Add(item2);
                }
            }
            return true;
        }

        public static bool CreateItemBox(int DateId, List<ItemInfo> itemInfos, ref int gold, ref int point, ref int giftToken, ref int medal, ref int exp, ref int honor)
        {
            List<ItemBoxInfo> FiltInfos = new List<ItemBoxInfo>();
            List<ItemBoxInfo> unFiltInfos = FindItemBox(DateId);
            if (unFiltInfos == null)
            {
                return false;
            }
            FiltInfos = unFiltInfos.Where((ItemBoxInfo s) => s.IsSelect).ToList();
            int dropItemCount = 1;
            int maxRound = 0;
            if (FiltInfos.Count < unFiltInfos.Count)
            {
                maxRound = ThreadSafeRandom.NextStatic((from s in unFiltInfos
                                                        where !s.IsSelect
                                                        select s.Random).Max());
            }
            List<ItemBoxInfo> RoundInfos = unFiltInfos.Where((ItemBoxInfo s) => !s.IsSelect && s.Random >= maxRound).ToList();
            int maxItems = RoundInfos.Count();
            if (maxItems > 0)
            {
                dropItemCount = ((dropItemCount > maxItems) ? maxItems : dropItemCount);
                int[] array = GetRandomUnrepeatArray(0, maxItems - 1, dropItemCount);
                int[] array2 = array;
                foreach (int i in array2)
                {
                    ItemBoxInfo item = RoundInfos[i];
                    if (FiltInfos == null)
                    {
                        FiltInfos = new List<ItemBoxInfo>();
                    }
                    FiltInfos.Add(item);
                }
            }
            foreach (ItemBoxInfo info in FiltInfos)
            {
                if (info == null)
                {
                    return false;
                }
                switch (info.TemplateId)
                {
                    case -1100:
                        giftToken += info.ItemCount;
                        continue;
                    case -800:
                        honor += info.ItemCount;
                        continue;
                    case -300:
                        medal += info.ItemCount;
                        continue;
                    case -200:
                        point += info.ItemCount;
                        continue;
                    case -100:
                        gold += info.ItemCount;
                        continue;
                    case 11107:
                        exp += info.ItemCount;
                        continue;
                }
                ItemInfo item2 = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(info.TemplateId), info.ItemCount, 101);
                if (item2 != null)
                {
                    item2.Count = info.ItemCount;
                    item2.IsBinds = info.IsBind;
                    item2.ValidDate = info.ItemValid;
                    item2.StrengthenLevel = info.StrengthenLevel;
                    item2.AttackCompose = info.AttackCompose;
                    item2.DefendCompose = info.DefendCompose;
                    item2.AgilityCompose = info.AgilityCompose;
                    item2.LuckCompose = info.LuckCompose;
                    item2.IsTips = info.IsTips != 0;
                    item2.IsLogs = info.IsLogs;
                    if (itemInfos == null)
                    {
                        itemInfos = new List<ItemInfo>();
                    }
                    itemInfos.Add(item2);
                }
            }
            return true;
        }

        public static int[] GetRandomUnrepeatArray(int minValue, int maxValue, int count)
        {
            int[] resultRound = new int[count];
            for (int i = 0; i < count; i++)
            {
                int j = random.Next(minValue, maxValue + 1);
                int num = 0;
                for (int k = 0; k < i; k++)
                {
                    if (resultRound[k] == j)
                    {
                        num++;
                    }
                }
                if (num == 0)
                {
                    resultRound[i] = j;
                }
                else
                {
                    i--;
                }
            }
            return resultRound;
        }

        public static bool CreateItemBox(int DateId, List<ItemInfo> itemInfos, ref int gold, ref int point, ref int giftToken, ref int exp, ref int honor)
        {
            return CreateItemBox(DateId, null, itemInfos, ref gold, ref point, ref giftToken, ref exp, ref honor);
        }

        public static bool CreateItemBox(int DateId, List<ItemBoxInfo> tempBox, List<ItemInfo> itemInfos, ref int gold, ref int point, ref int giftToken, ref int exp, ref int honor)
        {
            List<ItemBoxInfo> list = new List<ItemBoxInfo>();
            List<ItemBoxInfo> list2 = FindItemBox(DateId);
            if (tempBox != null && tempBox.Count > 0)
            {
                list2 = tempBox;
            }
            if (list2 == null)
            {
                return false;
            }
            list = list2.Where((ItemBoxInfo s) => s.IsSelect).ToList();
            int count = 1;
            int maxRound = 0;
            if (list.Count < list2.Count)
            {
                maxRound = ThreadSafeRandom.NextStatic((from s in list2
                                                        where !s.IsSelect
                                                        select s.Random).Max());
            }
            List<ItemBoxInfo> source = list2.Where((ItemBoxInfo s) => !s.IsSelect && s.Random >= maxRound).ToList();
            int num2 = source.Count();
            if (num2 > 0)
            {
                count = ((count > num2) ? num2 : count);
                int[] numArray = GetRandomUnrepeatArray(0, num2 - 1, count);
                int[] array = numArray;
                foreach (int num3 in array)
                {
                    ItemBoxInfo item = source[num3];
                    if (list == null)
                    {
                        list = new List<ItemBoxInfo>();
                    }
                    list.Add(item);
                }
            }
            foreach (ItemBoxInfo info2 in list)
            {
                if (info2 == null)
                {
                    return false;
                }
                switch (info2.TemplateId)
                {
                    case -800:
                        honor += info2.ItemCount;
                        continue;
                    case -200:
                        point += info2.ItemCount;
                        continue;
                    case -300:
                        giftToken += info2.ItemCount;
                        continue;
                    case -100:
                        gold += info2.ItemCount;
                        continue;
                    case 11107:
                        exp += info2.ItemCount;
                        continue;
                }
                ItemInfo info3 = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(info2.TemplateId), info2.ItemCount, 101);
                if (info3 != null)
                {
                    info3.IsBinds = info2.IsBind;
                    info3.ValidDate = info2.ItemValid;
                    info3.StrengthenLevel = info2.StrengthenLevel;
                    info3.AttackCompose = info2.AttackCompose;
                    info3.DefendCompose = info2.DefendCompose;
                    info3.AgilityCompose = info2.AgilityCompose;
                    info3.LuckCompose = info2.LuckCompose;
                    if (itemInfos == null)
                    {
                        itemInfos = new List<ItemInfo>();
                    }
                    itemInfos.Add(info3);
                }
            }
            return true;
        }

        public static List<ItemBoxInfo> FindLotteryItemBoxByRand(int DateId, int countSelect)
        {
            List<ItemBoxInfo> list = FindLotteryItemBox(DateId);
            List<ItemBoxInfo> list2 = new List<ItemBoxInfo>();
            for (int i = 0; i < countSelect; i++)
            {
                int num2 = ThreadSafeRandom.NextStatic(0, list.Count);
                if (num2 < list.Count)
                {
                    list2.Add(list[num2]);
                    list.Remove(list[num2]);
                }
            }
            return list2;
        }

        public static List<ItemBoxInfo> FindLotteryItemBox(int DataId)
        {
            if (!m_itemBoxs.ContainsKey(DataId))
            {
                return null;
            }
            List<ItemBoxInfo> list = new List<ItemBoxInfo>();
            foreach (ItemBoxInfo current in m_itemBoxs[DataId])
            {
                bool flag = true;
                foreach (ItemBoxInfo info2 in list)
                {
                    if (info2.TemplateId == current.TemplateId && info2.ItemCount == current.ItemCount)
                    {
                        flag = false;
                        break;
                    }
                }
                if (flag)
                {
                    list.Add(current);
                }
            }
            return list;
        }
    }
}
