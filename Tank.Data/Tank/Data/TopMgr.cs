using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data
{
    public class TopMgr
    {
        private static Dictionary<int, TopInfo> m_tops = new Dictionary<int, TopInfo>();
        private static Dictionary<int, List<TopAwardInfo>> m_topGoods = new Dictionary<int, List<TopAwardInfo>>();

        public static bool Init() => TopMgr.ReLoad();

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, TopInfo> tops = TopMgr.LoadTopDb();
                Dictionary<int, List<TopAwardInfo>> dictionary = TopMgr.LoadTopGoodDb(tops);
                if (tops.Count > 0)
                {
                    Interlocked.Exchange<Dictionary<int, TopInfo>>(ref TopMgr.m_tops, tops);
                    Interlocked.Exchange<Dictionary<int, List<TopAwardInfo>>>(ref TopMgr.m_topGoods, dictionary);
                }
                return true;
            }
            catch (Exception ex)
            {
                Logger.Error("TopMgr init error:" + ex.ToString());
            }
            return false;
        }

        public static Dictionary<int, TopInfo> LoadTopDb()
        {
            Dictionary<int, TopInfo> dictionary = new Dictionary<int, TopInfo>();
            using (WebBussiness webBussiness = new WebBussiness())
            {
                foreach (TopInfo topInfo in webBussiness.GetAllTop())
                {
                    if (!dictionary.ContainsKey(topInfo.ID))
                        dictionary.Add(topInfo.ID, topInfo);
                }
            }
            return dictionary;
        }

        public static Dictionary<int, List<TopAwardInfo>> LoadTopGoodDb(
          Dictionary<int, TopInfo> tops)
        {
            Dictionary<int, List<TopAwardInfo>> dictionary = new Dictionary<int, List<TopAwardInfo>>();
            using (WebBussiness webBussiness = new WebBussiness())
            {
                TopAwardInfo[] allTopAward = webBussiness.GetAllTopAward();
                foreach (TopInfo topInfo in tops.Values)
                {
                    TopInfo top = topInfo;
                    IEnumerable<TopAwardInfo> source = ((IEnumerable<TopAwardInfo>)allTopAward).Where<TopAwardInfo>((Func<TopAwardInfo, bool>)(s => s.TopID == top.ID));
                    dictionary.Add(top.ID, source.ToList<TopAwardInfo>());
                }
            }
            return dictionary;
        }

        public static TopInfo GetSingleTop(int id)
        {
            if (TopMgr.m_tops.Count == 0)
                TopMgr.Init();
            return TopMgr.m_tops.ContainsKey(id) ? TopMgr.m_tops[id] : (TopInfo)null;
        }

        public static List<TopInfo> GetAllTops()
        {
            if (TopMgr.m_tops.Count == 0)
                TopMgr.Init();
            return TopMgr.m_tops.Values.ToList<TopInfo>();
        }

        public static List<TopAwardInfo> GetTopGoods(int id)
        {
            if (TopMgr.m_topGoods.Count == 0)
                TopMgr.Init();
            return TopMgr.m_topGoods.ContainsKey(id) ? TopMgr.m_topGoods[id] : (List<TopAwardInfo>)null;
        }

        public static List<SqlDataProvider.Data.ItemInfo> GetGoods(List<TopAwardInfo> awards)
        {
            List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
            foreach (TopAwardInfo award in awards)
            {
                ItemTemplateInfo itemTemplate = ItemTemplateMgr.FindItemTemplate(award.TemplateID);
                if (itemTemplate != null)
                {
                    SqlDataProvider.Data.ItemInfo fromTemplate = SqlDataProvider.Data.ItemInfo.CreateFromTemplate(itemTemplate, award.Count, 112);
                    fromTemplate.ValidDate = award.ValidDate;
                    fromTemplate.StrengthenLevel = award.StrengthenLevel;
                    fromTemplate.AttackCompose = award.AttackCompose;
                    fromTemplate.DefendCompose = award.DefendCompose;
                    fromTemplate.AgilityCompose = award.AgilityCompose;
                    fromTemplate.LuckCompose = award.LuckCompose;
                    //fromTemplate.MagicAttack = award.MagicAttack;
                    //fromTemplate.MagicDefence = award.MagicDefend;
                    fromTemplate.goldValidDate = award.GoldValidate;
                    fromTemplate.goldBeginTime = DateTime.Now;
                    fromTemplate.IsBinds = award.IsBinds;
                    itemInfoList.Add(fromTemplate);
                }
            }
            return itemInfoList;
        }
    }
}
