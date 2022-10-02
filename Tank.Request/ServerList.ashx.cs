using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using Bussiness.CenterService;
using Bussiness;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ServerList : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            int total = 0;

            XElement result = new XElement("Result");

            try
            {
                using (CenterServiceClient temp = new CenterServiceClient())
                {
                    IList<ServerData> list = temp.GetServerList();

                    foreach (ServerData s in list)

                    {
                        if (s.State == -1)
                            continue;
                        //s.Online += 5;
                        total += s.Online;
                        result.Add(Road.Flash.FlashUtils.CreateServerInfo(s.Id, s.Name, s.Ip, s.Port - 69, s.State, s.MustLevel, s.LowestLevel,s.Online));
                    }
                }

                value = true;
                message = "Success!";
            }
            catch(Exception ex)
            {
                log.Error("Load server list error:",ex);
            }


            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            result.Add(new XAttribute("total", total));

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
