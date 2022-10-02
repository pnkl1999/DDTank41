using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using Bussiness;
using log4net;
using System.Reflection;
using Bussiness.Interface;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class SentReward : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static string GetSentRewardIP
        {
            get
            {
                return System.Configuration.ConfigurationSettings.AppSettings["SentRewardIP"];
            }
        }

        public static string GetSentRewardKey
        {
            get
            {
                return System.Configuration.ConfigurationSettings.AppSettings["SentRewardKey"];
            }
        }

        public static bool ValidSentRewardIP(string ip)
        {
            string ips = GetSentRewardIP;
            if (string.IsNullOrEmpty(ips) || ips.Split('|').Contains(ip))
                return true;
            return false;
        }

   

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            try 
            {
                //param格式：//int templateID, int count, int validDate, int StrengthenLevel, int AttackCompose, int DefendCompose, int AgilityCompose, int LuckCompose, bool isBinds
                //result:0:成功 1:失败 2:没有该账号 3:ip无效  4:param不合法 5:key错误 6:content内参数列不正确 7:超时
                int result=1;

                //判断IP是否合法
                if (ValidSentRewardIP(context.Request.UserHostAddress))
                {
                    string content = HttpUtility.UrlDecode(context.Request["content"]);

                    
                    string key = GetSentRewardKey;
                  
                    BaseInterface inter = BaseInterface.CreateInterface();
                    string[] str_param = inter.UnEncryptSentReward(content, ref  result, key);

                    if (str_param.Length == 8 && result != 5 && result != 6 && result != 7)  
                     {
                        string mailTitle = str_param[0];
                        string mailContent = str_param[1];
                        string username = str_param[2];
                        int gold = Int32.Parse(str_param[3]);
                        int money = Int32.Parse(str_param[4]);
                        string param = str_param[5];

                        //判断para是否合法，并将不合法的数值设为默认合法值
                        if (checkParam(ref param))  
                        {
                            PlayerBussiness pb = new PlayerBussiness();
                            result = pb.SendMailAndItemByUserName(mailTitle, mailContent, username, gold, money, param);
                        }
                        else
                        {
                            result = 4;
                        }

                    }

                }
                else 
                {
                    result = 3;
                }

                context.Response.Write(result);
               
            }
            catch(Exception ex)
            {
                log.Error("SentReward", ex);
            }

            
        }

      
           
      
        //0 int templateID, 1 int count,2 int validDate,3 int StrengthenLevel,4 int AttackCompose,5 int DefendCompose,6 int AgilityCompose,7 int LuckCompose,8 bool isBinds
        /// <summary>
        /// 检查param是否合法，并将不合法的设为默认合法值
        /// </summary>
        /// <param name="param">待检查字符</param>
        /// <returns></returns>
        private bool checkParam(ref string param)
        {
            //2 绑定时间必须为正数 默认为1天
            int minValidDate = 0;
            string defaultValidDate = "1";
            //3 强化等级0-9限制
            int maxSrengthenLeverl = 9;
            int minSrengthenLeverl = 0;
            //4-7 属性0-40，且必须为0，10，20，30，40
            string minAttribute = "0";
            string firstAttribute = "10";
            string secondAttribute = "20";
            string thirdAttribute = "30";
            string fourthAttribute = "40";
            //8 绑定情况：0未绑定，1绑定
            string  haveBind = "1";
            string noBind = "0";

            if (!string.IsNullOrEmpty(param))
            {
                string[] str_Goods = param.Split('|');
                int int_Length = str_Goods.Length;
                if (int_Length > 0)
                {
                    param = "";
                    int i = 0;
                    foreach (string str in str_Goods)
                    {

                        string[] str_GoodsAttribute = str.Split(',');
                        if (str_GoodsAttribute.Length > 0)
                        {
                            str_Goods[i] = "";
                            str_GoodsAttribute[2] = (Int32.Parse(str_GoodsAttribute[2]) < minValidDate || string.IsNullOrEmpty(str_GoodsAttribute[2].ToString())) ? defaultValidDate : str_GoodsAttribute[2];
                            str_GoodsAttribute[3] = (Int32.Parse(str_GoodsAttribute[3].ToString()) < minSrengthenLeverl || Int32.Parse(str_GoodsAttribute[3].ToString()) > maxSrengthenLeverl || string.IsNullOrEmpty(str_GoodsAttribute[3].ToString())) ? minSrengthenLeverl.ToString() : str_GoodsAttribute[3];
                            str_GoodsAttribute[4] = (str_GoodsAttribute[4] == minAttribute || str_GoodsAttribute[4] == firstAttribute || str_GoodsAttribute[4] == secondAttribute || str_GoodsAttribute[4] == thirdAttribute || str_GoodsAttribute[4] == fourthAttribute && string.IsNullOrEmpty(str_GoodsAttribute[4].ToString()) == false) ? str_GoodsAttribute[4] : minAttribute;
                            str_GoodsAttribute[5] = (str_GoodsAttribute[5] == minAttribute || str_GoodsAttribute[5] == firstAttribute || str_GoodsAttribute[5] == secondAttribute || str_GoodsAttribute[5] == thirdAttribute || str_GoodsAttribute[5] == fourthAttribute && string.IsNullOrEmpty(str_GoodsAttribute[5].ToString()) == false) ? str_GoodsAttribute[5] : minAttribute;
                            str_GoodsAttribute[6] = (str_GoodsAttribute[6] == minAttribute || str_GoodsAttribute[6] == firstAttribute || str_GoodsAttribute[6] == secondAttribute || str_GoodsAttribute[6] == thirdAttribute || str_GoodsAttribute[6] == fourthAttribute && string.IsNullOrEmpty(str_GoodsAttribute[6].ToString()) == false) ? str_GoodsAttribute[6] : minAttribute;
                            str_GoodsAttribute[7] = (str_GoodsAttribute[7] == minAttribute || str_GoodsAttribute[7] == firstAttribute || str_GoodsAttribute[7] == secondAttribute || str_GoodsAttribute[7] == thirdAttribute || str_GoodsAttribute[7] == fourthAttribute && string.IsNullOrEmpty(str_GoodsAttribute[7].ToString()) == false) ? str_GoodsAttribute[7] : minAttribute;
                            str_GoodsAttribute[8] = (str_GoodsAttribute[8] == haveBind || str_GoodsAttribute[8] == noBind && string.IsNullOrEmpty(str_GoodsAttribute[8]) == false) ? str_GoodsAttribute[8] : haveBind;
                        }

                        for (int j = 0; j < 9; ++j)
                        {
                            str_Goods[i] = str_Goods[i] + str_GoodsAttribute[j] + ",";
                        }
                        str_Goods[i] = str_Goods[i].Remove(str_Goods[i].Length - 1, 1);
                        ++i;

                    }
                    for (int k = 0; k < int_Length; ++k)
                    {
                        param = param + str_Goods[k] + "|";
                    }
                    param = param.Remove(param.Length - 1, 1);

                    return true;
                }
               
                
            }
            

            return false;
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
