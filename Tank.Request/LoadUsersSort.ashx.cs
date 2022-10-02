using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class LoadUsersSort : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
                bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            int total = 0;

            try
            {
                int page = 1;//int.Parse(context.Request["page"]);
                int size = 10;//int.Parse(context.Request["size"]);
                int order = int.Parse(context.Request["order"]);
                int userID = -1;// int.Parse(context.Request["state"]);
                bool resultValue = false;

                using (PlayerBussiness db = new PlayerBussiness())
                {
                    PlayerInfo[] infos = db.GetPlayerPage(page, size, ref total, order, userID, ref resultValue);
                    if (resultValue)
                    {
                        foreach (PlayerInfo info in infos)
                        {
                            XElement node = new XElement("Item", new XAttribute("ID", info.ID),
                           new XAttribute("NickName", info.NickName == null ? "" : info.NickName),
                           new XAttribute("Grade", info.Grade),
                           new XAttribute("Colors", info.Colors == null ? "" : info.Colors),
                           new XAttribute("Skin", info.Skin == null ? "" : info.Skin),
                           new XAttribute("Sex", info.Sex),
                           new XAttribute("Style", info.Style == null ? "" : info.Style),
                           new XAttribute("ConsortiaName", info.ConsortiaName == null ? "" : info.ConsortiaName),
                           new XAttribute("Hide", info.Hide),
                           new XAttribute("Offer", info.Offer),
                           new XAttribute("ReputeOffer", info.ReputeOffer),
                           new XAttribute("ConsortiaHonor", info.ConsortiaHonor),
                           new XAttribute("ConsortiaLevel", info.ConsortiaLevel),
                           new XAttribute("ConsortiaRepute", info.ConsortiaRepute),
                           new XAttribute("WinCount", info.Win),
                           new XAttribute("TotalCount", info.Total),
                           new XAttribute("EscapeCount", info.Escape),
                           new XAttribute("Repute", info.Repute),
                           new XAttribute("GP", info.GP));

                            result.Add(node);
                        }

                        value = true;
                        message = "Success!";
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("LoadUsersSort", ex);
            }

            result.Add(new XAttribute("total", total));
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
