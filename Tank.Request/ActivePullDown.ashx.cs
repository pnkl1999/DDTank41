using System;
using System.Configuration;
using System.Reflection;
using System.Text;
using System.Web;
using System.Xml.Linq;
using Bussiness;
using Bussiness.CenterService;
using log4net;
using Road.Flash;

namespace Tank.Request
{
	public class ActivePullDown : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			//LanguageMgr.Setup(ConfigurationManager.AppSettings["ReqPath"]);
			//int selfid = Convert.ToInt32(context.Request["selfid"]);
			//int activeID = Convert.ToInt32(context.Request["activeID"]);
			//_ = context.Request["key"];
			//string src = context.Request["activeKey"];
			//bool flag = false;
			//string msg = "ActivePullDownHandler.Fail";
			//string awardID = "";
			//XElement node = new XElement("Result");
			//if (src != "")
			//{
			//	byte[] bytes = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, src);
			//	awardID = Encoding.UTF8.GetString(bytes, 0, bytes.Length);
			//}
			//try
			//{
			//	using (PlayerBussiness playerBussiness = new PlayerBussiness())
			//	{
			//		if (playerBussiness.PullDown(activeID, awardID, selfid, ref msg) == 0)
			//		{
			//			using (CenterServiceClient centerServiceClient = new CenterServiceClient())
			//			{
			//				centerServiceClient.MailNotice(selfid);
			//			}
			//		}
			//	}
			//	flag = true;
			//	msg = LanguageMgr.GetTranslation(msg);
			//}
			//catch (Exception ex)
			//{
			//	log.Error("ActivePullDown", ex);
			//}
			//node.Add(new XAttribute("value", flag));
			//node.Add(new XAttribute("message", msg));
			//context.Response.ContentType = "text/plain";
			//context.Response.Write(node.ToString(check: false));
			string path = HttpContext.Current.Server.MapPath(".");
			path += "\\";
			LanguageMgr.Setup(path);
			int selfid = Convert.ToInt32(context.Request["selfid"]);//    selfid=19&
			int activeID = Convert.ToInt32(context.Request["activeID"]);//    activeID=21709&
			string key = context.Request["key"];//    key=db5e742130d3eec405df4408ff982fa8&
			string activeKey = context.Request["activeKey"];//    activeKey=KYbdx04Pv5JktjPqKbTlNcGQS5zhKg9o2xEkjcq4Vsde09L1oMKYkzM84WsfSTaJEho7CtbtUJtwouJeD4YRDr5AXJj3bPEHdsimIj8SCmAqhej1EyLVCtZ2NP0E5UdxruePXev46CsuV0bRnVUIjICb%2BHmVEL2rZOvL5smr5b0%3            
			bool value = false;
			string message = "ActivePullDownHandler.Fail";
			string awardID = "";
			XElement result = new XElement("Result");
			if (activeKey != "")
			{
				byte[] src = CryptoHelper.RsaDecryt2(StaticFunction.RsaCryptor, activeKey);
				awardID = Encoding.UTF8.GetString(src, 0, src.Length);
			}
			try
			{

				using (PlayerBussiness pb = new PlayerBussiness())
				{
					if (pb.PullDown(activeID, awardID, selfid, ref message) == 0)
					{
						using (CenterServiceClient client = new CenterServiceClient())
						{
							client.MailNotice(selfid);
						}
					}
				}

				value = true;
				message = LanguageMgr.GetTranslation(message); //"Success!"; -- Có vấn đề
			}
			catch (Exception ex)
			{
				log.Error("ActivePullDown", ex);
			}
			result.Add(new XAttribute("value", value));
			result.Add(new XAttribute("message", message));
			context.Response.ContentType = "text/plain";
			context.Response.Write(result.ToString(false));
		}
	}
}
