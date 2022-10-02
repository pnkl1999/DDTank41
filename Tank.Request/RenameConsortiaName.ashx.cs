using System;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using Bussiness.Interface;
using log4net;
using Road.Flash;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class RenameConsortiaName : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string translation = LanguageMgr.GetTranslation("Tank.Request.RenameConsortiaName.Fail1");
			XElement xelement = new XElement("Result");
			try
			{
				BaseInterface.CreateInterface();
				string str1 = context.Request["p"];
				if (context.Request["site"] != null)
				{
					HttpUtility.UrlDecode(context.Request["site"]);
				}
				_ = context.Request.UserHostAddress;
				if (!string.IsNullOrEmpty(str1))
				{
					byte[] bytes = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, str1);
					string[] strArray = Encoding.UTF8.GetString(bytes, 7, bytes.Length - 7).Split(',');
					if (strArray.Length == 5)
					{
						string name = strArray[0];
						string pass1 = strArray[1];
						string pass2 = strArray[2];
						_ = strArray[3];
						_ = strArray[4];
						if (PlayerManager.Login(name, pass1))
						{
							using (new ConsortiaBussiness())
							{
								PlayerManager.Update(name, pass2);
								flag = true;
								translation = LanguageMgr.GetTranslation("Tank.Request.RenameConsortiaName.Success");
							}
						}
					}
				}
			}
			catch (Exception ex)
			{
				log.Error("RenameConsortiaName", ex);
				flag = false;
				translation = LanguageMgr.GetTranslation("Tank.Request.RenameConsortiaName.Fail2");
			}
			xelement.Add(new XAttribute("value", flag));
			xelement.Add(new XAttribute("message", translation));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xelement.ToString(check: false));
		}
	}
}
