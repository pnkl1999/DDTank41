using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for pettemplateinfo
    /// </summary>
    public class pettemplateinfo : IHttpHandler
    {

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {

            context.Response.Write(Bulid(context));

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
                    PetTemplateInfo[] infos = db.GetAllPetTemplateInfo();
                    foreach (PetTemplateInfo info in infos)
                    {
                        result.Add(FlashUtils.CreatePetTemplate(info));
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("Load pettemplateinfo is fail!", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            return csFunction.CreateCompressXml(context, result, "pettemplateinfo", false);
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