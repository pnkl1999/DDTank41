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
using log4net;
using System.Reflection;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ConsortiaEquipControl : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
           

            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            int total = 0;

            try
            {
                int consortiaID = int.Parse(context.Request["consortiaID"]);

               
                using (ConsortiaBussiness db = new ConsortiaBussiness())
                {
                    for (int i = 1; i < 3;i++ )
                    {
                        for (int j = 1; j < 11; j++) 
                        {
                            ConsortiaEquipControlInfo cecInfo = db.GetConsortiaEuqipRiches(consortiaID, j,i);
                            if (cecInfo != null)
                            {
                                result.Add(new XElement("Item", new XAttribute("type", cecInfo.Type), new XAttribute("level", cecInfo.Level), new XAttribute("riches", cecInfo.Riches)));
                                total++;
                            }
                            
                        }
                    }
             
                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("ConsortiaEventList", ex);
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
