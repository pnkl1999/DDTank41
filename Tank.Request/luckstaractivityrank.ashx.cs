using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Specialized;
using log4net;
using System.Reflection;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for luckstaractivityrank
    /// </summary>
    public class luckstaractivityrank : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //luckstaractivityrank.ashx?rnd=0%2E272604011464864&selfid=18&key=6a8eecf0db891c4aee01de3aabf5fa02
            int selfid = Convert.ToInt32(context.Request["selfid"]);
            string key = context.Request["key"];
            bool value = false;
            string message = "fail!";
            XElement ranks = new XElement("Ranks");
            LuckstarActivityRankInfo myRankInfo = new LuckstarActivityRankInfo();
            myRankInfo.nickName = "";

            using (PlayerBussiness db = new PlayerBussiness())
            {
                LuckstarActivityRankInfo[] LuckstarActivityRanks = db.GetAllLuckstarActivityRank();
                foreach (LuckstarActivityRankInfo r in LuckstarActivityRanks)
                {
                    ranks.Add(FlashUtils.LuckstarActivityRank(r));
                    if (r.UserID == selfid)
                        myRankInfo = r;
                }
            }
            XElement myRank = new XElement("myRank"
                , new XAttribute("rank", myRankInfo.rank)
                , new XAttribute("useStarNum", myRankInfo.useStarNum)
                , new XAttribute("nickName", myRankInfo.nickName));
            ranks.Add(myRank);
            value = true;
            message = "Success!";
            ranks.Add(new XAttribute("lastUpdateTime", DateTime.Now.ToString("MM-dd hh:mm")));
            ranks.Add(new XAttribute("value", value));
            ranks.Add(new XAttribute("message", message));
            context.Response.ContentType = "text/plain";
            context.Response.Write(ranks.ToString(false));
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