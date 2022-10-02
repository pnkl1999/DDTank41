using System;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.Web;
using System.Web.Services;
using System.Xml.Linq;
using Bussiness;
using log4net;
using SqlDataProvider.BaseClass;
using SqlDataProvider.Data;

namespace Tank.Request
{
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	[WebService(Namespace = "http://tempuri.org/")]
	public class dailyloglist : IHttpHandler
	{
		private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

		protected Sql_DbObject db = new Sql_DbObject("AppConfig", "conString");

		public bool IsReusable => false;

		public void ProcessRequest(HttpContext context)
		{
			bool flag = false;
			string str1 = "Fail!";
			XElement node = new XElement("Result");
			try
			{
				_ = context.Request["key"];
				int UserID = int.Parse(context.Request["selfid"]);
				using (PlayerBussiness playerBussiness = new PlayerBussiness())
				{
					DailyLogListInfo info = playerBussiness.GetDailyLogListSingle(UserID);
					if (info == null)
					{
						info = new DailyLogListInfo
						{
							UserID = UserID,
							DayLog = "",
							UserAwardLog = 0,
							LastDate = DateTime.Now
						};
					}
					string str2 = info.DayLog;
					int num1 = info.UserAwardLog;
					DateTime dateTime = info.LastDate;
					char[] chArray = new char[1]
					{
						','
					};
					int length = str2.Split(chArray).Length;
					int month = DateTime.Now.Month;
					int year = DateTime.Now.Year;
					int day = DateTime.Now.Day;
					int num2 = DateTime.DaysInMonth(year, month);
					if (month != dateTime.Month || year != dateTime.Year)
					{
						str2 = "";
						num1 = 0;
						dateTime = DateTime.Now;
					}
					if (length < num2)
					{
						if (string.IsNullOrEmpty(str2) && length > 1)
						{
							str2 = "False";
						}
						for (int index = length; index < day - 1; index++)
						{
							str2 += ",False";
						}
					}
					info.DayLog = str2;
					info.UserAwardLog = num1;
					info.LastDate = dateTime;
					playerBussiness.UpdateDailyLogList(info);
					XElement xelement = new XElement("DailyLogList", new XAttribute("UserAwardLog", num1), new XAttribute("DayLog", str2), new XAttribute("luckyNum", 0), new XAttribute("myLuckyNum", 0));
					node.Add(xelement);
				}
				flag = true;
				str1 = "Success!";
			}
			catch (Exception ex)
			{
				log.Error("dailyloglist", ex);
			}
			node.Add(new XAttribute("value", flag));
			node.Add(new XAttribute("message", str1));
			node.Add(new XAttribute("nowDate", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")));
			context.Response.ContentType = "text/plain";
			context.Response.BinaryWrite(StaticFunction.Compress(node.ToString(check: false)));
		}

		public bool UpdateDailyLogList(DailyLogListInfo info)
		{
			bool flag = false;
			try
			{
				SqlParameter[] sqlParameters = new SqlParameter[5]
				{
					new SqlParameter("@UserID", info.UserID),
					new SqlParameter("@UserAwardLog", info.UserAwardLog),
					new SqlParameter("@DayLog", info.DayLog),
					new SqlParameter("@LastDate", info.LastDate),
					new SqlParameter("@Result", SqlDbType.Int)
				};
				sqlParameters[4].Direction = ParameterDirection.ReturnValue;
				flag = db.RunProcedure("SP_DailyLogList_Update", sqlParameters);
				return flag;
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("SP_DailyLogList_Update", exception);
					return flag;
				}
				return flag;
			}
		}
	}
}
