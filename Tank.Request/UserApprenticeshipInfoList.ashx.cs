using System;
using System.Collections.Generic;
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
	public class UserApprenticeshipInfoList : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = true;
			string str = "true!";
			int num1 = 0;
			XElement xelement = new XElement("Result");
			try
			{
				int num2 = int.Parse(context.Request["selfid"]);
				int num3 = int.Parse(context.Request["RelationshipID"]);
				if (num3 == 0)
				{
					num3 = num2;
				}
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					PlayerInfo userSingleByUserId1 = playerBussiness.GetUserSingleByUserID(num3);
					PlayerInfo userSingleByUserId2 = playerBussiness.GetUserSingleByUserID(num2);
					if (userSingleByUserId1 != null && userSingleByUserId2 != null)
					{
						if (userSingleByUserId2.masterID == userSingleByUserId1.ID)
						{
							XElement apprenticeshipInfo2 = FlashUtils.CreateUserApprenticeshipInfo(userSingleByUserId1);
							xelement.Add(apprenticeshipInfo2);
						}
						foreach (KeyValuePair<int, string> item in userSingleByUserId1.MasterOrApprenticesArr)
						{
							PlayerInfo userSingleByUserId3 = playerBussiness.GetUserSingleByUserID(item.Key);
							if (userSingleByUserId3 != null && userSingleByUserId3.ID != num2)
							{
								XElement apprenticeshipInfo = FlashUtils.CreateUserApprenticeshipInfo(userSingleByUserId3);
								xelement.Add(apprenticeshipInfo);
							}
						}
					}
					flag = true;
					str = "Success!";
				}
			}
			catch (Exception ex)
			{
				log.Error(ex);
			}
			xelement.Add(new XAttribute("total", num1));
			xelement.Add(new XAttribute("value", flag));
			xelement.Add(new XAttribute("message", str));
			context.Response.ContentType = "text/plain";
			context.Response.Write(xelement.ToString(check: false));
		}
	}
}