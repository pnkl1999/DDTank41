using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness;
using SqlDataProvider.Data;
using Road.Flash;
using log4net;
using System.Reflection;
using System.Xml;

namespace Tank.Request
{
    /// <summary>
    /// http://192.168.0.4:828/QuestList.ashx
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class QuestList : IHttpHandler
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
                    QuestInfo[] quests = db.GetALlQuest();
                    QuestAwardInfo[] questgoods = db.GetAllQuestGoods();
                    QuestConditionInfo[] questcondiction = db.GetAllQuestCondiction();
                    foreach (QuestInfo quest in quests)
                    {
                        //添加任务模板
                        XElement temp_xml = FlashUtils.CreateQuestInfo(quest);                      

                        //添加任何条件
                        IEnumerable temp_questcondiction = questcondiction.Where(s => s.QuestID == quest.ID);
                        foreach (QuestConditionInfo item1 in temp_questcondiction)
                        {
                            temp_xml.Add(FlashUtils.CreateQuestCondiction(item1));
                        }

                        //添加任务奖励
                        IEnumerable temp_questgoods = questgoods.Where(s => s.QuestID == quest.ID);
                        foreach (QuestAwardInfo item2 in temp_questgoods)
                        {
                            temp_xml.Add(FlashUtils.CreateQuestGoods(item2));
                        }
                        result.Add(temp_xml);
                    }

                    value = true;
                    message = "Success!";
                }
            }
            catch (Exception ex)
            {
                log.Error("QuestList", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            //return result.ToString(false);
            return csFunction.CreateCompressXml(context, result, "QuestList", true);
        }

        private static void AppendAttribute(XmlDocument doc, XmlNode node, string attr, string value)
        {
            XmlAttribute at = doc.CreateAttribute(attr);
            at.Value = value;
            node.Attributes.Append(at);
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
