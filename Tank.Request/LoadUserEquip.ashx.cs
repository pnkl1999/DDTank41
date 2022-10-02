using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using Bussiness;
using SqlDataProvider.Data;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class LoadUserEquip : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);


        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
               // int userid = int.Parse(context.Request.Params["ID"]);
                int userid = int.Parse(context.Request["ID"]);
                using (PlayerBussiness pb = new PlayerBussiness())
                {
                    PlayerInfo info = pb.GetUserSingleByUserID(userid);
                    result.Add(new XAttribute("Agility", info.Agility),
                        new XAttribute("Attack", info.Attack),
                        new XAttribute("Colors", info.Colors),
                        new XAttribute("Skin", info.Skin),
                        new XAttribute("Defence", info.Defence),
                        new XAttribute("GP", info.GP),
                        new XAttribute("Grade", info.Grade),
                        new XAttribute("Luck", info.Luck),
                        new XAttribute("Hide", info.Hide),
                        new XAttribute("Repute", info.Repute),
                        new XAttribute("Offer", info.Offer),
                        new XAttribute("NickName", info.NickName),
                        new XAttribute("ConsortiaName", info.ConsortiaName),
                        new XAttribute("ConsortiaID", info.ConsortiaID),
                        new XAttribute("ReputeOffer", info.ReputeOffer),
                        new XAttribute("ConsortiaHonor", info.ConsortiaHonor),
                        new XAttribute("ConsortiaLevel", info.ConsortiaLevel),
                        new XAttribute("ConsortiaRepute", info.ConsortiaRepute),
                        new XAttribute("WinCount", info.Win),
                        new XAttribute("TotalCount", info.Total),
                        new XAttribute("EscapeCount", info.Escape),
                        new XAttribute("Sex", info.Sex),
                        new XAttribute("Style", info.Style),
                        new XAttribute("FightPower",info.FightPower));




                    ItemInfo[] items = pb.GetUserEuqip(userid).ToArray();
                    foreach (ItemInfo g in items)
                    {
                        result.Add(Road.Flash.FlashUtils.CreateGoodsInfo(g));
                    }

                    //XElement item = new XElement("Item");
                    //ItemInfo[] items = pb.GetUserEuqip(userid);
                    //foreach (ItemInfo g in items)
                    //{
                    //    item.Add(Road.Flash.FlashUtils.CreateGoodsInfo(g));
                    //}

                    //XElement buff = new XElement("Buff");
                    //BuffInfo[] buffs = pb.GetUserBuff(userid);
                    //foreach (BuffInfo b in buffs)
                    //{
                    //    if (!b.IsValid())
                    //        continue;
                    //    buff.Add(Road.Flash.FlashUtils.CreateBuffInfo(b));
                    //}

                   // result.Add(item);
                    //result.Add(buff);
                }


                value = true;
                message = "Success!";

            }
            catch(Exception ex)
            {
                log.Error("LoadUserEquip", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            context.Response.Write(result.ToString(false));
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
