using Bussiness;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for eventrewarditemlist
    /// </summary>
    public class eventrewarditemlist : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                context.Response.Write(Bulid(context));
            }
            else
            {
                context.Response.Write("IP is not valid!");
            }
        }

        public static string Bulid(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    Dictionary<int, Dictionary<int, EventRewardInfo>> EventRewardInfo = new Dictionary<int, Dictionary<int, EventRewardInfo>>();

                    EventRewardInfo[] eventInfos = db.GetAllEventRewardInfo();
                    EventRewardGoodsInfo[] eventGoods = db.GetAllEventRewardGoods();

                    Dictionary<int, EventRewardInfo> tmp = null;

                    foreach (EventRewardInfo item in eventInfos)
                    {
                        item.AwardLists = new List<EventRewardGoodsInfo>();

                        if (!EventRewardInfo.ContainsKey(item.ActivityType))
                        {
                            tmp = new Dictionary<int, EventRewardInfo>();
                            tmp.Add(item.SubActivityType, item);

                            EventRewardInfo.Add(item.ActivityType, tmp);
                        }
                        else
                        {
                            // ton tai key => check key roi add
                            if (!EventRewardInfo[item.ActivityType].ContainsKey(item.SubActivityType))
                            {
                                EventRewardInfo[item.ActivityType].Add(item.SubActivityType, item);
                            }
                        }
                    }

                    foreach (EventRewardGoodsInfo good in eventGoods)
                    {
                        if (EventRewardInfo.ContainsKey(good.ActivityType) && EventRewardInfo[good.ActivityType].ContainsKey(good.SubActivityType))
                        {
                            EventRewardInfo[good.ActivityType][good.SubActivityType].AwardLists.Add(good);
                        }
                    }

                    XElement ActiveType = null;
                    //loop
                    foreach (Dictionary<int, EventRewardInfo> eventInActive in EventRewardInfo.Values)
                    {
                        foreach (EventRewardInfo info in eventInActive.Values)
                        {
                            if (ActiveType == null)
                            {
                                ActiveType = new XElement("ActivityType", new XAttribute("value", info.ActivityType));
                            }

                            XElement Items = new XElement("Items", new XAttribute("SubActivityType", info.SubActivityType), new XAttribute("Condition", info.Condition));
                            // add items
                            foreach (EventRewardGoodsInfo awardGood in info.AwardLists)
                            {
                                XElement Item = new XElement("Item", new XAttribute("TemplateId", awardGood.TemplateId),
                                                                    new XAttribute("StrengthLevel", awardGood.StrengthLevel),
                                                                    new XAttribute("AttackCompose", awardGood.AttackCompose),
                                                                    new XAttribute("DefendCompose", awardGood.DefendCompose),
                                                                    new XAttribute("LuckCompose", awardGood.LuckCompose),
                                                                    new XAttribute("AgilityCompose", awardGood.AgilityCompose),
                                                                    new XAttribute("IsBind", awardGood.IsBind),
                                                                    new XAttribute("ValidDate", awardGood.ValidDate),
                                                                    new XAttribute("Count", awardGood.Count));
                                Items.Add(Item);
                            }
                            ActiveType.Add(Items);
                        }
                        result.Add(ActiveType);
                        ActiveType = null;
                    }
                    //foreach (ShopGoodsShowListInfo s in eventInfos)
                    //{
                    //Store.Add(FlashUtils.CreateShopShowInfo(s));
                    //}
                    //result.Add(Store);
                    value = true;
                    message = "Success!";
                }
            }
            catch
            { }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            csFunction.CreateCompressXml(context, result, "eventrewarditemlist_out", false);
            return csFunction.CreateCompressXml(context, result, "eventrewarditemlist", true);
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}