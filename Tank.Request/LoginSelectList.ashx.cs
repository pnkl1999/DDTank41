using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using Road.Flash;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class LoginSelectList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string str1 = "Fail!";
			XElement xelement = new XElement("Result");
			try
			{
				string str2 = HttpUtility.UrlDecode(context.Request["username"]);
				HttpUtility.UrlDecode(context.Request["password"]);
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					PlayerInfo[] userLoginList = playerBussiness.GetUserLoginList(str2);
					if (userLoginList.Length == 0)
					{
						return;
					}
					PlayerInfo[] array = userLoginList;
					foreach (PlayerInfo playerInfo in array)
					{
						if (!string.IsNullOrEmpty(playerInfo.NickName))
						{
							xelement.Add(FlashUtils.CreateUserLoginList(playerInfo));
						}
					}
					flag = true;
					str1 = "Success!";
				}
			}
			catch (Exception ex)
			{
				log.Error("LoginSelectList", ex);
			}
			finally
			{
				xelement.Add(new XAttribute("value", flag));
				xelement.Add(new XAttribute("message", str1));
				context.Response.ContentType = "text/plain";
				context.Response.Write(xelement.ToString(check: false));
			}
		}
	}
}
