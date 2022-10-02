using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using System.Reflection;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for gmtipallbyids
    /// </summary>
    public class gmtipallbyids : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");

            try
            {
                string p = context.Request["ids"];
                string[] ids = null;
                if (!string.IsNullOrEmpty(p))
                {
                    ids = p.Split(',');
                }
                if (ids != null)
                {
                    using (ProduceBussiness db = new ProduceBussiness())
                    {
                        EdictumInfo[] edictumInfos = db.GetAllEdictum();
                        foreach (EdictumInfo info in edictumInfos)
                        {
                            info.ID = int.Parse(ids[0]);
                            //if (ids.Contains(info.ID.ToString()))
                            if (info.EndDate.Date > DateTime.Now.Date)
                            {
                                result.Add(FlashUtils.CreateEdictum(info));
                            }
                        }
                        value = true;
                        message = "Success!";
                    }
                }
            }
            catch (Exception ex)
            {
                //log.Error("User Login error", ex);
                //value = false;
                message = ex.ToString();// LanguageMgr.GetTranslation("Tank.Request.Login.Fail2");
            }
            finally
            {
                result.Add(new XAttribute("value", value));
                result.Add(new XAttribute("message", message));
                context.Response.ContentType = "text/plain";
                context.Response.Write(result.ToString(false));
            }
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