using System;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class GiftRecieveLog : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string str1 = "Fail!";
			XElement xelement1 = new XElement("Result");
			try
			{
				_ = context.Request["key"];
				int.Parse(context.Request["selfid"]);
				int num = int.Parse(context.Request["userID"]);
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					UserGiftInfo[] allUserGifts = playerBussiness.GetAllUserGifts(num, isReceive: true);
					if (allUserGifts != null)
					{
						UserGiftInfo[] array = allUserGifts;
						foreach (UserGiftInfo userGiftInfo in array)
						{
							XElement xelement2 = new XElement("Item", new XAttribute("playerID", userGiftInfo.ReceiverID), new XAttribute("TemplateID", userGiftInfo.TemplateID), new XAttribute("count", userGiftInfo.Count));
							xelement1.Add(xelement2);
						}
					}
				}
				flag = true;
				str1 = "Success!";
			}
			catch (Exception ex)
			{
				log.Error("giftrecievelog", ex);
			}
			xelement1.Add(new XAttribute("value", flag));
			xelement1.Add(new XAttribute("message", str1));
			context.Response.ContentType = "text/plain";
			context.Response.BinaryWrite(StaticFunction.Compress(xelement1.ToString(check: false)));
		}
	}
}
