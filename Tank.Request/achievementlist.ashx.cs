using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Collections.Specialized;
using System.Collections.Generic;
using SqlDataProvider.Data;
using Bussiness;
using Road.Flash;
using System.IO;
using log4net;
using System.Reflection;
namespace Tank.Request
{
    /// <summary>
    /// Summary description for achievementlist
    /// </summary>
    public class achievementlist : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
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
            bool value = false;
            string message = "Fail!";
            XElement result = new XElement("Result");
            try
            {
                using (ProduceBussiness db = new ProduceBussiness())
                {
                    AchievementInfo[] achives = db.GetALlAchievement();
                    AchievementRewardInfo[] achivegoods = db.GetALlAchievementReward();
                    AchievementConditionInfo[] achivecondiction = db.GetALlAchievementCondition();
                    foreach (AchievementInfo achive in achives)
                    {
                        //添加任务模板
                        XElement temp_xml = FlashUtils.CreateAchievement(achive);

                        //添加任何条件
                        IEnumerable temp_questcondiction = achivecondiction.Where(s => s.AchievementID == achive.ID);
                        foreach (AchievementConditionInfo item1 in temp_questcondiction)
                        {
                            temp_xml.Add(FlashUtils.CreateAchievementCondition(item1));
                        }

                        //添加任务奖励
                        IEnumerable temp_questgoods = achivegoods.Where(s => s.AchievementID == achive.ID);
                        foreach (AchievementRewardInfo item2 in temp_questgoods)
                        {
                            temp_xml.Add(FlashUtils.CreateAchievementReward(item2));
                        }
                        result.Add(temp_xml);
                    }
                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("achievementlist", ex);
            }
            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));
            csFunction.CreateCompressXml(context, result, "achievementlist_out", false);
            return csFunction.CreateCompressXml(context, result, "achievementlist", true);
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
