using System;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;

namespace Tank.Request
{
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	public class runetemplatelist : IHttpHandler
	{
		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
			{
				context.Response.Write(Bulid(context));
			}
			else
			{
				context.Response.Write("IP is not valid!");
			}
		}

		public static string Bulid(HttpContext context)
		{
			bool flag = false;
			string str = "Fail!";
			XElement result = new XElement("Result");
			XElement xelement = new XElement("RuneTemplate");
			try
			{
				using (new ProduceBussiness())
				{
				}
				flag = true;
				str = "Success!";
			}
			catch (Exception)
			{
			}
			result.Add(new XAttribute("value", flag));
			result.Add(new XAttribute("message", str));
			result.Add(xelement);
			csFunction.CreateCompressXml(context, result, "runetemplatelist_out", isCompress: false);
			return csFunction.CreateCompressXml(context, result, "runetemplatelist", isCompress: true);
		}
	}
}
