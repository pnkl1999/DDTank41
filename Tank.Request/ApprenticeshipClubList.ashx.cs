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
	public class ApprenticeshipClubList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag1 = true;
			string str1 = "true!";
			bool flag2 = false;
			bool flag3 = false;
			int num1 = 0;
			XElement xelement = new XElement("Result");
			try
			{
				int num2 = int.Parse(context.Request["page"]);
				int.Parse(context.Request["selfid"]);
				bool.Parse(context.Request["isReturnSelf"]);
				string str2 = ((context.Request["name"] == null) ? "" : context.Request["name"]);
				bool flag4 = bool.Parse(context.Request["appshipStateType"]);
				bool flag5 = bool.Parse(context.Request["requestType"]);
				int num3 = (flag5 ? 9 : 3);
				int num4 = ((!flag4) ? 1 : 2);
				int num5 = ((!flag4) ? 8 : 10);
				int num6 = -1;
				if (!flag5 && !flag4)
				{
					num4 = 3;
					num5 = 9;
				}
				else if (!flag5 && flag4)
				{
					num4 = 4;
					num5 = 9;
				}
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					if (str2 != null && str2.Length > 0)
					{
						num6 = playerBussiness.GetUserSingleByNickName(str2)?.ID ?? 0;
					}
					PlayerInfo[] playerPage = playerBussiness.GetPlayerPage(num2, num3, ref num1, num5, num4, num6, ref flag1);
					for (int i = 0; i < playerPage.Length; i++)
					{
						XElement apprenticeShipInfo = FlashUtils.CreateApprenticeShipInfo(playerPage[i]);
						xelement.Add(apprenticeShipInfo);
					}
					flag1 = true;
					str1 = "Success!";
				}
			}
			catch (Exception ex)
			{
				log.Error(ex);
			}
			xelement.Add(new XAttribute("total", num1));
			xelement.Add(new XAttribute("value", flag1));
			xelement.Add(new XAttribute("message", str1));
			xelement.Add(new XAttribute("isPlayerRegeisted", flag2));
			xelement.Add(new XAttribute("isSelfPublishEquip", flag3));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xelement.ToString(check: false));
		}
	}
}