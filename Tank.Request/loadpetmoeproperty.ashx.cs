using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;
using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;

namespace Tank.Request
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class loadpetmoeproperty : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
                context.Response.Write(loadpetmoeproperty.Bulid(context));
            else
                context.Response.Write("IP is not valid!");
        }

        public static string Bulid(HttpContext context)
        {
            bool flag = false;
            string str = "Fail!";
            XElement result = new XElement((XName)"Result");
            try
            {
                using (ProduceBussiness produceBussiness = new ProduceBussiness())
                {
                    XElement xelement = new XElement((XName)"ItemTemplate");
                    foreach (PetMoePropertyInfo petm in produceBussiness.GetAllPetMoeProperty())
                        xelement.Add((object)FlashUtils.CreatePetMoePropertyItems(petm));
                    result.Add((object)xelement);
                    flag = true;
                    str = "Success!";
                }
            }
            catch (Exception ex)
            {
                loadpetmoeproperty.log.Error((object)"loadpetmoeproperty", ex);
            }
            result.Add((object)new XAttribute((XName)"value", (object)flag));
            result.Add((object)new XAttribute((XName)"message", (object)str));
            csFunction.CreateCompressXml(context, result, "loadpetmoeproperty_out", false);
            return csFunction.CreateCompressXml(context, result, "loadpetmoeproperty", true);
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
